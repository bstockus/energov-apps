namespace EnerGov.Business.ClerksLicensing.Validation.Models; 

public class BusinessLicenseContactAddressEntity : EnerGovAddressEntity {

    public BusinessLicenseContactAddressEntity(BusinessEntityInformation enerGovAddressInformation) : base(enerGovAddressInformation) { }

    public override string ToString() => $"[ADDRESS] {base.ToString()}";

}