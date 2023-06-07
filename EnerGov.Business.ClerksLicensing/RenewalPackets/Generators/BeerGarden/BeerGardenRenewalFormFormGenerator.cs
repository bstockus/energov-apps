using System;
using System.Collections.Generic;
using System.Data.Common;
using System.IO;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;
using Dapper;
using EnerGov.Business.ClerksLicensing.Helpers;
using EnerGov.Business.ClerksLicensing.RenewalPackets.Constants;
using EnerGov.Business.ClerksLicensing.RenewalPackets.Generators.Models;
using iText.Forms;
using iText.Kernel.Pdf;
using Lax.Helpers.AssemblyResources;

namespace EnerGov.Business.ClerksLicensing.RenewalPackets.Generators.BeerGarden;

public class BeerGardenRenewalFormFormGenerator : LicenseRenewalFormGenerator<BeerGardenLicenseFeeAmounts> {

    public override string LicenseTypeName => "Beer Garden";
    public override string[] LicenseTypeIds => new[] {EnerGovLicenseTypeConstants.BeerGarden};

    public override string[] LicenseClassIds => new[] {
        EnerGovLicenseClassConstants.ClassATavern,
        EnerGovLicenseClassConstants.ClassBRestaurant,
        EnerGovLicenseClassConstants.ClassCRecreational,
        EnerGovLicenseClassConstants.ClassDRestaurant
    };

    public override int SortOrder => 100;

    public override bool ReleventLicense(EnerGovLicenseInformation enerGovLicenseInformation) =>
        enerGovLicenseInformation.IsBeerGardenLicenseType();

    public override BeerGardenLicenseFeeAmounts DefaultFees => new() {
        ClassAFeeAmount = 160.00m,
        ClassBFeeAmount = 160.00m,
        ClassCFeeAmount = 160.00m,
        ClassDFeeAmount = 260.00m
    };

    public override async Task<object> CurrentFeesForLicense(
        DbConnection sqlConnection,
        string licenseYear,
        CancellationToken cancellationToken) =>
        await sqlConnection.QueryFirstOrDefaultAsync<BeerGardenLicenseFeeAmounts>(
            await typeof(ClerksLicensingBusinessModule).Assembly.GetAssemblyResource(
                "BeerGardenLicenseFeeInformation.sql"),
            new {
                LicenseYear = licenseYear
            });

    public override async Task<IEnumerable<LicenseRenewalFee>> RenewalFees(RenewalRequest renewalRequest,
        BeerGardenLicenseFeeAmounts feeInformation,
        IEnumerable<EnerGovLicenseInformation> enerGovLicenseInformations) {
        var licenseInformation = enerGovLicenseInformations.FirstOrDefault();

        var fees = new List<LicenseRenewalFee>();

        if (licenseInformation.IsClassATavernLicenseClass()) {
            fees.Add(new LicenseRenewalFee("Class A Beer Garden", feeInformation.ClassAFeeAmount));
        }

        if (licenseInformation.IsClassBRestaurantLicenseClass()) {
            fees.Add(new LicenseRenewalFee("Class B Beer Garden", feeInformation.ClassBFeeAmount));
        }

        if (licenseInformation.IsClassCRecreationalLicenseClass()) {
            fees.Add(new LicenseRenewalFee("Class C Beer Garden", feeInformation.ClassCFeeAmount));
        }

        if (licenseInformation.IsClassDRestaurantLicenseClass()) {
            fees.Add(new LicenseRenewalFee("Class D Beer Garden", feeInformation.ClassDFeeAmount));
        }

        return await Task.FromResult(fees);
    }

    public override async Task<IEnumerable<LicenseRenewalDocument>> RenewalDocuments(RenewalRequest renewalRequest,
        BeerGardenLicenseFeeAmounts feeInformation,
        IEnumerable<EnerGovLicenseInformation> enerGovLicenseInformations,
        IDictionary<string, ParcelOwnerInformation> parcelOwners) {
        var nextLicenseYear = renewalRequest.PreviousLicenseYear + 1;
        var nextLicenseYearStartDate = new DateTime(nextLicenseYear, 7, 1);
        var nextLicenseYearEndDate = new DateTime(nextLicenseYear + 1, 6, 30);

        var beerGardenLicenseRenewalFormPdfData =
            await typeof(ClerksLicensingBusinessModule).Assembly.GetAssemblyResourceAsBytes(
                "BeerGardenApplication.pdf");

        await using var beerGardenLicenseRenewalFormPdfMemoryStream = new MemoryStream();
        var beerGardenLicenseRenewalFormPdfDocument = new PdfDocument(
            new PdfReader(new MemoryStream(beerGardenLicenseRenewalFormPdfData)),
            new PdfWriter(beerGardenLicenseRenewalFormPdfMemoryStream));

        var beerGardenLicenseRenewalForm = PdfAcroForm.GetAcroForm(beerGardenLicenseRenewalFormPdfDocument, true);

        var licenseInformation = enerGovLicenseInformations.FirstOrDefault();

        beerGardenLicenseRenewalForm.GetField("IsRenewal").SetValue("X");
        beerGardenLicenseRenewalForm.GetField("IsFromLastYear").SetValue("X");

        if (licenseInformation.IsClassATavernLicenseClass()) {
            beerGardenLicenseRenewalForm.GetField("ClassA").SetValue("X");
            beerGardenLicenseRenewalForm.GetField("Fee")
                .SetValue(feeInformation.ClassAFeeAmount.ToString("F2"));
        }

        if (licenseInformation.IsClassBRestaurantLicenseClass()) {
            beerGardenLicenseRenewalForm.GetField("ClassB").SetValue("X");
            beerGardenLicenseRenewalForm.GetField("Fee")
                .SetValue(feeInformation.ClassBFeeAmount.ToString("F2"));
        }

        if (licenseInformation.IsClassCRecreationalLicenseClass()) {
            beerGardenLicenseRenewalForm.GetField("ClassC").SetValue("X");
            beerGardenLicenseRenewalForm.GetField("Fee")
                .SetValue(feeInformation.ClassCFeeAmount.ToString("F2"));
        }

        if (licenseInformation.IsClassDRestaurantLicenseClass()) {
            beerGardenLicenseRenewalForm.GetField("ClassD").SetValue("X");
            beerGardenLicenseRenewalForm.GetField("Fee")
                .SetValue(feeInformation.ClassDFeeAmount.ToString("F2"));
        }

        beerGardenLicenseRenewalForm.GetField("LegalName").SetValue(licenseInformation?.FullLegalName ?? "");
        beerGardenLicenseRenewalForm.GetField("BusinessAddress_Street")
            .SetValue(licenseInformation?.CompanyMailingAddress_StreetAddress ?? "");
        beerGardenLicenseRenewalForm.GetField("BusinessAddress_City")
            .SetValue(licenseInformation?.CompanyMailingAddress_City?.FormatAsCityName() ?? "");
        beerGardenLicenseRenewalForm.GetField("BusinessAddress_State")
            .SetValue(licenseInformation?.CompanyMailingAddress_State ?? "");
        beerGardenLicenseRenewalForm.GetField("BusinessAddress_ZipCode")
            .SetValue(licenseInformation?.CompanyMailingAddress_PostalCode?.FormatAsZipCode() ?? "");
        beerGardenLicenseRenewalForm.GetField("TradeName").SetValue(licenseInformation?.TradeName);
        beerGardenLicenseRenewalForm.GetField("PremiseAddress")
            .SetValue(licenseInformation?.LocationAddress_StreetAddress?.FormatAsAddress() ?? "");
        beerGardenLicenseRenewalForm.GetField("BeerGardenDescription")
            .SetValue(licenseInformation?.BeerGardenDescription ?? "");


        beerGardenLicenseRenewalForm.GetField("Agent_FirstName")
            .SetValue(licenseInformation?.ManagerName_First ?? "");
        beerGardenLicenseRenewalForm.GetField("Agent_MiddleName")
            .SetValue(licenseInformation?.ManagerName_Middle ?? "");
        beerGardenLicenseRenewalForm.GetField("Agent_LastName")
            .SetValue(licenseInformation?.ManagerName_Last ?? "");

        beerGardenLicenseRenewalForm.GetField("AgentAddress_Street")
            .SetValue(licenseInformation?.ManagerCompleteAddress_StreetAddress ?? "");
        beerGardenLicenseRenewalForm.GetField("AgentAddress_City")
            .SetValue(licenseInformation?.ManagerCompleteAddress_City?.FormatAsCityName() ?? "");
        beerGardenLicenseRenewalForm.GetField("AgentAddress_State")
            .SetValue(licenseInformation?.ManagerCompleteAddress_State ?? "");
        beerGardenLicenseRenewalForm.GetField("AgentAddress_ZipCode")
            .SetValue(licenseInformation?.ManagerCompleteAddress_PostalCode?.FormatAsZipCode() ?? "");

        beerGardenLicenseRenewalForm.GetField("CabaretManager_HomePhoneNumber")
            .SetValue(licenseInformation?.ManagerHomePhone?.FormatAsTelephoneNumber() ?? "");
        beerGardenLicenseRenewalForm.GetField("CabaretManager_DaytimePhoneNumber")
            .SetValue(licenseInformation?.ManagerBusinessPhone?.FormatAsTelephoneNumber() ?? "");

        beerGardenLicenseRenewalForm.GetField("LicensePeriodStart")
            .SetValue($"{nextLicenseYearStartDate:d}");
        beerGardenLicenseRenewalForm.GetField("LicensePeriodEnd")
            .SetValue($"{nextLicenseYearEndDate:d}");

        beerGardenLicenseRenewalForm.FlattenFields();

        beerGardenLicenseRenewalFormPdfDocument.Close();

        return new[]
            {new LicenseRenewalDocument("Beer Garden", beerGardenLicenseRenewalFormPdfMemoryStream.ToArray())};
    }

}