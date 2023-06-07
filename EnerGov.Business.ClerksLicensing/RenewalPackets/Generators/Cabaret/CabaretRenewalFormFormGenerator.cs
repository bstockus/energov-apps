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
using EnerGov.Business.ClerksLicensing.RenewalPackets.Generators.PersonalDataSheet;
using iText.Forms;
using iText.Kernel.Pdf;
using Lax.Helpers.AssemblyResources;

namespace EnerGov.Business.ClerksLicensing.RenewalPackets.Generators.Cabaret;

public class CabaretRenewalFormFormGenerator : LicenseRenewalFormGenerator<CabaretLicenseFeeAmounts> {

    public static async Task<byte[]> GenerateOutdoorCabaretRenewalForms(
        int previousLicenseYear,
        CabaretLicenseFeeAmounts cabaretLicenseFeeAmounts,
        IEnumerable<EnerGovLicenseInformation> enerGovLicenseInformations,
        IDictionary<string, ParcelOwnerInformation> parcelOwners) {
        var nextLicenseYear = previousLicenseYear + 1;
        var nextLicenseYearStartDate = new DateTime(nextLicenseYear, 7, 1);
        var nextLicenseYearEndDate = new DateTime(nextLicenseYear + 1, 6, 30);

        var outdoorCabaretLicenseRenewalFormPdfData =
            await typeof(ClerksLicensingBusinessModule).Assembly.GetAssemblyResourceAsBytes(
                "OutdoorCabaretApplication.pdf");

        await using var outdoorCabaretLicenseRenewalFormPdfMemoryStream = new MemoryStream();
        var outdoorCabaretLicenseRenewalFormPdfDocument = new PdfDocument(
            new PdfReader(new MemoryStream(outdoorCabaretLicenseRenewalFormPdfData)),
            new PdfWriter(outdoorCabaretLicenseRenewalFormPdfMemoryStream));

        var outdoorCabaretLicenseRenewalForm =
            PdfAcroForm.GetAcroForm(outdoorCabaretLicenseRenewalFormPdfDocument, true);

        outdoorCabaretLicenseRenewalForm.GetField("IsRenewal").SetValue("X");
        outdoorCabaretLicenseRenewalForm.GetField("IsFromLastYear").SetValue("X");

        var licenseInformation = enerGovLicenseInformations.FirstOrDefault();

        outdoorCabaretLicenseRenewalForm.GetField("LicensePeriodStart")
            .SetValue($"{nextLicenseYearStartDate:d}");
        outdoorCabaretLicenseRenewalForm.GetField("LicensePeriodEnd")
            .SetValue($"{nextLicenseYearEndDate:d}");
        outdoorCabaretLicenseRenewalForm.GetField("Fee")
            .SetValue(cabaretLicenseFeeAmounts.OutdoorCabaretAmount.ToString("F2"));

        if (!string.IsNullOrEmpty(licenseInformation?.ParcelNumber) &&
            parcelOwners.ContainsKey(licenseInformation.ParcelNumber)) {
            var parcelOwner = parcelOwners[licenseInformation.ParcelNumber];

            outdoorCabaretLicenseRenewalForm.GetField("ParcelOwner").SetValue(parcelOwner.OwnerName?.Trim() ?? "");
            outdoorCabaretLicenseRenewalForm.GetField("OwnerAddress")
                .SetValue(parcelOwner.CompleteAddress?.Trim() ?? "");
            outdoorCabaretLicenseRenewalForm.GetField("OwnerCity").SetValue(
                parcelOwner.City?.FormatAsCityName() ?? "");
            outdoorCabaretLicenseRenewalForm.GetField("OwnerState")
                .SetValue(parcelOwner.State?.Trim() ?? "");
            outdoorCabaretLicenseRenewalForm.GetField("OwnerZipCode")
                .SetValue(parcelOwner.ZipCode?.FormatAsZipCode() ?? "");
        }

        outdoorCabaretLicenseRenewalForm.GetField("LegalName").SetValue(licenseInformation?.FullLegalName ?? "");
        outdoorCabaretLicenseRenewalForm.GetField("BusinessAddress_Street")
            .SetValue(licenseInformation?.CompanyMailingAddress_StreetAddress ?? "");
        outdoorCabaretLicenseRenewalForm.GetField("BusinessAddress_City")
            .SetValue(licenseInformation?.CompanyMailingAddress_City?.FormatAsCityName() ?? "");
        outdoorCabaretLicenseRenewalForm.GetField("BusinessAddress_State")
            .SetValue(licenseInformation?.CompanyMailingAddress_State ?? "");
        outdoorCabaretLicenseRenewalForm.GetField("BusinessAddress_ZipCode")
            .SetValue(licenseInformation?.CompanyMailingAddress_PostalCode ?? "");
        outdoorCabaretLicenseRenewalForm.GetField("TradeName").SetValue(licenseInformation?.TradeName ?? "");
        outdoorCabaretLicenseRenewalForm.GetField("PremiseAddress")
            .SetValue(licenseInformation?.LocationAddress_StreetAddress?.FormatAsAddress() ?? "");
        outdoorCabaretLicenseRenewalForm.GetField("BusinessPhoneNumber")
            .SetValue(licenseInformation?.BusinessPhoneNumber?.FormatAsTelephoneNumber() ?? "");


        outdoorCabaretLicenseRenewalForm.GetField("CabaretDescription")
            .SetValue(licenseInformation?.OutdoorCabaretDescription ?? "");
        outdoorCabaretLicenseRenewalForm.GetField("NatureOfEntertainment")
            .SetValue(licenseInformation?.OutdoorCabaretNatureOfEntertainment ?? "");
        outdoorCabaretLicenseRenewalForm.GetField("OtherBusiness")
            .SetValue(licenseInformation?.OtherBusinessConductedOnPremise ?? "");

        outdoorCabaretLicenseRenewalForm.GetField("Agent_FirstName")
            .SetValue(licenseInformation?.ManagerName_First ?? "");
        outdoorCabaretLicenseRenewalForm.GetField("Agent_MiddleName")
            .SetValue(licenseInformation?.ManagerName_Middle ?? "");
        outdoorCabaretLicenseRenewalForm.GetField("Agent_LastName")
            .SetValue(licenseInformation?.ManagerName_Last ?? "");

        outdoorCabaretLicenseRenewalForm.GetField("AgentAddress_Street")
            .SetValue(licenseInformation?.ManagerCompleteAddress_StreetAddress ?? "");
        outdoorCabaretLicenseRenewalForm.GetField("AgentAddress_City")
            .SetValue(licenseInformation?.ManagerCompleteAddress_City?.FormatAsCityName() ?? "");
        outdoorCabaretLicenseRenewalForm.GetField("AgentAddress_State")
            .SetValue(licenseInformation?.ManagerCompleteAddress_State ?? "");
        outdoorCabaretLicenseRenewalForm.GetField("AgentAddress_ZipCode")
            .SetValue(licenseInformation?.ManagerCompleteAddress_PostalCode?.FormatAsZipCode() ?? "");

        outdoorCabaretLicenseRenewalForm.GetField("CabaretManager_HomePhoneNumber")
            .SetValue(licenseInformation?.ManagerHomePhone?.FormatAsTelephoneNumber() ?? "");
        outdoorCabaretLicenseRenewalForm.GetField("CabaretManager_DaytimePhoneNumber")
            .SetValue(licenseInformation?.ManagerBusinessPhone?.FormatAsTelephoneNumber() ?? "");


        outdoorCabaretLicenseRenewalForm.FlattenFields();

        var personalDataPeople = enerGovLicenseInformations.GroupBy(_ => new {
                _.ContactFirstName,
                _.ContactMiddleName,
                _.ContactLastName
            }).Where(_ => _.All(x => !x.ContactType.Equals(EnerGovBusinessContactTypeConstants.Agent)))
            .Select(_ => new ClerkPersonalDataSheetPerson(_.First()));


        //await AppendPersonalDataSheetForm(
        //    outdoorCabaretLicenseRenewalFormPdfDocument,
        //    personalDataPeople);

        outdoorCabaretLicenseRenewalFormPdfDocument.Close();

        return outdoorCabaretLicenseRenewalFormPdfMemoryStream.ToArray();
    }

    public static async Task<byte[]> GenerateIndoorCabaretRenewalForms(
        int previousLicenseYear,
        CabaretLicenseFeeAmounts cabaretLicenseFeeAmounts,
        IEnumerable<EnerGovLicenseInformation> enerGovLicenseInformations,
        IDictionary<string, ParcelOwnerInformation> parcelOwners) {
        var nextLicenseYear = previousLicenseYear + 1;
        var nextLicenseYearStartDate = new DateTime(nextLicenseYear, 7, 1);
        var nextLicenseYearEndDate = new DateTime(nextLicenseYear + 1, 6, 30);

        var indoorCabaretLicenseRenewalFormPdfData =
            await typeof(ClerksLicensingBusinessModule).Assembly.GetAssemblyResourceAsBytes(
                "IndoorCabaretApplication.pdf");

        await using var indoorCabaretLicenseRenewalFormPdfMemoryStream = new MemoryStream();
        var indoorCabaretLicenseRenewalFormPdfDocument = new PdfDocument(
            new PdfReader(new MemoryStream(indoorCabaretLicenseRenewalFormPdfData)),
            new PdfWriter(indoorCabaretLicenseRenewalFormPdfMemoryStream));

        var indoorCabaretLicenseRenewalForm =
            PdfAcroForm.GetAcroForm(indoorCabaretLicenseRenewalFormPdfDocument, true);

        indoorCabaretLicenseRenewalForm.GetField("IsRenewal").SetValue("X");
        indoorCabaretLicenseRenewalForm.GetField("IsFromLastYear").SetValue("X");

        var licenseInformation = enerGovLicenseInformations.FirstOrDefault();

        indoorCabaretLicenseRenewalForm.GetField("LicensePeriodStart")
            .SetValue($"{nextLicenseYearStartDate:d}");
        indoorCabaretLicenseRenewalForm.GetField("LicensePeriodEnd")
            .SetValue($"{nextLicenseYearEndDate:d}");
        indoorCabaretLicenseRenewalForm.GetField("Fee")
            .SetValue(cabaretLicenseFeeAmounts.IndoorCabaretAmount.ToString("F2"));

        if (!string.IsNullOrEmpty(licenseInformation?.ParcelNumber) &&
            parcelOwners.ContainsKey(licenseInformation.ParcelNumber)) {
            var parcelOwner = parcelOwners[licenseInformation.ParcelNumber];

            indoorCabaretLicenseRenewalForm.GetField("ParcelOwner").SetValue(parcelOwner.OwnerName?.Trim() ?? "");
            indoorCabaretLicenseRenewalForm.GetField("OwnerAddress")
                .SetValue(parcelOwner.CompleteAddress?.Trim() ?? "");
            indoorCabaretLicenseRenewalForm.GetField("OwnerCity").SetValue(
                parcelOwner.City?.FormatAsCityName() ?? "");
            indoorCabaretLicenseRenewalForm.GetField("OwnerState")
                .SetValue(parcelOwner.State?.Trim() ?? "");
            indoorCabaretLicenseRenewalForm.GetField("OwnerZipCode")
                .SetValue(parcelOwner.ZipCode?.FormatAsZipCode() ?? "");
        }

        indoorCabaretLicenseRenewalForm.GetField("LegalName").SetValue(licenseInformation?.FullLegalName ?? "");
        indoorCabaretLicenseRenewalForm.GetField("BusinessAddress_Street")
            .SetValue(licenseInformation?.CompanyMailingAddress_StreetAddress ?? "");
        indoorCabaretLicenseRenewalForm.GetField("BusinessAddress_City")
            .SetValue(licenseInformation?.CompanyMailingAddress_City?.FormatAsCityName() ?? "");
        indoorCabaretLicenseRenewalForm.GetField("BusinessAddress_State")
            .SetValue(licenseInformation?.CompanyMailingAddress_State ?? "");
        indoorCabaretLicenseRenewalForm.GetField("BusinessAddress_ZipCode")
            .SetValue(licenseInformation?.CompanyMailingAddress_PostalCode ?? "");
        indoorCabaretLicenseRenewalForm.GetField("TradeName").SetValue(licenseInformation?.TradeName ?? "");
        indoorCabaretLicenseRenewalForm.GetField("PremiseAddress")
            .SetValue(licenseInformation?.LocationAddress_StreetAddress?.FormatAsAddress() ?? "");
        indoorCabaretLicenseRenewalForm.GetField("BusinessPhoneNumber")
            .SetValue(licenseInformation?.BusinessPhoneNumber?.FormatAsTelephoneNumber() ?? "");


        indoorCabaretLicenseRenewalForm.GetField("CabaretDescription")
            .SetValue(licenseInformation?.IndoorCabaretDescription ?? "");
        indoorCabaretLicenseRenewalForm.GetField("NatureOfEntertainment")
            .SetValue(licenseInformation?.IndoorCabaretNatureOfEntertainment ?? "");
        indoorCabaretLicenseRenewalForm.GetField("OtherBusiness")
            .SetValue(licenseInformation?.OtherBusinessConductedOnPremise ?? "");

        indoorCabaretLicenseRenewalForm.GetField("Agent_FirstName")
            .SetValue(licenseInformation?.ManagerName_First ?? "");
        indoorCabaretLicenseRenewalForm.GetField("Agent_MiddleName")
            .SetValue(licenseInformation?.ManagerName_Middle ?? "");
        indoorCabaretLicenseRenewalForm.GetField("Agent_LastName")
            .SetValue(licenseInformation?.ManagerName_Last ?? "");

        indoorCabaretLicenseRenewalForm.GetField("AgentAddress_Street")
            .SetValue(licenseInformation?.ManagerCompleteAddress_StreetAddress ?? "");
        indoorCabaretLicenseRenewalForm.GetField("AgentAddress_City")
            .SetValue(licenseInformation?.ManagerCompleteAddress_City?.FormatAsCityName() ?? "");
        indoorCabaretLicenseRenewalForm.GetField("AgentAddress_State")
            .SetValue(licenseInformation?.ManagerCompleteAddress_State ?? "");
        indoorCabaretLicenseRenewalForm.GetField("AgentAddress_ZipCode")
            .SetValue(licenseInformation?.ManagerCompleteAddress_PostalCode?.FormatAsZipCode() ?? "");

        indoorCabaretLicenseRenewalForm.GetField("CabaretManager_HomePhoneNumber")
            .SetValue(licenseInformation?.ManagerHomePhone?.FormatAsTelephoneNumber() ?? "");
        indoorCabaretLicenseRenewalForm.GetField("CabaretManager_DaytimePhoneNumber")
            .SetValue(licenseInformation?.ManagerBusinessPhone?.FormatAsTelephoneNumber() ?? "");


        indoorCabaretLicenseRenewalForm.FlattenFields();

        var personalDataPeople = enerGovLicenseInformations.GroupBy(_ => new {
                _.ContactFirstName,
                _.ContactMiddleName,
                _.ContactLastName
            }).Where(_ => _.All(x => !x.ContactType.Equals(EnerGovBusinessContactTypeConstants.Agent)))
            .Select(_ => new ClerkPersonalDataSheetPerson(_.First()));


        //await AppendPersonalDataSheetForm(
        //    indoorCabaretLicenseRenewalFormPdfDocument,
        //    personalDataPeople);

        indoorCabaretLicenseRenewalFormPdfDocument.Close();

        return indoorCabaretLicenseRenewalFormPdfMemoryStream.ToArray();
    }

    public override string LicenseTypeName => "Cabaret";
    public override string[] LicenseTypeIds => new[] {EnerGovLicenseTypeConstants.Cabaret};

    public override string[] LicenseClassIds => new[] {
        EnerGovLicenseClassConstants.IndoorCabaret,
        EnerGovLicenseClassConstants.OutdoorCabaret
    };

    public override int SortOrder => 100;

    public override bool ReleventLicense(EnerGovLicenseInformation enerGovLicenseInformation) =>
        enerGovLicenseInformation.IsCabaretLicenseType();

    public override CabaretLicenseFeeAmounts DefaultFees => new() {
        IndoorCabaretAmount = 135.00m,
        OutdoorCabaretAmount = 160.00m
    };

    public override async Task<object> CurrentFeesForLicense(
        DbConnection sqlConnection,
        string licenseYear,
        CancellationToken cancellationToken) =>
        await sqlConnection.QueryFirstOrDefaultAsync<CabaretLicenseFeeAmounts>(
            await typeof(ClerksLicensingBusinessModule).Assembly.GetAssemblyResource(
                "CabaretLicenseFeeInformation.sql"),
            new {
                LicenseYear = licenseYear
            });

    public override async Task<IEnumerable<LicenseRenewalFee>> RenewalFees(RenewalRequest renewalRequest,
        CabaretLicenseFeeAmounts feeInformation,
        IEnumerable<EnerGovLicenseInformation> enerGovLicenseInformations) {
        var fees = new List<LicenseRenewalFee>();

        if (enerGovLicenseInformations.FirstOrDefault().IsIndoorCabaretLicenseClass()) {
            fees.Add(new LicenseRenewalFee("Indoor Cabaret", feeInformation.IndoorCabaretAmount));
        }

        if (enerGovLicenseInformations.FirstOrDefault().IsOutdoorCabaretLicenseClass()) {
            fees.Add(new LicenseRenewalFee("Outdoor Cabaret", feeInformation.OutdoorCabaretAmount));
        }

        return await Task.FromResult(fees);
    }

    public override async Task<IEnumerable<LicenseRenewalDocument>> RenewalDocuments(RenewalRequest renewalRequest,
        CabaretLicenseFeeAmounts feeInformation,
        IEnumerable<EnerGovLicenseInformation> enerGovLicenseInformations,
        IDictionary<string, ParcelOwnerInformation> parcelOwners) {
        if (enerGovLicenseInformations.FirstOrDefault().IsIndoorCabaretLicenseClass()) {
            return new[] {
                new LicenseRenewalDocument("Indoor Cabaret",
                    await GenerateIndoorCabaretRenewalForms(
                        renewalRequest.PreviousLicenseYear,
                        feeInformation,
                        enerGovLicenseInformations,
                        parcelOwners))
            };
        }

        if (enerGovLicenseInformations.FirstOrDefault().IsOutdoorCabaretLicenseClass()) {
            return new[] {
                new LicenseRenewalDocument("Outdoor Cabaret",
                    await GenerateOutdoorCabaretRenewalForms(
                        renewalRequest.PreviousLicenseYear,
                        feeInformation,
                        enerGovLicenseInformations,
                        parcelOwners))
            };
        }

        return Array.Empty<LicenseRenewalDocument>();
    }

}