namespace EnerGov.Business.ClerksLicensing.RenewalPackets.Generators.Alcohol.Models;

public class ClerksBusinessInformation {

    public string TradeName { get; }
    public string BusinessPhoneNumber { get; }
    public string AddressOfPremises { get; }
    public string PostOfficeAndZipCode { get; }
    public string PremiseDescription { get; }

    public ClerksBusinessInformation(
        string tradeName,
        string businessPhoneNumber,
        string addressOfPremises,
        string postOfficeAndZipCode,
        string premiseDescription) {
        TradeName = tradeName;
        BusinessPhoneNumber = businessPhoneNumber;
        AddressOfPremises = addressOfPremises;
        PostOfficeAndZipCode = postOfficeAndZipCode;
        PremiseDescription = premiseDescription;
    }

}