using System;
using System.Collections.Generic;
using System.Data.Common;
using System.Linq;
using System.Reflection;
using System.Threading;
using System.Threading.Tasks;
using Dapper;
using EnerGov.Business.FireOccupancy.Constants;
using EnerGov.Business.FireOccupancy.InspectionAutomations.Helpers;
using EnerGov.Data.Configuration;
using EnerGov.Data.GIS;
using EnerGov.Services.Email.Helpers;
using EnerGov.Services.Templating;
using Lax.Data.Sql.SqlServer;
using Microsoft.Extensions.Options;

namespace EnerGov.Business.FireOccupancy.InspectionAutomations.Tasks.ReferredToBuildingSafetyEmail {

    public class ReferredToBuildingSafetyEmailTask : IFireOccupancyInspectionTask {

        private static readonly Guid[] ValidFromStatuses = {
            InspectionStatus.Requested,
            InspectionStatus.RequestedAutoCreated,
            InspectionStatus.Scheduled
        };

        private static readonly Guid[] ValidToStatuses = {
            InspectionStatus.NoViolationsFound,
            InspectionStatus.ViolationFoundNotResolved,
            InspectionStatus.ViolationFoundResolved
        };

        private readonly ITemplateRenderingService _templateRenderingService;
        private readonly IOptions<FireOccupancyConfiguration> _fireOccupancyConfigurationOptions;
        private readonly ISqlServerConnectionProvider<GISSqlServerConnection> _gisSqlServerConnectionProvider;

        

        public ReferredToBuildingSafetyEmailTask(
            ITemplateRenderingService templateRenderingService,
            IOptions<FireOccupancyConfiguration> fireOccupancyConfigurationOptions,
            ISqlServerConnectionProvider<GISSqlServerConnection> gisSqlServerConnectionProvider) {

            _templateRenderingService = templateRenderingService;
            _fireOccupancyConfigurationOptions = fireOccupancyConfigurationOptions;
            _gisSqlServerConnectionProvider = gisSqlServerConnectionProvider;
        }

        public async Task HandleInspection(
            ConfigurationDbContext configurationDbContext, 
            DbConnection enerGovDbConnection,
            Guid inspectionId, 
            int rowVersion, 
            Guid fromStatusId, 
            Guid toStatusId, 
            CancellationToken cancellationToken) {

            if (!ValidFromStatuses.Contains(fromStatusId) || !ValidToStatuses.Contains(toStatusId)) {
                return;
            }

            var configurationOptions = _fireOccupancyConfigurationOptions.Value;

            var customFieldInformation = await enerGovDbConnection.QueryFirstOrDefaultAsync<CustomFieldsInformation>(
                new CommandDefinition(
                    @"SELECT
                        ISNULL(csi.ReasonForBuildingInspectionsReferral, '') AS ReasonForBuildingInspectionsReferral,
                        ISNULL(csi.ReferToBuildingInspections, 0) AS ReferToBuildingInspections,
                        ISNULL((SELECT TOP 1 cfpli.SVALUE FROM CUSTOMFIELDPICKLISTITEM cfpli WHERE cfpli.GCUSTOMFIELDPICKLISTITEM = csi.InspectedBy), '') AS InspectionPerformedBy,
                        gle.STATETAXNUMBER AS OccupancyNumber,
                        gle.DBA AS OccupancyName,
                        insp.INSPECTIONNUMBER AS InspectionNumber,
                        par.PARCELNUMBER AS ParcelNumber,
                        maddr.ADDRESSLINE1 AS HouseNumber,
                        maddr.ADDRESSLINE2 AS StreetName,
                        maddr.STREETTYPE AS StreetType,
                        maddr.POSTDIRECTION AS PostDirection,
                        maddr.UNITORSUITE AS UnitNumber
                    FROM CUSTOMSAVERINSPECTIONS csi
                    INNER JOIN IMINSPECTION insp ON csi.ID = insp.IMINSPECTIONID
                    INNER JOIN BLGLOBALENTITYEXTENSION gle ON insp.LINKID = gle.BLGLOBALENTITYEXTENSIONID
                    LEFT OUTER JOIN IMINSPECTIONPARCEL ipar ON insp.IMINSPECTIONID = ipar.IMINSPECTIONID AND ipar.MAIN = 1
                    LEFT OUTER JOIN PARCEL par ON ipar.PARCELID = par.PARCELID
                    LEFT OUTER JOIN IMINSPECTIONADDRESS iaddr ON insp.IMINSPECTIONID = iaddr.IMINSPECTIONID AND iaddr.MAIN = 1
                    LEFT OUTER JOIN MAILINGADDRESS maddr ON iaddr.MAILINGADDRESSID = maddr.MAILINGADDRESSID
                    WHERE csi.ID = @InspectionId",
                    new {
                        InspectionId = inspectionId
                    },
                    cancellationToken: cancellationToken));

            if (customFieldInformation.ReferToBuildingInspections ?? false) {

                var gisConnection =
                    await _gisSqlServerConnectionProvider.GetSqlServerConnectionAsync(cancellationToken);

                var inspectionDistrictInformation = (await gisConnection.QueryFirstOrDefaultAsync<InspectionDistrictInformation>(
                    new CommandDefinition(
                        @"SELECT TOP 1 
                                InspectionConstDist
                            FROM ENERGOVPARCELS_PROCESSED
                            WHERE TaxParcelNo = @TaxParcelNo",
                        new {
                            TaxParcelNo = customFieldInformation.ParcelNumber
                        },
                        cancellationToken: cancellationToken)));

                var inspectionDistrict = "ICD-NO";

                if (inspectionDistrictInformation != null) {
                    inspectionDistrict = inspectionDistrictInformation.InspectionConstDist;
                }

                var inspectorEmailAddress = await enerGovDbConnection.QueryFirstOrDefaultAsync<InspectorInformation>(
                    new CommandDefinition(
                        @"SELECT
                                U.EMAIL AS EmailAddress
                            FROM GISZONETOINSPECTORDESIG gisZoneInsp
                            INNER JOIN GISZONEEXTERNALVALUE gisZoneExtVal ON gisZoneInsp.GISZONEEXTERNALVALUEID = gisZoneExtVal.GISZONEEXTERNALVALUEID
                            INNER JOIN IMINSPECTIONZONE inspZone ON gisZoneExtVal.IMINSPECTIONZONEID = inspZone.IMINSPECTIONZONEID
                            INNER JOIN USERS U on gisZoneInsp.USERID = U.SUSERGUID
                            WHERE inspZone.NAME = @ZoneName",
                        new {
                            ZoneName = inspectionDistrict
                        },
                        cancellationToken: cancellationToken));

                var emailsToNotify =
                    new List<string>(configurationOptions.Notification.ReferredToBuildingSafetyEmail.Recipients);

                if (inspectorEmailAddress != null) {
                    emailsToNotify.Add(inspectorEmailAddress.EmailAddress);
                }

                var bodyText =
                    await _templateRenderingService.GenerateAsync(
                        Assembly.GetExecutingAssembly(), 
                        "ReferredToBuildingSafetyEmail.txt.liquid",
                        customFieldInformation);
                var bodyHtml = await _templateRenderingService.GenerateAsync(
                    Assembly.GetExecutingAssembly(), 
                    "ReferredToBuildingSafetyEmail.html.liquid",
                    customFieldInformation);

                configurationDbContext.QueueInternalInspectionEmail(
                    inspectionId,
                    rowVersion,
                    new EmailMessage {
                        EmailName = "ReferredToBuildingSafetyEmail",
                        FromAddress = configurationOptions.Notification.ReferredToBuildingSafetyEmail.FromAddress,
                        ToAddresses = emailsToNotify.Select(_ => _.ToUpper()).GroupBy(_ => _).Select(_ => _.Key).ToArray(),
                        Subject =
                            $"Occupancy referred to Building Safety for {customFieldInformation.OccupancyNumber ?? ""} ({customFieldInformation.OccupancyName ?? ""})",
                        BodyText = bodyText,
                        BodyHtml = bodyHtml
                    });

            }
        }

    }

}