using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace EnerGov.Business.ClerksLicensing.Validation.Models; 

public class BusinessLicenseContactEntity : EnerGovContactEntity {

    public BusinessLicenseContactEntity(BusinessEntityInformation enerGovContactInformation,
        IEnumerable<BusinessEntityInformation> businessEntityInformations) : base(enerGovContactInformation) {

        BusinessContactTypeId = enerGovContactInformation.BusinessContactTypeId ?? "";
        BusinessContactType = enerGovContactInformation.BusinessContactType ?? "";
        IsBilling = enerGovContactInformation.IsBilling ?? false;

        BusinessLicenseContactAddresses = businessEntityInformations.Where(_ => _.EntityType.Equals("BLCA"))
            .Select(_ => new BusinessLicenseContactAddressEntity(_)).ToList();
    }

    public string BusinessContactTypeId { get; }
    public string BusinessContactType { get; }
    public bool IsBilling { get; }
    public IEnumerable<BusinessLicenseContactAddressEntity> BusinessLicenseContactAddresses { get; }

    public override string ToString() {
        var results = new StringBuilder();

        results.AppendLine($"[CONTACT]: {BusinessContactType} => {base.ToString()} (IsBilling = {IsBilling.ToBooleanString()})");

        foreach (var companyAddress in BusinessLicenseContactAddresses) {
            results.AppendLine(companyAddress.ToString().IndentString(2));
        }

        return results.ToString();
    }

}