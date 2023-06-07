using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Reflection;
using System.Threading;
using System.Threading.Tasks;
using AutoMapper.Internal;
using EnerGov.Business.ClerksLicensing.Helpers;
using EnerGov.Business.ClerksLicensing.RenewalPackets.Generators;
using EnerGov.Data.EnerGov;
using EnerGov.Web.ClerksLicensing.Hubs;
using Hangfire;
using Lax.Data.Sql;
using Lax.Helpers.AsyncProgress;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using Microsoft.AspNetCore.SignalR;
using Microsoft.Extensions.Caching.Memory;
using Microsoft.Extensions.Hosting;

namespace EnerGov.Web.ClerksLicensing.Areas.ClerksLicensing.Pages
{

    public class LicenseRenewalPacketModel : PageModel {

        public record LicenseInformation(
            string LicenseName,
            string TypeName, 
            IEnumerable<LicenseFeeInformation> FeeInformations);

        public record LicenseFeeInformation(
            string FieldName,
            string DisplayName,
            decimal DefaultValue);

        private readonly IEnumerable<ILicenseRenewalFormGenerator> _licenseRenewalFormGenerators;
        private readonly RenewalPacketGenerator _renewalPacketGenerator;
        private readonly IHubContext<JobProgressHub> _jobProgressHubContext;
        private readonly IMemoryCache _memoryCache;
        private readonly IBackgroundJobClient _backgroundJobClient;
        private readonly ISqlConnectionProvider<EnerGovSqlServerConnection> _enerGovSqlConnectionProvider;
        private readonly IWebHostEnvironment _webHostEnvironment;

        public string JobId { get; set; }
        public string FileName { get; set; }

        [BindProperty]
        public string RunType { get; set; }

        [BindProperty]
        public int PriorLicenseYear { get; set; }

        [BindProperty]
        public bool AddBlankPagesForDoubleSidedPrinting { get; set; }

        [BindProperty]
        public DateTime LetterDate { get; set; }

        [BindProperty]
        public DateTime? ApplicationDueDate { get; set; }

        [BindProperty]
        public DateTime? JADate { get; set; }

        [BindProperty]
        public DateTime? CouncilDate { get; set; }

        [BindProperty]
        public DateTime? PaymentDueDate { get; set; }

        [BindProperty]
        public DateTime? MiscellaneousDueDate { get; set; }

        public IEnumerable<LicenseInformation> LicenseFeeInformations { get; set; }


        public LicenseRenewalPacketModel(
            IEnumerable<ILicenseRenewalFormGenerator> licenseRenewalFormGenerators,
            RenewalPacketGenerator renewalPacketGenerator,
            IHubContext<JobProgressHub> jobProgressHubContext,
            IMemoryCache memoryCache,
            IBackgroundJobClient backgroundJobClient,
            ISqlConnectionProvider<EnerGovSqlServerConnection> enerGovSqlConnectionProvider,
            IWebHostEnvironment webHostEnvironment) {
            _licenseRenewalFormGenerators = licenseRenewalFormGenerators;
            _renewalPacketGenerator = renewalPacketGenerator;
            _jobProgressHubContext = jobProgressHubContext;
            _memoryCache = memoryCache;
            _backgroundJobClient = backgroundJobClient;
            _enerGovSqlConnectionProvider = enerGovSqlConnectionProvider;
            _webHostEnvironment = webHostEnvironment;
        }

        public async Task OnGet(CancellationToken cancellationToken) {

            PriorLicenseYear = DateTime.Today.Year - 1;
            AddBlankPagesForDoubleSidedPrinting = true;

            LetterDate = DateTime.Today;

            if (_webHostEnvironment.IsDevelopment()) {
                ApplicationDueDate = new DateTime(2020, 4, 15);
                JADate = new DateTime(2020, 6, 2);
                CouncilDate = new DateTime(2020, 6, 11);
                PaymentDueDate = new DateTime(2020, 6, 15);
                MiscellaneousDueDate = new DateTime(2020, 5, 27);
            }

            var enerGovSqlConnection = await _enerGovSqlConnectionProvider.GetDbConnectionAsync(cancellationToken);

            var licenseFeeInformations = new List<LicenseInformation>();

            foreach (var licenseRenewalFormGenerator in _licenseRenewalFormGenerators) {
                var currentFeesForLicense =
                    await licenseRenewalFormGenerator.CurrentFeesForLicense(
                        enerGovSqlConnection,
                        DateTime.Today.Year.ToString(), 
                        cancellationToken);

                licenseFeeInformations.Add(
                    new LicenseInformation(
                        licenseRenewalFormGenerator.LicenseTypeName,
                        licenseRenewalFormGenerator.GetType().Name,
                        currentFeesForLicense.GetType().GetProperties()
                            .Where(f => f.IsPublic() && f.PropertyType == typeof(decimal)).Select(f =>
                                new LicenseFeeInformation(
                                    f.Name,
                                    (f.GetCustomAttribute(typeof(DisplayAttribute)) as DisplayAttribute)?.Name ?? "",
                                    (decimal) f.GetMemberValue(currentFeesForLicense)))));
            }

            LicenseFeeInformations =
                licenseFeeInformations;

            //LicenseFeeInformations =
            //    _licenseRenewalFormGenerators.Select(_ => (_.LicenseTypeName,
            //        _.GetType().Name,
            //        _.DefaultFeesForLicense().GetType().GetProperties()
            //            .Where(f => f.IsPublic() && f.PropertyType == typeof(decimal)).Select(f =>
            //                (f.Name,
            //                    (f.GetCustomAttribute(typeof(DisplayAttribute)) as DisplayAttribute)?.Name ?? "",
            //                    (decimal)f.GetMemberValue(_.DefaultFeesForLicense())))));

        }

        public void OnPostGenerate(IFormCollection formData) {

            JobId = Guid.NewGuid().ToString();
            FileName = "License Renewal Packets";

            var coverLetterDates = new CoverLetterDates {
                LetterDate = LetterDate,
                ApplicationDueDate = ApplicationDueDate ?? DateTime.Today,
                JADate = JADate ?? DateTime.Today,
                CouncilDate = CouncilDate ?? DateTime.Today,
                PaymentDueDate = PaymentDueDate ?? DateTime.Today,
                MiscellaneousDueDate = MiscellaneousDueDate ?? DateTime.Today
            };

            var licenseFeeInformations = _licenseRenewalFormGenerators.Select(_ => (_.LicenseTypeName,
                _.GetType().Name,
                _.DefaultFeesForLicense(),
                _.DefaultFeesForLicense().GetType().GetProperties()
                    .Where(f => f.IsPublic() && f.PropertyType == typeof(decimal)).Select(f =>
                        (f.Name,
                            (f.GetCustomAttribute(typeof(DisplayAttribute)) as DisplayAttribute)?.Name ?? "",
                            (decimal) f.GetMemberValue(_.DefaultFeesForLicense()),
                            f))));

            var licenseFees = new List<object>();

            foreach (var licenseFeeInformation in licenseFeeInformations) {

                if (formData.Any(_ => _.Key.Equals(licenseFeeInformation.Name))) {

                    var licenseFeesObject = licenseFeeInformation.Item3;

                    foreach (var feeInformation in licenseFeeInformation.Item4) {
                        
                        if (formData.Any(_ => _.Key.Equals(licenseFeeInformation.Name + "." + feeInformation.Name))) {

                            var decimalValue = decimal.Parse(formData.First(_ =>
                                _.Key.Equals(licenseFeeInformation.Name + "." + feeInformation.Name)).Value.First());

                            feeInformation.f.SetValue(licenseFeesObject, decimalValue);

                        }

                    }

                    licenseFees.Add(licenseFeesObject);


                }

            }

            var renewalRequest = new RenewalRequest(
                PriorLicenseYear,
                licenseFees,
                RunType,
                AddBlankPagesForDoubleSidedPrinting,
                coverLetterDates);

            _backgroundJobClient.Enqueue(() => PerformGenerateBackgroundJob(
                JobId,
                renewalRequest,
                "Production"));

        }

        public async Task PerformGenerateBackgroundJob(
            string jobId,
            RenewalRequest specification,
            string environment) {

            var progress = new AsyncProgress<ReportGeneratorProgress>(async (generatorProgress) => {
                await _jobProgressHubContext.Clients.Group(jobId).SendAsync("progress",
                    generatorProgress.ProgressPercentage, generatorProgress.TextMessage);
            });

            var results = await _renewalPacketGenerator.Generate(
                specification,
                environment,
                "Prod",
                progress);

            

            _memoryCache.Set(jobId, results);

            await _jobProgressHubContext.Clients.Group(jobId).SendAsync("show-download");

        }

    }
}
