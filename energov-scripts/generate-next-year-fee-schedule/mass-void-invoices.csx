#r "nuget: System.Data.SqlClient, 4.6.0"
#r "nuget: Dapper, 1.60.6"

using System.Data.SqlClient;
using Dapper;

public class FeeInformation {
    public string InvoiceId { get; set; }
    public string ComputedFeeId { get; set; }
}

var ENERGOV_SQL_CONNECTION_STRING = "Server=lax-sql1\\ENERGOV;Database=energov_test;Trusted_Connection=True;";

var enerGovSqlConnection = new SqlConnection(ENERGOV_SQL_CONNECTION_STRING);
await enerGovSqlConnection.OpenAsync();

var feeInformations = await enerGovSqlConnection.QueryAsync<FeeInformation>(@"
    SELECT
        cainv.CAINVOICEID AS InvoiceId,
        cacompfee.CACOMPUTEDFEEID AS ComputedFeeId
    FROM CAINVOICE cainv
    INNER JOIN CAINVOICEFEE cainvfee ON cainv.CAINVOICEID = cainvfee.CAINVOICEID
    INNER JOIN CACOMPUTEDFEE cacompfee ON cainvfee.CACOMPUTEDFEEID = cacompfee.CACOMPUTEDFEEID
    WHERE cainv.INVOICENUMBER BETWEEN '00019940' AND '00021232' AND
        cainv.CASTATUSID = 1");

var feeInformationLookups = feeInformations.ToLookup(_ => _.InvoiceId, _ => _);

foreach (var feeInformationGroup in feeInformationLookups) {

    Console.WriteLine($"{feeInformationGroup.Key}:");

    await enerGovSqlConnection.ExecuteScalarAsync(
        @"
        UPDATE CAINVOICE
        SET CASTATUSID = 5
        WHERE CAINVOICEID = @InvoiceId
        ",
        new {
            InvoiceId = feeInformationGroup.Key
        }
    );

    foreach (var feeInfo in feeInformationGroup) {
        Console.WriteLine($"      {feeInfo.ComputedFeeId}");

        await enerGovSqlConnection.ExecuteScalarAsync(
            @"
            UPDATE CACOMPUTEDFEE
            SET CASTATUSID = 5
            WHERE CACOMPUTEDFEEID = @ComputedFeeId
            ",
            new {
                @ComputedFeeId = feeInfo.ComputedFeeId
            }
        );
    }

}