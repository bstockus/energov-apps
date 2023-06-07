using System.Threading;
using System.Threading.Tasks;
using Dapper;
using EnerGov.Data.EnerGov;
using Lax.Data.Sql;

namespace EnerGov.Web.Tasks {
    public class EmailQueueFixTask {

        private readonly ISqlConnectionProvider<EnerGovSqlServerConnection> _enerGovSqlConnectionProvider;

        public EmailQueueFixTask(
            ISqlConnectionProvider<EnerGovSqlServerConnection> enerGovSqlConnectionProvider) {

            _enerGovSqlConnectionProvider = enerGovSqlConnectionProvider;
        }

        public async Task RunTask(CancellationToken cancellationToken) {

            var enerGovConnection = await _enerGovSqlConnectionProvider.GetDbConnectionAsync(cancellationToken);

            await enerGovConnection.ExecuteScalarAsync(new CommandDefinition(
                @"UPDATE [EMAILQUEUE]
                        SET EMAILFROM = 'energov@cityoflacrosse.org', SENTTOBUS = 0
                        WHERE DATESENT IS NULL AND EMAILFROM = ''",
                cancellationToken: cancellationToken));

        }

    }
}
