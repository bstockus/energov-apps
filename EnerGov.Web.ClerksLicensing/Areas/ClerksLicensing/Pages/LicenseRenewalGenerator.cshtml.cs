using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;
using Dapper;
using EnerGov.Business.ClerksLicensing.Helpers;
using EnerGov.Business.ClerksLicensing.LicensePackets;
using EnerGov.Data.EnerGov;
using EnerGov.Web.ClerksLicensing.Hubs;
using Hangfire;
using Lax.Data.Sql;
using Lax.Helpers.AsyncProgress;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using Microsoft.AspNetCore.Mvc.Rendering;
using Microsoft.AspNetCore.SignalR;
using Microsoft.Extensions.Caching.Memory;

namespace EnerGov.Web.ClerksLicensing.Areas.ClerksLicensing.Pages {
    public class LicenseRenewalGeneratorModel : PageModel {

        private readonly LicensePacketGenerator _licensePacketGenerator;
        private readonly ISqlConnectionProvider<EnerGovSqlServerConnection> _enerGovSqlConnectionProvider;
        private readonly IBackgroundJobClient _backgroundJobClient;
        private readonly IMemoryCache _memoryCache;
        private readonly IHubContext<JobProgressHub> _jobProgressHubContext;

        public string JobId { get; set; }
        public string FileName { get; set; }

        public IEnumerable<LicensePacketGenerator.LicensePacketInfo> LicensePacketInfos =
            Array.Empty<LicensePacketGenerator.LicensePacketInfo>();

        public IEnumerable<SelectListItem> LicenseTypes { get; set; }
        public IEnumerable<SelectListItem> LicenseStatuses { get; set; }

        [BindProperty]
        public int TaxYear { get; set; }

        [BindProperty]
        public DateTime GrantedDate { get; set; }

        [BindProperty]
        public string[] LicenseTypesToInclude { get; set; }

        [BindProperty]
        public string[] LicenseStatusesToInclude { get; set; }

        public LicenseRenewalGeneratorModel(
            LicensePacketGenerator licensePacketGenerator,
            ISqlConnectionProvider<EnerGovSqlServerConnection> enerGovSqlConnectionProvider,
            IBackgroundJobClient backgroundJobClient,
            IMemoryCache memoryCache,
            IHubContext<JobProgressHub> jobProgressHubContext) {
            _licensePacketGenerator = licensePacketGenerator;
            _enerGovSqlConnectionProvider = enerGovSqlConnectionProvider;
            _backgroundJobClient = backgroundJobClient;
            _memoryCache = memoryCache;
            _jobProgressHubContext = jobProgressHubContext;
        }

        public async Task OnGet(CancellationToken cancellationToken) {
            TaxYear = DateTime.Today.Year;
            GrantedDate = DateTime.Today;

            var enerGovSqlConnection = await _enerGovSqlConnectionProvider.GetDbConnectionAsync(cancellationToken);

            LicenseTypes = await FetchLicenseTypeSelectInfos(enerGovSqlConnection, cancellationToken);
            LicenseStatuses = await FetchLicenseStatusSelectInfos(enerGovSqlConnection, cancellationToken);

        }

        public async Task OnPostFetchLicenses(CancellationToken cancellationToken) {

            var enerGovSqlConnection = await _enerGovSqlConnectionProvider.GetDbConnectionAsync(cancellationToken);

            LicenseTypes = await FetchLicenseTypeSelectInfos(enerGovSqlConnection, cancellationToken);
            LicenseStatuses = await FetchLicenseStatusSelectInfos(enerGovSqlConnection, cancellationToken);

            LicensePacketInfos = await _licensePacketGenerator.Fetch(
                new LicensePacketGenerator.LicensePacketRequest(
                    TaxYear,
                    LicenseTypesToInclude,
                    LicenseStatusesToInclude,
                    GrantedDate));

        }

        public async Task OnPostGenerate(CancellationToken cancellationToken) {

            JobId = Guid.NewGuid().ToString();
            FileName = "License Certificate Packets";

            var enerGovSqlConnection = await _enerGovSqlConnectionProvider.GetDbConnectionAsync(cancellationToken);

            LicenseTypes = await FetchLicenseTypeSelectInfos(enerGovSqlConnection, cancellationToken);
            LicenseStatuses = await FetchLicenseStatusSelectInfos(enerGovSqlConnection, cancellationToken);

            var licensePacketRequest = new LicensePacketGenerator.LicensePacketRequest(
                TaxYear,
                LicenseTypesToInclude,
                LicenseStatusesToInclude,
                GrantedDate);

            _backgroundJobClient.Enqueue(() => PerformGenerateBackgroundJob(
                JobId,
                licensePacketRequest));

        }

        public async Task PerformGenerateBackgroundJob(
            string jobId,
            LicensePacketGenerator.LicensePacketRequest specification) {

            var progress = new AsyncProgress<ReportGeneratorProgress>(async (generatorProgress) => {
                await _jobProgressHubContext.Clients.Group(jobId).SendAsync("progress",
                    generatorProgress.ProgressPercentage, generatorProgress.TextMessage);
            });

            var results = await _licensePacketGenerator.Generate(
                specification,
                reportGeneratorProgress: progress);

            _memoryCache.Set(jobId, results);

            await _jobProgressHubContext.Clients.Group(jobId).SendAsync("show-download");

        }

        private async Task<IEnumerable<SelectListItem>> FetchLicenseTypeSelectInfos(
            IDbConnection enerGovSqlConnection,
            CancellationToken cancellationToken) =>
            (await enerGovSqlConnection.QueryAsync<LicenseTypeInformation>(
                new CommandDefinition(
                    @"SELECT bllt.BLLICENSETYPEID AS LicenseTypeId, bllt.NAME AS LicenseTypeName 
                        FROM BLLICENSETYPE bllt ORDER BY bllt.NAME",
                    cancellationToken: cancellationToken)))
            .Select(_ => new SelectListItem(
                _.LicenseTypeName,
                _.LicenseTypeId))
            .ToList();

        private async Task<IEnumerable<SelectListItem>> FetchLicenseStatusSelectInfos(
            IDbConnection enerGovSqlConnection,
            CancellationToken cancellationToken) =>
            (await enerGovSqlConnection.QueryAsync<LicenseStatusInformation>(
                new CommandDefinition(
                    @"SELECT blls.BLLICENSESTATUSID AS LicenseStatusId, blls.NAME AS LicenseStatusName 
                        FROM BLLICENSESTATUS blls ORDER BY blls.NAME",
                    cancellationToken: cancellationToken)))
            .Select(_ => new SelectListItem(
                _.LicenseStatusName,
                _.LicenseStatusId))
            .ToList();

        public record LicenseTypeInformation(
            string LicenseTypeId,
            string LicenseTypeName);

        public record LicenseStatusInformation(
            string LicenseStatusId,
            string LicenseStatusName);


    }
}
