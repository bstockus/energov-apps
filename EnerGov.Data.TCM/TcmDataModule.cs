using Autofac;
using Lax.Data.Sql.SqlServer;

namespace EnerGov.Data.TCM {
    public class TcmDataModule : Module {

        private readonly string _tcmConnectionString;

        public TcmDataModule(string tcmConnectionString) {
            _tcmConnectionString = tcmConnectionString;
        }

        protected override void Load(ContainerBuilder builder) {
            builder.RegisterSqlServerConnectionProvider<TcmSqlServerConnection>(_tcmConnectionString);
        }

    }

}
