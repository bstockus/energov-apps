namespace EnerGov.Business.ClerksLicensing.Validation.Models; 

public class CompanyAddressEntity : EnerGovAddressEntity {

    public CompanyAddressEntity(
        BusinessEntityInformation companyAddressInformation) : base(companyAddressInformation) { }

    public override string ToString() => $"[ADDRESS] {base.ToString()}";

}