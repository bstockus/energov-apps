using System;
using System.Threading;
using System.Threading.Tasks;
using AutoMapper;
using AutoMapper.QueryableExtensions;
using Dapper;
using EnerGov.Data.EnerGov;
using EnerGov.Data.Munis;
using Lax.Business.Bus.Logging;
using Lax.Data.Sql.SqlServer;
using MediatR;
using Microsoft.EntityFrameworkCore;

namespace EnerGov.Business.UtilityExcavation.UtilityFeeGLAccounts {

    [LogRequest]
    public class FetchUtilityFeeGLAccountQuery : IRequest<UtilityFeeGLAccountDetailedInformation> {

        public Guid EnerGovFeeId { get; }
        public Guid EnerGovPickListItemId { get; }

        public FetchUtilityFeeGLAccountQuery(
            Guid enerGovFeeId,
            Guid enerGovPickListItemId) {

            EnerGovFeeId = enerGovFeeId;
            EnerGovPickListItemId = enerGovPickListItemId;
        }

        public class Handler : IRequestHandler<FetchUtilityFeeGLAccountQuery, UtilityFeeGLAccountDetailedInformation> {

            public class MunisAccountInfo {

                public string AccountDescription { get; set; }
                public string OrganizationDescription { get; set; }
                public string AccountType { get; set; }
                public string BalanceType { get; set; }

            }

            public class EnerGovPickListItemInfo {

                public string ItemName { get; set; }

            }

            public class EnerGovFeeInfo {

                public string FeeName { get; set; }

            }

            private readonly DbSet<UtilityFeeGLAccount> _utilityFeeGlAccounts;
            private readonly IMapper _mapper;
            private readonly ISqlServerConnectionProvider<EnerGovSqlServerConnection> _enerGovSqlConnectionProvider;
            private readonly ISqlServerConnectionProvider<MunisSqlServerConnection> _munisSqlConnectionProvider;

            public Handler(
                DbSet<UtilityFeeGLAccount> utilityFeeGLAccounts,
                IMapper mapper,
                ISqlServerConnectionProvider<EnerGovSqlServerConnection> enerGovSqlConnectionProvider,
                ISqlServerConnectionProvider<MunisSqlServerConnection> munisSqlConnectionProvider) {

                _utilityFeeGlAccounts = utilityFeeGLAccounts;
                _mapper = mapper;
                _enerGovSqlConnectionProvider = enerGovSqlConnectionProvider;
                _munisSqlConnectionProvider = munisSqlConnectionProvider;
            }

            private async Task<UtilityFeeGLAccountDetailedInformation.MunisAccount> FetchMunisAccountInformation(
                string org, string obj, string project,
                CancellationToken cancellationToken) {

                var munisAccountInfo =
                    await (await _munisSqlConnectionProvider.GetSqlServerConnectionAsync(cancellationToken))
                        .QueryFirstAsync<MunisAccountInfo>(@"SELECT
                            LTRIM(RTRIM(accts.LongDescription))  AS 'AccountDescription',
                            LTRIM(RTRIM(orgs.LongDescription))   AS 'OrganizationDescription',
                            accts.AccountType AS 'AccountType',
                            ISNULL(accts.BalanceType,'') AS 'BalanceType'
                        FROM Accounts accts
                        INNER JOIN Organizations orgs ON accts.OrganizationId = orgs.Id
                        INNER JOIN GLObjects objs ON accts.ObjectId = objs.Id
                        LEFT OUTER JOIN Projects projs ON accts.ProjectId = projs.Id
                        WHERE
                            objs.ObjectCode = @ObjectNumber AND
                            orgs.OrganizationCode = @OrganizationNumber AND
                            (@ProjectNumber IS NULL OR @ProjectNumber = '' OR projs.ProjectCode = @ProjectNumber)",
                            new {
                                ObjectNumber = obj,
                                OrganizationNumber = org,
                                ProjectNumber = project
                            });

                return new UtilityFeeGLAccountDetailedInformation.MunisAccount {
                    AccountOrgCode = org,
                    AccountObjectCode = obj,
                    AccountProjectCode = project,
                    AccountDescription = munisAccountInfo.AccountDescription,
                    OrganizationDescription = munisAccountInfo.OrganizationDescription,
                    AccountType = munisAccountInfo.AccountType,
                    BalanceType = munisAccountInfo.BalanceType
                };

            }


            private async Task<UtilityFeeGLAccountDetailedInformation.EnerGovWorkType>
                FetchEnerGovPickListItemInformation(Guid itemId,
                    CancellationToken cancellationToken) {

                var enerGovPickListItemInfo =
                    await (await _enerGovSqlConnectionProvider.GetSqlServerConnectionAsync(cancellationToken))
                        .QueryFirstAsync<EnerGovPickListItemInfo>(@"SELECT 
                          cfpli.SVALUE AS ItemName
                        FROM CUSTOMFIELDPICKLISTITEM cfpli
                        WHERE cfpli.GCUSTOMFIELDPICKLISTITEM = @ItemId",
                            new {
                                ItemId = itemId
                            });

                return new UtilityFeeGLAccountDetailedInformation.EnerGovWorkType {
                    EnerGovPickListItemId = itemId,
                    WorkTypeName = enerGovPickListItemInfo.ItemName
                };

            }


            private async Task<UtilityFeeGLAccountDetailedInformation.EnerGovFee> FetchEnerGovFeeInformation(Guid feeId,
                CancellationToken cancellationToken) {

                var enerGovFeeInfo =
                    await (await _enerGovSqlConnectionProvider.GetSqlServerConnectionAsync(cancellationToken))
                        .QueryFirstAsync<EnerGovFeeInfo>(@"SELECT
                          caf.NAME AS FeeName
                        FROM CAFEE caf
                        WHERE caf.CAFEEID = @FeeId",
                            new {
                                FeeId = feeId
                            });

                return new UtilityFeeGLAccountDetailedInformation.EnerGovFee {
                    FeeId = feeId,
                    FeeName = enerGovFeeInfo.FeeName
                };

            }
                

            public async Task<UtilityFeeGLAccountDetailedInformation> Handle(FetchUtilityFeeGLAccountQuery request,
                CancellationToken cancellationToken) {

                var accountInfo = await _utilityFeeGlAccounts.AsNoTracking()
                    .ProjectTo<UtilityFeeGLAccountInformation>(_mapper.ConfigurationProvider)
                    .FirstOrDefaultAsync(
                        _ => _.EnerGovFeeId.Equals(request.EnerGovFeeId) &&
                             _.EnerGovPickListItemId.Equals(request.EnerGovPickListItemId), cancellationToken);

                return new UtilityFeeGLAccountDetailedInformation {
                    WorkType = await FetchEnerGovPickListItemInformation(accountInfo.EnerGovPickListItemId,
                        cancellationToken),
                    Fee = await FetchEnerGovFeeInformation(accountInfo.EnerGovFeeId, cancellationToken),
                    ExpenseAccount = await FetchMunisAccountInformation(
                        accountInfo.MunisExpenseAccountOrg,
                        accountInfo.MunisExpenseAccountObject,
                        accountInfo.MunisExpenseAccountProject,
                        cancellationToken),
                    ExpenseCashAccount = await FetchMunisAccountInformation(
                        accountInfo.MunisExpenseCashAccountOrg,
                        accountInfo.MunisExpenseCashAccountObject,
                        accountInfo.MunisExpenseCashAccountProject,
                        cancellationToken),
                    RevenueAccount = await FetchMunisAccountInformation(
                        accountInfo.MunisRevenueAccountOrg,
                        accountInfo.MunisRevenueAccountObject,
                        accountInfo.MunisRevenueAccountProject,
                        cancellationToken),
                    RevenueCashAccount = await FetchMunisAccountInformation(
                        accountInfo.MunisRevenueCashAccountOrg,
                        accountInfo.MunisRevenueCashAccountObject,
                        accountInfo.MunisRevenueCashAccountProject,
                        cancellationToken)
                };

            }

        }

    }

}