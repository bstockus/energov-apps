using System;
using System.Threading;
using System.Threading.Tasks;
using Dapper;
using EnerGov.Data.EnerGov;
using Lax.Business.Bus.Logging;
using Lax.Data.Sql.SqlServer;
using MediatR;

namespace EnerGov.Business.UtilityExcavation.EnerGovInvoices {

    [LogRequest]
    public class MarkInvoicePaidCommand : IRequest {

        public string InvoiceId { get; set; }
        public string JournalYear { get; set; }
        public string JournalPeriod { get; set; }
        public string JournalNumber { get; set; }

        public class InvoiceFeeInfo {

            public string InvoiceFeeId { get; set; }
            public string ComputedFeeId { get; set; }
            public decimal ComputedAmount { get; set; }

        }

        public class Handler : IRequestHandler<MarkInvoicePaidCommand> {

            private readonly ISqlServerConnectionProvider<EnerGovSqlServerConnection>
                _enerGovSqlServerConnectionProvider;

            public Handler(
                ISqlServerConnectionProvider<EnerGovSqlServerConnection> enerGovSqlServerConnectionProvider) {
                _enerGovSqlServerConnectionProvider = enerGovSqlServerConnectionProvider;
            }

            public async Task<Unit> Handle(MarkInvoicePaidCommand request, CancellationToken cancellationToken) {

                var enerGovConnection =
                    await _enerGovSqlServerConnectionProvider.GetSqlServerConnectionAsync(cancellationToken);

                var invoiceFees = await enerGovConnection.QueryAsync<InvoiceFeeInfo>(@"SELECT
                      caif.CAINVOICEFEEID AS InvoiceFeeId,
                      cacf.CACOMPUTEDFEEID AS ComputedFeeId,
                      cacf.COMPUTEDAMOUNT AS ComputedAmount
                    FROM CAINVOICEFEE caif
                    INNER JOIN CACOMPUTEDFEE cacf ON caif.CACOMPUTEDFEEID = cacf.CACOMPUTEDFEEID
                    WHERE caif.CAINVOICEID = @InvoiceId",
                    new {
                        request.InvoiceId
                    });

                var sqlTransaction = enerGovConnection.BeginTransaction();

                try {

                    foreach (var invoiceFeeInfo in invoiceFees) {

                        await sqlTransaction.Connection.QueryAsync(@"UPDATE CACOMPUTEDFEE
                                SET
                                    CASTATUSID = 4,
                                    AMOUNTPAIDTODATE = COMPUTEDAMOUNT,
                                    LASTCHANGEDON = SYSDATETIME(),
                                    LASTCHANGEDBY = 'a24df514-c3c1-49c7-8784-0b2bf58c79fa',
                                    ROWVERSION = ROWVERSION + 1
                                WHERE CACOMPUTEDFEEID = @ComputedFeeId;",
                            new {
                                invoiceFeeInfo.ComputedFeeId
                            },
                            transaction: sqlTransaction);

                        await sqlTransaction.Connection.QueryAsync(@"UPDATE CAINVOICEFEE
                                SET 
                                  PAIDAMOUNT = @ComputedAmount
                                WHERE CAINVOICEFEEID = @InvoiceFeeId;",
                            new {
                                invoiceFeeInfo.ComputedAmount,
                                invoiceFeeInfo.InvoiceFeeId
                            },
                            transaction: sqlTransaction);

                    }

                    await sqlTransaction.Connection.QueryAsync(@"UPDATE CAINVOICE
                            SET
                              CASTATUSID = 4,
                              LASTCHANGEDON = SYSDATETIME(),
                              LASTCHANGEDBY = 'a24df514-c3c1-49c7-8784-0b2bf58c79fa',
                              ROWVERSION = ROWVERSION + 1,
                              INVOICEDESCRIPTION = @InvoiceDescription
                            WHERE CAINVOICEID = @InvoiceId;",
                        new {
                            request.InvoiceId,
                            InvoiceDescription =
                                $"Paid by Journal Voucher {request.JournalYear}/{request.JournalPeriod}/{request.JournalNumber}"
                        },
                        transaction: sqlTransaction);

                    sqlTransaction.Commit();

                } catch (Exception) {
                    sqlTransaction.Rollback();
                }

                return Unit.Value;

            }


        }

    }

}