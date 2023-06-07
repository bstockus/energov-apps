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

namespace EnerGov.Business.ClerksLicensing.RenewalPackets.Generators.Secondhand;

public class SecondhandLicenseRenewalFormGenerator : LicenseRenewalFormGenerator<SecondhandLicenseFeeAmounts> {

    public override string LicenseTypeName => "Secondhand";

    public override string[] LicenseTypeIds => new[] {
        EnerGovLicenseTypeConstants.Secondhand,
        EnerGovLicenseTypeConstants.Pawnbroker,
        EnerGovLicenseTypeConstants.MallFleaMarket
    };

    public override string[] LicenseClassIds => new[] {
        EnerGovLicenseClassConstants.Secondhand,
        EnerGovLicenseClassConstants.Pawnbroker,
        EnerGovLicenseClassConstants.MallFleaMarket
    };

    public override int SortOrder => 100;

    public override bool ReleventLicense(EnerGovLicenseInformation enerGovLicenseInformation) =>
        enerGovLicenseInformation.IsSecondhandLicenseType() ||
        enerGovLicenseInformation.IsPawnbrokerLicenseType() ||
        enerGovLicenseInformation.IsMallFleaMarketLicenseType();

    public override SecondhandLicenseFeeAmounts DefaultFees => new() {
        SecondhandArticleDealerFeeAmount = 125.00m,
        SecondhandJewelryFeeAmount = 125.00m,
        MallFleaMarketFeeAmount = 250.00m,
        PawnbrokerFeeAmount = 250.00m
    };

    public override async Task<object> CurrentFeesForLicense(
        DbConnection sqlConnection,
        string licenseYear,
        CancellationToken cancellationToken) =>
        await sqlConnection.QueryFirstOrDefaultAsync<SecondhandLicenseFeeAmounts>(
            await typeof(ClerksLicensingBusinessModule).Assembly.GetAssemblyResource(
                "SecondhandLicenseFeeInformation.sql"),
            new {
                LicenseYear = licenseYear
            });

    public override async Task<IEnumerable<LicenseRenewalFee>> RenewalFees(
        RenewalRequest renewalRequest,
        SecondhandLicenseFeeAmounts feeInformation,
        IEnumerable<EnerGovLicenseInformation> enerGovLicenseInformations) {
        var fees = new List<LicenseRenewalFee>();

        if (enerGovLicenseInformations.FirstOrDefault().IsSecondhandLicenseType()) {
            if (enerGovLicenseInformations.FirstOrDefault().IsSecondhandArticleLicenseSubClass()) {
                fees.Add(new LicenseRenewalFee("Secondhand Article Dealer",
                    feeInformation.SecondhandArticleDealerFeeAmount));
            }

            if (enerGovLicenseInformations.FirstOrDefault().IsSecondhandJewelryLicenseSubClass()) {
                fees.Add(new LicenseRenewalFee("Secondhand Jewelry, Precious Metals and Gems",
                    feeInformation.SecondhandJewelryFeeAmount));
            }
        }

        if (enerGovLicenseInformations.FirstOrDefault().IsPawnbrokerLicenseType()) {
            fees.Add(new LicenseRenewalFee("Pawnbroker", feeInformation.PawnbrokerFeeAmount));
        }

        if (enerGovLicenseInformations.FirstOrDefault().IsMallFleaMarketLicenseType()) {
            fees.Add(
                new LicenseRenewalFee("Secondhand Dealer Mall/Flea Market", feeInformation.MallFleaMarketFeeAmount));
        }

        return await Task.FromResult(fees);
    }

    public override async Task<IEnumerable<LicenseRenewalDocument>> RenewalDocuments(
        RenewalRequest renewalRequest,
        SecondhandLicenseFeeAmounts feeInformation,
        IEnumerable<EnerGovLicenseInformation> enerGovLicenseInformations,
        IDictionary<string, ParcelOwnerInformation> parcelOwners) {
        var nextLicenseYear = renewalRequest.PreviousLicenseYear + 1;
        var nextLicenseYearStartDate = new DateTime(nextLicenseYear, 7, 1);
        var nextLicenseYearEndDate = new DateTime(nextLicenseYear + 1, 6, 30);

        var renewalFormPdfData =
            await typeof(ClerksLicensingBusinessModule).Assembly.GetAssemblyResourceAsBytes(
                "PawnbrokerAndSecondhandLicenseForm.pdf");

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

        renewalForm.GetField("LicensePeriodStart")
            .SetValue($"{nextLicenseYearStartDate:d}");
        renewalForm.GetField("LicensePeriodEnd")
            .SetValue($"{nextLicenseYearEndDate:d}");

        renewalForm.GetField("WisconsinSellerPermitNumber")
            .SetValue(licenseInformation?.WisconsinSellersPermitNumber ?? "");


        renewalForm.GetField("PremiseAddress")
            .SetValue(licenseInformation?.LocationAddress_StreetAddress?.FormatAsAddress() ?? "");

        if (!string.IsNullOrEmpty(licenseInformation?.ParcelNumber) &&
            parcelOwners.ContainsKey(licenseInformation.ParcelNumber)) {
            var parcelOwner = parcelOwners[licenseInformation.ParcelNumber];

            renewalForm.GetField("ParcelOwner").SetValue(parcelOwner.OwnerName?.Trim() ?? "");
            renewalForm.GetField("OwnerAddress")
                .SetValue(parcelOwner.CompleteAddress?.Trim() ?? "");
            renewalForm.GetField("OwnerCity").SetValue(
                parcelOwner.City?.FormatAsCityName() ?? "");
            renewalForm.GetField("OwnerState")
                .SetValue(parcelOwner.State?.Trim() ?? "");
            renewalForm.GetField("OwnerZipCode")
                .SetValue(parcelOwner.ZipCode?.FormatAsZipCode() ?? "");
        }

        var totalFee = 0.00m;

        if (enerGovLicenseInformations.FirstOrDefault().IsSecondhandLicenseType()) {
            if (enerGovLicenseInformations.FirstOrDefault().IsSecondhandArticleLicenseSubClass()) {
                totalFee += feeInformation.SecondhandArticleDealerFeeAmount;
                renewalForm.GetField("SeconhandArticle").SetValue("X");
            }

            if (enerGovLicenseInformations.FirstOrDefault().IsSecondhandJewelryLicenseSubClass()) {
                totalFee += feeInformation.SecondhandJewelryFeeAmount;
                renewalForm.GetField("SecondhandJewelry").SetValue("X");
            }
        }

        if (enerGovLicenseInformations.FirstOrDefault().IsPawnbrokerLicenseType()) {
            totalFee += feeInformation.PawnbrokerFeeAmount;
            renewalForm.GetField("Pawnbroker").SetValue("X");
        }

        if (enerGovLicenseInformations.FirstOrDefault().IsMallFleaMarketLicenseType()) {
            totalFee += feeInformation.MallFleaMarketFeeAmount;
            renewalForm.GetField("MallFleaMarket").SetValue("X");
        }

        renewalForm.GetField("Fee").SetValue(totalFee.ToString("F2"));

        renewalForm.FlattenFields();

        renewalFormPdfDocument.Close();

        return new[] {
            new LicenseRenewalDocument("Pawnbroker, Secondhand or Mall/Flea Market License",
                renewalFormPdfMemoryStream.ToArray())
        };
    }

}