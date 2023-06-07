namespace EnerGov.Data.Configuration {

    public class ConfigurationConnectionStringProvider {

        public string ConnectionString { get; }

        public ConfigurationConnectionStringProvider(
            string connectionString) {

            ConnectionString = connectionString;
        }

    }

}