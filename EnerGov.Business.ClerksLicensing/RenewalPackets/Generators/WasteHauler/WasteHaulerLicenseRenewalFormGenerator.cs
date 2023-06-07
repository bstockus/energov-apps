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

namespace EnerGov.Business.ClerksLicensing.RenewalPackets.Generators.WasteHauler;

public class WasteHaulerLicenseRenewalFormGenerator : LicenseRenewalFormGenerator<WasteHaulerLicenseFeeAmounts> {

    public override string LicenseTypeName => "Waste Hauler";
    public override string[] LicenseTypeIds => new[] {EnerGovLicenseTypeConstants.WasteHauler};
    public override string[] LicenseClassIds => new[] {EnerGovLicenseClassConstants.WasteHauler};
    public override int SortOrder => 100;

    public override bool ReleventLicense(EnerGovLicenseInformation enerGovLicenseInformation) =>
        enerGovLicenseInformation.IsWasteHaulerLicenseType();

    public override WasteHaulerLicenseFeeAmounts DefaultFees => new() {
        LicenseFeeAmount = 200.00m
    };

    public override async Task<object> CurrentFeesForLicense(
        DbConnection sqlConnection,
        string licenseYear,
        CancellationToken cancellationToken) =>
        await sqlConnection.QueryFirstOrDefaultAsync<WasteHaulerLicenseFeeAmounts>(
            await typeof(ClerksLicensingBusinessModule).Assembly.GetAssemblyResource(
                "WasteHaulerLicenseFeeInformation.sql"),
            new {
                LicenseYear = licenseYear
            });

    public override async Task<IEnumerable<LicenseRenewalFee>> RenewalFees(
        RenewalRequest renewalRequest,
        WasteHaulerLicenseFeeAmounts feeInformation,
        IEnumerable<EnerGovLicenseInformation> enerGovLicenseInformations) =>
        await Task.FromResult(new[] {new LicenseRenewalFee("Waste Hauler", feeInformation.LicenseFeeAmount)});

    public override async Task<IEnumerable<LicenseRenewalDocument>> RenewalDocuments(
        RenewalRequest renewalRequest,
        WasteHaulerLicenseFeeAmounts feeInformation,
        IEnumerable<EnerGovLicenseInformation> enerGovLicenseInformations,
        IDictionary<string, ParcelOwnerInformation> parcelOwners) {
        var nextLicenseYear = renewalRequest.PreviousLicenseYear + 1;
        var nextLicenseYearStartDate = new DateTime(nextLicenseYear, 7, 1);
        var nextLicenseYearEndDate = new DateTime(nextLicenseYear + 1, 6, 30);

        var renewalFormPdfData =
            await typeof(ClerksLicensingBusinessModule).Assembly.GetAssemblyResourceAsBytes(
                "WasteHaulerLicenseForm.pdf");

        await using var renewalFormPdfMemoryStream = new MemoryStream();
        var renewalFormPdfDocument = new PdfDocument(
            new PdfReader(new MemoryStream(renewalFormPdfData)),
            new PdfWriter(renewalFormPdfMemoryStream));

        var renewalForm = PdfAcroForm.GetAcroForm(renewalFormPdfDocument, true);

        var licenseInformation = enerGovLicenseInformations.FirstOrDefault();

        renewalForm.GetField("IsRenewal").SetValue("X");

        renewalForm.GetField("LegalName").SetValue(licenseInformation?.FullLegalName ?? "");
        renewalForm.GetField("BusinessAddress_Street")
            .SetValue(licenseInformation?.CompanyMailingAddress_StreetAddress ?? "");
        renewalForm.GetField("BusinessAddress_City")
            .SetValue(licenseInformation?.CompanyMailingAddress_City?.FormatAsCityName() ?? "");
        renewalForm.GetField("BusinessAddress_State")
            .SetValue(licenseInformation?.CompanyMailingAddress_State ?? "");
        renewalForm.GetField("BusinessAddress_ZipCode")
            .SetValue(licenseInformation?.CompanyMailingAddress_PostalCode?.FormatAsZipCode() ?? "");
        renewalForm.GetField("BusinessPhoneNumber")
            .SetValue(licenseInformation?.BusinessPhoneNumber?.FormatAsTelephoneNumber() ?? "");
        renewalForm.GetField("TradeName").SetValue(licenseInformation?.TradeName);

        renewalForm.GetField("LicensePeriodStart")
            .SetValue($"{nextLicenseYearStartDate:d}");
        renewalForm.GetField("LicensePeriodEnd")
            .SetValue($"{nextLicenseYearEndDate:d}");

        renewalForm.GetField("Fee").SetValue(feeInformation.LicenseFeeAmount.ToString("F2"));

        if (licenseInformation.IsEngagedInCleaningWasteHaulerQuestion()) {
            renewalForm.GetField("ScepticTankCleaningBusiness").SetValue("X");
        }

        if (licenseInformation.IsNotEngagedInCleaningWasteHaulerQuestion()) {
            renewalForm.GetField("OnlyTransportsAndDisposes").SetValue("X");
        }


        renewalForm.FlattenFields();

        renewalFormPdfDocument.Close();

        return new[] {new LicenseRenewalDocument("Waste Hauler Facility", renewalFormPdfMemoryStream.ToArray())};
    }

}