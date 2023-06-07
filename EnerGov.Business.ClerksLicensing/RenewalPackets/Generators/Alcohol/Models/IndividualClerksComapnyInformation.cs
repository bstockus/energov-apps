namespace EnerGov.Business.ClerksLicensing.RenewalPackets.Generators.Alcohol.Models;

public class IndividualClerksComapnyInformation : ClerksCompanyInformation {

    public ClerksPerson Owner { get; }

    public override ClerksCompanyType CompanyType => ClerksCompanyType.Individual;

    public IndividualClerksComapnyInformation(ClerksPerson owner, string wisconsinSellersPermitNumber, string taxNumber,
        ClerksBusinessInformation businessInformation) : base(wisconsinSellersPermitNumber, taxNumber,
        businessInformation) => Owner = owner;

}