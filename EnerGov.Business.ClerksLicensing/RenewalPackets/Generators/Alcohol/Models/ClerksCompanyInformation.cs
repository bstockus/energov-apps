namespace EnerGov.Business.ClerksLicensing.RenewalPackets.Generators.Alcohol.Models;

public abstract class ClerksCompanyInformation {

    public string WisconsinSellersPermitNumber { get; }
    public string TaxNumber { get; }
    public ClerksBusinessInformation BusinessInformation { get; }

    public abstract ClerksCompanyType CompanyType { get; }

    protected ClerksCompanyInformation(
        string wisconsinSellersPermitNumber,
        string taxNumber,
        ClerksBusinessInformation businessInformation) {
        WisconsinSellersPermitNumber = wisconsinSellersPermitNumber;
        TaxNumber = taxNumber;
        BusinessInformation = businessInformation;
    }

}