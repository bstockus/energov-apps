using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using System.Threading;
using System.Threading.Tasks;
using Dapper;
using EnerGov.Business.FireOccupancy.InspectionAutomations.Models;
using EnerGov.Data.Configuration;
using EnerGov.Data.EnerGov;
using EnerGov.Services.Email.Helpers;
using EnerGov.Services.Templating;
using Lax.Data.Entities.EntityFrameworkCore;
using Lax.Data.Sql;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using Microsoft.Extensions.Options;

namespace EnerGov.Business.FireOccupancy.NotificationAutomations {

    public class ReInspectionInfo {

        public string InspectionId { get; set; }
        public string InspectionNumber { get; set; }
        public DateTime? ScheduledDate { get; set; }
        public string InspectionComments { get; set; }
        public string OccupancyNumber { get; set; }
        public string BusinessName { get; set; }
        public string Addresses { get; set; }
        public string InspectedBy { get; set; }
        public string InspectionPerformedBy { get; set; }
        public string ParentInspection { get; set; }
        public DateTime? ParentInspectionDate { get; set; }

        public string DisplayScheduledDate => (ScheduledDate ?? DateTime.Today).ToShortDateString();
        public string DisplayParentInspectionDate => (ScheduledDate ?? DateTime.Today).ToShortDateString();

    }

    public class ReInspectionEmailData {

        public ReInspectionInfo[] CurrentAndPastDueReInspectionInfos { get; set; }
        public ReInspectionInfo[] UpcomingReInspectionInfos { get; set; }

    }

    public class ReInspectionNotificationAutomationTaskRunner {

        private readonly ISqlConnectionProvider<EnerGovSqlServerConnection> _enerGovSqlConnectionProvider;
        private readonly IOptions<FireOccupancyConfiguration> _fireOccupancyConfigurationOptions;
        private readonly ConfigurationDbContext _configurationDbContext;
        private readonly ITemplateRenderingService _templateRenderingService;

        public ReInspectionNotificationAutomationTaskRunner(
            ISqlConnectionProvider<EnerGovSqlServerConnection> enerGovSqlConnectionProvider,
            IOptions<FireOccupancyConfiguration> fireOccupancyConfigurationOptions,
            ConfigurationDbContext configurationDbContext,
            ITemplateRenderingService templateRenderingService) {

            _enerGovSqlConnectionProvider = enerGovSqlConnectionProvider;
            _fireOccupancyConfigurationOptions = fireOccupancyConfigurationOptions;
            _configurationDbContext = configurationDbContext;
            _templateRenderingService = templateRenderingService;
        }

        public async Task RunTasks(CancellationToken cancellationToken) {

            Console.WriteLine("Running ReInspection Notification Task Runner...");

            var enerGovConnection = await _enerGovSqlConnectionProvider.GetDbConnectionAsync(cancellationToken);
            var configurationOptions = _fireOccupancyConfigurationOptions.Value;

            var releventInspections = await enerGovConnection.QueryAsync<ReInspectionInfo>(
                new CommandDefinition(
                    @"SELECT
                                    insp.IMINSPECTIONID AS InspectionId,
                                    insp.INSPECTIONNUMBER AS InspectionNumber,
                                    insp.SCHEDULEDSTARTDATE AS ScheduledDate,
                                    insp.COMMENTS AS InspectionComments,
                                    occu.STATETAXNUMBER AS OccupancyNumber,
                                    occu.DBA AS BusinessName,
                                   (SELECT STUFF((SELECT ',' +
                                                               LTRIM(RTRIM(
                                                                           LTRIM(RTRIM(ma.ADDRESSLINE1)) + ' ' +
                                                                           LTRIM(RTRIM(
                                                                                       LTRIM(RTRIM(ma.ADDRESSLINE2)) + ' ' +
                                                                                       LTRIM(RTRIM(
                                                                                                   LTRIM(RTRIM(ma.STREETTYPE)) + ' ' +
                                                                                                   LTRIM(RTRIM(
                                                                                                               LTRIM(RTRIM(ma.POSTDIRECTION)) +
                                                                                                               ' ' +
                                                                                                               LTRIM(RTRIM(ma.UNITORSUITE))
                                                                                                       ))
                                                                                           ))
                                                                               ))
                                                                   ))
                                                        FROM IMINSPECTIONADDRESS insa
                                                                 INNER JOIN MAILINGADDRESS ma ON insa.MAILINGADDRESSID = ma.MAILINGADDRESSID
                                                        WHERE insa.IMINSPECTIONID = insp.IMINSPECTIONID
                                                        ORDER BY ma.ADDRESSLINE1, ma.ADDRESSLINE2, ma.UNITORSUITE
                                                                     FOR XML PATH ('')), 1, 1, '')) AS Addresses,
                                    custFields.InspectedBy AS InspectedBy,
                                    (SELECT TOP 1 cfpli.SVALUE
                                              FROM CUSTOMFIELDPICKLISTITEM cfpli
                                              WHERE cfpli.GCUSTOMFIELDPICKLISTITEM = custFields.InspectedBy) AS InspectionPerformedBy,
                                    insp.PARENTINSPECTIONNUMBER AS ParentInspection,
                                    (SELECT TOP 1 parentInsp.ACTUALSTARTDATE FROM IMINSPECTION parentInsp WHERE parentInsp.INSPECTIONNUMBER = insp.PARENTINSPECTIONNUMBER) AS ParentInspectionDate
                                FROM IMINSPECTION insp
                                INNER JOIN BLGLOBALENTITYEXTENSION occu ON insp.LINKID = occu.BLGLOBALENTITYEXTENSIONID
                                INNER JOIN CUSTOMSAVERINSPECTIONS custFields ON insp.IMINSPECTIONID = custFields.ID
                                WHERE insp.IMINSPECTIONTYPEID IN @InspectionTypeIds AND
                                      insp.IMINSPECTIONSTATUSID IN @ReInspectionNotificationStatusIds",
                    new {
                        configurationOptions.Scanning.InspectionTypeIds,
                        configurationOptions.Scanning.ReInspectionNotificationStatusIds
                    },
                    cancellationToken: cancellationToken));

            Console.WriteLine($"    Relevent Inspection Count = {releventInspections.Count()}");

            var inspectorEmails = await _configurationDbContext.Set<Inspector>()
                .TagWith("Get Inspector for Custom Field Pick List Item")
                .AsNoTracking()
                .ToDictionaryAsync(_ => _.CustomFieldPickListItemId, _ => _.EmailAddress, cancellationToken);

            var inspectorsGettingNotified = new HashSet<string>();

            foreach (var releventInspection in releventInspections.Where(_ => _.ScheduledDate.HasValue && _.ScheduledDate.Value.Date <= DateTime.Today.Date)) {

                var inspectionId = Guid.Parse(releventInspection.InspectionId);

                inspectorsGettingNotified.Add(releventInspection.InspectedBy);

            }

            foreach (var inspectorGettingNotified in inspectorsGettingNotified.Where(_ => !string.IsNullOrEmpty(_))) {

                var inspectorId = Guid.Parse(inspectorGettingNotified);

                if (!inspectorEmails.ContainsKey(inspectorId)) {
                    continue;
                }

                var previousInspectionEmails = await _configurationDbContext.Set<ReInspectionNotification>()
                    .TagWith("Get Previous Re Inspection Notifications")
                    .AsNoTracking()
                    .Where(_ => _.InspectorId.Equals(inspectorId))
                    .ToListAsync(cancellationToken);

                if (previousInspectionEmails.Any() &&
                    (previousInspectionEmails.Max(_ => _.NotificationDateTime).AddHours(23) > DateTime.Now)) {
                    // Skip if last email was sent less than 23 hrs ago
                    continue;
                }

                var releventInspectorInspections =
                    releventInspections.Where(_ => !string.IsNullOrEmpty(_.InspectedBy) && _.InspectedBy.Equals(inspectorGettingNotified));

                var reInspectionEmailData = new ReInspectionEmailData {
                    CurrentAndPastDueReInspectionInfos = releventInspectorInspections
                        .Where(_ => (_.ScheduledDate ?? DateTime.Today).Date <= DateTime.Today.Date)
                        .OrderBy(_ => (_.ScheduledDate ?? DateTime.Today)).ToArray(),
                    UpcomingReInspectionInfos = releventInspectorInspections
                        .Where(_ => (_.ScheduledDate ?? DateTime.Today).Date > DateTime.Today.Date)
                        .OrderBy(_ => (_.ScheduledDate ?? DateTime.Today)).ToArray()
                };

                var bodyText = await _templateRenderingService.GenerateAsync(
                    Assembly.GetExecutingAssembly(),
                    "ReInspectionNotificationEmail.txt.liquid",
                    reInspectionEmailData,
                    new[] {typeof(ReInspectionInfo)});

                var bodyHtml = await _templateRenderingService.GenerateAsync(
                    Assembly.GetExecutingAssembly(),
                    "ReInspectionNotificationEmail.html.liquid",
                    reInspectionEmailData,
                    new[] { typeof(ReInspectionInfo) });

                _configurationDbContext.QueueInternalEmail(
                    new EmailMessage {
                        EmailName = "ReInspectionNotificationEmail",
                        FromAddress = configurationOptions.Notification.ReInspectionNotificationEmail.FromAddress,
                        ToAddresses = new[] {inspectorEmails[inspectorId]},
                        Subject = "Daily Occupancy Re-Inspection Schedule Email",
                        BodyHtml = bodyHtml,
                        BodyText = bodyText
                    });

                _configurationDbContext.Set<ReInspectionNotification>()
                    .Add(new ReInspectionNotification {
                        InspectorId = inspectorId,
                        NotificationDateTime = DateTime.Now
                    });

            }

            await _configurationDbContext.SaveChangesAsync(cancellationToken);

        }

    }

    public class ReInspectionNotification {

        public Guid InspectorId { get; set; }
        public DateTime NotificationDateTime { get; set; }

        public class EntityModelBuilder : EntityFrameworkModelBuilder<ConfigurationDbContext, ReInspectionNotification> {

            public override void Build(EntityTypeBuilder<ReInspectionNotification> builder) {

                builder.ToTable("ReInspectionNotifications", FireOccupancySchemaConstants.SchemaName);

                builder.HasKey(_ => new {
                    InspectionId = _.InspectorId,
                    _.NotificationDateTime
                });

            }

        }

    }

}
