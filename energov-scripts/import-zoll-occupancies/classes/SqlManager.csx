#r "nuget: System.Data.SqlClient, 4.6.0"
#r "nuget: Dapper, 1.60.6"

using System.Data;
using System.Data.Common;
using System.Data.SqlClient;
using System.Threading;
using Dapper;

public class SqlManager {

    public SqlConnection SqlConnection { get; set; }
    private DbTransaction _sqlTransaction { get; set; }
    public bool ExecuteCommands { get; set; }

    public SqlManager(SqlConnection sqlConnection, bool executeCommands) {
        SqlConnection = sqlConnection;
        ExecuteCommands = executeCommands;
    }

    public async Task ExecuteScalarAsync(string sqlCmd, object prms) {
        if (ExecuteCommands) {
            await SqlConnection.ExecuteScalarAsync(sqlCmd, prms, _sqlTransaction);
        }
    }

    public async Task ExecuteScalarAsync(string sqlCmd) {
        if (ExecuteCommands) {
            await SqlConnection.ExecuteScalarAsync(sqlCmd, null, _sqlTransaction);
        }
    }

    public async Task<T> ExecuteScalarAsync<T>(string sqlCmd) {
        if (ExecuteCommands) {
            return await SqlConnection.ExecuteScalarAsync<T>(sqlCmd, null, _sqlTransaction);
        }
        return await Task.FromResult(default(T));
    }

    public async Task BulkInsertRows<TModel>(
            IEnumerable<TModel> models,
            string tableName,
            CancellationToken cancellationToken = default) {

            if (ExecuteCommands) {
                var modelType = typeof(TModel);

                var dt = new DataTable();

                var bulkCopy = new SqlBulkCopy(SqlConnection) { DestinationTableName = tableName };

                foreach (var property in modelType.GetProperties()) {

                    dt.Columns.Add(new DataColumn(property.Name, property.PropertyType));
                    bulkCopy.ColumnMappings.Add(property.Name, property.Name);

                }

                foreach (var model in models) {

                    var dr = dt.NewRow();

                    foreach (var property in modelType.GetProperties()) {

                        dr[property.Name] = property.GetValue(model);

                    }

                    dt.Rows.Add(dr);

                }

                await bulkCopy.WriteToServerAsync(dt, cancellationToken);
            }
        }

    public async Task BeginTransaction() {
        if (ExecuteCommands) {
            _sqlTransaction = await SqlConnection.BeginTransactionAsync();
        }
    }

    public async Task CommitAsync() {
        if (ExecuteCommands && _sqlTransaction != null) {
            await _sqlTransaction.CommitAsync();
            _sqlTransaction = null;
        }
    }

    public async Task RollbackAsync() {
        if (ExecuteCommands && _sqlTransaction != null) {
            await _sqlTransaction.RollbackAsync();
            _sqlTransaction = null;
        }
    }

}