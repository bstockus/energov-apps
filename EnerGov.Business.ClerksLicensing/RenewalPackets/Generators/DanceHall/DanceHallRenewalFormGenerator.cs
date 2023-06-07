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

namespace EnerGov.Business.ClerksLicensing.RenewalPackets.Generators.DanceHall;

public class DanceHallRenewalFormGenerator : LicenseRenewalFormGenerator<DanceHallLicenseFeeAmounts> {

    public override string LicenseTypeName => "Dance Hall";
    public override string[] LicenseTypeIds => new[] {EnerGovLicenseTypeConstants.DanceHall};
    public override string[] LicenseClassIds => new[] {EnerGovLicenseClassConstants.DanceHall};
    public override int SortOrder => 100;

    public override bool ReleventLicense(EnerGovLicenseInformation enerGovLicenseInformation) =>
        enerGovLicenseInformation.IsDanceHallLicenseType();

    public override DanceHallLicenseFeeAmounts DefaultFees => new() {
        Amount = 110.00m
    };

    public override async Task<object> CurrentFeesForLicense(
        DbConnection sqlConnection,
        string licenseYear,
        CancellationToken cancellationToken) =>
        await sqlConnection.QueryFirstOrDefaultAsync<DanceHallLicenseFeeAmounts>(
            await typeof(ClerksLicensingBusinessModule).Assembly.GetAssemblyResource(
                "DanceHallLicenseFeeInformation.sql"),
            new {
                LicenseYear = licenseYear
            });

    public override async Task<IEnumerable<LicenseRenewalFee>> RenewalFees(
        RenewalRequest renewalRequest,
        DanceHallLicenseFeeAmounts feeInformation,
        IEnumerable<EnerGovLicenseInformation> enerGovLicenseInformations) =>
        await Task.FromResult(new[] {new LicenseRenewalFee("Dance Hall", feeInformation.Amount)});

    public override async Task<IEnumerable<LicenseRenewalDocument>> RenewalDocuments(
        RenewalRequest renewalRequest,
        DanceHallLicenseFeeAmounts feeInformation,
        IEnumerable<EnerGovLicenseInformation> enerGovLicenseInformations,
        IDictionary<string, ParcelOwnerInformation> parcelOwners) {
        var nextLicenseYear = renewalRequest.PreviousLicenseYear + 1;
        var nextLicenseYearStartDate = new DateTime(nextLicenseYear, 7, 1);
        var nextLicenseYearEndDate = new DateTime(nextLicenseYear + 1, 6, 30);

        var renewalFormPdfData =
            await typeof(ClerksLicensingBusinessModule).Assembly.GetAssemblyResourceAsBytes(
                "DanceHallLicenseForm.pdf");

        await using var renewalFormPdfMemoryStream = new MemoryStream();
        var renewalFormPdfDocument = new PdfDocument(
            new PdfReader(new MemoryStream(renewalFormPdfData)),
            new PdfWriter(renewalFormPdfMemoryStream));

        var renewalForm = PdfAcroForm.GetAcroForm(renewalFormPdfDocument, true);

        var licenseInformation = enerGovLicenseInformations.FirstOrDefault();

        renewalForm.GetField("IsRenewal").SetValue("X");
        renewalForm.GetField("IsFromLastYear").SetValue("X");

        renewalForm.GetField("LegalName").SetValue(licenseInformation?.FullLegalName ?? "");
        renewalForm.GetField("BusinessAddress_Street")
            .SetValue(licenseInformation?.CompanyMailingAddress_StreetAddress ?? "");
        renewalForm.GetField("BusinessAddress_City")
            .SetValue(licenseInformation?.CompanyMailingAddress_City?.FormatAsCityName() ?? "");
        renewalForm.GetField("BusinessAddress_State")
            .SetValue(licenseInformation?.CompanyMailingAddress_State ?? "");
        renewalForm.GetField("BusinessAddress_ZipCode")
            .SetValue(licenseInformation?.CompanyMailingAddress_PostalCode?.FormatAsZipCode() ?? "");
        renewalForm.GetField("TradeName").SetValue(licenseInformation?.TradeName);
        renewalForm.GetField("PremiseAddress")
            .SetValue(licenseInformation?.LocationAddress_StreetAddress?.FormatAsAddress() ?? "");


        renewalForm.GetField("Agent_FirstName")
            .SetValue(licenseInformation?.ManagerName_First ?? "");
        renewalForm.GetField("Agent_MiddleName")
            .SetValue(licenseInformation?.ManagerName_Middle ?? "");
        renewalForm.GetField("Agent_LastName")
            .SetValue(licenseInformation?.ManagerName_Last ?? "");

        renewalForm.GetField("AgentAddress_Street")
            .SetValue(licenseInformation?.ManagerCompleteAddress_StreetAddress ?? "");
        renewalForm.GetField("AgentAddress_City")
            .SetValue(licenseInformation?.ManagerCompleteAddress_City?.FormatAsCityName() ?? "");
        renewalForm.GetField("AgentAddress_State")
            .SetValue(licenseInformation?.ManagerCompleteAddress_State ?? "");
        renewalForm.GetField("AgentAddress_ZipCode")
            .SetValue(licenseInformation?.ManagerCompleteAddress_PostalCode?.FormatAsZipCode() ?? "");

        renewalForm.GetField("CabaretManager_HomePhoneNumber")
            .SetValue(licenseInformation?.ManagerHomePhone?.FormatAsTelephoneNumber() ?? "");
        renewalForm.GetField("CabaretManager_DaytimePhoneNumber")
            .SetValue(licenseInformation?.ManagerBusinessPhone?.FormatAsTelephoneNumber() ?? "");

        renewalForm.GetField("LicensePeriodStart")
            .SetValue($"{nextLicenseYearStartDate:d}");
        renewalForm.GetField("LicensePeriodEnd")
            .SetValue($"{nextLicenseYearEndDate:d}");

        var totalFee = feeInformation.Amount;

        renewalForm.GetField("Fee").SetValue(totalFee.ToString("F2"));

        renewalForm.FlattenFields();

        renewalFormPdfDocument.Close();

        return new[] {new LicenseRenewalDocument("Dance Hall", renewalFormPdfMemoryStream.ToArray())};
    }

}