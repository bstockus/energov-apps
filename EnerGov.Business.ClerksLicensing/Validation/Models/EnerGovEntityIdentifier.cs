namespace EnerGov.Business.ClerksLicensing.Validation.Models; 

public class EnerGovEntityIdentifier {

    public EnerGovEntityIdentifier(string businessIdentifier, string businessLicenseIdentifier) {
        BusinessIdentifier = businessIdentifier;
        BusinessLicenseIdentifier = businessLicenseIdentifier;
    }

    public EnerGovEntityIdentifier(string businessIdentifier) : this(businessIdentifier, null) { }


    public string BusinessIdentifier { get; }
    public string BusinessLicenseIdentifier { get; }

    public override string ToString() =>
        string.IsNullOrWhiteSpace(BusinessLicenseIdentifier)
            ? $"[BUSINESS] {BusinessIdentifier}"
            : $"[LICENSE] {BusinessLicenseIdentifier}";

}