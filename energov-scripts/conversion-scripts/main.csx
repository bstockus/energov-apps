#r "nuget: System.Data.SqlClient, 4.7.0"
#r "nuget: Dapper, 2.0.30"

using System.Data.SqlClient;
using Dapper;

public class ClerkBusiness {
    public string TradeName { get; set; }
    public string PremiseAddress { get; set; }
    public string WISPNumber { get; set; }
    public string FEIN { get; set; }
    public string BusinessType { get; set; }
}

public class EnerGovBusiness {
    public string BusinessId { get; set; }
    public string RegistrationId { get; set; }
    public string TradeName { get; set; } 
    public string WISPNumber { get; set; }
    public string CustomFieldsExists { get; set; }
    public string StreetAddress { get; set; }
}

var businessTypeMappings = new Dictionary<string, string>{
    {"CORP", "1553db92-fe81-46d1-a7fd-9bc1b67023de"},
    {"LLC", "a63e6114-1e48-4001-85a2-6bbb5bb59504"},
    {"IND", "d7f856bd-bd93-4349-8dcb-61a326bcf3dc"},
    {"PRTN", "ee099d89-00e2-4d34-af66-a23eb12559b9"}
};

var enerGovSqlConnection = new SqlConnection(@"Server=lax-sql1;Database=energovprod;Trusted_Connection=True;MultipleActiveResultSets=True;");
await enerGovSqlConnection.OpenAsync();

var clerksSqlConnection = new SqlConnection(@"Server=lax-sp2;Database=Clerk1;Trusted_Connection=True;MultipleActiveResultSets=True;");
await clerksSqlConnection.OpenAsync();

var clerksBusinesses = (await clerksSqlConnection.QueryAsync<ClerkBusiness>(@"SELECT 
	ISNULL(LTRIM(RTRIM(prem.TradeName)), '') AS TradeName,
	ISNULL(LTRIM(RTRIM(prem.PremiseAddress)), '') AS PremiseAddress,
	ISNULL(LTRIM(RTRIM(buis.WISPNumber)), '') AS WISPNumber,
	ISNULL(LTRIM(RTRIM(buis.FEIN)), '') AS FEIN,
	ISNULL(LTRIM(RTRIM(buis.BusinessType)), '') AS BusinessType
  FROM [Clerk1].[dbo].[tblLicenseCustomerPremises] prem
  INNER JOIN [tblLicenseCustomerMaster] buis ON prem.CustomerID = buis.CustomerID")).ToList();

var enerGovBusinesses = (await enerGovSqlConnection.QueryAsync<EnerGovBusiness>(@"SELECT
    buis.BLGLOBALENTITYEXTENSIONID AS BusinessId,
    buis.REGISTRATIONID AS RegistrationId,
    buis.STATETAXNUMBER AS WISPNumber,
    buis.DBA AS TradeName,
    ISNULL((SELECT TOP 1 cust_field.ID FROM CUSTOMSAVERLICENSEMANAGEMENT cust_field WHERE cust_field.ID = buis.BLGLOBALENTITYEXTENSIONID), '') AS CustomFieldsExists,
    LTRIM(RTRIM(ma.ADDRESSLINE1)) +
            IIF(LEN(ma.PREDIRECTION) > 0, ' ' + LTRIM(RTRIM(ma.PREDIRECTION)), '') + ' ' +
            LTRIM(RTRIM(ma.ADDRESSLINE2)) + ' ' + LTRIM(RTRIM(ma.STREETTYPE)) +
            IIF(LEN(ma.POSTDIRECTION) > 0, ' ' + LTRIM(RTRIM(ma.POSTDIRECTION)), '') +
            IIF(LEN(ma.UNITORSUITE) > 0, ' ' + LTRIM(RTRIM(ma.UNITORSUITE)), '') AS StreetAddress
FROM BLGLOBALENTITYEXTENSION buis
INNER JOIN BLLICENSE lic ON buis.BLGLOBALENTITYEXTENSIONID = lic.BLGLOBALENTITYEXTENSIONID
INNER JOIN BLGLOBALENTITYEXTENSIONADDRESS buis_addr ON buis.BLGLOBALENTITYEXTENSIONID = buis_addr.BLGLOBALENTITYEXTENSIONID AND buis_addr.MAIN = 1
INNER JOIN MAILINGADDRESS ma ON buis_addr.MAILINGADDRESSID = ma.MAILINGADDRESSID
WHERE buis.BLEXTCOMPANYTYPEID = 'b0bcecf3-927a-45ac-b93a-45cc5a5c37c0' AND lic.BLLICENSETYPEID IN ('7f4eb150-f664-4990-a1d2-2b5a3a5afa76', 'd59413cc-e339-4605-b35e-5f8538a90afc', '0442003d-b7a4-4600-b559-89a0f5a9e515', 'b2d09619-c5cd-43bc-bf1a-1005eae96055') AND lic.TAXYEAR = 2019")).ToList();



foreach (var enerGovBusiness in enerGovBusinesses.GroupBy(_ => _.BusinessId).Select(_ => _.FirstOrDefault())) {
    
    if (!string.IsNullOrWhiteSpace(enerGovBusiness.WISPNumber) && clerksBusinesses.Any(_ => _.WISPNumber.Equals(enerGovBusiness.WISPNumber))) {
        var clerkBusiness = clerksBusinesses.FirstOrDefault(_ => _.WISPNumber.Equals(enerGovBusiness.WISPNumber));
        if (businessTypeMappings.ContainsKey(clerkBusiness.BusinessType)) {
            if (string.IsNullOrWhiteSpace(enerGovBusiness.CustomFieldsExists)) {
                var insertSqlCommand = new SqlCommand(@"INSERT INTO CUSTOMSAVERLICENSEMANAGEMENT(ID, ClerksCompanyType) VALUES (@Id, @ClerksCompanyType)", enerGovSqlConnection);
                insertSqlCommand.Parameters.AddWithValue("@Id", enerGovBusiness.BusinessId);
                insertSqlCommand.Parameters.AddWithValue("@ClerksCompanyType", businessTypeMappings[clerkBusiness.BusinessType]);
                await insertSqlCommand.ExecuteNonQueryAsync();
                //Console.WriteLine($"[{enerGovBusiness.BusinessId}]: {enerGovBusiness.TradeName} => INSERT");
            } else {
                var updateSqlCommand = new SqlCommand(@"UPDATE CUSTOMSAVERLICENSEMANAGEMENT SET ClerksCompanyType = @ClerksCompanyType WHERE Id = @Id", enerGovSqlConnection);
                updateSqlCommand.Parameters.AddWithValue("@Id", enerGovBusiness.BusinessId);
                updateSqlCommand.Parameters.AddWithValue("@ClerksCompanyType", businessTypeMappings[clerkBusiness.BusinessType]);
                await updateSqlCommand.ExecuteNonQueryAsync();
                //Console.WriteLine($"[{enerGovBusiness.BusinessId}]: {enerGovBusiness.TradeName} => UPDATE");
            }
            continue;
        }
        
    }
    Console.WriteLine($"[{enerGovBusiness.BusinessId}]: {enerGovBusiness.TradeName} => {enerGovBusiness.RegistrationId}");

}