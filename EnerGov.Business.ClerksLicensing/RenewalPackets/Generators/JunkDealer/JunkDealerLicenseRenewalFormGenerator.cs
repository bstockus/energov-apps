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

namespace EnerGov.Business.ClerksLicensing.RenewalPackets.Generators.JunkDealer;

public static class EnerGovJunkDealerLicenseSubTypeConstants {

    public static readonly string JunkDealer = "b478e4f7-36d6-4b1d-97d8-64a27c7c39a3";
    public static readonly string ItinerantJunkDealer = "d56a3792-101f-4af9-9a92-5db19be5acbe";

}

public class JunkDealerLicenseRenewalFormGenerator : LicenseRenewalFormGenerator<JunkDealerLicenseFeeAmounts> {

    public override string LicenseTypeName => "Junk Dealer";
    public override string[] LicenseTypeIds => new[] {EnerGovLicenseTypeConstants.JunkDealer};
    public override string[] LicenseClassIds => new[] {EnerGovLicenseClassConstants.JunkDealer};
    public override int SortOrder => 100;

    public override bool ReleventLicense(EnerGovLicenseInformation enerGovLicenseInformation) =>
        enerGovLicenseInformation.IsJunkDealerLicenseType();

    public override JunkDealerLicenseFeeAmounts DefaultFees => new() {
        JunkDealerFeeAmount = 160.00m,
        ItinerantJunkDealerFeeAmount = 110.00m
    };

    public override async Task<object> CurrentFeesForLicense(
        DbConnection sqlConnection,
        string licenseYear,
        CancellationToken cancellationToken) =>
        await sqlConnection.QueryFirstOrDefaultAsync<JunkDealerLicenseFeeAmounts>(
            await typeof(ClerksLicensingBusinessModule).Assembly.GetAssemblyResource(
                "JunkDealerLicenseFeeInformation.sql"),
            new {
                LicenseYear = licenseYear
            });

    public override async Task<IEnumerable<LicenseRenewalFee>> RenewalFees(RenewalRequest renewalRequest,
        JunkDealerLicenseFeeAmounts feeInformation,
        IEnumerable<EnerGovLicenseInformation> enerGovLicenseInformations) {
        var fees = new List<LicenseRenewalFee>();

        if (enerGovLicenseInformations.FirstOrDefault().IsJunkDealerLicenseSubType()) {
            fees.Add(new LicenseRenewalFee("Junk Dealer", feeInformation.JunkDealerFeeAmount));
        }

        if (enerGovLicenseInformations.FirstOrDefault().IsItinerantJunkDealerLicenseSubType()) {
            fees.Add(new LicenseRenewalFee("Itinerant Junk Dealer", feeInformation.ItinerantJunkDealerFeeAmount));
        }

        return await Task.FromResult(fees);
    }

    public override async Task<IEnumerable<LicenseRenewalDocument>> RenewalDocuments(RenewalRequest renewalRequest,
        JunkDealerLicenseFeeAmounts feeInformation,
        IEnumerable<EnerGovLicenseInformation> enerGovLicenseInformations,
        IDictionary<string, ParcelOwnerInformation> parcelOwners) {
        var nextLicenseYear = renewalRequest.PreviousLicenseYear + 1;
        var nextLicenseYearStartDate = new DateTime(nextLicenseYear, 7, 1);
        var nextLicenseYearEndDate = new DateTime(nextLicenseYear + 1, 6, 30);

        var renewalFormPdfData =
            await typeof(ClerksLicensingBusinessModule).Assembly.GetAssemblyResourceAsBytes(
                "JunkDealerLicenseForm.pdf");

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
        renewalForm.GetField("TradeName").SetValue(licenseInformation?.TradeName);
        renewalForm.GetField("BusinessPhoneNumber")
            .SetValue(licenseInformation?.BusinessPhoneNumber?.FormatAsTelephoneNumber() ?? "");
        renewalForm.GetField("PremiseAddress")
            .SetValue(licenseInformation?.LocationAddress_StreetAddress?.FormatAsAddress() ?? "");


        renewalForm.GetField("LicensePeriodStart")
            .SetValue($"{nextLicenseYearStartDate:d}");
        renewalForm.GetField("LicensePeriodEnd")
            .SetValue($"{nextLicenseYearEndDate:d}");

        if (licenseInformation.IsJunkDealerLicenseSubType()) {
            renewalForm.GetField("Fee").SetValue(feeInformation.JunkDealerFeeAmount.ToString("F2"));
            renewalForm.GetField("JunkDealer").SetValue("X");
        } else if (licenseInformation.IsItinerantJunkDealerLicenseSubType()) {
            renewalForm.GetField("Fee").SetValue(feeInformation.ItinerantJunkDealerFeeAmount.ToString("F2"));
            renewalForm.GetField("ItinerantJunkDealer").SetValue("X");
        }

        renewalForm.GetField("DetailedNatureOfBusiness")
            .SetValue(licenseInformation.DetailedNatureOfBusiness ?? "");
        renewalForm.GetField("KindsOfMaterials")
            .SetValue(licenseInformation.KindOfMaterialToBeHandled ?? "");

        renewalForm.FlattenFields();

        renewalFormPdfDocument.Close();

        return new[] {new LicenseRenewalDocument("Junk Dealer", renewalFormPdfMemoryStream.ToArray())};
    }

}