using System;
using System.Data.Common;
using System.Linq;
using System.Reflection;
using System.Threading;
using System.Threading.Tasks;
using Dapper;
using EnerGov.Business.FireOccupancy.Constants;
using EnerGov.Business.FireOccupancy.InspectionAutomations.Helpers;
using EnerGov.Data.Configuration;
using EnerGov.Services.Email.Helpers;
using EnerGov.Services.Templating;
using Microsoft.Extensions.Options;

namespace EnerGov.Business.FireOccupancy.InspectionAutomations.Tasks.ReferredToFirePreventionEmail {

    public class ReferredToFirePreventionEmailTask : IFireOccupancyInspectionTask {

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
        
        public ReferredToFirePreventionEmailTask(
            ITemplateRenderingService templateRenderingService,
            IOptions<FireOccupancyConfiguration> fireOccupancyConfigurationOptions) {

            _templateRenderingService = templateRenderingService;
            _fireOccupancyConfigurationOptions = fireOccupancyConfigurationOptions;
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
                        ISNULL(csi.ReasonForFirePreventionReferral, '') AS ReasonForFirePreventionReferral,
                        ISNULL(csi.ReferToFirePrevention, 0) AS ReferToFirePrevention,
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

            if (customFieldInformation.ReferToFirePrevention ?? false) {

                var bodyText =
                    await _templateRenderingService.GenerateAsync(
                        Assembly.GetExecutingAssembly(), 
                        "ReferredToFirePreventionEmail.txt.liquid",
                        customFieldInformation);
                var bodyHtml = await _templateRenderingService.GenerateAsync(
                    Assembly.GetExecutingAssembly(), 
                    "ReferredToFirePreventionEmail.html.liquid",
                    customFieldInformation);

                configurationDbContext.QueueInternalInspectionEmail(
                    inspectionId,
                    rowVersion,
                    new EmailMessage {
                        EmailName = "ReferredToFirePreventionEmail",
                        FromAddress = configurationOptions.Notification.ReferredToFirePreventionEmail.FromAddress,
                        ToAddresses = configurationOptions.Notification.ReferredToFirePreventionEmail.Recipients.Select(_ => _.ToUpper()).GroupBy(_ => _).Select(_ => _.Key).ToArray(),
                        Subject =
                            $"Occupancy referred to Fire Prevention for {customFieldInformation.OccupancyNumber ?? ""} ({customFieldInformation.OccupancyName ?? ""})",
                        BodyText = bodyText,
                        BodyHtml = bodyHtml
                    });

            }
        }

    }

}