using System.Collections.Generic;
using System.Linq;

namespace EnerGov.Business.ClerksLicensing.RenewalPackets.Generators.Alcohol.Models;

public class LimitedLiabilityClerksCompanyInformation : ClerksCompanyInformation {

    public ClerksCorporation Corporation { get; }
    public ClerksPerson Agent { get; }
    public ClerksPerson[] Members { get; }

    public override ClerksCompanyType CompanyType => ClerksCompanyType.LimitedLiabilityCompany;

    public LimitedLiabilityClerksCompanyInformation(
        ClerksCorporation corporation,
        ClerksPerson agent,
        IEnumerable<ClerksPerson> members, string wisconsinSellersPermitNumber, string taxNumber,
        ClerksBusinessInformation businessInformation) : base(wisconsinSellersPermitNumber, taxNumber,
        businessInformation) {
        Corporation = corporation;
        Agent = agent;
        Members = members.ToArray();
    }

}