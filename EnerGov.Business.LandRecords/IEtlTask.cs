using System.Collections.Generic;
using System.Data.SqlClient;
using System.Threading.Tasks;

namespace EnerGov.Business.LandRecords {

    public interface IEtlTask {

        string TableName { get; }
        IEnumerable<string> TableDependencies { get; }

        Task LoadTable(SqlConnection countyTaxSqlConnection, SqlConnection landRecordsSqlConnection);

    }

}
