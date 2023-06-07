using System;
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
    public class FetchMarketDriveExportQuery : IRequest<IEnumerable<MarketDriveExportEntry>> {

        public class Handler : IRequestHandler<FetchMarketDriveExportQuery, IEnumerable<MarketDriveExportEntry>> {

            private readonly ISqlServerConnectionProvider<EnerGovSqlServerConnection> _enerGovSqlServerConnectionProvider;
            private readonly IOptions<ExportConfiguration> _exportConfigurationOptions;

            public Handler(
                ISqlServerConnectionProvider<EnerGovSqlServerConnection> enerGovSqlServerConnectionProvider,
                IOptions<ExportConfiguration> exportConfigurationOptions) {

                _enerGovSqlServerConnectionProvider = enerGovSqlServerConnectionProvider;
                _exportConfigurationOptions = exportConfigurationOptions;
            }

            public async Task<IEnumerable<MarketDriveExportEntry>> Handle(FetchMarketDriveExportQuery request, CancellationToken cancellationToken) {

                var marketDriveExportConfiguration = _exportConfigurationOptions.Value.MarketDrive;

                var statusMappings = marketDriveExportConfiguration.StatusMap
                    .Select(_ => _.EnerGovIds.Select(x => new Tuple<string, string>(x, _.Name)))
                    .SelectMany(x => x)
                    .ToDictionary(_ => _.Item1, _ => _.Item2);

                var statusesToInclude = statusMappings.Keys.ToList();

                var closedCutoffDate =
                    DateTime.Now.AddDays(marketDriveExportConfiguration.NumberOfDaysToPullClosedPermits * -1);

                await using var enerGovConnection =
                    await _enerGovSqlServerConnectionProvider.GetSqlServerConnectionAsync(cancellationToken);
                return (await enerGovConnection.QueryAsync<MarketDriveExportEntry>(
                    new CommandDefinition(
                        @"SELECT
                                    p.PERMITNUMBER AS 'PermitNumber',
                                    par.PARCELNUMBER AS 'ParcelNumber',
                                    pt.NAME AS 'TypeName',
                                    pwc.NAME AS 'ClassName',
                                    p.PMPERMITSTATUSID AS 'StatusId',
                                    p.APPLYDATE AS 'ApplyDate',
                                    p.EXPIREDATE AS 'ExpireDate',
                                    p.ISSUEDATE AS 'IssueDate',
                                    p.FINALIZEDATE AS 'FinalizeDate',
                                    p.LASTINSPECTIONDATE AS 'LastInspectionDate',
                                    p.VALUE AS 'Valuation',
                                    p.DESCRIPTION AS 'Description'
                                  FROM PMPERMIT p
                                  INNER JOIN PMPERMITTYPE pt ON p.PMPERMITTYPEID = pt.PMPERMITTYPEID
                                  INNER JOIN PMPERMITWORKCLASS pwc ON p.PMPERMITWORKCLASSID = pwc.PMPERMITWORKCLASSID
                                  INNER JOIN PMPERMITPARCEL pp ON p.PMPERMITID = pp.PMPERMITID
                                  INNER JOIN PARCEL par ON pp.PARCELID = par.PARCELID
                                  WHERE pp.MAIN = 1 AND
                                        (p.FINALIZEDATE IS NULL OR p.FINALIZEDATE >= @ClosedCutoffDate) AND
                                        p.PMPERMITTYPEID IN @PermitTypesToInclude AND
                                        p.PMPERMITWORKCLASSID NOT IN @PermitWorkClassesToExclude AND
                                        p.PMPERMITSTATUSID IN @PermitStatusesToInclude AND
                                        par.PARCELNUMBER LIKE @ParcelNumberPrefix AND
                                        p.PERMITNUMBER NOT LIKE @PermitNumberPrefix",
                        new {
                            PermitTypesToInclude = marketDriveExportConfiguration.IncludePermitTypes.ToList(),
                            PermitWorkClassesToExclude =
                                marketDriveExportConfiguration.ExcludePermitWorkClasses.ToList(),
                            PermitStatusesToInclude = statusesToInclude,
                            ParcelNumberPrefix =
                                marketDriveExportConfiguration.IncludePermitsWithParcelNumberPrefix + "%",
                            PermitNumberPrefix =
                                marketDriveExportConfiguration.ExcludePermitsWithNumberPrefix + "%",
                            ClosedCutoffDate = closedCutoffDate
                        },
                        cancellationToken: cancellationToken
                    ))).ToList();
            }

        }

    }

}
