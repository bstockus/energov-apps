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
using EnerGov.Data.Configuration;
using EnerGov.Services.Email.Helpers;
using EnerGov.Services.Reporting;
using EnerGov.Services.Templating;
using Microsoft.Extensions.Options;

namespace EnerGov.Business.FireOccupancy.InspectionAutomations.Tasks.ExternalReportEmail {

    public class ExternalReportEmailTask : IFireOccupancyInspectionTask {

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

        public ExternalReportEmailTask(
            ITemplateRenderingService templateRenderingService,
            IReportRenderingService reportRenderingService,
            IOptions<FireOccupancyConfiguration> fireOccupancyConfigurationOptions) {
            _templateRenderingService = templateRenderingService;
            _reportRenderingService = reportRenderingService;
            _fireOccupancyConfigurationOptions = fireOccupancyConfigurationOptions;
        }

        public async Task HandleInspection(ConfigurationDbContext configurationDbContext,
            DbConnection enerGovDbConnection,
            Guid inspectionId, int rowVersion, Guid fromStatusId, Guid toStatusId,
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
                            ISNULL((SELECT TOP 1 cfpli.SVALUE FROM CUSTOMFIELDPICKLISTITEM cfpli WHERE cfpli.GCUSTOMFIELDPICKLISTITEM = csi.InspectedBy), '') AS InspectionPerformedBy,
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
                                      zone_type.BLEXTBUSINESSCATEGORYID = '4f47636f-0830-424d-a209-977ae9485f5e') AS ZoneId,
                            ISNULL(insp.ACTUALSTARTDATE, GETDATE()) As ActualDate
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

            foreach (var inspectionContactInformation in inspectionContacts.Where(_ =>
                !string.IsNullOrWhiteSpace(_.EmailAddress) && EmailValidator.Validate(_.EmailAddress))) {

                var bodyText =
                    await _templateRenderingService.GenerateAsync(Assembly.GetExecutingAssembly(), "ExternalReportEmail.txt.liquid",
                        inspectionContactInformation);
                var bodyHtml = await _templateRenderingService.GenerateAsync(
                    Assembly.GetExecutingAssembly(), 
                    "ExternalReportEmail.html.liquid",
                    inspectionContactInformation);

                var reportContents = await _reportRenderingService.RenderReportAsPdf(
                    configurationOptions.Reporting.FireInspectionLetterReportUrl,
                    new {
                        InspectionId = inspectionId
                    });

                configurationDbContext.QueueExternalInspectionEmail(
                    inspectionId,
                    rowVersion,
                    new EmailMessage {
                        EmailName = "ExternalReportEmail",
                        FromAddress = configurationOptions.Notification.ExternalReportEmail.FromAddress,
                        ToAddresses = new[] {inspectionContactInformation.EmailAddress.Trim()},
                        BodyHtml = bodyHtml,
                        BodyText = bodyText,
                        Subject =
                            $"Results of a Fire Occupancy Inspection for {inspectionContactInformation.HouseNumber} {inspectionContactInformation.StreetName} {inspectionContactInformation.StreetType} {inspectionContactInformation.PostDirection}",
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