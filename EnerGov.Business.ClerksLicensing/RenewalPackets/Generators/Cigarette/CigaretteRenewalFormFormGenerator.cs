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

namespace EnerGov.Business.ClerksLicensing.RenewalPackets.Generators.Cigarette;

public class CigaretteRenewalFormFormGenerator : LicenseRenewalFormGenerator<CigaretteLicenseFeeAmounts> {

    public override string LicenseTypeName => "Cigarette";
    public override string[] LicenseTypeIds => new[] {EnerGovLicenseTypeConstants.Cigarette};

    public override string[] LicenseClassIds => new[] {
        EnerGovLicenseClassConstants.Both,
        EnerGovLicenseClassConstants.OverTheCounter,
        EnerGovLicenseClassConstants.VendingMachine
    };

    public override int SortOrder => 100;

    public override bool ReleventLicense(EnerGovLicenseInformation enerGovLicenseInformation) =>
        enerGovLicenseInformation.IsCigaretteLicenseType();

    public override CigaretteLicenseFeeAmounts DefaultFees => new() {
        Amount = 100.00m
    };

    public override async Task<object> CurrentFeesForLicense(
        DbConnection sqlConnection,
        string licenseYear,
        CancellationToken cancellationToken) =>
        await sqlConnection.QueryFirstOrDefaultAsync<CigaretteLicenseFeeAmounts>(
            await typeof(ClerksLicensingBusinessModule).Assembly.GetAssemblyResource(
                "CigaretteLicenseFeeInformation.sql"),
            new {
                LicenseYear = licenseYear
            });

    public override async Task<IEnumerable<LicenseRenewalFee>> RenewalFees(RenewalRequest renewalRequest,
        CigaretteLicenseFeeAmounts feeInformation,
        IEnumerable<EnerGovLicenseInformation> enerGovLicenseInformations) =>
        await Task.FromResult(new[] {new LicenseRenewalFee("Cigarette & Tobacco", feeInformation.Amount)});

    public override async Task<IEnumerable<LicenseRenewalDocument>> RenewalDocuments(RenewalRequest renewalRequest,
        CigaretteLicenseFeeAmounts feeInformation,
        IEnumerable<EnerGovLicenseInformation> enerGovLicenseInformations,
        IDictionary<string, ParcelOwnerInformation> parcelOwners) {
        var nextLicenseYear = renewalRequest.PreviousLicenseYear + 1;
        var nextLicenseYearStartDate = new DateTime(nextLicenseYear, 7, 1);
        var nextLicenseYearEndDate = new DateTime(nextLicenseYear + 1, 6, 30);

        var cigaretteLicenseRenewalFormPdfData =
            await typeof(ClerksLicensingBusinessModule).Assembly.GetAssemblyResourceAsBytes(
                "CigaretteLicenseForm.pdf");

        await using var cigaretteLicenseRenewalFormPdfMemoryStream = new MemoryStream();
        var cigaretteLicenseRenewalFormPdfDocument = new PdfDocument(
            new PdfReader(new MemoryStream(cigaretteLicenseRenewalFormPdfData)),
            new PdfWriter(cigaretteLicenseRenewalFormPdfMemoryStream));

        var cigaretteLicenseRenewalForm =
            PdfAcroForm.GetAcroForm(cigaretteLicenseRenewalFormPdfDocument, true);


        var licenseInformation = enerGovLicenseInformations.FirstOrDefault();


        cigaretteLicenseRenewalForm.GetField("accntno")
            .SetValue(licenseInformation.WisconsinSellersPermitNumber ?? "");

        cigaretteLicenseRenewalForm.GetField("fein").SetValue(licenseInformation.TaxNumber ?? "");

        cigaretteLicenseRenewalForm.GetField("legalname").SetValue(licenseInformation.FullLegalName ?? "");
        cigaretteLicenseRenewalForm.GetField("busname").SetValue(licenseInformation.TradeName ?? "");

        cigaretteLicenseRenewalForm.GetField("permloc")
            .SetValue(licenseInformation.LocationAddress_StreetAddress ?? "");
        cigaretteLicenseRenewalForm.GetField("City").SetValue(
            licenseInformation.LocationAddress_City?.FormatAsCityName() ?? "");
        cigaretteLicenseRenewalForm.GetField("state").SetValue(
            licenseInformation.LocationAddress_State ?? "");
        cigaretteLicenseRenewalForm.GetField("zip")
            .SetValue(licenseInformation.LocationAddress_PostalCode?.FormatAsZipCode() ?? "");
        cigaretteLicenseRenewalForm.GetField("phoneno").SetValue(licenseInformation.BusinessPhoneNumber ?? "");
        cigaretteLicenseRenewalForm.GetField("mailadd")
            .SetValue(licenseInformation.CompanyMailingAddress_StreetAddress ?? "");
        cigaretteLicenseRenewalForm.GetField("mailaddcity").SetValue(
            licenseInformation.CompanyMailingAddress_City?.FormatAsCityName() ?? "");
        cigaretteLicenseRenewalForm.GetField("mailaddstate")
            .SetValue(licenseInformation.CompanyMailingAddress_State ?? "");
        cigaretteLicenseRenewalForm.GetField("mailaddzip")
            .SetValue(licenseInformation.CompanyMailingAddress_PostalCode?.FormatAsZipCode() ?? "");

        cigaretteLicenseRenewalForm.GetField("periodcov").SetValue(
            $"{nextLicenseYearStartDate.ToShortDateString()} to {nextLicenseYearEndDate.ToShortDateString()}");

        if (licenseInformation.IsOverTheCounterLicenseClass()) {
            cigaretteLicenseRenewalForm.GetField("type_otc").SetValue("X");
        } else if (licenseInformation.IsVendingMachineLicenseClass()) {
            cigaretteLicenseRenewalForm.GetField("type_vend").SetValue("X");
        } else if (licenseInformation.IsBothCigaretteLicenseClass()) {
            cigaretteLicenseRenewalForm.GetField("type_both").SetValue("X");
        }

        cigaretteLicenseRenewalForm.FlattenFields();

        cigaretteLicenseRenewalFormPdfDocument.Close();

        return new[]
            {new LicenseRenewalDocument("Cigarette", cigaretteLicenseRenewalFormPdfMemoryStream.ToArray())};
    }

}