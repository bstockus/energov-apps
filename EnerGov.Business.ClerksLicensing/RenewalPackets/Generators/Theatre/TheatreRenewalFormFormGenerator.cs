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

namespace EnerGov.Business.ClerksLicensing.RenewalPackets.Generators.Theatre;

public class TheatreRenewalFormFormGenerator : LicenseRenewalFormGenerator<TheatreLicenseFeeAmounts> {

    public override string LicenseTypeName => "Theater";
    public override string[] LicenseTypeIds => new[] {EnerGovLicenseTypeConstants.Theatre};
    public override string[] LicenseClassIds => new[] {EnerGovLicenseClassConstants.Theatre};
    public override int SortOrder => 100;

    public override bool ReleventLicense(EnerGovLicenseInformation enerGovLicenseInformation) =>
        enerGovLicenseInformation.IsTheatreLicenseType();

    public override TheatreLicenseFeeAmounts DefaultFees => new() {
        TheatreUnder500LicenseFeeAmount = 85.00m,
        Theatre500To1000LicenseFeeAmount = 135.00m,
        TheatreOver1000LicenseFeeAmount = 185.00m
    };

    public override async Task<object> CurrentFeesForLicense(
        DbConnection sqlConnection,
        string licenseYear,
        CancellationToken cancellationToken) =>
        await sqlConnection.QueryFirstOrDefaultAsync<TheatreLicenseFeeAmounts>(
            await typeof(ClerksLicensingBusinessModule).Assembly.GetAssemblyResource(
                "TheatreLicenseFeeInformation.sql"),
            new {
                LicenseYear = licenseYear
            });

    public override async Task<IEnumerable<LicenseRenewalFee>> RenewalFees(RenewalRequest renewalRequest,
        TheatreLicenseFeeAmounts feeInformation,
        IEnumerable<EnerGovLicenseInformation> enerGovLicenseInformations) {
        var totalFee = 0.00m;
        var licenseInformation = enerGovLicenseInformations.FirstOrDefault();

        var theatreScreens500OrUnder = licenseInformation.TheatreScreens500OrUnder ?? 0;
        var theatreScreens500To1000 = licenseInformation.TheatreScreens500To1000 ?? 0;
        var theatreScreensOver1000 = licenseInformation.TheatreScreensOver1000 ?? 0;

        if (theatreScreens500OrUnder > 0) {
            totalFee += theatreScreens500OrUnder * feeInformation.TheatreUnder500LicenseFeeAmount;
        }

        if (theatreScreens500To1000 > 0) {
            totalFee += theatreScreens500To1000 * feeInformation.Theatre500To1000LicenseFeeAmount;
        }

        if (theatreScreensOver1000 > 0) {
            totalFee += theatreScreensOver1000 * feeInformation.TheatreOver1000LicenseFeeAmount;
        }

        return await Task.FromResult(new[] {new LicenseRenewalFee("Theater", totalFee)});
    }

    public override async Task<IEnumerable<LicenseRenewalDocument>> RenewalDocuments(
        RenewalRequest renewalRequest,
        TheatreLicenseFeeAmounts feeInformation,
        IEnumerable<EnerGovLicenseInformation> enerGovLicenseInformations,
        IDictionary<string, ParcelOwnerInformation> parcelOwners) {
        var nextLicenseYear = renewalRequest.PreviousLicenseYear + 1;
        var nextLicenseYearStartDate = new DateTime(nextLicenseYear, 7, 1);
        var nextLicenseYearEndDate = new DateTime(nextLicenseYear + 1, 6, 30);

        var theatreLicenseRenewalFormPdfData =
            await typeof(ClerksLicensingBusinessModule).Assembly.GetAssemblyResourceAsBytes(
                "TheatreLicenseForm.pdf");

        await using var theatreLicenseRenewalFormPdfMemoryStream = new MemoryStream();
        var theatreLicenseRenewalFormPdfDocument = new PdfDocument(
            new PdfReader(new MemoryStream(theatreLicenseRenewalFormPdfData)),
            new PdfWriter(theatreLicenseRenewalFormPdfMemoryStream));

        var theatreLicenseRenewalForm = PdfAcroForm.GetAcroForm(theatreLicenseRenewalFormPdfDocument, true);

        var licenseInformation = enerGovLicenseInformations.FirstOrDefault();

        theatreLicenseRenewalForm.GetField("IsRenewal").SetValue("X");
        theatreLicenseRenewalForm.GetField("IsFromLastYear").SetValue("X");

        theatreLicenseRenewalForm.GetField("LegalName").SetValue(licenseInformation?.FullLegalName ?? "");
        theatreLicenseRenewalForm.GetField("BusinessAddress_Street")
            .SetValue(licenseInformation?.CompanyMailingAddress_StreetAddress ?? "");
        theatreLicenseRenewalForm.GetField("BusinessAddress_City")
            .SetValue(licenseInformation?.CompanyMailingAddress_City?.FormatAsCityName() ?? "");
        theatreLicenseRenewalForm.GetField("BusinessAddress_State")
            .SetValue(licenseInformation?.CompanyMailingAddress_State ?? "");
        theatreLicenseRenewalForm.GetField("BusinessAddress_ZipCode")
            .SetValue(licenseInformation?.CompanyMailingAddress_PostalCode?.FormatAsZipCode() ?? "");
        theatreLicenseRenewalForm.GetField("TradeName").SetValue(licenseInformation?.TradeName);
        theatreLicenseRenewalForm.GetField("PremiseAddress")
            .SetValue(licenseInformation?.LocationAddress_StreetAddress?.FormatAsAddress() ?? "");


        theatreLicenseRenewalForm.GetField("Agent_FirstName")
            .SetValue(licenseInformation?.ManagerName_First ?? "");
        theatreLicenseRenewalForm.GetField("Agent_MiddleName")
            .SetValue(licenseInformation?.ManagerName_Middle ?? "");
        theatreLicenseRenewalForm.GetField("Agent_LastName")
            .SetValue(licenseInformation?.ManagerName_Last ?? "");

        theatreLicenseRenewalForm.GetField("AgentAddress_Street")
            .SetValue(licenseInformation?.ManagerCompleteAddress_StreetAddress ?? "");
        theatreLicenseRenewalForm.GetField("AgentAddress_City")
            .SetValue(licenseInformation?.ManagerCompleteAddress_City?.FormatAsCityName() ?? "");
        theatreLicenseRenewalForm.GetField("AgentAddress_State")
            .SetValue(licenseInformation?.ManagerCompleteAddress_State ?? "");
        theatreLicenseRenewalForm.GetField("AgentAddress_ZipCode")
            .SetValue(licenseInformation?.ManagerCompleteAddress_PostalCode?.FormatAsZipCode() ?? "");

        theatreLicenseRenewalForm.GetField("CabaretManager_HomePhoneNumber")
            .SetValue(licenseInformation?.ManagerHomePhone?.FormatAsTelephoneNumber() ?? "");
        theatreLicenseRenewalForm.GetField("CabaretManager_DaytimePhoneNumber")
            .SetValue(licenseInformation?.ManagerBusinessPhone?.FormatAsTelephoneNumber() ?? "");

        theatreLicenseRenewalForm.GetField("LicensePeriodStart")
            .SetValue($"{nextLicenseYearStartDate:d}");
        theatreLicenseRenewalForm.GetField("LicensePeriodEnd")
            .SetValue($"{nextLicenseYearEndDate:d}");

        var totalFee = 0.00m;

        var theatreScreens500OrUnder = licenseInformation.TheatreScreens500OrUnder ?? 0;
        var theatreScreens500To1000 = licenseInformation.TheatreScreens500To1000 ?? 0;
        var theatreScreensOver1000 = licenseInformation.TheatreScreensOver1000 ?? 0;

        if (theatreScreens500OrUnder > 0) {
            theatreLicenseRenewalForm.GetField("ScreensUnder500").SetValue(theatreScreens500OrUnder.ToString());
            theatreLicenseRenewalForm.GetField("FeeUnder500").SetValue(
                (theatreScreens500OrUnder * feeInformation.TheatreUnder500LicenseFeeAmount)
                .ToString("F2"));
            totalFee += theatreScreens500OrUnder * feeInformation.TheatreUnder500LicenseFeeAmount;
        }

        if (theatreScreens500To1000 > 0) {
            theatreLicenseRenewalForm.GetField("Screens500To1000").SetValue(theatreScreens500To1000.ToString());
            theatreLicenseRenewalForm.GetField("Fee500To1000").SetValue(
                (theatreScreens500To1000 * feeInformation.Theatre500To1000LicenseFeeAmount)
                .ToString("F2"));
            totalFee += theatreScreens500To1000 * feeInformation.Theatre500To1000LicenseFeeAmount;
        }

        if (theatreScreensOver1000 > 0) {
            theatreLicenseRenewalForm.GetField("ScreensOver1000").SetValue(theatreScreensOver1000.ToString());
            theatreLicenseRenewalForm.GetField("FeeOver1000").SetValue(
                (theatreScreensOver1000 * feeInformation.TheatreOver1000LicenseFeeAmount)
                .ToString("F2"));
            totalFee += theatreScreensOver1000 * feeInformation.TheatreOver1000LicenseFeeAmount;
        }

        theatreLicenseRenewalForm.GetField("TotalFees").SetValue(totalFee.ToString("F2"));
        theatreLicenseRenewalForm.GetField("Fee").SetValue(totalFee.ToString("F2"));

        theatreLicenseRenewalForm.FlattenFields();

        theatreLicenseRenewalFormPdfDocument.Close();

        return new[] {new LicenseRenewalDocument("Theater", theatreLicenseRenewalFormPdfMemoryStream.ToArray())};
    }

}