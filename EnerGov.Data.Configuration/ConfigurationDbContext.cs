using System.Collections.Generic;
using Lax.Data.Entities.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore;

namespace EnerGov.Data.Configuration {

    public class ConfigurationDbContext : DbContext {

        private readonly ConfigurationConnectionStringProvider _configurationConnectionStringProvider;

        private readonly IEnumerable<IEntityFrameworkModelBuilder<ConfigurationDbContext>>
            _entityFrameworkModelBuilders;

        public ConfigurationDbContext(
            ConfigurationConnectionStringProvider configurationConnectionStringProvider,
            IEnumerable<IEntityFrameworkModelBuilder<ConfigurationDbContext>> entityFrameworkModelBuilders) {

            _configurationConnectionStringProvider = configurationConnectionStringProvider;
            _entityFrameworkModelBuilders = entityFrameworkModelBuilders;
        }

        protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder) {
            base.OnConfiguring(optionsBuilder);


            optionsBuilder.EnableSensitiveDataLogging();
            optionsBuilder.UseSqlServer(
                _configurationConnectionStringProvider.ConnectionString,
                sqlOption => {
                    sqlOption.MigrationsAssembly(typeof(ConfigurationDbContext).Assembly.FullName);
                });
        }

        protected override void OnModelCreating(ModelBuilder modelBuilder) {
            foreach (var entityFrameworkModelBuilder in _entityFrameworkModelBuilders) {
                entityFrameworkModelBuilder.Build(modelBuilder);
            }
        }

    }

}