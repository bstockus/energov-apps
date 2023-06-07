using Autofac;
using Autofac.Extensions.DependencyInjection;
using Microsoft.EntityFrameworkCore.Design;
using Microsoft.Extensions.DependencyInjection;
using EnerGov.Business;
using EnerGov.Data.Configuration;
using Serilog;

namespace EnerGov.Web {

    public class DesignTimeDataStoreContextFactory : IDesignTimeDbContextFactory<ConfigurationDbContext> {

        public ConfigurationDbContext CreateDbContext(string[] args) {
            Log.Logger = new LoggerConfiguration()
                .MinimumLevel.Debug()
                .WriteTo.LiterateConsole()
                .WriteTo.Debug()
                .CreateLogger();

            var services = new ServiceCollection();
            
            var builder = new ContainerBuilder();
            builder.Populate(services);

            builder.RegisterModule(
                new BusinessModule(
                    @"Server=.;Database=EnerGovConfiguration;User Id=test;Password=Passw0rd;MultipleActiveResultSets=True;",
                    @"",
                    @"",
                    @"",
                    @"",
                    @"",
                    @"",
                    @""));

            var container = builder.Build();

            var scope = container.BeginLifetimeScope();

            return scope.Resolve<ConfigurationDbContext>();
        }

    }

}