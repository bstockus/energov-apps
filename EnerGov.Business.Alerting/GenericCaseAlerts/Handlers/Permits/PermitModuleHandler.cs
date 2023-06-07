using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Common;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;
using Dapper;
using EnerGov.Business.Alerting.GenericCaseAlerts.Handlers.Permits.Models;
using EnerGov.Business.Alerting.GenericCaseAlerts.Models;
using EnerGov.Data.Configuration;
using EnerGov.Services.Email.Helpers;
using EnerGov.Services.Templating;
using Microsoft.EntityFrameworkCore;

namespace EnerGov.Business.Alerting.GenericCaseAlerts.Handlers.Permits {

    public class PermitModuleHandler : IModuleHandler {

        public string Module => "PERMIT";

        public async Task ProcessModule(
            IEnumerable<GenericCaseAlertSpecification> specifications,
            DbConnection enerGovConnection,
            ConfigurationDbContext configurationDbContext,
            ITemplateRenderingService templateRenderingService,
            CancellationToken cancellationToken) {

            await PermitChangeScan(
                specifications, 
                enerGovConnection, 
                configurationDbContext, 
                templateRenderingService, 
                cancellationToken);


            await PermitInvoicePaidScan(
                specifications, 
                enerGovConnection, 
                configurationDbContext, 
                templateRenderingService, 
                cancellationToken);

        }

        private async Task PermitInvoicePaidScan(
            IEnumerable<GenericCaseAlertSpecification> specifications, 
            IDbConnection enerGovConnection,
            ConfigurationDbContext configurationDbContext, 
            ITemplateRenderingService templateRenderingService,
            CancellationToken cancellationToken) {

            // Scan for Fee Changes

            if (specifications.Any(_ => _.IsPaidEvent())) {
                var basicPermitInvoiceInfos = (await enerGovConnection.QueryAsync<BasicPermitInvoiceInfo>(
                    new CommandDefinition(
                        @"SELECT
                                        pmpf.PMPERMITID AS PermitId,
                                        cainv.CAINVOICEID AS InvoiceId,
                                        cainv.CASTATUSID AS InvoiceStatusId,
                                        cainv.ROWVERSION AS RowVersion,
                                        pmp.PMPERMITTYPEID AS PermitTypeId,
                                        pmp.PMPERMITWORKCLASSID AS PermitWorkClassId
                                    FROM CAINVOICE cainv
                                    INNER JOIN CAINVOICEFEE cainv_fee ON cainv.CAINVOICEID = cainv_fee.CAINVOICEID
                                    INNER JOIN CACOMPUTEDFEE cacf ON cainv_fee.CACOMPUTEDFEEID = cacf.CACOMPUTEDFEEID
                                    INNER JOIN PMPERMITFEE pmpf ON cacf.CACOMPUTEDFEEID = pmpf.CACOMPUTEDFEEID
                                    INNER JOIN PMPERMIT pmp ON pmpf.PMPERMITID = pmp.PMPERMITID
                                    WHERE pmp.APPLYDATE >= '2018-01-01' AND pmp.PMPERMITSTATUSID <> '576b2e7a-3fd5-492c-890d-54f8ff488cb0' AND pmp.PMPERMITSTATUSID <> 'ee460170-2d3a-4802-9119-ee58d0e42b70'
                                    GROUP BY pmpf.PMPERMITID,
                                             cainv.CAINVOICEID,
                                             cainv.CASTATUSID,
                                             cainv.ROWVERSION,
                                             pmp.PMPERMITTYPEID,
                                             pmp.PMPERMITWORKCLASSID",
                        cancellationToken: cancellationToken))).ToList();

                Console.WriteLine($"\n\nBasic Permit Invoice Infos = {basicPermitInvoiceInfos.Count}");

                var permitAlertFeeScans = (await configurationDbContext
                    .Set<GenericCaseAlertFeeScan>()
                    .AsNoTracking()
                    .TagWith("Select Permit Generic Alert Fee Scans")
                    .Where(_ => _.Module.Equals(Module))
                    .ToListAsync(cancellationToken)).ToLookup(_ => (CaseId: _.CaseId, InvoiceId: _.InvoiceId));

                foreach (var basicPermitInvoiceInfo in basicPermitInvoiceInfos) {
                    var permitId = Guid.Parse(basicPermitInvoiceInfo.PermitId);
                    var invoiceId = Guid.Parse(basicPermitInvoiceInfo.InvoiceId);

                    var previousPermitAlertFeeScans =
                        permitAlertFeeScans.Contains((permitId, invoiceId))
                            ? permitAlertFeeScans[(permitId, invoiceId)].ToList()
                            : new List<GenericCaseAlertFeeScan>();

                    if (basicPermitInvoiceInfo.InvoiceStatusId == 4 &&
                        (!previousPermitAlertFeeScans.Any() || previousPermitAlertFeeScans
                            .OrderByDescending(_ => _.RowVersion).First().InvoiceStatusId != 4)) {
                        var releventSpecifications = specifications.Where(_ =>
                                _.IsPaidEvent() &&
                                (!_.TypeFilters().Any() ||
                                 _.TypeFilters().Contains(basicPermitInvoiceInfo.PermitTypeId.ToUpper())) &&
                                (!_.WorkClassFilters().Any() ||
                                 _.WorkClassFilters().Contains(basicPermitInvoiceInfo.PermitWorkClassId.ToUpper())))
                            .ToList();


                        // This is a paid invoice, run the specifications

                        if (releventSpecifications.Any()) {
                            var permitInfo = await QueryPermitInfo(enerGovConnection, cancellationToken, permitId);

                            foreach (var releventSpecification in releventSpecifications) {

                                if (await TestAdditionalSqlPredicate(enerGovConnection, cancellationToken,
                                    releventSpecification, basicPermitInvoiceInfo.PermitId)) {
                                    break;
                                }

                                // Handle Relevant Specification

                                await HandlePermitAlert(
                                    configurationDbContext, 
                                    templateRenderingService, 
                                    releventSpecification,
                                    permitInfo, "PERMIT PAID");
                            }
                        }
                    }

                    if (!previousPermitAlertFeeScans.Any(_ => _.RowVersion.Equals(basicPermitInvoiceInfo.RowVersion))) {
                        configurationDbContext
                            .Set<GenericCaseAlertFeeScan>()
                            .Add(new GenericCaseAlertFeeScan {
                                Module = Module,
                                CaseId = permitId,
                                InvoiceId = invoiceId,
                                DateScanned = DateTime.Now,
                                InvoiceStatusId = basicPermitInvoiceInfo.InvoiceStatusId,
                                RowVersion = basicPermitInvoiceInfo.RowVersion
                            });

                        await configurationDbContext.SaveChangesAsync(cancellationToken);
                    }
                }
            }
        }

        private async Task PermitChangeScan(
            IEnumerable<GenericCaseAlertSpecification> specifications, 
            IDbConnection enerGovConnection,
            ConfigurationDbContext configurationDbContext, 
            ITemplateRenderingService templateRenderingService,
            CancellationToken cancellationToken) {

            var basicPermitInfos = (await enerGovConnection.QueryAsync<BasicPermitInfo>(
                    @"SELECT
                        pmp.PMPERMITID AS PermitId,
                        pmp.ROWVERSION AS RowVersion,
                        pmp.PMPERMITSTATUSID AS PermitStatusId,
                        pmp.PMPERMITTYPEID AS PermitTypeId,
                        pmp.PMPERMITWORKCLASSID AS PermitWorkClassId
                    FROM PMPERMIT pmp
                    WHERE pmp.APPLYDATE >= '2018-01-01' AND 
                          pmp.PMPERMITSTATUSID <> '576b2e7a-3fd5-492c-890d-54f8ff488cb0' AND 
                          pmp.PMPERMITSTATUSID <> 'ee460170-2d3a-4802-9119-ee58d0e42b70'")
                ).ToList();

            Console.WriteLine($"\n\nBasic Permit Infos = {basicPermitInfos.Count}");

            var permitAlertScans = (await configurationDbContext
                .Set<GenericCaseAlertScan>()
                .AsNoTracking()
                .TagWith("Select Permit Generic Alert Scans")
                .Where(_ => _.Module.Equals(Module))
                .ToListAsync(cancellationToken)).ToLookup(_ => _.CaseId);

            foreach (var basicPermitInfo in basicPermitInfos) {
                var permitId = Guid.Parse(basicPermitInfo.PermitId);

                var previousPermitAlertScans =
                    permitAlertScans.Contains(permitId)
                        ? permitAlertScans[permitId].ToList()
                        : new List<GenericCaseAlertScan>();

                if (!previousPermitAlertScans.Any()) {

                    // This is a new permit
                    var releventSpecifications = specifications.Where(_ =>
                            _.IsCreatedEvent() &&
                            (!_.TypeFilters().Any() ||
                             _.TypeFilters().Contains(basicPermitInfo.PermitTypeId.ToUpper())) &&
                            (!_.WorkClassFilters().Any() ||
                             _.WorkClassFilters().Contains(basicPermitInfo.PermitWorkClassId.ToUpper())))
                        .ToList();

                    if (releventSpecifications.Any()) {
                        var permitInfo = await QueryPermitInfo(enerGovConnection, cancellationToken, permitId);

                        foreach (var releventSpecification in releventSpecifications) {
                            if (await TestAdditionalSqlPredicate(
                                enerGovConnection, 
                                cancellationToken, 
                                releventSpecification,
                                basicPermitInfo.PermitId)) {

                                break;
                            }

                            // Handle Relevant Specification

                            await HandlePermitAlert(
                                configurationDbContext, 
                                templateRenderingService, 
                                releventSpecification,
                                permitInfo, 
                                "NEW PERMIT");
                        }
                    }

                } else if (!basicPermitInfo.PermitStatusId.Equals(
                    previousPermitAlertScans.OrderByDescending(_ => _.RowVersion).First().CaseStatusId?.ToString() ??
                    "")) {

                    // This is a changed permit
                    var releventSpecifications = specifications.Where(_ =>
                            _.IsStatusChangeEvent() &&
                            _.StatusChangeEventStatuses().Contains(basicPermitInfo.PermitStatusId) &&
                            (!_.TypeFilters().Any() ||
                             _.TypeFilters().Contains(basicPermitInfo.PermitTypeId.ToUpper())) &&
                            (!_.WorkClassFilters().Any() ||
                             _.WorkClassFilters().Contains(basicPermitInfo.PermitWorkClassId.ToUpper())))
                        .ToList();

                    if (releventSpecifications.Any()) {
                        var permitInfo = await QueryPermitInfo(enerGovConnection, cancellationToken, permitId);

                        foreach (var releventSpecification in releventSpecifications) {
                            if (await TestAdditionalSqlPredicate(
                                enerGovConnection, 
                                cancellationToken, 
                                releventSpecification,
                                basicPermitInfo.PermitId)) {

                                break;
                            }

                            // Handle Relevant Specification

                            await HandlePermitAlert(
                                configurationDbContext, 
                                templateRenderingService, 
                                releventSpecification,
                                permitInfo, 
                                "PERMIT STATUS CHANGED");
                        }
                    }

                }

                if (!previousPermitAlertScans.Any(_ => _.RowVersion.Equals(basicPermitInfo.RowVersion))) {
                    configurationDbContext
                        .Set<GenericCaseAlertScan>()
                        .Add(new GenericCaseAlertScan {
                            CaseId = permitId,
                            Module = Module,
                            DateScanned = DateTime.Now,
                            CaseStatusId = Guid.Parse(basicPermitInfo.PermitStatusId),
                            RowVersion = basicPermitInfo.RowVersion
                        });

                    await configurationDbContext.SaveChangesAsync(cancellationToken);
                }
            }
        }

        private static async Task HandlePermitAlert(
            ConfigurationDbContext configurationDbContext,
            ITemplateRenderingService templateRenderingService, 
            GenericCaseAlertSpecification releventSpecification,
            PermitInfo permitInfo,
            string alertType) {

            Console.WriteLine(
                $"  Handling {alertType} Event {releventSpecification.Name} for Permit {permitInfo.PermitNumber}");

            var bodyText =
                await templateRenderingService.GenerateAsync(releventSpecification.BodyText,
                    permitInfo);
            var bodyHtml =
                await templateRenderingService.GenerateAsync(releventSpecification.BodyHtml,
                    permitInfo);

            configurationDbContext.QueueInternalEmail(
                new EmailMessage {
                    EmailName = releventSpecification.Name,
                    FromAddress = "energov-alerts@cityoflacrosse.org",
                    ToAddresses = releventSpecification.AllRecipients(permitInfo.AssignedUserEmail).ToArray(),
                    Subject =
                        $"[ENERGOV][{alertType}] {permitInfo.PermitNumber} - {releventSpecification.Subject}",
                    BodyHtml = bodyHtml,
                    BodyText = bodyText
                });
        }

        private static async Task<PermitInfo> QueryPermitInfo(
            IDbConnection enerGovConnection,
            CancellationToken cancellationToken,
            Guid permitId) =>

            await enerGovConnection.QueryFirstAsync<PermitInfo>(
                new CommandDefinition(
                    @"SELECT
                                    pmp.PMPERMITID AS PermitId,
                                    pmpt.NAME AS PermitType,
                                    pmpwc.NAME AS PermitWorkClass,
                                    pmp.PERMITNUMBER AS PermitNumber,
                                    pmp.DESCRIPTION AS PermitDescription,
                                    ge.GLOBALENTITYNAME AS ContractorName,
                                    par.PARCELNUMBER AS ParcelNumber,
                                    LTRIM(RTRIM(ma.ADDRESSLINE1)) + ' ' + LTRIM(RTRIM(ma.ADDRESSLINE2)) + ' ' + LTRIM(RTRIM(ma.STREETTYPE)) + ' ' + LTRIM(RTRIM(ma.POSTDIRECTION)) AS Address,
                                    usr.EMAIL AS AssignedUserEmail
                                FROM PMPERMIT pmp
                                INNER JOIN PMPERMITTYPE pmpt ON pmp.PMPERMITTYPEID = pmpt.PMPERMITTYPEID
                                INNER JOIN PMPERMITWORKCLASS pmpwc ON pmp.PMPERMITWORKCLASSID = pmpwc.PMPERMITWORKCLASSID
                                LEFT OUTER JOIN PMPERMITADDRESS pmpa ON pmp.PMPERMITID = pmpa.PMPERMITID AND pmpa.MAIN = 1
                                LEFT OUTER JOIN MAILINGADDRESS ma ON pmpa.MAILINGADDRESSID = ma.MAILINGADDRESSID
                                LEFT OUTER JOIN PMPERMITPARCEL pmpp ON pmp.PMPERMITID = pmpp.PMPERMITID AND pmpp.MAIN = 1
                                LEFT OUTER JOIN PARCEL par ON pmpp.PARCELID = par.PARCELID
                                LEFT OUTER JOIN PMPERMITCONTACT pmpc ON pmp.PMPERMITID = pmpc.PMPERMITID AND pmpc.LANDMANAGEMENTCONTACTTYPEID = '28ed9832-f568-4296-afd8-4c44a874f1b2'
                                LEFT OUTER JOIN GLOBALENTITY ge ON pmpc.GLOBALENTITYID = ge.GLOBALENTITYID
                                LEFT OUTER JOIN USERS usr ON pmp.ASSIGNEDTO = usr.SUSERGUID
                                WHERE pmp.PMPERMITID = @PermitId",
                    new {
                        PermitId = permitId.ToString()
                    },
                    cancellationToken: cancellationToken));

        private static async Task<bool> TestAdditionalSqlPredicate(
            IDbConnection enerGovConnection,
            CancellationToken cancellationToken, 
            GenericCaseAlertSpecification releventSpecification,
            string permitId) {

            if (string.IsNullOrWhiteSpace(releventSpecification.AdditionalSqlPredicate)) {
                return false;
            }

            var results = (int) (await enerGovConnection.ExecuteScalarAsync(
                new CommandDefinition(
                    releventSpecification.AdditionalSqlPredicate,
                    new {
                        PermitId = permitId
                    },
                    cancellationToken: cancellationToken)));

            return results == 0;
        }

    }

}