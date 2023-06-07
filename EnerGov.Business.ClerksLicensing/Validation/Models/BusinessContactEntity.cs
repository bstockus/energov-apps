using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace EnerGov.Business.ClerksLicensing.Validation.Models; 

public class BusinessContactEntity : EnerGovContactEntity {

    public BusinessContactEntity(
        BusinessEntityInformation businessContactInformation,
        IEnumerable<BusinessEntityInformation> businessEntityInformations) : base(businessContactInformation) {

        BusinessContactTypeId = businessContactInformation.BusinessContactTypeId ?? "";
        BusinessContactType = businessContactInformation.BusinessContactType ?? "";

        BusinessContactAddresses = businessEntityInformations.Where(_ => _.EntityType.Equals("BCAD"))
            .Select(_ => new BusinessContactAddressEntity(_)).ToList();
    }

    public string BusinessContactTypeId { get; }
    public string BusinessContactType { get; }
    public IEnumerable<BusinessContactAddressEntity> BusinessContactAddresses { get; }

    public override string ToString() {
        var results = new StringBuilder();

        results.AppendLine($"[CONTACT]: {BusinessContactType} => {base.ToString()}");

        foreach (var companyAddress in BusinessContactAddresses) {
            results.AppendLine(companyAddress.ToString().IndentString(2));
        }

        return results.ToString();
    }

}