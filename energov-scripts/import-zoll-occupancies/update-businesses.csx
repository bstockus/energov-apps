#r "nuget: System.Data.SqlClient, 4.6.0"
#r "nuget: Dapper, 1.60.6"

#load "classes/SqlManager.csx"

using System.Data.SqlClient;
using Dapper;

public class EnerGovBusiness {
    public string BusinessGlobalEntityId { get; set; }
    public string GlobalEntityId { get; set; }
    public string DBA { get; set; }
    public string Buis_CompanyName { get; set; }
    public string Comp_CompanyName { get; set; }
    public string Buis_BusinessPhone { get; set; }
    public string Comp_BusinessPhone { get; set; }
    public string Buis_Email { get; set; }
    public string Comp_Email { get; set; }
    public string BusinessId { get; set; }
}

var ENERGOV_SQL_CONNECTION_STRING = "Server=lax-sql1\\ENERGOV;Database=energov_train;Trusted_Connection=True;";

var enerGovSqlConnection = new SqlConnection(ENERGOV_SQL_CONNECTION_STRING);
await enerGovSqlConnection.OpenAsync();

var enerGovSqlManager = new SqlManager(enerGovSqlConnection, false);

if (enerGovSqlManager.ExecuteCommands) {
    Console.WriteLine($"Warning you are about to make changes to the '{ENERGOV_SQL_CONNECTION_STRING}' database!!!");
    Console.Write("Are you sure (Y/N)? ");

    var key = Console.ReadKey();
    Console.WriteLine("");
    if (!key.KeyChar.ToString().ToUpper().Equals("Y")) {
        Console.WriteLine("Exiting!");
        Environment.Exit(-1);
    }
}

var businesses = await enerGovSqlConnection.QueryAsync<EnerGovBusiness>(@"SELECT
        (SELECT TOP 1 comp_cont.GLOBALENTITYID
            FROM BLGLOBALENTITYEXTENSIONCONTACT comp_cont
            WHERE comp_cont.BLGLOBALENTITYEXTENSIONID = buis.BLGLOBALENTITYEXTENSIONID AND
                comp_cont.BLCONTACTTYPEID = '89625cdf-c6a3-47c2-8e54-2ac0c4e17c4e') AS BusinessGlobalEntityId,
        buis.GLOBALENTITYID AS GlobalEntityId,
        buis.DBA AS DBA,
        buis.COMPANYNAME AS Buis_CompanyName,
        comp.GLOBALENTITYNAME AS Comp_CompanyName,
        buis.BUSINESSPHONE AS Buis_BusinessPhone,
        comp.BUSINESSPHONE AS Comp_BusinessPhone,
        buis.EMAIL AS Buis_Email,
        comp.EMAIL AS Comp_Email,
        buis.BLGLOBALENTITYEXTENSIONID AS BusinessId
    FROM BLGLOBALENTITYEXTENSION buis
    INNER JOIN GLOBALENTITY comp ON buis.GLOBALENTITYID = comp.GLOBALENTITYID
    WHERE buis.GLOBALENTITYID IS NOT NULL AND buis.BLEXTCOMPANYTYPEID IN ('a3cf6703-6409-491f-b218-dc83ced4f3f2', '7baacd99-8439-44ad-8eeb-c05abb359bbd', '31cd6ee6-42d4-4158-b47e-5ad0e88b7925')");

Console.WriteLine($"Count of Businesses: {businesses.Count()}");

foreach (var business in businesses) {
    
    //1. Add a Business Type contact if it doesn't exist:
    if (string.IsNullOrEmpty(business.BusinessGlobalEntityId)) {

        await enerGovSqlManager.ExecuteScalarAsync(@"INSERT INTO BLGLOBALENTITYEXTENSIONCONTACT
                (BLGLOBALENTITYEXTCONTACTID, BLGLOBALENTITYEXTENSIONID, GLOBALENTITYID, BLCONTACTTYPEID)
            VALUES (
                @GlobalEntityExtContactId,
                @BusinessId,
                @GlobalEntityId,
                '89625cdf-c6a3-47c2-8e54-2ac0c4e17c4e'
            )", new {
                 GlobalEntityExtContactId = Guid.NewGuid().ToString(),
                 BusinessId = business.BusinessId,
                 GlobalEntityId = business.GlobalEntityId
            });
        
        //2. Update the Business Itself:
        await enerGovSqlManager.ExecuteScalarAsync(@"UPDATE BLGLOBALENTITYEXTENSION
            SET
                COMPANYNAME = @CompanyName,
                BUSINESSPHONE = @BusinessPhone,
                EMAIL = @Email,
                GLOBALENTITYID = NULL
            WHERE BLGLOBALENTITYEXTENSIONID = @BusinessId", new {
                    CompanyName = business.Comp_CompanyName,
                    Email = business.Comp_Email ?? "",
                    BusinessPhone = business.Comp_BusinessPhone ?? "",
                    BusinessId = business.BusinessId
                });

    }
}