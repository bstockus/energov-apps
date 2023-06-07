using Autofac;
using Lax.Data.Sql.SqlServer;

namespace EnerGov.Data.Munis {

    public class MunisDataModule : Module {

        private readonly string _munisConnectionString;

        public MunisDataModule(string munisConnectionString) {
            _munisConnectionString = munisConnectionString;
        }

        protected override void Load(ContainerBuilder builder) {

            builder.RegisterSqlServerConnectionProvider<MunisSqlServerConnection>(_munisConnectionString);

        }

    }

}
