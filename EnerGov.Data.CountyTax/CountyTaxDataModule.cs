using Autofac;
using Lax.Data.Sql.SqlServer;

namespace EnerGov.Data.CountyTax {

    public class CountyTaxDataModule : Module {

        private readonly string _countyTaxConnectionString;

        public CountyTaxDataModule(string countyTaxConnectionString) {
            _countyTaxConnectionString = countyTaxConnectionString;
        }

        protected override void Load(ContainerBuilder builder) {
            builder.RegisterSqlServerConnectionProvider<CountyTaxSqlServerConnection>(_countyTaxConnectionString);
        }

    }

}