using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Dapper;
using EnerGov.Data.EnerGov;
using Lax.Cli.Common;
using Lax.Data.Sql.SqlServer;

namespace EnerGov.Business.UtilityExcavation {

    //[LogRequest]
    //public class MarkInvoiceTransferedCommand : IRequest<decimal> {

    //    public string InvoiceId { get; set; }
    //    public string DescriptionText { get; set; }

    //    public class InvoiceFeeInfo {

    //        public string InvoiceFeeId { get; set; }
    //        public string ComputedFeeId { get; set; }
    //        public decimal ComputedAmount { get; set; }

    //    }

    //    public class Handler : IRequestHandler<MarkInvoiceTransferedCommand, decimal> {

    //        private readonly ISqlServerConnectionProvider<EnerGovSqlServerConnection>
    //            _enerGovSqlServerConnectionProvider;

    //        public Handler(
    //            ISqlServerConnectionProvider<EnerGovSqlServerConnection> enerGovSqlServerConnectionProvider) {
    //            _enerGovSqlServerConnectionProvider = enerGovSqlServerConnectionProvider;
    //        }

    //        public async Task<decimal> Handle(MarkInvoiceTransferedCommand request, CancellationToken cancellationToken) {

    //            var enerGovConnection =
    //                await _enerGovSqlServerConnectionProvider.GetSqlServerConnectionAsync(cancellationToken);

    //            var invoiceFees = await enerGovConnection.QueryAsync<InvoiceFeeInfo>(@"SELECT
    //                  caif.CAINVOICEFEEID AS InvoiceFeeId,
    //                  cacf.CACOMPUTEDFEEID AS ComputedFeeId,
    //                  cacf.COMPUTEDAMOUNT AS ComputedAmount
    //                FROM CAINVOICEFEE caif
    //                INNER JOIN CACOMPUTEDFEE cacf ON caif.CACOMPUTEDFEEID = cacf.CACOMPUTEDFEEID
    //                WHERE caif.CAINVOICEID = @InvoiceId",
    //                new {
    //                    request.InvoiceId
    //                });

    //            var sqlTransaction = enerGovConnection.BeginTransaction();

    //            try {

    //                foreach (var invoiceFeeInfo in invoiceFees) {

    //                    await sqlTransaction.Connection.QueryAsync(@"UPDATE CACOMPUTEDFEE
    //                            SET
    //                                CASTATUSID = 4,
    //                                AMOUNTPAIDTODATE = COMPUTEDAMOUNT,
    //                                LASTCHANGEDON = SYSDATETIME(),
    //                                LASTCHANGEDBY = 'a24df514-c3c1-49c7-8784-0b2bf58c79fa',
    //                                ROWVERSION = ROWVERSION + 1
    //                            WHERE CACOMPUTEDFEEID = @ComputedFeeId;",
    //                        new {
    //                            invoiceFeeInfo.ComputedFeeId
    //                        },
    //                        transaction: sqlTransaction);

    //                    await sqlTransaction.Connection.QueryAsync(@"UPDATE CAINVOICEFEE
    //                            SET 
    //                              PAIDAMOUNT = @ComputedAmount
    //                            WHERE CAINVOICEFEEID = @InvoiceFeeId;",
    //                        new {
    //                            invoiceFeeInfo.ComputedAmount,
    //                            invoiceFeeInfo.InvoiceFeeId
    //                        },
    //                        transaction: sqlTransaction);

    //                }

    //                await sqlTransaction.Connection.QueryAsync(@"UPDATE CAINVOICE
    //                        SET
    //                          CASTATUSID = 4,
    //                          LASTCHANGEDON = SYSDATETIME(),
    //                          LASTCHANGEDBY = 'a24df514-c3c1-49c7-8784-0b2bf58c79fa',
    //                          ROWVERSION = ROWVERSION + 1,
    //                          INVOICEDESCRIPTION = @InvoiceDescription
    //                        WHERE CAINVOICEID = @InvoiceId;",
    //                    new {
    //                        request.InvoiceId,
    //                        InvoiceDescription =
    //                            request.DescriptionText
    //                    },
    //                    transaction: sqlTransaction);

    //                sqlTransaction.Commit();

    //            } catch (Exception) {
    //                sqlTransaction.Rollback();
    //            }

    //            return Unit.Value;

    //        }


    //    }

    //}

    public class UtilityExcavationTestTask : CliTask {

        public class InvoiceComputedFeeInfo {
            public string InvoiceId { get; set; }
            public string InvoiceFeeId { get; set; }
            public string ComputedFeeId { get; set; }
            public decimal ComputedAmount { get; set; }
            public string FeeName { get; set; }
            public decimal PaidAmount { get; set; }
            public string InvoiceNumber { get; set; }

        }

        private readonly ISqlServerConnectionProvider<EnerGovSqlServerConnection> _enerGovSqlServerConnectionProvider;

        public override string Name => "utility-excavation-test";

        public UtilityExcavationTestTask(ISqlServerConnectionProvider<EnerGovSqlServerConnection> enerGovSqlServerConnectionProvider) {
            _enerGovSqlServerConnectionProvider = enerGovSqlServerConnectionProvider;
        }

        public override async Task Run(ILookup<string, string> args, IEnumerable<string> flags) {

            var enerGovConnection =
                await _enerGovSqlServerConnectionProvider.GetSqlServerConnectionAsync();

            var invoices = await File.ReadAllLinesAsync(@"C:\Users\stockusb\Desktop\invoice_xfer.txt");

            var outputFile = new StringBuilder("InvoiceNumber,FeeName,AmountPaid,ComputedAmount,AmountTransfered\n");

            foreach (var invoice in invoices) {

                var invoiceFees = await enerGovConnection.QueryAsync<InvoiceComputedFeeInfo>(
                    @"SELECT
                            caif.CAINVOICEID AS InvoiceId,
                            caif.CAINVOICEFEEID AS InvoiceFeeId,
                            cacf.CACOMPUTEDFEEID AS ComputedFeeId,
                            cacf.COMPUTEDAMOUNT AS ComputedAmount,
                            caif.PAIDAMOUNT AS PaidAmount,
                            cacf.FEENAME AS FeeName,
                            cai.INVOICENUMBER AS InvoiceNumber
                        FROM CAINVOICEFEE caif
                        INNER JOIN CACOMPUTEDFEE cacf ON caif.CACOMPUTEDFEEID = cacf.CACOMPUTEDFEEID
                        INNER JOIN CAINVOICE cai ON caif.CAINVOICEID = cai.CAINVOICEID
                        WHERE cai.INVOICENUMBER = @InvoiceNumber",
                    new {
                        InvoiceNumber = invoice.PadLeft(8, '0')
                    });

                var sqlTransaction = await enerGovConnection.BeginTransactionAsync();

                Console.WriteLine($"INVOICE: {invoice.PadLeft(8, '0')}");

                try {
                    

                    foreach (var invoiceComputedFeeInfo in invoiceFees) {

                        await sqlTransaction.Connection.QueryAsync(@"UPDATE CACOMPUTEDFEE
                                SET
                                    CASTATUSID = 4,
                                    AMOUNTPAIDTODATE = COMPUTEDAMOUNT,
                                    LASTCHANGEDON = SYSDATETIME(),
                                    LASTCHANGEDBY = 'a24df514-c3c1-49c7-8784-0b2bf58c79fa',
                                    ROWVERSION = ROWVERSION + 1,
                                    NOTES = @Notes
                                WHERE CACOMPUTEDFEEID = @ComputedFeeId;",
                            new {
                                invoiceComputedFeeInfo.ComputedFeeId,
                                Notes = $"Fee was transfered to the 2020 Tax Roll."
                            },
                            transaction: sqlTransaction);

                        await sqlTransaction.Connection.QueryAsync(@"UPDATE CAINVOICEFEE
                                SET 
                                  PAIDAMOUNT = @ComputedAmount
                                WHERE CAINVOICEFEEID = @InvoiceFeeId;",
                            new {
                                invoiceComputedFeeInfo.ComputedAmount,
                                invoiceComputedFeeInfo.InvoiceFeeId
                            },
                            transaction: sqlTransaction);

                        Console.WriteLine(
                            $"      FEE: {invoiceComputedFeeInfo.FeeName} => {invoiceComputedFeeInfo.ComputedAmount:C2} (Paid: {invoiceComputedFeeInfo.PaidAmount:C2})");

                        outputFile.AppendLine(
                            $"\"{invoiceComputedFeeInfo.InvoiceNumber}\",\"{invoiceComputedFeeInfo.FeeName}\",{invoiceComputedFeeInfo.PaidAmount},{invoiceComputedFeeInfo.ComputedAmount}, {invoiceComputedFeeInfo.ComputedAmount - invoiceComputedFeeInfo.PaidAmount}");

                    }

                    await sqlTransaction.Connection.QueryAsync(@"UPDATE CAINVOICE
                            SET
                              CASTATUSID = 4,
                              LASTCHANGEDON = SYSDATETIME(),
                              LASTCHANGEDBY = 'a24df514-c3c1-49c7-8784-0b2bf58c79fa',
                              ROWVERSION = ROWVERSION + 1
                            WHERE CAINVOICEID = @InvoiceId;",
                        new {
                            InvoiceId = invoiceFees.FirstOrDefault()?.InvoiceId ?? ""
                        },
                        transaction: sqlTransaction);

                    await sqlTransaction.CommitAsync();
                } catch (Exception) {
                    await sqlTransaction.RollbackAsync();
                }

            }

            await File.WriteAllTextAsync(@"C:\Users\stockusb\Desktop\invoice_xfer_results.csv", outputFile.ToString());

        }



    }
}
