using System;
using System.Collections.Generic;
using System.CommandLine;
using System.CommandLine.IO;
using System.Diagnostics;
using System.IO;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;
using Colorify;
using Microsoft.Data.SqlClient;

namespace EnerGov.Scripts.TransferInvoicesToTaxRoll {

    class Program {

        public class InvoiceNumberInfo {

            public string InvoiceNumber { get; set; }
            public string InvoiceId { get; set; }

        }

        public class InvoiceFeeInfo {
            public int InvoiceStatus { get; set; }
            public string InvoiceStatusText { get; set; }
            public decimal InvoiceTotal { get; set; }
            public string InvoiceNumber { get; set; }
            public decimal InvoiceFeePaidAmount { get; set; }
            public decimal ComputedFeeAmountPaidToDate { get; set; }
            public int ComputedFeeStatus { get; set; }
            public string ComputedFeeStatusText { get; set; }
            public decimal ComputedFeeAmount { get; set; }
            public string PermitNumber { get; set; }
            public string CodeCaseNumber { get; set; }
            public string InspectionNumber { get; set; }
            public string InvoiceFeeId { get; set; }
            public string ComputedFeeId { get; set; }
            public string PermitFeeId { get; set; }
            public string CodeCaseFeeId { get; set; }
            public string InspectionFeeId { get; set; }
            public string FeeDescription { get; set; }
            public string InvoiceId { get; set; }
            public decimal AmountDue => ComputedFeeAmount - ComputedFeeAmountPaidToDate;

            public override string ToString() => $"{InvoiceNumber},\"{InvoiceStatusText}\",{ComputedFeeId},\"{ComputedFeeStatusText}\",\"{FeeDescription}\",{ComputedFeeAmountPaidToDate:F2},{ComputedFeeAmount:F2},{AmountDue:F2}";
        }

        /// <param name="database">EnerGov SQL Server Database Name</param>
        /// <param name="performUpdates">Actually apply any updates to the database</param>
        /// <param name="invoicesFile">Invoices CSV File</param>
        /// <param name="output">Name of the CSV file to output</param>
        static async Task Main(
            IConsole console,
            CancellationToken cancellationToken,
            FileInfo invoicesFile,
            string database = "energov_train",
            bool performUpdates = false,
            string output = "Output.csv") {

            var connectionString = $"Server=lax-sql1\\ENERGOV;Database={database};Trusted_Connection=True;";

            try {

                if (invoicesFile == null) {
                    console.Error.WriteLine("Error: You must provide an invoice file!");
                    return;
                }

                var consoleManager = new ConsoleManager(console);

                var enerGovSqlConnection = new SqlConnection(connectionString);
                await enerGovSqlConnection.OpenAsync(cancellationToken);

                var enerGovSqlManager = new SqlManager(enerGovSqlConnection, performUpdates, consoleManager);

                if (enerGovSqlManager.ExecuteCommands) {
                    consoleManager.WriteLine($"Warning you are about to make changes to the '{connectionString}' database!!!", Colors.txtDefault);
                    consoleManager.WriteLineBeginning("Are you sure (Y/N)? ", Colors.txtDefault);

                    var key = Console.ReadKey();
                    consoleManager.WriteLineEnding("");
                    if (!key.KeyChar.ToString().ToUpper().Equals("Y")) {
                        consoleManager.WriteLine("Exiting!", Colors.txtDanger);
                        return;
                    }
                }

                consoleManager.BeginScope("Processing Invoices File:");

                var invoiceNumbers = await File.ReadAllLinesAsync(invoicesFile.FullName, cancellationToken);

                consoleManager.EndScope();

                var invoiceInfo = (await enerGovSqlManager.QueryAsync<InvoiceNumberInfo>(
                    @"SELECT
                        invs.INVOICENUMBER AS InvoiceNumber,
                        invs.CAINVOICEID AS InvoiceId
                    FROM CAINVOICE invs",
                    cancellationToken, 
                    "Fetch Invoice Number Infos")).ToDictionary(_ => _.InvoiceNumber, _ => _.InvoiceId);

                consoleManager.BeginScope("Fetching Invoices:");

                var invoiceFeeInformations = new List<InvoiceFeeInfo>();

                foreach (var invoiceNumber in invoiceNumbers) {
                    
                    consoleManager.BeginScope($"Processing Invoice {invoiceNumber}:", Colors.bgInfo);

                    var invoiceId = invoiceInfo[invoiceNumber];

                    consoleManager.WriteLine($"Invoice ID = {invoiceId}");

                    // Will need to get all associated fees for the invoice.

                    var invoiceFees = await enerGovSqlManager.QueryAsync<InvoiceFeeInfo>(
                        @"SELECT
                                inv.CASTATUSID AS InvoiceStatus,
                                inv_status.NAME AS InvoiceStatusText,
                                inv.INVOICETOTAL AS InvoiceTotal,
                                inv.INVOICENUMBER AS InvoiceNumber,
                                inv_fee.PAIDAMOUNT AS InvoiceFeePaidAmount,
                                comp_fee.AMOUNTPAIDTODATE AS ComputedFeeAmountPaidToDate,
                                comp_fee.CASTATUSID AS ComputedFeeStatus,
                                comp_fee_status.NAME AS ComputedFeeStatusText,
                                comp_fee.COMPUTEDAMOUNT AS ComputedFeeAmount,
                                perm.PERMITNUMBER AS PermitNumber,
                                code.CASENUMBER AS CodeCaseNumber,
                                insp.INSPECTIONNUMBER AS InspectionNumber,
                                inv_fee.CAINVOICEFEEID AS InvoiceFeeId,
                                comp_fee.CACOMPUTEDFEEID AS ComputedFeeId,
                                perm_fee.PMPERMITFEEID AS PermitFeeId,
                                code_fee.CMCODECASEFEEID AS CodeCaseFeeId,
                                insp_fee.IMINSPECTIONFEEID AS InspectionFeeId,
                                comp_fee.FEEDESCRIPTION AS FeeDescription,
                                inv.CAINVOICEID AS InvoiceId
                            FROM CAINVOICE inv
                            INNER JOIN CAINVOICEFEE inv_fee ON inv.CAINVOICEID = inv_fee.CAINVOICEID
                            INNER JOIN CACOMPUTEDFEE comp_fee ON inv_fee.CACOMPUTEDFEEID = comp_fee.CACOMPUTEDFEEID
                            INNER JOIN CASTATUS inv_status ON inv.CASTATUSID = inv_status.CASTATUSID
                            INNER JOIN CASTATUS comp_fee_status ON comp_fee.CASTATUSID = comp_fee_status.CASTATUSID
                            LEFT OUTER JOIN PMPERMITFEE perm_fee ON comp_fee.CACOMPUTEDFEEID = perm_fee.CACOMPUTEDFEEID
                            LEFT OUTER JOIN PMPERMIT perm ON perm_fee.PMPERMITID = perm.PMPERMITID
                            LEFT OUTER JOIN CMCODECASEFEE code_fee ON comp_fee.CACOMPUTEDFEEID = code_fee.CACOMPUTEDFEEID
                            LEFT OUTER JOIN CMCODECASE code ON code_fee.CMCODECASEID = code.CMCODECASEID
                            LEFT OUTER JOIN IMINSPECTIONFEE insp_fee ON comp_fee.CACOMPUTEDFEEID = insp_fee.CACOMPUTEDFEEID
                            LEFT OUTER JOIN IMINSPECTION insp ON insp_fee.IMINSPECTIONID = insp.IMINSPECTIONID
                            WHERE inv.CAINVOICEID = @InvoiceId",
                        new {
                            InvoiceId = invoiceId
                        },
                        cancellationToken,
                        "Fetch Invoice Fee Infos");

                        if (invoiceFees.Any(_ => !_.InvoiceStatus.Equals(1) && !_.InvoiceStatus.Equals(3) && !_.InvoiceStatus.Equals(8))) {

                            throw new Exception($"Incorrect Invoice or Fee Status for Invoice: {invoiceNumber}");
                        }
                    
                    invoiceFeeInformations.AddRange(invoiceFees);

                    consoleManager.EndScope();
                }

                foreach (var invoiceFeeInformationGroup in invoiceFeeInformations.GroupBy(_ => _.InvoiceNumber)) {

                    consoleManager.BeginScope($"Processing Invoice {invoiceFeeInformationGroup.Key}:");

                    await enerGovSqlManager.ExecuteScalarAsync(
                        @"INSERT INTO CAINVOICENOTE (CAINVOICENOTEID, CAINVOICEID, TEXT, CREATEDBY, CREATEDDATE) 
                            VALUES (@InvoiceNoteId, @InvoiceId, @Text, 'a24df514-c3c1-49c7-8784-0b2bf58c79fa', GETDATE())",
                        new {
                            InvoiceNoteId = Guid.NewGuid().ToString(),
                            InvoiceId = invoiceFeeInformationGroup.First().InvoiceId,
                            Text = $"Remaining amount of {(invoiceFeeInformationGroup.Sum(_ => _.AmountDue)):C2} was transferred to the Tax Roll on {DateTime.Today:d}"
                        },
                        cancellationToken,
                        "Add Note to Invoice"
                    );

                    await enerGovSqlManager.ExecuteScalarAsync(
                        @"UPDATE CAINVOICE SET 
                            CASTATUSID = 4,
                            INVOICEDESCRIPTION = '[Sent to Tax Roll] ' + INVOICEDESCRIPTION
                          WHERE CAINVOICEID = @InvoiceId",
                        new {
                            InvoiceId = invoiceFeeInformationGroup.First().InvoiceId
                        },
                        cancellationToken,
                        "Mark Invoice as Paid in Full");

                    foreach (var invoiceFeeInformation in invoiceFeeInformationGroup.Where(_ => _.AmountDue > 0.00m)) {

                        await enerGovSqlManager.ExecuteScalarAsync(
                            @"UPDATE CACOMPUTEDFEE SET 
                                CASTATUSID = 4, 
                                NOTES = @Notes
                              WHERE CACOMPUTEDFEEID = @ComputedFeeId",
                            new {
                                invoiceFeeInformation.ComputedFeeId,
                                Notes = $"Remaining amount of {invoiceFeeInformation.AmountDue:C2} was transferred to the Tax Roll on {DateTime.Today:d}",
                                AmountPaidToDate = invoiceFeeInformation.ComputedFeeAmount
                            },
                            cancellationToken,
                            "Mark Fee as Deleted.");

                    }


                    consoleManager.EndScope();

                }

                consoleManager.EndScope();

                await File.WriteAllTextAsync(
                    output,
                    invoiceFeeInformations.Aggregate(
                        "Invoice Number,Invoice Status,Fee Id,Fee Status,Fee Description,Paid To Date,Fee Amount,Amount Due",
                        (s, _) => $"{s}\n{_.ToString()}"),
                    cancellationToken
                );


            } catch (OperationCanceledException) {
                console.Error.WriteLine("The operation was aborted");
            } catch (Exception e) {
                console.Error.WriteLine($"Exception: {e.Message}");
            }
        }

    }
}
