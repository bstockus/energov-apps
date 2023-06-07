using System.Collections.Generic;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;
using Dapper;
using EnerGov.Data.EnerGov;
using Lax.Business.Bus.Logging;
using Lax.Data.Sql.SqlServer;
using MediatR;
using Microsoft.Extensions.Options;

namespace EnerGov.Business.Exports.MarketDrive {

    [LogRequest]
    public class FetchMarketDrivePermitTypesToIncludeQuery : IRequest<IEnumerable<FetchMarketDrivePermitTypesToIncludeQuery.PermitTypeResultItem>> {

        public class PermitTypeResultItem {
            public string PermitTypeId { get; set; }
            public string PermitTypeName { get; set; }
        }

        public class Handler : IRequestHandler<FetchMarketDrivePermitTypesToIncludeQuery, IEnumerable<PermitTypeResultItem>> {

            private readonly ISqlServerConnectionProvider<EnerGovSqlServerConnection> _enerGovSqlServerConnectionProvider;
            private readonly IOptions<ExportConfiguration> _exportConfigurationOptions;

            public Handler(
                ISqlServerConnectionProvider<EnerGovSqlServerConnection> enerGovSqlServerConnectionProvider,
                IOptions<ExportConfiguration> exportConfigurationOptions) {
                _enerGovSqlServerConnectionProvider = enerGovSqlServerConnectionProvider;
                _exportConfigurationOptions = exportConfigurationOptions;
            }

            public async Task<IEnumerable<PermitTypeResultItem>> Handle(FetchMarketDrivePermitTypesToIncludeQuery request, CancellationToken cancellationToken) {

                var marketDriveExportConfiguration = _exportConfigurationOptions.Value.MarketDrive;

                await using var enerGovConnection =
                    await _enerGovSqlServerConnectionProvider.GetSqlServerConnectionAsync(cancellationToken);
                return (await enerGovConnection.QueryAsync<PermitTypeResultItem>(
                    new CommandDefinition(
                        @"SELECT
                                pt.PMPERMITTYPEID AS 'PermitTypeId',
                                pt.NAME AS 'PermitTypeName'
                            FROM PMPERMITTYPE pt
                            WHERE pt.PMPERMITTYPEID IN @PermitTypesToInclude",
                        new {
                            PermitTypesToInclude = marketDriveExportConfiguration.IncludePermitTypes.ToList()
                        },
                        cancellationToken: cancellationToken))).ToList();
            }

        }

    }

}