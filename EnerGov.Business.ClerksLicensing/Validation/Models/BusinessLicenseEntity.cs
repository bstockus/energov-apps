using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace EnerGov.Business.ClerksLicensing.Validation.Models; 

public class BusinessLicenseEntity : EnerGovEntity {

    public BusinessLicenseEntity(
        BusinessEntity parent,
        BusinessEntityInformation businessLicenseInformation,
        IEnumerable<BusinessEntityInformation> businessEntityInformations) {

        ParentBusiness = parent;

        LicenseId = businessLicenseInformation.LicenseId ?? "";
        LicenseNumber = businessLicenseInformation.LicenseNumber ?? "";
        LicenseYear = businessLicenseInformation.LicenseYear ?? 0;
        LicenseTypeId = businessLicenseInformation.LicenseTypeId ?? "";
        LicenseType = businessLicenseInformation.LicenseType ?? "";
        LicenseClassId = businessLicenseInformation.LicenseClassId ?? "";
        LicenseClass = businessLicenseInformation.LicenseClass ?? "";
        LicenseStatusId = businessLicenseInformation.LicenseStatusId ?? "";
        LicenseStatus = businessLicenseInformation.LicenseStatus ?? "";
        AppliedDate = businessLicenseInformation.AppliedDate;
        IssuedDate = businessLicenseInformation.IssuedDate;
        ExpirationDate = businessLicenseInformation.ExpirationDate;
        Description = businessLicenseInformation.Description ?? "";
        DistrictId = businessLicenseInformation.DistrictId ?? "";
        District = businessLicenseInformation.District ?? "";

        BusinessLicenseAddresses = businessEntityInformations.Where(_ => _.EntityType.Equals("BLAD"))
            .Select(_ => new BusinessLicenseAddressEntity(_)).ToList();

        BusinessLicenseContacts = businessEntityInformations.Where(_ => _.EntityType.Equals("BLCO"))
            .Select(_ => new BusinessLicenseContactEntity(_,
                businessEntityInformations.Where(
                    x => x.EntityType.Equals("BLCA") && (x.ContactId ?? "").Equals(_.ContactId)))).ToList();

        BusinessLicenseParcels = businessEntityInformations.Where(_ => _.EntityType.Equals("BLPA"))
            .Select(_ => new BusinessLicenseParcelEntity(_)).ToList();

    }

    public BusinessEntity ParentBusiness { get; }

    public string LicenseId { get; }
    public string LicenseNumber { get; }
    public int LicenseYear { get; }
    public string LicenseTypeId { get; }
    public string LicenseType { get; }
    public string LicenseClassId { get; }
    public string LicenseClass { get; }
    public string LicenseStatusId { get; }
    public string LicenseStatus { get; }
    public DateTime? AppliedDate { get; }
    public DateTime? IssuedDate { get; }
    public DateTime? ExpirationDate { get; }
    public string Description { get; }
    public string DistrictId { get; }
    public string District { get; }
    public IEnumerable<BusinessLicenseAddressEntity> BusinessLicenseAddresses { get; }
    public IEnumerable<BusinessLicenseContactEntity> BusinessLicenseContacts { get; }
    public IEnumerable<BusinessLicenseParcelEntity> BusinessLicenseParcels { get; }

    public override string ToString() {
        var results = new StringBuilder();

        results.AppendLine($"[LICENSE] {LicenseNumber} ({LicenseYear}) => {LicenseType} - {LicenseClass}");

        foreach (var businessAddress in BusinessLicenseAddresses) {
            results.AppendLine(businessAddress.ToString().IndentString(2));
        }
        foreach (var businessParcel in BusinessLicenseParcels) {
            results.AppendLine(businessParcel.ToString().IndentString(2));
        }
        foreach (var businessContact in BusinessLicenseContacts) {
            results.AppendLine(businessContact.ToString().IndentString(2));
        }

        return results.ToString();
    }

    public override EnerGovEntityIdentifier EntityIdentifier => new(
        ParentBusiness.EntityIdentifier.BusinessIdentifier,
        $"{LicenseNumber}");
    public override IEnumerable<EnerGovAddressEntity> EntityAddresses => BusinessLicenseAddresses;

}