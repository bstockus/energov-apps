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
using EnerGov.Business.ClerksLicensing.RenewalPackets.Generators.Alcohol.Models;
using EnerGov.Business.ClerksLicensing.RenewalPackets.Generators.Models;
using iText.Forms;
using iText.Kernel.Pdf;
using Lax.Helpers.AssemblyResources;

namespace EnerGov.Business.ClerksLicensing.RenewalPackets.Generators.Alcohol;

public class AlcoholLicenseRenewalFormGenerator : LicenseRenewalFormGenerator<AlcoholLicenseFeeAmounts> {

    public override string LicenseTypeName => "Alcohol";
    public override string[] LicenseTypeIds => new[] {EnerGovLicenseTypeConstants.Alcohol};

    public override string[] LicenseClassIds => new[] {
        EnerGovLicenseClassConstants.ClassABeer,
        EnerGovLicenseClassConstants.ClassALiquor,
        EnerGovLicenseClassConstants.ClassBBeer,
        EnerGovLicenseClassConstants.ClassBWinery,
        EnerGovLicenseClassConstants.CombinationClassBBeerAndLiquor,
        EnerGovLicenseClassConstants.CombinationClassBBeerAndLiquorReserve
    };

    public override int SortOrder => 50;

    public override bool ReleventLicense(EnerGovLicenseInformation enerGovLicenseInformation) =>
        false;

    public override AlcoholLicenseFeeAmounts DefaultFees => new() {
        ClassABeerAmount = 100.00m,
        ClassALiquorAmount = 500.00m,
        ClassBBeerAmount = 10.00m,
        ClassBLiquorAmount = 60.00m,
        ClassBWineOnlyAmount = 500.00m,
        ClassCWineAmount = 100.00m,
        ReserveClassBLiquorAmount = 10000.00m,
        PublicationFeeAmount = 20.00m
    };

    public override async Task<object> CurrentFeesForLicense(
        DbConnection sqlConnection,
        string licenseYear,
        CancellationToken cancellationToken) =>
        await sqlConnection.QueryFirstOrDefaultAsync<AlcoholLicenseFeeAmounts>(
            await typeof(ClerksLicensingBusinessModule).Assembly.GetAssemblyResource(
                "AlcoholLicenseFeeInformation.sql"),
            new {
                LicenseYear = licenseYear
            });

    public override async Task<IEnumerable<LicenseRenewalFee>> RenewalFees(RenewalRequest renewalRequest,
        AlcoholLicenseFeeAmounts feeInformation,
        IEnumerable<EnerGovLicenseInformation> enerGovLicenseInformations) =>
        await Task.FromResult(Array.Empty<LicenseRenewalFee>());

    public override async Task<IEnumerable<LicenseRenewalDocument>> RenewalDocuments(RenewalRequest renewalRequest,
        AlcoholLicenseFeeAmounts feeInformation,
        IEnumerable<EnerGovLicenseInformation> enerGovLicenseInformations,
        IDictionary<string, ParcelOwnerInformation> parcelOwners) =>
        await Task.FromResult(Array.Empty<LicenseRenewalDocument>());

    public override bool
        ReleventForAllLicenses(IEnumerable<EnerGovLicenseInformation> enerGovLicenseInformations) =>
        enerGovLicenseInformations.Any(_ => _.IsAlcoholLicenseType());

    public override async Task<IEnumerable<LicenseRenewalDocument>> AllRenewalDocuments(
        RenewalRequest renewalRequest, AlcoholLicenseFeeAmounts feeInformation,
        IEnumerable<EnerGovLicenseInformation> enerGovLicenseInformations,
        IDictionary<string, ParcelOwnerInformation> parcelOwners) =>
        new[] {
            new LicenseRenewalDocument("Alcohol Renewal",
                await GenerateAlcoholLicenseRenewalForms(
                    renewalRequest.PreviousLicenseYear, feeInformation,
                    enerGovLicenseInformations.Where(_ => _.IsAlcoholLicenseType())))
        };

    public override async Task<IEnumerable<LicenseRenewalFee>> AllRenewalFees(RenewalRequest renewalRequest,
        AlcoholLicenseFeeAmounts feeInformation,
        IEnumerable<EnerGovLicenseInformation> enerGovLicenseInformations) {
        var licenseInformations = enerGovLicenseInformations.Where(_ => _.IsAlcoholLicenseType()).ToList();


        var fees = new List<LicenseRenewalFee>();
        if (licenseInformations.Any(_ => _.IsClassABeerLicenseClass())) {
            fees.Add(new LicenseRenewalFee("Class \"A\" Beer", feeInformation.ClassABeerAmount,
                feeInformation.PublicationFeeAmount, true));
        }

        if (licenseInformations.Any(_ => _.IsClassBBeerLicenseClass())) {
            fees.Add(new LicenseRenewalFee("Class \"B\" Beer", feeInformation.ClassBBeerAmount,
                feeInformation.PublicationFeeAmount, true));
        }

        if (licenseInformations.Any(_ => _.IsClassALiquorLicenseClass())) {
            fees.Add(new LicenseRenewalFee("\"Class A\" Liquor", feeInformation.ClassALiquorAmount,
                feeInformation.PublicationFeeAmount, true));
        }

        if (licenseInformations.Any(_ => _.IsCombinationClassBBeerAndLiquorLicenseClass())) {
            fees.Add(new LicenseRenewalFee("Combination \"Class B\" Beer & Liquor",
                feeInformation.ClassBBeerAmount + feeInformation.ClassBLiquorAmount,
                feeInformation.PublicationFeeAmount, true));
        }

        if (licenseInformations.Any(_ => _.IsCombinationClassBBeerAndLiquorReserveLicenseClass())) {
            fees.Add(new LicenseRenewalFee("Combination \"Class B\" Beer & Liquor (Reserve)",
                feeInformation.ClassBBeerAmount + feeInformation.ReserveClassBLiquorAmount,
                feeInformation.PublicationFeeAmount, true));
        }

        if (licenseInformations.Any(_ => _.IsClassBWineryLicenseClass())) {
            fees.Add(new LicenseRenewalFee("\"Class B\" Winery (Wine Only)", feeInformation.ClassBWineOnlyAmount,
                feeInformation.PublicationFeeAmount, true));
        }

        if (licenseInformations.Any(_ => _.IsClassCWineLicenseClass())) {
            fees.Add(new LicenseRenewalFee("\"Class C\" Wine", feeInformation.ClassCWineAmount,
                feeInformation.PublicationFeeAmount, true));
        }


        return await Task.FromResult(fees);
    }

    public static async Task<byte[]> GenerateAlcoholLicenseRenewalForms(
        int priorLicenseYear,
        AlcoholLicenseFeeAmounts feeAmounts,
        IEnumerable<EnerGovLicenseInformation> enerGovLicenseInformations) {
        var licenseInformations = enerGovLicenseInformations.ToList();

        var licenseInformation = licenseInformations.FirstOrDefault();

        var licenseCount = licenseInformations.GroupBy(_ => _.LicenseId).Select(_ => _.Key).Count();

        var isClassABeerLicense =
            licenseInformations.Any(_ => _.IsClassABeerLicenseClass());
        var isClassBBeerLicense = licenseInformations.Any(_ => _.IsClassBBeerLicenseClass());
        var isClassALiquorLicense = licenseInformations.Any(_ => _.IsClassALiquorLicenseClass());
        var isComboClassBLicense =
            licenseInformations.Any(_ => _.IsCombinationClassBBeerAndLiquorLicenseClass());
        var isComboClassBReserveLicense =
            licenseInformations.Any(_ => _.IsCombinationClassBBeerAndLiquorReserveLicenseClass());
        var isClassBWineryLicense = licenseInformations.Any(_ => _.IsClassBWineryLicenseClass());
        var isClassCWineLicense = licenseInformations.Any(_ => _.IsClassCWineLicenseClass());

        var alcoholLicenseInformation = new ClerksAlcoholLicenseInformation(
            isClassABeerLicense
                ? feeAmounts.ClassABeerAmount
                : null,
            isClassBBeerLicense ||
            isComboClassBLicense ||
            isComboClassBReserveLicense
                ? feeAmounts.ClassBBeerAmount
                : null,
            isClassCWineLicense
                ? feeAmounts.ClassCWineAmount
                : null,
            isClassALiquorLicense
                ? feeAmounts.ClassALiquorAmount
                : null,
            false,
            isComboClassBLicense || isComboClassBReserveLicense
                ? feeAmounts.ClassBLiquorAmount
                : null,
            null,
            isClassBWineryLicense
                ? feeAmounts.ClassBWineOnlyAmount
                : null,
            feeAmounts.PublicationFeeAmount * licenseCount);

        var premiseDescription = licenseInformation?.AlchoholLicenseSalesAndServiceArea ?? "";
        if (!string.IsNullOrWhiteSpace(licenseInformation?.AlcoholLicenseStorageArea)) {
            premiseDescription += $"(Storage: {licenseInformation.AlcoholLicenseStorageArea})";
        }

        ClerksCompanyInformation clerksCompanyInformation;

        var groupedEnerGovLicenseInformation =
            licenseInformations.GroupBy(_ => (_.PersonId, _.ContactTypeId)).Select(_ => _.FirstOrDefault()).ToList();

        if (licenseInformation.IsCorporationClerksCompanyType() ||
            licenseInformation.IsNonProfitOrganizationClerksCompanyType()) {
            var agent = groupedEnerGovLicenseInformation.FirstOrDefault(_ => _.IsAgentContactType())
                ?.AsClerksPerson() ?? new ClerksPerson("", "", "", "");
            var president = groupedEnerGovLicenseInformation.FirstOrDefault(_ => _.IsPresidentContactType())
                ?.AsClerksPerson();
            var vicePresident = groupedEnerGovLicenseInformation.FirstOrDefault(_ => _.IsVicePresidentContactType())
                ?.AsClerksPerson();
            var secretary = groupedEnerGovLicenseInformation.FirstOrDefault(_ => _.IsSecretaryContactType())
                ?.AsClerksPerson();
            var treasurer = groupedEnerGovLicenseInformation.FirstOrDefault(_ => _.IsTreasurerContactType())
                ?.AsClerksPerson();
            var directors = groupedEnerGovLicenseInformation.Where(_ => _.IsDirectorContactType())
                .Select(_ => _.AsClerksPerson());

            clerksCompanyInformation = new CorporationClerksCompanyInformation(
                new ClerksCorporation(
                    licenseInformation.FullLegalName ?? "",
                    licenseInformation.CompanyMailingAddress_CompleteAddress?.FormatAsAddress() ?? ""),
                agent,
                president,
                vicePresident,
                secretary,
                treasurer,
                directors,
                licenseInformation.WisconsinSellersPermitNumber ?? "",
                licenseInformation.TaxNumber ?? "",
                new ClerksBusinessInformation(
                    licenseInformation.TradeName ?? "",
                    licenseInformation.BusinessPhoneNumber ?? "",
                    licenseInformation.LocationAddress_StreetAddress ?? "",
                    licenseInformation.LocationAddress_PostOfficeAddress?.FormatAsAddress() ?? "",
                    premiseDescription));
        } else if (licenseInformation.IsPartnershipClerksCompanyType()) {
            var partners = groupedEnerGovLicenseInformation.Where(_ => _.IsPartnerContactType())
                .Select(_ => _.AsClerksPerson());

            clerksCompanyInformation = new PartnershipClerksCompanyInformation(
                partners,
                licenseInformation?.WisconsinSellersPermitNumber ?? "",
                licenseInformation?.TaxNumber ?? "",
                new ClerksBusinessInformation(
                    licenseInformation?.TradeName ?? "",
                    licenseInformation?.BusinessPhoneNumber ?? "",
                    licenseInformation.LocationAddress_StreetAddress ?? "",
                    licenseInformation.LocationAddress_PostOfficeAddress?.FormatAsAddress() ?? "",
                    premiseDescription));
        } else if (licenseInformation.IsLimitedLiabilityCorporationClerksCompanyType()) {
            var agent =
                groupedEnerGovLicenseInformation.FirstOrDefault(_ => _.IsAgentContactType())?.AsClerksPerson() ??
                new ClerksPerson("", "", "", "");
            var members = groupedEnerGovLicenseInformation.Where(_ => _.IsMemberContactType())
                .Select(_ => _.AsClerksPerson());

            clerksCompanyInformation = new LimitedLiabilityClerksCompanyInformation(
                new ClerksCorporation(
                    licenseInformation?.FullLegalName ?? "",
                    licenseInformation?.CompanyMailingAddress_CompleteAddress?.FormatAsAddress() ?? ""),
                agent,
                members,
                licenseInformation?.WisconsinSellersPermitNumber ?? "",
                licenseInformation?.TaxNumber ?? "",
                new ClerksBusinessInformation(
                    licenseInformation?.TradeName ?? "",
                    licenseInformation.BusinessPhoneNumber ?? "",
                    licenseInformation.LocationAddress_StreetAddress ?? "",
                    licenseInformation.LocationAddress_PostOfficeAddress?.FormatAsAddress() ?? "",
                    premiseDescription));
        } else {
            var owner = groupedEnerGovLicenseInformation
                            .FirstOrDefault(_ => _.IsOwnerContactType() || _.IsIndividualContactType())
                            ?.AsClerksPerson() ??
                        new ClerksPerson("", "", "", "");

            clerksCompanyInformation = new IndividualClerksComapnyInformation(
                owner,
                licenseInformation?.WisconsinSellersPermitNumber ?? "",
                licenseInformation?.TaxNumber ?? "",
                new ClerksBusinessInformation(
                    licenseInformation?.TradeName ?? "",
                    licenseInformation?.BusinessPhoneNumber ?? "",
                    licenseInformation.LocationAddress_StreetAddress ?? "",
                    licenseInformation.LocationAddress_PostOfficeAddress?.FormatAsAddress() ?? "",
                    premiseDescription));
        }

        return await GenerateAlcoholLicenseRenewalForm(
            priorLicenseYear,
            clerksCompanyInformation,
            alcoholLicenseInformation);
    }

    private static async Task AppendAlcoholLicenseRenewalAdditionalContactsForm(
        PdfDocument previousDocument,
        IEnumerable<ClerksPerson> people,
        bool flattenFormFields) {
        if (!people.Any()) {
            return;
        }

        var alcoholLicenseRenewalFormPdfData =
            await typeof(ClerksLicensingBusinessModule).Assembly.GetAssemblyResourceAsBytes(
                "AlcoholLicenseRenewalAdditionalContacts.pdf");

        await using var alcoholLicenseRenewalFormPdfMemoryStream = new MemoryStream();
        var alcoholLicenseRenewalFormPdfDocument = new PdfDocument(
            new PdfReader(new MemoryStream(alcoholLicenseRenewalFormPdfData)),
            new PdfWriter(alcoholLicenseRenewalFormPdfMemoryStream));

        var alcoholLicenseRenewalForm = PdfAcroForm.GetAcroForm(alcoholLicenseRenewalFormPdfDocument, true);

        var index = 1;
        foreach (var person in people.Take(27)) {
            FillInPersonInformation(
                alcoholLicenseRenewalForm,
                person,
                $"lastname(s){index}",
                $"firstname(s){index}",
                $"middlename(s){index}",
                $"address{index}");

            index++;
        }

        if (flattenFormFields) {
            alcoholLicenseRenewalForm.FlattenFields();
        }

        alcoholLicenseRenewalFormPdfDocument.Close();

        PdfHelper.AppendPagesFromPdf(alcoholLicenseRenewalFormPdfMemoryStream.ToArray(), previousDocument);

        if (people.Skip(27).Any()) {
            await AppendAlcoholLicenseRenewalAdditionalContactsForm(previousDocument, people.Skip(27),
                flattenFormFields);
        }
    }

    private static async Task<byte[]> GenerateAlcoholLicenseRenewalForm(
        int priorLicenseYear,
        ClerksCompanyInformation companyInformation,
        ClerksAlcoholLicenseInformation alcoholLicenseInformation) {
        var nextLicenseYear = priorLicenseYear + 1;
        var nextLicenseYearStartDate = new DateTime(nextLicenseYear, 7, 1);
        var nextLicenseYearEndDate = new DateTime(nextLicenseYear + 1, 6, 30);

        var alcoholLicenseRenewalFormPdfData =
            await typeof(ClerksLicensingBusinessModule).Assembly.GetAssemblyResourceAsBytes(
                "AlcoholLicenseRenewalForm.pdf");

        await using var alcoholLicenseRenewalFormPdfMemoryStream = new MemoryStream();
        var alcoholLicenseRenewalFormPdfDocument = new PdfDocument(
            new PdfReader(new MemoryStream(alcoholLicenseRenewalFormPdfData)),
            new PdfWriter(alcoholLicenseRenewalFormPdfMemoryStream));

        var alcoholLicenseRenewalForm = PdfAcroForm.GetAcroForm(alcoholLicenseRenewalFormPdfDocument, true);

        alcoholLicenseRenewalForm.GetField("beginning").SetValue(nextLicenseYearStartDate.ToShortDateString());
        alcoholLicenseRenewalForm.GetField("ending").SetValue(nextLicenseYearEndDate.ToShortDateString());

        alcoholLicenseRenewalForm.GetField("ckgovbody_city").SetValue("city");

        alcoholLicenseRenewalForm.GetField("govbody").SetValue("La Crosse");
        alcoholLicenseRenewalForm.GetField("county").SetValue("La Crosse");

        alcoholLicenseRenewalForm.GetField("permitno").SetValue(companyInformation.WisconsinSellersPermitNumber);
        alcoholLicenseRenewalForm.GetField("feinno").SetValue(companyInformation.TaxNumber);

        alcoholLicenseRenewalForm.GetField("tradename").SetValue(companyInformation.BusinessInformation.TradeName);
        alcoholLicenseRenewalForm.GetField("busphone")
            .SetValue(companyInformation.BusinessInformation.BusinessPhoneNumber);
        alcoholLicenseRenewalForm.GetField("tradeaddress")
            .SetValue(companyInformation.BusinessInformation.AddressOfPremises);
        alcoholLicenseRenewalForm.GetField("pozip")
            .SetValue(companyInformation.BusinessInformation.PostOfficeAndZipCode);
        alcoholLicenseRenewalForm.GetField("premisesdesc")
            .SetValue(companyInformation.BusinessInformation.PremiseDescription);

        var additionalPeople = new List<ClerksPerson>();

        switch (companyInformation.CompanyType) {
            case ClerksCompanyType.Corporation:
                alcoholLicenseRenewalForm.GetField("taxtype_corp").SetValue("corp");
                var corporationCompanyInformation = companyInformation as CorporationClerksCompanyInformation;
                FillInCorporationSection(alcoholLicenseRenewalForm, corporationCompanyInformation?.Corporation);
                if (corporationCompanyInformation?.Agent != null) {
                    FillInAgentSection(alcoholLicenseRenewalForm, corporationCompanyInformation.Agent);
                }

                if (corporationCompanyInformation?.President != null) {
                    FillInOfficersSection(alcoholLicenseRenewalForm, corporationCompanyInformation.President, 1);
                }

                if (corporationCompanyInformation?.VicePresident != null) {
                    FillInOfficersSection(alcoholLicenseRenewalForm, corporationCompanyInformation.VicePresident, 2);
                }

                if (corporationCompanyInformation?.Secretary != null) {
                    FillInOfficersSection(alcoholLicenseRenewalForm, corporationCompanyInformation.Secretary, 3);
                }

                if (corporationCompanyInformation?.Treasurer != null) {
                    FillInOfficersSection(alcoholLicenseRenewalForm, corporationCompanyInformation.Treasurer, 4);
                }
                //if (corporationCompanyInformation.Directors != null && corporationCompanyInformation.Directors.Any()) {
                //    FillInOfficersSection(alcoholLicenseRenewalForm, corporationCompanyInformation.Directors[0], 5);
                //}
                //if (corporationCompanyInformation.Directors != null && corporationCompanyInformation.Directors.Count() >= 2) {
                //    FillInOfficersSection(alcoholLicenseRenewalForm, corporationCompanyInformation.Directors[1], 6);
                //}

                if (corporationCompanyInformation?.Directors != null) {
                    additionalPeople.AddRange(corporationCompanyInformation.Directors);
                }

                break;
            case ClerksCompanyType.LimitedLiabilityCompany:
                alcoholLicenseRenewalForm.GetField("taxtype_llc").SetValue("llc");
                var llcCompanyInformation = companyInformation as LimitedLiabilityClerksCompanyInformation;
                FillInCorporationSection(alcoholLicenseRenewalForm, llcCompanyInformation?.Corporation);
                if (llcCompanyInformation?.Agent != null) {
                    FillInAgentSection(alcoholLicenseRenewalForm, llcCompanyInformation.Agent);
                }

                if (llcCompanyInformation?.Members != null && llcCompanyInformation.Members.Any()) {
                    FillInOfficersSection(alcoholLicenseRenewalForm, llcCompanyInformation.Members[0], 1);
                }

                if (llcCompanyInformation?.Members != null && llcCompanyInformation.Members.Count() >= 2) {
                    FillInOfficersSection(alcoholLicenseRenewalForm, llcCompanyInformation.Members[1], 2);
                }

                if (llcCompanyInformation?.Members != null && llcCompanyInformation.Members.Count() >= 3) {
                    FillInOfficersSection(alcoholLicenseRenewalForm, llcCompanyInformation.Members[2], 3);
                }

                if (llcCompanyInformation?.Members != null && llcCompanyInformation.Members.Count() >= 4) {
                    FillInOfficersSection(alcoholLicenseRenewalForm, llcCompanyInformation.Members[3], 4);
                }

                if (llcCompanyInformation?.Members != null && llcCompanyInformation.Members.Count() >= 5) {
                    FillInOfficersSection(alcoholLicenseRenewalForm, llcCompanyInformation.Members[4], 5);
                }

                if (llcCompanyInformation?.Members != null && llcCompanyInformation.Members.Count() >= 6) {
                    FillInOfficersSection(alcoholLicenseRenewalForm, llcCompanyInformation.Members[5], 6);
                }

                if (llcCompanyInformation?.Members != null) {
                    additionalPeople.AddRange(llcCompanyInformation.Members.Skip(6));
                }

                break;
            case ClerksCompanyType.Partnership:
                alcoholLicenseRenewalForm.GetField("taxtype_part").SetValue("part");
                var partnershipCompanyInformation = companyInformation as PartnershipClerksCompanyInformation;
                if (partnershipCompanyInformation?.Partners != null && partnershipCompanyInformation.Partners.Any()) {
                    FillInPartnerSection(alcoholLicenseRenewalForm, partnershipCompanyInformation.Partners[0], 1);
                }

                if (partnershipCompanyInformation?.Partners != null &&
                    partnershipCompanyInformation.Partners.Count() >= 2) {
                    FillInPartnerSection(alcoholLicenseRenewalForm, partnershipCompanyInformation.Partners[1], 2);
                }

                if (partnershipCompanyInformation?.Partners != null &&
                    partnershipCompanyInformation.Partners.Count() >= 3) {
                    FillInPartnerSection(alcoholLicenseRenewalForm, partnershipCompanyInformation.Partners[2], 3);
                }

                if (partnershipCompanyInformation?.Partners != null) {
                    additionalPeople.AddRange(partnershipCompanyInformation.Partners.Skip(3));
                }

                break;
            case ClerksCompanyType.Individual:
                alcoholLicenseRenewalForm.GetField("taxtype_ind").SetValue("ind");
                var individualCompanyInformation = companyInformation as IndividualClerksComapnyInformation;
                if (individualCompanyInformation?.Owner != null) {
                    FillInPartnerSection(alcoholLicenseRenewalForm, individualCompanyInformation.Owner, 1);
                }

                break;
        }

        FillInLicenseFee(alcoholLicenseRenewalForm, alcoholLicenseInformation.ClassABeerFee, "classabeer",
            "classabeerfee");
        FillInLicenseFee(alcoholLicenseRenewalForm, alcoholLicenseInformation.ClassBBeerFee, "classbbeer",
            "classbbeerfee");
        FillInLicenseFee(alcoholLicenseRenewalForm, alcoholLicenseInformation.ClassCWineFee, "classcwine",
            "classcwinefee");
        FillInLicenseFee(alcoholLicenseRenewalForm, alcoholLicenseInformation.ClassALiquorFee, "classaliquor",
            "classaliquorfee");
        FillInLicenseFee(alcoholLicenseRenewalForm, alcoholLicenseInformation.ClassBLiquorFee, "classbliquor",
            "classbliquorfee");
        FillInLicenseFee(alcoholLicenseRenewalForm, alcoholLicenseInformation.ReserveClassBLiquorFee,
            "reserveclassbliq", "resclassbliqfee");
        FillInLicenseFee(alcoholLicenseRenewalForm, alcoholLicenseInformation.ClassBWineOnlyWineryFee, "classbwine",
            "classbwinefee");

        if (alcoholLicenseInformation.ClassALiquorCiderOnly) {
            alcoholLicenseRenewalForm.GetField("classaliquorcideronly").SetValue("Yes");
        }

        alcoholLicenseRenewalForm.GetField("publicationfee")
            .SetValue(alcoholLicenseInformation.PublicationFee.ToString("F2"));

        var totalFees = (alcoholLicenseInformation.ClassABeerFee ?? 0.00m) +
                        (alcoholLicenseInformation.ClassBBeerFee ?? 0.00m) +
                        (alcoholLicenseInformation.ClassCWineFee ?? 0.00m) +
                        (alcoholLicenseInformation.ClassALiquorFee ?? 0.00m) +
                        (alcoholLicenseInformation.ClassBLiquorFee ?? 0.00m) +
                        (alcoholLicenseInformation.ReserveClassBLiquorFee ?? 0.00m) +
                        (alcoholLicenseInformation.ClassBWineOnlyWineryFee ?? 0.00m) +
                        alcoholLicenseInformation.PublicationFee;

        alcoholLicenseRenewalForm.GetField("totalfee").SetValue(totalFees.ToString("F2"));

        alcoholLicenseRenewalForm.FlattenFields();

        await AppendAlcoholLicenseRenewalAdditionalContactsForm(
            alcoholLicenseRenewalFormPdfDocument,
            additionalPeople,
            true);

        alcoholLicenseRenewalFormPdfDocument.Close();

        return alcoholLicenseRenewalFormPdfMemoryStream.ToArray();
    }


    private static void FillInCorporationSection(PdfAcroForm alcoholLicenseRenewalForm,
        ClerksCorporation corporation) {
        alcoholLicenseRenewalForm.GetField("namecorp").SetValue(corporation.FullLegalName);
        alcoholLicenseRenewalForm.GetField("addresscorp").SetFontSize(8.0f);
        alcoholLicenseRenewalForm.GetField("addresscorp").SetValue(corporation.Address);
    }

    private static void FillInAgentSection(PdfAcroForm alcoholLicenseRenewalForm, ClerksPerson agent) {
        FillInPersonInformation(alcoholLicenseRenewalForm, agent, "lastnameagent", "firstnameagent",
            "middlenameagent", "addressagent");
    }

    private static readonly Dictionary<int, (string, string, string, string)> OfficerSectionFieldNames = new() {
        {1, ("lastnamepresmem", "firstnamepresmem", "middlenamepresmem", "addressnamepresmem")},
        {2, ("lastnamevpresmem", "firstnamevpresmem", "middlenamevpresmem", "addressvpresmem")},
        {3, ("lastnamesecretary", "firstnamesecretary", "middlenamesecretary", "addresssecretary")},
        {4, ("lastnametreasurer", "firstnametreasurer", "middlenametreasurer", "addresstreasurer")},
        {5, ("lastnamedirectors", "firstnamedirectors", "middlenamedirectors", "addressdirectors")},
        {6, ("lastnamedirectors2", "firstnamedirectors2", "middlenamedirectors2", "addressdirectors2")}
    };

    private static void FillInOfficersSection(PdfAcroForm alcoholLicenseRenewalForm, ClerksPerson officer,
        int sectionIndex) {
        FillInPersonInformation(
            alcoholLicenseRenewalForm,
            officer,
            OfficerSectionFieldNames[sectionIndex].Item1,
            OfficerSectionFieldNames[sectionIndex].Item2,
            OfficerSectionFieldNames[sectionIndex].Item3,
            OfficerSectionFieldNames[sectionIndex].Item4);
    }

    private static readonly Dictionary<int, (string, string, string, string)> PartnerSectionFieldNames = new() {
        {1, ("lastname(s)1", "firstname(s)1", "middlename(s)1", "address1")},
        {2, ("lastname(s)2", "firstname(s)2", "middlename(s)2", "address2")},
        {3, ("lastname(s)3", "firstname(s)3", "middlename(s)3", "address3")}
    };

    private static void FillInPartnerSection(PdfAcroForm alcoholLicenseRenewalForm, ClerksPerson partner,
        int sectionIndex) {
        FillInPersonInformation(
            alcoholLicenseRenewalForm,
            partner,
            PartnerSectionFieldNames[sectionIndex].Item1,
            PartnerSectionFieldNames[sectionIndex].Item2,
            PartnerSectionFieldNames[sectionIndex].Item3,
            PartnerSectionFieldNames[sectionIndex].Item4);
    }

    private static void FillInPersonInformation(PdfAcroForm alcoholLicenseRenewalForm, ClerksPerson person,
        string lastNameField, string firstNameField, string middleNameField, string addressField) {
        alcoholLicenseRenewalForm.GetField(lastNameField).SetValue(person.LastName);
        alcoholLicenseRenewalForm.GetField(firstNameField).SetValue(person.FirstName);
        alcoholLicenseRenewalForm.GetField(middleNameField).SetValue(person.MiddleName);
        alcoholLicenseRenewalForm.GetField(addressField).SetFontSize(8.0f);
        alcoholLicenseRenewalForm.GetField(addressField).SetValue(person.HomeAddress);
    }

    private static void FillInLicenseFee(PdfAcroForm alcoholLicenseRenewalForm, decimal? amount,
        string checkBoxName, string feeName) {
        if (!amount.HasValue) {
            return;
        }

        alcoholLicenseRenewalForm.GetField(checkBoxName).SetValue("Yes");
        alcoholLicenseRenewalForm.GetField(feeName).SetValue(amount.Value.ToString("F2"));
    }

}