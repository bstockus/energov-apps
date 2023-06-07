using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace EnerGov.Business.ClerksLicensing.Validation.Models; 

public class BusinessEntity : EnerGovEntity {

    public static IEnumerable<BusinessEntity> ProcessToBusinessEntities(
        IEnumerable<BusinessEntityInformation> businessEntityInformations) =>
        businessEntityInformations.GroupBy(_ => _.BusinessId).Select(_ =>
            new BusinessEntity(_.FirstOrDefault(x => x.EntityType.Equals("BUIS")), _));

    public BusinessEntity(
        BusinessEntityInformation businessInformation,
        IEnumerable<BusinessEntityInformation> businessEntityInformations) {

        BusinessId = businessInformation.BusinessId ?? "";
        BusinessNumber = businessInformation.BusinessNumber ?? "";
        BusinessCompanyTypeId = businessInformation.BusinessCompanyTypeId ?? "";
        BusinessCompanyType = businessInformation.BusinessCompanyType ?? "";
        BusinessStatusId = businessInformation.BusinessStatusId ?? "";
        BusinessStatus = businessInformation.BusinessStatus ?? "";
        Description = businessInformation.Description ?? "";
        TradeName = businessInformation.TradeName ?? "";
        FederalTaxNumber = businessInformation.FederalTaxNumber ?? "";
        StateTaxNumber = businessInformation.StateTaxNumber ?? "";
        DistrictId = businessInformation.DistrictId ?? "";
        District = businessInformation.District ?? "";
        BusinessLocationId = businessInformation.BusinessLocationId ?? "";
        BusinessLocation = businessInformation.BusinessLocation ?? "";
        OpenDate = businessInformation.OpenDate;
        CloseDate = businessInformation.CloseDate;

        if (businessEntityInformations.Any(_ => _.EntityType.Equals("COMP"))) {
            var companyEntityInfo = businessEntityInformations.FirstOrDefault(_ => _.EntityType.Equals("COMP"));
            Company = new CompanyEntity(
                companyEntityInfo,
                businessEntityInformations.Where(_ =>
                    (_.ContactId ?? "").Equals(companyEntityInfo.ContactId) && (_.EntityType.Equals("CADR"))));
        }

        BusinessAddresses = businessEntityInformations.Where(_ => _.EntityType.Equals("BADR"))
            .Select(_ => new BusinessAddressEntity(_)).ToList();

        BusinessContacts = businessEntityInformations.Where(_ => _.EntityType.Equals("BCON"))
            .Select(_ => new BusinessContactEntity(_,
                businessEntityInformations.Where(
                    x => x.EntityType.Equals("BCAD") && (x.ContactId ?? "").Equals(_.ContactId)))).ToList();

        BusinessParcels = businessEntityInformations.Where(_ => _.EntityType.Equals("BPAR"))
            .Select(_ => new BusinessParcelEntity(_)).ToList();

        BusinessLicenses = businessEntityInformations.Where(_ => _.EntityType.Equals("BLIC"))
            .Select(_ =>
                new BusinessLicenseEntity(this, _,
                    businessEntityInformations.Where(x => (x.LicenseId ?? "").Equals(_.LicenseId)))).ToList();

    }

    public string BusinessId { get; }
    public string BusinessNumber { get; }
    public string BusinessCompanyTypeId { get; }
    public string BusinessCompanyType { get; }
    public string BusinessStatusId { get; }
    public string BusinessStatus { get; }
    public string Description { get; }
    public string TradeName { get; }
    public string FederalTaxNumber { get; }
    public string StateTaxNumber { get; }
    public string DistrictId { get; }
    public string District { get; }
    public string BusinessLocationId { get; }
    public string BusinessLocation { get; }
    public DateTime? OpenDate { get; }
    public DateTime? CloseDate { get; }
    public CompanyEntity Company { get; }
    public IEnumerable<BusinessAddressEntity> BusinessAddresses { get; }
    public IEnumerable<BusinessContactEntity> BusinessContacts { get; }
    public IEnumerable<BusinessParcelEntity> BusinessParcels { get; }
    public IEnumerable<BusinessLicenseEntity> BusinessLicenses { get; }

    public override string ToString() {
        var results = new StringBuilder();
        results.AppendLine($"[BUSINESS] {BusinessNumber}: {TradeName}");
        results.AppendLine(Company.ToString().IndentString(2));
        foreach (var businessAddress in BusinessAddresses) {
            results.AppendLine(businessAddress.ToString().IndentString(2));
        }
        foreach (var businessParcel in BusinessParcels) {
            results.AppendLine(businessParcel.ToString().IndentString(2));
        }
        foreach (var businessContact in BusinessContacts) {
            results.AppendLine(businessContact.ToString().IndentString(2));
        }

        foreach (var businessLicense in BusinessLicenses) {
            results.AppendLine(businessLicense.ToString().IndentString(2));
        }
        return results.ToString();
    }

    public override EnerGovEntityIdentifier EntityIdentifier => new($"{BusinessNumber}");
    public override IEnumerable<EnerGovAddressEntity> EntityAddresses => BusinessAddresses;

}