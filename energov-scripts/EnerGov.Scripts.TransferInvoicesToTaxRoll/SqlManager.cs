using System.Collections.Generic;
using System.CommandLine.IO;
using System.Data.Common;
using System.Threading;
using System.Threading.Tasks;
using Dapper;
using Microsoft.Data.SqlClient;

namespace EnerGov.Scripts.TransferInvoicesToTaxRoll {

    public class SqlManager {

        private readonly ConsoleManager _consoleManager;

        private DbTransaction _sqlTransaction { get; set; }

        private SqlConnection SqlConnection { get; }
        public bool ExecuteCommands { get; }

        public SqlManager(SqlConnection sqlConnection, bool executeCommands, ConsoleManager consoleManager) {
            _consoleManager = consoleManager;
            SqlConnection = sqlConnection;
            ExecuteCommands = executeCommands;
        }

        public async Task ExecuteScalarAsync(string sqlCmd, object prms, CancellationToken cancellationToken, string name = null) {
            await _consoleManager.TimeAndMaybeExecuteTask(name, async () => {
                await SqlConnection.ExecuteScalarAsync(new CommandDefinition(
                    sqlCmd,
                    prms,
                    _sqlTransaction,
                    cancellationToken: cancellationToken));
            }, ExecuteCommands);
        }

        public async Task ExecuteScalarAsync(string sqlCmd, CancellationToken cancellationToken, string name = null) =>
            await ExecuteScalarAsync(sqlCmd, cancellationToken, name);

        public async Task<T> ExecuteScalarAsync<T>(string sqlCmd, object prms, CancellationToken cancellationToken, string name = null) =>
            await _consoleManager.TimeAndMaybeExecuteTask<T>(name,
                async () => await SqlConnection.ExecuteScalarAsync<T>(new CommandDefinition(
                    sqlCmd,
                    prms,
                    _sqlTransaction,
                    cancellationToken: cancellationToken)),
                async () => await Task.FromResult(default(T)),
                ExecuteCommands);

        public async Task<T> ExecuteScalarAsync<T>(string sqlCmd, CancellationToken cancellationToken, string name = null) =>
            await ExecuteScalarAsync<T>(sqlCmd, null, cancellationToken, name);

        public async Task<IEnumerable<T>>
            QueryAsync<T>(string sqlCmd, object prms, CancellationToken cancellationToken, string name = null) =>
            await _consoleManager.TimeAndExecuteTask(name, async () => await SqlConnection.QueryAsync<T>(new CommandDefinition(
                sqlCmd,
                prms,
                cancellationToken: cancellationToken)));


        public async Task<IEnumerable<T>> QueryAsync<T>(string sqlCmd, CancellationToken cancellationToken, string name = null) =>
            await QueryAsync<T>(sqlCmd, null, cancellationToken, name);

        public async Task<T> QueryFirstAsync<T>(string sqlCmd, object prms, CancellationToken cancellationToken, string name = null) =>
            await _consoleManager.TimeAndExecuteTask<T>(
                name,
                async () => await SqlConnection.QueryFirstAsync<T>(new CommandDefinition(
                    sqlCmd,
                    prms,
                    cancellationToken: cancellationToken)));

        public async Task<T> QueryFirstAsync<T>(string sqlCmd, CancellationToken cancellationToken, string name = null) =>
            await QueryFirstAsync<T>(sqlCmd, null, cancellationToken, name);

        public async Task BeginTransaction(CancellationToken cancellationToken) {
            if (ExecuteCommands) {
                _sqlTransaction = await SqlConnection.BeginTransactionAsync(cancellationToken);
            }
        }

        public async Task CommitAsync(CancellationToken cancellationToken) {
            if (ExecuteCommands && _sqlTransaction != null) {
                await _sqlTransaction.CommitAsync(cancellationToken);
                _sqlTransaction = null;
            }
        }

        public async Task RollbackAsync(CancellationToken cancellationToken) {
            if (ExecuteCommands && _sqlTransaction != null) {
                await _sqlTransaction.RollbackAsync(cancellationToken);
                _sqlTransaction = null;
            }
        }

    }
}