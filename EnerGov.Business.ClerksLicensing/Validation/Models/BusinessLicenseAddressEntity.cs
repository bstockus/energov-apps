namespace EnerGov.Business.ClerksLicensing.Validation.Models; 

public class BusinessLicenseAddressEntity : EnerGovAddressEntity {

    public BusinessLicenseAddressEntity(
        BusinessEntityInformation businessLicenseAddressInformation) : base(businessLicenseAddressInformation) {

        IsMain = businessLicenseAddressInformation.IsMain ?? false;
    }

    public bool IsMain { get; }

    public override string ToString() => $"[ADDRESS] {base.ToString()} (IsMain = {IsMain.ToBooleanString()})";

}