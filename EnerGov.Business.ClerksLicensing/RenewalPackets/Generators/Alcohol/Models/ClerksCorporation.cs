namespace EnerGov.Business.ClerksLicensing.RenewalPackets.Generators.Alcohol.Models;

public class ClerksCorporation {

    public string FullLegalName { get; }
    public string Address { get; }

    public ClerksCorporation(string fullLegalName, string address) {
        FullLegalName = fullLegalName;
        Address = address;
    }

}