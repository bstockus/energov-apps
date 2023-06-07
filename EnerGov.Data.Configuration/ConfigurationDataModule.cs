using System.Reflection;
using Autofac;
using Lax.Data.Entities.EntityFrameworkCore;
using Module = Autofac.Module;

namespace EnerGov.Data.Configuration {

    public class ConfigurationDataModule : Module {

        private readonly Assembly[] _entityAssemblies;
        private readonly string _connectionString;

        public ConfigurationDataModule(
            Assembly[] entityAssemblies,
            string connectionString) {
            _entityAssemblies = entityAssemblies;
            _connectionString = connectionString;
        }

        protected override void Load(ContainerBuilder builder) {

            builder.RegisterUnitOfWork();

            builder
                .RegisterEntityFrameworkContext<ConfigurationDbContext>()
                .RegisterEntityFrameworkModelBuilders(_entityAssemblies)
                .RegisterEntityFrameworkDbSetProviders(_entityAssemblies);

            builder
                .Register(context => new ConfigurationConnectionStringProvider(_connectionString))
                .AsSelf()
                .InstancePerDependency();

        }

    }

}