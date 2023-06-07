using Autofac;
using Lax.Data.Sql.SqlServer;

namespace EnerGov.Data.EnerGov {

    public class EnerGovDataModule : Module {

        private readonly string _enerGovConnectionString;

        public EnerGovDataModule(string enerGovConnectionString) {

            _enerGovConnectionString = enerGovConnectionString;
        }

        protected override void Load(ContainerBuilder builder) {

            builder.RegisterSqlServerConnectionProvider<EnerGovSqlServerConnection>(_enerGovConnectionString);

        }

    }

}