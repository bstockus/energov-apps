using System;
using System.Data.Common;
using System.Linq;
using System.Reflection;
using System.Threading;
using System.Threading.Tasks;
using Dapper;
using EmailValidation;
using EnerGov.Business.FireOccupancy.Constants;
using EnerGov.Business.FireOccupancy.InspectionAutomations.Helpers;
using EnerGov.Business.FireOccupancy.InspectionAutomations.Models;
using EnerGov.Data.Configuration;
using EnerGov.Services.Email.Helpers;
using EnerGov.Services.Reporting;
using EnerGov.Services.Templating;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Options;

namespace EnerGov.Business.FireOccupancy.InspectionAutomations.Tasks.InternalReportEmail {

    public class InternalReportEmailTask : IFireOccupancyInspectionTask {

        private readonly ITemplateRenderingService _templateRenderingService;
        private readonly IReportRenderingService _reportRenderingService;
        private readonly IOptions<FireOccupancyConfiguration> _fireOccupancyConfigurationOptions;

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

        public InternalReportEmailTask(
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

            var inspectionContacts = (await enerGovDbConnection.QueryAsync<InspectionContactInformation>(
                new CommandDefinition(
                    @"SELECT
                            LTRIM(RTRIM(ge.GLOBALENTITYNAME)) AS GlobalEntityName,
                            LTRIM(RTRIM(ge.FIRSTNAME + ' ' + ge.LASTNAME)) AS PersonName,
                            LTRIM(RTRIM(ISNULL(ge.EMAIL, ''))) AS EmailAddress,
                            csi.InspectedBy AS InspectedBy,
                            (SELECT TOP 1 cfpli.SVALUE FROM CUSTOMFIELDPICKLISTITEM cfpli WHERE cfpli.GCUSTOMFIELDPICKLISTITEM = csi.InspectedBy) AS InspectionPerformedBy,
                            gle.STATETAXNUMBER AS OccupancyNumber,
                            gle.DBA AS OccupancyName,
                            insp.INSPECTIONNUMBER AS InspectionNumber,
                            par.PARCELNUMBER AS ParcelNumber,
                            maddr.ADDRESSLINE1 AS HouseNumber,
                            maddr.ADDRESSLINE2 AS StreetName,
                            maddr.STREETTYPE AS StreetType,
                            maddr.POSTDIRECTION AS PostDirection,
                            maddr.UNITORSUITE AS UnitNumber,
                            (SELECT TOP 1 gle_zone.BLEXTBUSINESSTYPEID
                                FROM BLGLOBALENTITYEXTBUSTYPE gle_zone
                                INNER JOIN BLEXTBUSINESSTYPE zone_type ON gle_zone.BLEXTBUSINESSTYPEID = zone_type.BLEXTBUSINESSTYPEID
                                WHERE gle_zone.BLGLOBALENTITYEXTENSIONID = gle.BLGLOBALENTITYEXTENSIONID AND
                                      zone_type.BLEXTBUSINESSCATEGORYID = '4f47636f-0830-424d-a209-977ae9485f5e') AS ZoneId
                        FROM IMINSPECTION insp
                        INNER JOIN IMINSPECTIONCONTACT insc ON insp.IMINSPECTIONID = insc.IMINSPECTIONID
                        INNER JOIN GLOBALENTITY ge ON insc.GLOBALENTITYID = ge.GLOBALENTITYID
                        INNER JOIN CUSTOMSAVERINSPECTIONS csi ON insp.IMINSPECTIONID = csi.ID
                        INNER JOIN BLGLOBALENTITYEXTENSION gle ON insp.LINKID = gle.BLGLOBALENTITYEXTENSIONID
                        LEFT OUTER JOIN IMINSPECTIONPARCEL ipar ON insp.IMINSPECTIONID = ipar.IMINSPECTIONID AND ipar.MAIN = 1
                        LEFT OUTER JOIN PARCEL par ON ipar.PARCELID = par.PARCELID
                        LEFT OUTER JOIN IMINSPECTIONADDRESS iaddr ON insp.IMINSPECTIONID = iaddr.IMINSPECTIONID AND iaddr.MAIN = 1
                        LEFT OUTER JOIN MAILINGADDRESS maddr ON iaddr.MAILINGADDRESSID = maddr.MAILINGADDRESSID
                        WHERE insp.IMINSPECTIONID = @InspectionId",
                    new {
                        InspectionId = inspectionId
                    },
                    cancellationToken: cancellationToken))).ToList();

            if (!inspectionContacts.Any()) {

                var inspectionNoContactInfo = await enerGovDbConnection.QueryFirstAsync<InspectionNoContactInformation>(
                    new CommandDefinition(
                        @"SELECT
                                csi.InspectedBy AS InspectedBy,
                                (SELECT TOP 1 cfpli.SVALUE FROM CUSTOMFIELDPICKLISTITEM cfpli WHERE cfpli.GCUSTOMFIELDPICKLISTITEM = csi.InspectedBy) AS InspectionPerformedBy,
                                gle.STATETAXNUMBER AS OccupancyNumber,
                                gle.DBA AS OccupancyName,
                                insp.INSPECTIONNUMBER AS InspectionNumber
                            FROM IMINSPECTION insp
                            INNER JOIN CUSTOMSAVERINSPECTIONS csi ON insp.IMINSPECTIONID = csi.ID
                            INNER JOIN BLGLOBALENTITYEXTENSION gle ON insp.LINKID = gle.BLGLOBALENTITYEXTENSIONID
                            WHERE insp.IMINSPECTIONID = @InspectionId",
                        new {
                            InspectionId = inspectionId
                        },
                        cancellationToken: cancellationToken));

                if (inspectionNoContactInfo != null) {


                    configurationDbContext.QueueInternalInspectionEmail(
                        inspectionId,
                        rowVersion,
                        new EmailMessage {
                            EmailName = "BadInspection",
                            FromAddress = configurationOptions.Notification.InternalReportEmail.FromAddress,
                            ToAddresses = configurationOptions.Notification.ErrorNotifications,
                            BodyHtml = $"Inspection {inspectionNoContactInfo.InspectionNumber} has encountered an unexpected error " +
                                       $"while trying to generate the internal inspection report for the inspector.  " +
                                       $"Please manually review this inspection and then manually generate the inspection report.  " +
                                       $"Occupancy Number = {inspectionNoContactInfo.OccupancyNumber} ({inspectionNoContactInfo.OccupancyName})",
                            BodyText = $"Inspection {inspectionNoContactInfo.InspectionNumber} has encountered an unexpected error " +
                                       $"while trying to generate the internal inspection report for the inspector.  " +
                                       $"Please manually review this inspection and then manually generate the inspection report.  " +
                                       $"Occupancy Number = {inspectionNoContactInfo.OccupancyNumber} ({inspectionNoContactInfo.OccupancyName})",
                            Subject = "Unexpected Error While running EnerGov Fire Occupancy Automations"
                        });

                }

                return;

            }

            if (inspectionContacts.All(_ => string.IsNullOrWhiteSpace(_.EmailAddress) || !EmailValidator.Validate(_.EmailAddress))) {

                var emailsToNotify = configurationOptions.Notification.InternalReportEmail.Recipients.ToList();

                if (inspectionContacts.FirstOrDefault()?.InspectedBy != null) {

                    var inspectedByGuid = Guid.Parse(inspectionContacts.First().InspectedBy);

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
                    await _templateRenderingService.GenerateAsync(
                        Assembly.GetExecutingAssembly(), 
                        "InternalReportEmail.txt.liquid",
                        inspectionContacts.FirstOrDefault());
                var bodyHtml = await _templateRenderingService.GenerateAsync(
                    Assembly.GetExecutingAssembly(), 
                    "InternalReportEmail.html.liquid",
                    inspectionContacts.FirstOrDefault());

                var reportContents = await _reportRenderingService.RenderReportAsPdf(
                    configurationOptions.Reporting.FireInspectionLetterWithAddressReportUrl,
                    new {
                        InspectionId = inspectionId
                    });

                configurationDbContext.QueueInternalInspectionEmail(
                    inspectionId,
                    rowVersion,
                    new EmailMessage {
                        EmailName = "InternalReportEmail",
                        FromAddress = configurationOptions.Notification.InternalReportEmail.FromAddress,
                        ToAddresses = emailsToNotify.Select(_ => _.ToUpper()).GroupBy(_ => _).Select(_ => _.Key).ToArray(),
                        BodyHtml = bodyHtml,
                        BodyText = bodyText,
                        Subject = "Please Mail a Copy of the Inspection Results Letter",
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
