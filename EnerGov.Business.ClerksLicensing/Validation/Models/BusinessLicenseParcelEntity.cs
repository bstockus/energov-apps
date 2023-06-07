namespace EnerGov.Business.ClerksLicensing.Validation.Models; 

public class BusinessLicenseParcelEntity : EnerGovParcelEntity {

    public BusinessLicenseParcelEntity(BusinessEntityInformation enerGovParcelInformation) : base(
        enerGovParcelInformation) {

        IsMain = enerGovParcelInformation.IsMain ?? false;
    }

    public bool IsMain { get; }

    public override string ToString() => $"[PARCEL] {base.ToString()} (IsMain = {IsMain.ToBooleanString()})";

}