using System.Collections.Generic;
using System.IO;
using System.Reflection;
using System.Security.Claims;
using System.Threading;
using Autofac;
using Elastic.Apm.NetCoreAll;
using Hangfire;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Server.HttpSys;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using EnerGov.Business;
using EnerGov.Business.Alerting;
using EnerGov.Business.Alerting.GenericCaseAlerts;
using EnerGov.Business.Alerting.NewCssPermitAlerts;
using EnerGov.Business.Exports;
using EnerGov.Business.FireOccupancy;
using EnerGov.Business.FireOccupancy.InspectionAutomations;
using EnerGov.Business.FireOccupancy.NotificationAutomations;
using EnerGov.Data.Configuration;
using EnerGov.Security.Authorization;
using EnerGov.Services.Email;
using EnerGov.Services.Email.Senders;
using EnerGov.Services.Reporting.SSRS;
using EnerGov.Web.ClerksLicensing;
using EnerGov.Web.ClerksLicensing.Hubs;
using EnerGov.Web.Common;
using EnerGov.Web.Exports;
using EnerGov.Web.FireOccupancy;
using EnerGov.Web.LandRecords;
using EnerGov.Web.Tasks;
using EnerGov.Web.Utilities;
using EnerGov.Web.UtilityExcavation;
using Microsoft.AspNetCore.Authentication.OpenIdConnect;
using Microsoft.AspNetCore.Mvc.Razor.RuntimeCompilation;
using Microsoft.Extensions.FileProviders;
using Microsoft.Extensions.Hosting;
using Microsoft.Identity.Web;
using Microsoft.Identity.Web.UI;
using Newtonsoft.Json;

namespace EnerGov.Web {

    public class Startup {

        public static Assembly[] WebAssemblies = {
            typeof(CommonWebModule).Assembly,
            typeof(UtilityExcavationWebModule).Assembly,
            typeof(FireOccupancyWebModule).Assembly,
            typeof(ExportsWebModule).Assembly,
            typeof(ClerksLicensingWebModule).Assembly,
            typeof(LandRecordsWebModule).Assembly,
            typeof(UtilitiesWebModule).Assembly
        };

        public Startup(
            IConfiguration configuration,
            IWebHostEnvironment webHostEnvironment) {
            Configuration = configuration;
            WebHostEnvironment = webHostEnvironment;
        }

        public IConfiguration Configuration { get; }
        public IWebHostEnvironment WebHostEnvironment { get; }

        public void ConfigureServices(IServiceCollection services) {
            var configurationConnectionString = Configuration.GetConnectionString("EnerGovConfiguration");
            var enerGovConnectionString = Configuration.GetConnectionString("EnerGov");
            var munisConnectionString = Configuration.GetConnectionString("Munis");
            var gisConnectionString = Configuration.GetConnectionString("GIS");
            var landRecordsConnectionString = Configuration.GetConnectionString("LandRecords");
            var tcmConnectionString = Configuration.GetConnectionString("Tcm");


            services.Configure<FireOccupancyConfiguration>(Configuration.GetSection("FireOccupancy"));
            services.Configure<ExportConfiguration>(Configuration.GetSection("Export"));
            services.Configure<EmailOptions>(Configuration.GetSection("Email"));
            services.Configure<SSRSConfiguration>(Configuration.GetSection("Reporting"));
            services.Configure<AlertingConfiguration>(Configuration.GetSection("Alerting"));

            

            services.AddMemoryCache();

            //services.AddAuthentication(IISDefaults.AuthenticationScheme);
            services
                .AddAuthentication(OpenIdConnectDefaults.AuthenticationScheme)
                .AddMicrosoftIdentityWebApp(Configuration, "AzureAD")
                .EnableTokenAcquisitionToCallDownstreamApi(new[] {"User.Read", "User.Read.All"})
                .AddMicrosoftGraph(Configuration.GetSection("GraphBeta"))
                .AddInMemoryTokenCaches();

            services.AddAuthorization(options => { options.RegisterAuthorizationPolicies(); });

            services.AddSignalR(options => { options.EnableDetailedErrors = true; });

            services.AddHangfire(_ => {
                _.UseSqlServerStorage(configurationConnectionString);
                _.UseFilter(new AutomaticRetryAttribute {Attempts = 0});
                _.UseRecommendedSerializerSettings(x => {
                    x.TypeNameHandling = TypeNameHandling.All;
                });
            });
            services.AddHangfireServer();

            

            services.AddControllersWithViews();
            var razorPages = 
                services
                    .AddRazorPages()
                    .AddMicrosoftIdentityUI();

            foreach (var webAssembly in WebAssemblies) {
                razorPages.AddApplicationPart(webAssembly);
            }

            if (WebHostEnvironment.IsDevelopment()) {
                razorPages.AddRazorRuntimeCompilation();

                services.Configure<MvcRazorRuntimeCompilationOptions>(options => {
                    var libraryPartialPath = Path.Combine(WebHostEnvironment.ContentRootPath, "..",
                        typeof(ClerksLicensingWebModule).Assembly.GetName().Name ?? string.Empty);
                    var libraryPath = Path.GetFullPath(libraryPartialPath);
                    options.FileProviders.Add(new PhysicalFileProvider(libraryPath));
                });

                services.AddMiniProfiler().AddEntityFramework();

                services.AddDatabaseDeveloperPageExceptionFilter();
            }

            

            services.AddHttpContextAccessor();

            services.AddHealthChecks()
                .AddDbContextCheck<ConfigurationDbContext>("configuration-db-context")
                .AddSqlServer(enerGovConnectionString, name: "energov-database")
                .AddSqlServer(munisConnectionString, name: "munis-database")
                .AddSqlServer(gisConnectionString, name: "gis-database")
                .AddSqlServer(landRecordsConnectionString, name: "land-records-database")
                .AddSqlServer(tcmConnectionString, name: "tcm-server")
                .AddHangfire(options => { options.MinimumAvailableServers = 1; }, name: "hangfire");

        }

        public void ConfigureContainer(ContainerBuilder builder) {
            var configurationConnectionString = Configuration.GetConnectionString("EnerGovConfiguration");
            var enerGovConnectionString = Configuration.GetConnectionString("EnerGov");
            var munisConnectionString = Configuration.GetConnectionString("Munis");
            var gisConnectionString = Configuration.GetConnectionString("GIS");
            var landRecordsConnectionString = Configuration.GetConnectionString("LandRecords");
            var countyTaxConnectionString = Configuration.GetConnectionString("CountyTax");
            var zollRmsConnectionString = Configuration.GetConnectionString("ZollRms");
            var tcmConnectionString = Configuration.GetConnectionString("Tcm");

            builder
                .RegisterModule(
                    new BusinessModule(
                        configurationConnectionString,
                        enerGovConnectionString,
                        munisConnectionString,
                        gisConnectionString,
                        landRecordsConnectionString,
                        countyTaxConnectionString,
                        zollRmsConnectionString,
                        tcmConnectionString))
                .RegisterModule(
                    new WebModule(WebAssemblies));

            
        }

        public void Configure(IApplicationBuilder app, IWebHostEnvironment env) {

            if (env.IsDevelopment()) {

                app.UseDeveloperExceptionPage();
                app.UseMiniProfiler();

            } else {

                app.UseExceptionHandler("/Error");
                app.UseHsts();

            }

            app.UseHttpsRedirection();
            app.UseStaticFiles();
            app.UseRouting();

            var impersonateUser = Configuration.GetImpersonateUser();

            if (impersonateUser != null && env.IsDevelopment()) {
                app.Use(async (context, next) => {

                    var claimsIdentity = new ClaimsIdentity(new List<Claim> {
                        new(ClaimTypes.PrimarySid, impersonateUser)
                    }, HttpSysDefaults.AuthenticationScheme);

                    var claimsPrincipal = new ClaimsPrincipal(claimsIdentity);

                    context.User = claimsPrincipal;

                    await next.Invoke();
                });
            } else {
                app.UseAuthentication();
            }

            app.UseAuthorization();

            if (!env.IsDevelopment()) {
                
            }

            app.UseHangfireServer();

            app.UseHangfireDashboard("/__admin/hangfire", new DashboardOptions {
                Authorization = new[] {new HangfireDashboardAuthorizationFilter()}
            });

            if (!env.IsDevelopment()) {

                app.UseAllElasticApm(Configuration);

                RecurringJob.AddOrUpdate<FireOccupancyInspectionTaskRunner>("fire-occupancy-automation",
                runner => runner.RunTasks(CancellationToken.None), "0 22 * * *");

                RecurringJob.AddOrUpdate<ReInspectionNotificationAutomationTaskRunner>("re-inspection-notification",
                    runner => runner.RunTasks(CancellationToken.None), "0 6 * * *");

                RecurringJob.AddOrUpdate<SmtpInternalEmailSender>("internal-email-sender",
                    sender => sender.SendEmails(CancellationToken.None), "10 * * * *");

                RecurringJob.AddOrUpdate<MailGunExternalEmailSender>("external-email-sender",
                    sender => sender.SendEmails(CancellationToken.None), "15 * * * *");

                RecurringJob.AddOrUpdate<EmailQueueFixTask>("email-queue-fix",
                    runner => runner.RunTask(CancellationToken.None), "0 6 * * *");

                RecurringJob.AddOrUpdate<NewCssPermitAlertTask>(
                    "new-css-permit-alert",
                    runner => runner.Run(CancellationToken.None),
                    "15 * * * *");

                RecurringJob.AddOrUpdate<GenericCaseAlertTask>(
                    "generic-case-alert",
                    runner => runner.Run(CancellationToken.None),
                    "15 * * * *");
            } else {
                RecurringJob.RemoveIfExists("fire-occupancy-automation");
                RecurringJob.RemoveIfExists("re-inspection-notification");
                RecurringJob.RemoveIfExists("internal-email-sender");
                RecurringJob.RemoveIfExists("external-email-sender");
                RecurringJob.RemoveIfExists("email-queue-fix");
                RecurringJob.RemoveIfExists("new-css-permit-alert");
                RecurringJob.RemoveIfExists("generic-case-alert");
            }

            app.UseEndpoints(endpoints => {
                endpoints.MapHealthChecks("/__health");
                endpoints.MapHub<JobProgressHub>("/jobprogress");
                endpoints.MapRazorPages();
                endpoints.MapControllers();
            });

        }
    }

}
