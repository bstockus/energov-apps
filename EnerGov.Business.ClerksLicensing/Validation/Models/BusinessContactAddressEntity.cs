namespace EnerGov.Business.ClerksLicensing.Validation.Models; 

public class BusinessContactAddressEntity : EnerGovAddressEntity {

    public BusinessContactAddressEntity(
        BusinessEntityInformation businessContactAddressInformation) : base(businessContactAddressInformation) { }

    public override string ToString() => $"[ADDRESS] {base.ToString()}";

}