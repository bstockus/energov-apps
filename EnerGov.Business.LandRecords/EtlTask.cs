using System.Collections.Generic;
using System.Data.SqlClient;
using System.Threading.Tasks;

namespace EnerGov.Business.LandRecords {

    public abstract class EtlTask : IEtlTask {

        public abstract string TableName { get; }

        public abstract IEnumerable<string> TableDependencies { get; }

        protected abstract string SqlQuery { get; }

        public async Task LoadTable(SqlConnection countyTaxSqlConnection, SqlConnection landRecordsSqlConnection) {
            
            var sqlCommand = new SqlCommand(SqlQuery, countyTaxSqlConnection);

            using (var reader = await sqlCommand.ExecuteReaderAsync()) {

                using (var sqlBulkCopy = new SqlBulkCopy(landRecordsSqlConnection)) {

                    // Set operation to never timeout
                    sqlBulkCopy.BulkCopyTimeout = 0;

                    sqlBulkCopy.DestinationTableName = $"[dbo].[{TableName}]";

                    await sqlBulkCopy.WriteToServerAsync(reader);

                }

            }

            

        }

    }

}