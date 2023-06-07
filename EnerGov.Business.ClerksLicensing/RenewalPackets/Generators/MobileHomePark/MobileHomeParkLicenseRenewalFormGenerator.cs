using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
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

namespace EnerGov.Business.ClerksLicensing.RenewalPackets.Generators.MobileHomePark;

public static class EnerGovLicenseInformationMobileHomeParkExtensions {

    public static bool IsMobileHomeParkLicenseType(this EnerGovLicenseInformation enerGovLicenseInformation) =>
        enerGovLicenseInformation.IsOfLicenseType(EnerGovLicenseTypeConstants.MobileHomePark);

}

public class MobileHomeParkLicenseFeeAmount {

    [Display(Name = "Fee Amount (per 50 units)")]
    public decimal LicenseFeeAmount { get; set; }

}

public class MobileHomeParkLicenseRenewalFormGenerator : LicenseRenewalFormGenerator<MobileHomeParkLicenseFeeAmount> {

    public override string LicenseTypeName => "Mobile Home Park";

    public override string[] LicenseTypeIds => new[] {
        EnerGovLicenseTypeConstants.MobileHomePark
    };

    public override string[] LicenseClassIds => new[] {
        EnerGovLicenseClassConstants.MobileHomePark
    };

    public override int SortOrder => 100;

    public override bool ReleventLicense(EnerGovLicenseInformation enerGovLicenseInformation) =>
        enerGovLicenseInformation.IsMobileHomeParkLicenseType();

    public override MobileHomeParkLicenseFeeAmount DefaultFees => new() {
        LicenseFeeAmount = 100.00m
    };

    public override async Task<object> CurrentFeesForLicense(
        DbConnection sqlConnection,
        string licenseYear,
        CancellationToken cancellationToken) =>
        await sqlConnection.QueryFirstOrDefaultAsync<MobileHomeParkLicenseFeeAmount>(
            await typeof(ClerksLicensingBusinessModule).Assembly.GetAssemblyResource(
                "MobileHomeParkLicenseFeeInformation.sql"),
            new {
                LicenseYear = licenseYear
            });

    public override async Task<IEnumerable<LicenseRenewalFee>> RenewalFees(
        RenewalRequest renewalRequest,
        MobileHomeParkLicenseFeeAmount feeInformation,
        IEnumerable<EnerGovLicenseInformation> enerGovLicenseInformations) =>
        await Task.FromResult(new List<LicenseRenewalFee> {
            new(
                "Mobile Home Park",
                (decimal) Math.Ceiling((enerGovLicenseInformations.First().NumberOfLots ?? 0) / 50.0d) *
                feeInformation.LicenseFeeAmount)
        });

    public override async Task<IEnumerable<LicenseRenewalDocument>> RenewalDocuments(
        RenewalRequest renewalRequest,
        MobileHomeParkLicenseFeeAmount feeInformation,
        IEnumerable<EnerGovLicenseInformation> enerGovLicenseInformations,
        IDictionary<string, ParcelOwnerInformation> parcelOwners) {
        var nextLicenseYear = renewalRequest.PreviousLicenseYear + 1;
        var nextLicenseYearStartDate = new DateTime(nextLicenseYear, 7, 1);
        var nextLicenseYearEndDate = new DateTime(nextLicenseYear + 1, 6, 30);

        var renewalFormPdfData =
            await typeof(ClerksLicensingBusinessModule).Assembly.GetAssemblyResourceAsBytes(
                "MobileHomeParkLicenseForm.pdf");

        await using var renewalFormPdfMemoryStream = new MemoryStream();
        var renewalFormPdfDocument = new PdfDocument(
            new PdfReader(new MemoryStream(renewalFormPdfData)),
            new PdfWriter(renewalFormPdfMemoryStream));

        var renewalForm = PdfAcroForm.GetAcroForm(renewalFormPdfDocument, true);

        var licenseInformation = enerGovLicenseInformations.FirstOrDefault();

        renewalForm.GetField("IsRenewal").SetValue("X");

        renewalForm.GetField("ApplicantName").SetValue(licenseInformation?.FullLegalName ?? "");
        renewalForm.GetField("ApplicantAddress")
            .SetValue(licenseInformation?.CompanyMailingAddress_CompleteAddressNoBreaks?.FormatAsAddress() ?? "");


        renewalForm.GetField("ParkName").SetValue(licenseInformation?.NameOfMobileHomePark ?? "");
        renewalForm.GetField("ParkAddress")
            .SetValue(licenseInformation?.LocationAddress_StreetAddress?.FormatAsAddress() ?? "");

        renewalForm.GetField("NumberOfLots").SetValue((licenseInformation?.NumberOfLots ?? 0).ToString());

        if (!string.IsNullOrEmpty(licenseInformation?.ParcelNumber) &&
            parcelOwners.ContainsKey(licenseInformation.ParcelNumber)) {
            var parcelOwner = parcelOwners[licenseInformation.ParcelNumber];

            renewalForm.GetField("OwnerName").SetValue(parcelOwner.OwnerName?.Trim() ?? "");
            renewalForm.GetField("OwnerAddress")
                .SetValue($"{parcelOwner.CompleteAddress?.Trim() ?? ""}, " +
                          $"{parcelOwner.City?.FormatAsCityName() ?? ""} {parcelOwner.State?.Trim() ?? ""} " +
                          $"{parcelOwner.ZipCode?.FormatAsZipCode() ?? ""}");
        }


        var totalFee = (decimal) Math.Ceiling((licenseInformation.NumberOfLots ?? 0) / 50.0d) *
                       feeInformation.LicenseFeeAmount;

        renewalForm.GetField("LicensePeriod")
            .SetValue($"{nextLicenseYearStartDate:d} to {nextLicenseYearEndDate:d}");

        renewalForm.GetField("Fee").SetValue(totalFee.ToString("F2"));

        renewalForm.FlattenFields();

        renewalFormPdfDocument.Close();

        return new[] {new LicenseRenewalDocument("Mobile Home Park License", renewalFormPdfMemoryStream.ToArray())};
    }

}