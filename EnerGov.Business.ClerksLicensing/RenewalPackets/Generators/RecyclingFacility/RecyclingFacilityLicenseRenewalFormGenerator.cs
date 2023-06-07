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

namespace EnerGov.Business.ClerksLicensing.RenewalPackets.Generators.RecyclingFacility;

public class
    RecyclingFacilityLicenseRenewalFormGenerator : LicenseRenewalFormGenerator<RecyclingFacilityLicenseFeeAmounts> {

    public override string LicenseTypeName => "Recycling Facility";

    public override string[] LicenseTypeIds =>
        new[] {EnerGovLicenseTypeConstants.RecyclingFacility};

    public override string[] LicenseClassIds =>
        new[] {EnerGovLicenseClassConstants.RecyclingFacility};

    public override int SortOrder => 100;

    public override bool ReleventLicense(EnerGovLicenseInformation enerGovLicenseInformation) =>
        enerGovLicenseInformation.IsRecyclingFacilityLicenseType();

    public override RecyclingFacilityLicenseFeeAmounts DefaultFees => new() {
        PickUpStationFeeAmount = 110.00m,
        ProcessingFacilityFeeAmount = 110.00m,
        RecyclingCenterFeeAmount = 110.00m,
        ReverseVendingMachineFeeAmount = 110.00m
    };

    public override async Task<object> CurrentFeesForLicense(
        DbConnection sqlConnection,
        string licenseYear,
        CancellationToken cancellationToken) =>
        await sqlConnection.QueryFirstOrDefaultAsync<RecyclingFacilityLicenseFeeAmounts>(
            await typeof(ClerksLicensingBusinessModule).Assembly.GetAssemblyResource(
                "RecyclingFacilityLicenseFeeInformation.sql"),
            new {
                LicenseYear = licenseYear
            });

    public override async Task<IEnumerable<LicenseRenewalFee>> RenewalFees(
        RenewalRequest renewalRequest,
        RecyclingFacilityLicenseFeeAmounts feeInformation,
        IEnumerable<EnerGovLicenseInformation> enerGovLicenseInformations) {
        var fees = new List<LicenseRenewalFee>();

        if (enerGovLicenseInformations.FirstOrDefault().IsProcessingFacilityLicenseSubType()) {
            fees.Add(new LicenseRenewalFee("Recycling Processing Facility",
                feeInformation.ProcessingFacilityFeeAmount));
        }

        if (enerGovLicenseInformations.FirstOrDefault().IsRecyclingCenterLicenseSubType()) {
            fees.Add(new LicenseRenewalFee("Recycling Center",
                feeInformation.RecyclingCenterFeeAmount));
        }

        if (enerGovLicenseInformations.FirstOrDefault().IsPickUpStationLicenseSubType()) {
            fees.Add(new LicenseRenewalFee("Pick-Up Station",
                feeInformation.PickUpStationFeeAmount));
        }

        if (enerGovLicenseInformations.FirstOrDefault().IsReverseVendingMachineLicenseSubType()) {
            fees.Add(new LicenseRenewalFee("Reverse Vending Machine",
                feeInformation.ReverseVendingMachineFeeAmount));
        }

        return await Task.FromResult(fees);
    }

    public override async Task<IEnumerable<LicenseRenewalDocument>> RenewalDocuments(
        RenewalRequest renewalRequest,
        RecyclingFacilityLicenseFeeAmounts feeInformation,
        IEnumerable<EnerGovLicenseInformation> enerGovLicenseInformations,
        IDictionary<string, ParcelOwnerInformation> parcelOwners) {
        var nextLicenseYear = renewalRequest.PreviousLicenseYear + 1;
        var nextLicenseYearStartDate = new DateTime(nextLicenseYear, 7, 1);
        var nextLicenseYearEndDate = new DateTime(nextLicenseYear + 1, 6, 30);

        var renewalFormPdfData =
            await typeof(ClerksLicensingBusinessModule).Assembly.GetAssemblyResourceAsBytes(
                "RecyclingLicenseForm.pdf");

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
        renewalForm.GetField("PremiseAddress")
            .SetValue(licenseInformation?.LocationAddress_StreetAddress?.FormatAsAddress() ?? "");

        renewalForm.GetField("LicensePeriodStart")
            .SetValue($"{nextLicenseYearStartDate:d}");
        renewalForm.GetField("LicensePeriodEnd")
            .SetValue($"{nextLicenseYearEndDate:d}");

        var totalFee = 0.00m;

        if (enerGovLicenseInformations.FirstOrDefault().IsProcessingFacilityLicenseSubType()) {
            totalFee += feeInformation.ProcessingFacilityFeeAmount;
            renewalForm.GetField("ProcessingFacility").SetValue("X");
        }

        if (enerGovLicenseInformations.FirstOrDefault().IsRecyclingCenterLicenseSubType()) {
            totalFee += feeInformation.RecyclingCenterFeeAmount;
            renewalForm.GetField("RecyclingCenter").SetValue("X");
        }

        if (enerGovLicenseInformations.FirstOrDefault().IsPickUpStationLicenseSubType()) {
            totalFee += feeInformation.PickUpStationFeeAmount;
            renewalForm.GetField("PickUpStation").SetValue("X");
        }

        if (enerGovLicenseInformations.FirstOrDefault().IsReverseVendingMachineLicenseSubType()) {
            totalFee += feeInformation.ReverseVendingMachineFeeAmount;
            renewalForm.GetField("ReverseVendingMachine").SetValue("X");
        }

        renewalForm.GetField("Fee").SetValue(totalFee.ToString("F2"));

        renewalForm.GetField("DetailedNatureOfBusiness")
            .SetValue(licenseInformation.DetailedNatureOfBusiness ?? "");
        renewalForm.GetField("KindsOfMaterials")
            .SetValue(licenseInformation.KindOfMaterialToBeHandled ?? "");

        renewalForm.FlattenFields();

        renewalFormPdfDocument.Close();

        return new[] {new LicenseRenewalDocument("Recycling Facility", renewalFormPdfMemoryStream.ToArray())};
    }

}