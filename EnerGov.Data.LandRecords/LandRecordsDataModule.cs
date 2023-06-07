using Autofac;
using Lax.Data.Sql.SqlServer;

namespace EnerGov.Data.LandRecords {

    public class LandRecordsDataModule : Module {

        private readonly string _landRecordsConnectionString;

        public LandRecordsDataModule(
            string landRecordsConnectionString) {
            _landRecordsConnectionString = landRecordsConnectionString;
        }

        protected override void Load(ContainerBuilder builder) {

            builder.RegisterSqlServerConnectionProvider<LandRecordsSqlServerConnection>(_landRecordsConnectionString);

        }

    }

}