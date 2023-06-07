using System;
using System.IO;
using Autofac;
using Autofac.Extensions.DependencyInjection;
using EnerGov.Business;
using EnerGov.Business.Alerting;
using EnerGov.Business.Exports;
using EnerGov.Business.FireOccupancy;
using EnerGov.Security.Authorization;
using EnerGov.Services.Email;
using EnerGov.Services.Reporting.SSRS;
using Lax.Business.Authorization.Static;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Logging;
using Serilog;

namespace EnerGov.Cli {

    public class CliStartup : IStartup {

        public IServiceProvider ConfigureServices(IServiceCollection services) {

            var configuration = new ConfigurationBuilder()
                .SetBasePath(Directory.GetCurrentDirectory())
                .AddYamlFile("appsettings.yml", optional: false)
                .AddYamlFile($"appsettings.Development.yml", optional: true)
                .AddEnvironmentVariables()
                .Build();

            services.AddLogging(loggingBuilder =>
                loggingBuilder.ClearProviders().AddSerilog().SetMinimumLevel(LogLevel.Information));

            services.AddSingleton<IConfiguration>(configuration);

            services.Configure<FireOccupancyConfiguration>(configuration.GetSection("FireOccupancy"));
            services.Configure<ExportConfiguration>(configuration.GetSection("Export"));
            services.Configure<EmailOptions>(configuration.GetSection("Email"));
            services.Configure<SSRSConfiguration>(configuration.GetSection("Reporting"));
            services.Configure<AlertingConfiguration>(configuration.GetSection("Alerting"));

            services.AddMemoryCache();

            services.AddAuthorizationCore(options => { options.RegisterAuthorizationPolicies(); });

            var builder = new ContainerBuilder();
            builder.Populate(services);

            builder.RegisterModule(
                new BusinessModule(
                    @"Server=.;Database=EnerGovConfiguration;Trusted_Connection=True;MultipleActiveResultSets=True;",
                    //@"Server=lax-sql1;Database=EnerGovApps;User Id=app_EnerGovApps;Password=9HBuU2nwwaQAHGlakPSI;MultipleActiveResultSets=True;",
                    @"Server=lax-sql1\ENERGOV;Database=energov_prod;User Id=app_EnerGovApps;Password=9HBuU2nwwaQAHGlakPSI;MultipleActiveResultSets=True;",
                    @"Data Source=LAX-FINMUNAPP;Initial Catalog=munprod;User ID=MUNISReader;password=munis123;",
                    @"Data Source=lax-sql1;Initial Catalog=LAXGIS;User ID=app_EnerGovApps;password=9HBuU2nwwaQAHGlakPSI",
                    @"Server=lax-sql1;Database=LandRecords;User Id=app_EnerGovApps;Password=9HBuU2nwwaQAHGlakPSI;MultipleActiveResultSets=True;",
                    @"Server=LAXSQLPROD.gov.co.la-crosse.wi.us;Database=Tax;User Id=TaxUser;Password=taxuser123;MultipleActiveResultSets=True;",
                    @"Server=batman;Database=RMS5SQL;User Id=ZollRMSReporting;Password=BcQsHVLvp6UUfbQByTts;MultipleActiveResultSets=True;",
                    @"Server=lax-tylerma1\TYLERCI;Database=tylercmprod;User ID=app_EnerGovApps;password=9HBuU2nwwaQAHGlakPSI"));
            builder.RegisterModule<CliModule>();

            builder.RegisterStaticAuthorizationUserProvider();

            var container = builder.Build();

            return new AutofacServiceProvider(container);
        }

        public void Configure(IApplicationBuilder app) => throw new NotImplementedException();

    }

}