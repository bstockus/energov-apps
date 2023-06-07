using Autofac;
using Lax.Data.Sql.SqlServer;

namespace EnerGov.Data.GIS {

    public class GISDataModule : Module {

        private readonly string _gisConnectionString;

        public GISDataModule(string gisConnectionString) {
            _gisConnectionString = gisConnectionString;
        }

        protected override void Load(ContainerBuilder builder) {

            builder.RegisterSqlServerConnectionProvider<GISSqlServerConnection>(_gisConnectionString);

        }

    }

}