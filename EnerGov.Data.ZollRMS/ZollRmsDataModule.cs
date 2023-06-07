using Autofac;
using Lax.Data.Sql.SqlServer;

namespace EnerGov.Data.ZollRMS {

    public class ZollRmsDataModule : Module {

        private readonly string _zollRmsConnectionString;

        public ZollRmsDataModule(string zollRmsConnectionString) {
            _zollRmsConnectionString = zollRmsConnectionString;
        }

        protected override void Load(ContainerBuilder builder) {

            builder.RegisterSqlServerConnectionProvider<ZollRmsSqlServerConnection>(_zollRmsConnectionString);

        }

    }

}