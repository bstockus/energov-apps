using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;
using EnerGov.Data.CountyTax;
using EnerGov.Data.LandRecords;
using Lax.Data.Sql.SqlServer;
using Lax.Helpers.DirectedAcyclicGraphs;
using MediatR;
using Microsoft.Extensions.Logging;

namespace EnerGov.Business.LandRecords {

    public class LoadLandRecordsCommand : IRequest {

        public class Handler : IRequestHandler<LoadLandRecordsCommand> {

            private readonly ISqlServerConnectionProvider<CountyTaxSqlServerConnection>
                _countyTaxSqlServerConnectionProvider;

            private readonly ISqlServerConnectionProvider<LandRecordsSqlServerConnection>
                _landRecordsSqlServerConnectionProvider;

            private readonly IEnumerable<IEtlTask> _etlTasks;
            private readonly ILogger<Handler> _logger;

            public Handler(
                ISqlServerConnectionProvider<CountyTaxSqlServerConnection> countyTaxSqlServerConnectionProvider,
                ISqlServerConnectionProvider<LandRecordsSqlServerConnection> landRecordsSqlServerConnectionProvider,
                IEnumerable<IEtlTask> etlTasks,
                ILogger<Handler> logger) {

                _countyTaxSqlServerConnectionProvider = countyTaxSqlServerConnectionProvider;
                _landRecordsSqlServerConnectionProvider = landRecordsSqlServerConnectionProvider;
                _etlTasks = etlTasks;
                _logger = logger;
            }

            public async Task<Unit> Handle(LoadLandRecordsCommand request, CancellationToken cancellationToken) {

                // Topologically Sort the DAG of ETL Tasks
                var sortedTasks = SortedTasks();
                var tasksDictionary = _etlTasks.ToDictionary(_ => _.TableName, _ => _);

                // Open Sql Server Connections
                var countyTaxSqlConnection =
                    await _countyTaxSqlServerConnectionProvider.GetSqlServerConnectionAsync(cancellationToken);
                var landRecordsSqlConnection =
                    await _landRecordsSqlServerConnectionProvider.GetSqlServerConnectionAsync(cancellationToken);

                await DeleteExistingData(landRecordsSqlConnection, sortedTasks.AsEnumerable());

                await LoadNewData(countyTaxSqlConnection, landRecordsSqlConnection,
                    sortedTasks.AsEnumerable().Reverse().Select(_ => tasksDictionary[_]));

                return Unit.Value;


            }

            private List<string> SortedTasks() {
                var nodes = new HashSet<string>();
                var edges = new HashSet<Tuple<string, string>>();

                foreach (var etlTask in _etlTasks) {
                    nodes.Add(etlTask.TableName);

                    foreach (var etlTaskTableDependency in etlTask.TableDependencies) {
                        edges.Add(new Tuple<string, string>(etlTask.TableName, etlTaskTableDependency));
                    }
                }

                var sortedTasks = TopologicalSorter.TopologicalSort(nodes, edges);
                return sortedTasks;
            }

            private async Task DeleteExistingData(SqlConnection landRecordsSqlConnection, IEnumerable<string> tables) {

                foreach (var table in tables) {

                    var sqlCommandText = $"DELETE FROM [dbo].[{table}];";

                    var sqlCommand = new SqlCommand(sqlCommandText, landRecordsSqlConnection);

                    var rows = await sqlCommand.ExecuteNonQueryAsync();

                    _logger.LogInformation("DeleteExistingData: Table:{Table} Sql:{SqlCommand} Rows:{Rows}", table,
                        sqlCommandText, rows);

                }

            }

            private async Task LoadNewData(
                SqlConnection countyTaxSqlConnection,
                SqlConnection landRecordsSqlConnection,
                IEnumerable<IEtlTask> tasks) {

                foreach (var etlTask in tasks) {

                    try {
                        await etlTask.LoadTable(countyTaxSqlConnection, landRecordsSqlConnection);
                        _logger.LogInformation("Task Implemented: {TableName}", etlTask.TableName);
                    } catch (NotImplementedException) {
                        _logger.LogInformation("Task Not Implemented: {TableName}", etlTask.TableName);
                    }

                }

            }

        }

    }

}