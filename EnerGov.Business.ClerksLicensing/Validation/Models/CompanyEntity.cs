using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace EnerGov.Business.ClerksLicensing.Validation.Models; 

public class CompanyEntity : EnerGovContactEntity {

    public CompanyEntity(
        BusinessEntityInformation companyInformation,
        IEnumerable<BusinessEntityInformation> businessEntityInformations) : base(companyInformation) {

        CompanyAddresses = businessEntityInformations.Where(_ => _.EntityType.Equals("CADR"))
            .Select(_ => new CompanyAddressEntity(_)).ToList();

    }

    public IEnumerable<CompanyAddressEntity> CompanyAddresses { get; }

    public override string ToString() {
        var results = new StringBuilder();

        results.AppendLine($"[COMPANY]: {base.ToString()}");

        foreach (var companyAddress in CompanyAddresses) {
            results.AppendLine(companyAddress.ToString().IndentString(2));
        }

        return results.ToString();
    }

}