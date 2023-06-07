using System;
using System.Data.Common;
using System.Linq;
using System.Reflection;
using System.Threading;
using System.Threading.Tasks;
using Dapper;
using EnerGov.Business.FireOccupancy.Constants;
using EnerGov.Business.FireOccupancy.InspectionAutomations.Helpers;
using EnerGov.Business.FireOccupancy.InspectionAutomations.Models;
using EnerGov.Data.Configuration;
using EnerGov.Services.Email.Helpers;
using EnerGov.Services.Reporting;
using EnerGov.Services.Templating;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Options;

namespace EnerGov.Business.FireOccupancy.InspectionAutomations.Tasks.ChangeInOccupancyEmail {

    public class ChangeInOccupancyEmailTask : IFireOccupancyInspectionTask {

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
        private readonly IReportRenderingService _reportRenderingService;
        private readonly IOptions<FireOccupancyConfiguration> _fireOccupancyConfigurationOptions;

        

        public ChangeInOccupancyEmailTask(
            ITemplateRenderingService templateRenderingService,
            IReportRenderingService reportRenderingService,
            IOptions<FireOccupancyConfiguration> fireOccupancyConfigurationOptions) {
            _templateRenderingService = templateRenderingService;
            _reportRenderingService = reportRenderingService;
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
                        ISNULL(csi.DescriptionOfOccupancyInformationChanges, '') AS DescriptionOfOccupancyInformationChanges,
                        ISNULL(csi.ChangeInOccupancyInformation, 0) AS ChangeInOccupancyInformation,
                        csi.InspectedBy AS InspectedBy,
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

            if (customFieldInformation.ChangeInOccupancyInformation ?? false) {

                var emailsToNotify = configurationOptions.Notification.ChangeInOccupancyEmail.Recipients.ToList();

                if (!string.IsNullOrEmpty(customFieldInformation.InspectedBy) &&
                    Guid.TryParse(customFieldInformation.InspectedBy, out _)) {

                    var inspectedByGuid = Guid.Parse(customFieldInformation.InspectedBy);

                    var inspector = await configurationDbContext.Set<Inspector>()
                        .TagWith("Get Inspector for Custom Field Pick List Item")
                        .AsNoTracking()
                        .FirstOrDefaultAsync(_ => _.CustomFieldPickListItemId.Equals(inspectedByGuid),
                            cancellationToken);

                    if (inspector != null) {
                        emailsToNotify.Add(inspector.EmailAddress);
                    }
                }

                var bodyText =
                    await _templateRenderingService.GenerateAsync(Assembly.GetExecutingAssembly(), "ChangeInOccupancyEmail.txt.liquid",
                        customFieldInformation);
                var bodyHtml = await _templateRenderingService.GenerateAsync(Assembly.GetExecutingAssembly(), "ChangeInOccupancyEmail.html.liquid",
                    customFieldInformation);

                var reportContents = await _reportRenderingService.RenderReportAsPdf(
                    configurationOptions.Reporting.FireInspectionLetterWithAddressReportUrl,
                    new {
                        InspectionId = inspectionId
                    });

                configurationDbContext.QueueInternalInspectionEmail(
                    inspectionId,
                    rowVersion,
                    new EmailMessage {
                        EmailName = "ContactInspectionLetterName",
                        FromAddress = configurationOptions.Notification.ChangeInOccupancyEmail.FromAddress,
                        ToAddresses = emailsToNotify.Select(_ => _.ToUpper()).GroupBy(_ => _).Select(_ => _.Key).ToArray(),
                        Subject =
                            $"Change in Occupancy Information for {customFieldInformation.OccupancyNumber ?? ""} ({customFieldInformation.OccupancyName ?? ""})",
                        BodyText = bodyText,
                        BodyHtml = bodyHtml,
                        Attachments = new[] {
                            new EmailMessageAttachment {
                                FileName = "FireInspectionLetter.pdf",
                                MimeType = "application/pdf",
                                FileContents = reportContents
                            }
                        }
                    });

            }


        }

    }

}
