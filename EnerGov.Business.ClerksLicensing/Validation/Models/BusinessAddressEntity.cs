namespace EnerGov.Business.ClerksLicensing.Validation.Models; 

public class BusinessAddressEntity : EnerGovAddressEntity {

    public BusinessAddressEntity(
        BusinessEntityInformation businessAddressInformation) : base(businessAddressInformation) {

        IsMain = businessAddressInformation.IsMain ?? false;
    }

    public bool IsMain { get; }

    public override string ToString() => $"[ADDRESS] {base.ToString()} (IsMain = {IsMain.ToBooleanString()})";

}