using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using System.Threading;
using System.Threading.Tasks;
using Dapper;
using EnerGov.Business.Alerting.NewCssPermitAlerts.Models;
using EnerGov.Data.Configuration;
using EnerGov.Data.EnerGov;
using EnerGov.Services.Email.Helpers;
using EnerGov.Services.Templating;
using Lax.Data.Sql;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Options;

namespace EnerGov.Business.Alerting.NewCssPermitAlerts {

    public class NewCssPermitAlertTask {

        public class ReleventPermit {

            public string PermitId { get; set; }
            public string PermitType { get; set; }
            public string PermitWorkClass { get; set; }
            public string PermitNumber { get; set; }
            public string PermitDescription { get; set; }
            public string ContractorName { get; set; }
            public string ParcelNumber { get; set; }
            public string Address { get; set; }

        }

        private readonly ISqlConnectionProvider<EnerGovSqlServerConnection> _enerGovSqlConnectionProvider;
        private readonly ConfigurationDbContext _configurationDbContext;
        private readonly IOptions<AlertingConfiguration> _alertingConfigurationOptions;
        private readonly ITemplateRenderingService _templateRenderingService;

        public NewCssPermitAlertTask(
            ISqlConnectionProvider<EnerGovSqlServerConnection> enerGovSqlConnectionProvider,
            ConfigurationDbContext configurationDbContext,
            IOptions<AlertingConfiguration> alertingConfigurationOptions,
            ITemplateRenderingService templateRenderingService) {
            _enerGovSqlConnectionProvider = enerGovSqlConnectionProvider;
            _configurationDbContext = configurationDbContext;
            _alertingConfigurationOptions = alertingConfigurationOptions;
            _templateRenderingService = templateRenderingService;
        }

        public async Task Run(CancellationToken cancellationToken) {

            var enerGovConnection = await _enerGovSqlConnectionProvider.GetDbConnectionAsync(cancellationToken);
            var newCssPermitAlertConfiguration = _alertingConfigurationOptions.Value.NewCssPermitAlert;

            if (!newCssPermitAlertConfiguration.EnableTask) {
                return;
            }

            var previouslyAlertedPermits = (await _configurationDbContext
                    .Set<NewCssPermitAlert>()
                    .AsNoTracking()
                    .TagWith("Fetch all previously alerted New CSS Permits")
                    .ToListAsync(cancellationToken))
                .ToLookup(_ => _.PermitId);

            var alertTypes = await _configurationDbContext
                .Set<NewCssPermitAlertType>()
                .AsNoTracking()
                .TagWith("Fetch all New CSS Permit alert Types")
                .ToListAsync(cancellationToken);

            foreach (var alertType in alertTypes.Where(_ => _.SendAlerts)) {

                Console.WriteLine($"Scanning for Permits (PermitTypeId={alertType.PermitTypeId}, PermitWorkClassId={alertType.PermitWorkClassId})");

                var fixedEmailsToAlert = new List<string>();

                if (!string.IsNullOrWhiteSpace(newCssPermitAlertConfiguration.OverrideEmailAddress)) {
                    fixedEmailsToAlert.Add(newCssPermitAlertConfiguration.OverrideEmailAddress);
                } else {
                    fixedEmailsToAlert.AddRange(alertType.EmailsToAlert.Split(','));
                }

                var releventPermits = await enerGovConnection.QueryAsync<ReleventPermit>(
                    new CommandDefinition(
                        @"SELECT
                                pmp.PMPERMITID AS PermitId,
                                pmpt.NAME AS PermitType,
                                pmpwc.NAME AS PermitWorkClass,
                                pmp.PERMITNUMBER AS PermitNumber,
                                pmp.DESCRIPTION AS PermitDescription,
                                ISNULL(ge.GLOBALENTITYNAME, '') AS ContractorName,
                                ISNULL(par.PARCELNUMBER, '') AS ParcelNumber,
                                LTRIM(RTRIM(ISNULL(ma.ADDRESSLINE1, ''))) + ' ' + LTRIM(RTRIM(ISNULL(ma.ADDRESSLINE2, ''))) + ' ' + LTRIM(RTRIM(ISNULL(ma.STREETTYPE, ''))) + ' ' + 
                                    LTRIM(RTRIM(ISNULL(ma.POSTDIRECTION, ''))) AS Address
                            FROM PMPERMIT pmp
                            INNER JOIN PMPERMITTYPE pmpt ON pmp.PMPERMITTYPEID = pmpt.PMPERMITTYPEID
                            INNER JOIN PMPERMITWORKCLASS pmpwc ON pmp.PMPERMITWORKCLASSID = pmpwc.PMPERMITWORKCLASSID
                            LEFT OUTER JOIN PMPERMITADDRESS pmpa ON pmp.PMPERMITID = pmpa.PMPERMITID AND pmpa.MAIN = 1
                            LEFT OUTER JOIN MAILINGADDRESS ma ON pmpa.MAILINGADDRESSID = ma.MAILINGADDRESSID
                            LEFT OUTER JOIN PMPERMITPARCEL pmpp ON pmp.PMPERMITID = pmpp.PMPERMITID AND pmpp.MAIN = 1
                            LEFT OUTER JOIN PARCEL par ON pmpp.PARCELID = par.PARCELID
                            LEFT OUTER JOIN PMPERMITCONTACT pmpc ON pmp.PMPERMITID = pmpc.PMPERMITID AND pmpc.LANDMANAGEMENTCONTACTTYPEID = '28ed9832-f568-4296-afd8-4c44a874f1b2'
                            LEFT OUTER JOIN GLOBALENTITY ge ON pmpc.GLOBALENTITYID = ge.GLOBALENTITYID
                            WHERE pmp.PMPERMITTYPEID = @PermitTypeId AND 
                                  pmp.PMPERMITWORKCLASSID = @PermitWorkClassId AND 
                                  pmp.PMPERMITSTATUSID = '8d4d91f1-bd78-477e-b2b7-ef9cbf672427'
                            GROUP BY pmp.PMPERMITID, pmpt.NAME, pmpwc.NAME, pmp.PERMITNUMBER, pmp.DESCRIPTION, ISNULL(ge.GLOBALENTITYNAME, ''), ISNULL(par.PARCELNUMBER, ''), 
                                LTRIM(RTRIM(ISNULL(ma.ADDRESSLINE1, ''))) + ' ' + LTRIM(RTRIM(ISNULL(ma.ADDRESSLINE2, ''))) + ' ' + LTRIM(RTRIM(ISNULL(ma.STREETTYPE, ''))) + ' ' + 
                                LTRIM(RTRIM(ISNULL(ma.POSTDIRECTION, '')))",
                        new {
                            alertType.PermitTypeId,
                            alertType.PermitWorkClassId
                        },
                        cancellationToken: cancellationToken));

                foreach (var releventPermit in releventPermits) {
                    
                    Console.Write($"  Handling Permit {releventPermit.PermitId} ({releventPermit.PermitNumber}) => ");

                    var permitId = Guid.Parse(releventPermit.PermitId);

                    if (previouslyAlertedPermits.Contains(permitId)) {
                        Console.WriteLine("Previously Alerted, Ignoring.");
                        continue;
                    }

                    var bodyText = await _templateRenderingService.GenerateAsync(
                        Assembly.GetExecutingAssembly(),
                        "NewCssPermitAlert.txt.liquid",
                        releventPermit);
                    var bodyHtml = await _templateRenderingService.GenerateAsync(
                        Assembly.GetExecutingAssembly(),
                        "NewCssPermitAlert.html.liquid",
                        releventPermit);

                    _configurationDbContext.QueueInternalEmail(
                        new EmailMessage {
                            EmailName = "NewCssPermitAlert",
                            FromAddress = newCssPermitAlertConfiguration.FromAddress,
                            ToAddresses = fixedEmailsToAlert.ToArray(),
                            Subject = $"New CSS Permit Received - {releventPermit.PermitNumber}",
                            BodyHtml = bodyHtml,
                            BodyText = bodyText
                        });

                    _configurationDbContext
                        .Set<NewCssPermitAlert>()
                        .Add(new NewCssPermitAlert {
                            PermitId = permitId,
                            TimeStamp = DateTime.Now,
                            EmailsNotified = fixedEmailsToAlert.Aggregate("", (x, y) => $"{x},{y}")
                        });

                    await _configurationDbContext.SaveChangesAsync(cancellationToken);
                    Console.WriteLine($"Sending emails to {fixedEmailsToAlert.Aggregate("", (x, y) => $"{x},{y}")}");

                }

            }

        }

    }

}
