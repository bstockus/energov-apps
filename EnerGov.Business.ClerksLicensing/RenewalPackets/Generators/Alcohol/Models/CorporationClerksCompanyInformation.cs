using System.Collections.Generic;
using System.Linq;

namespace EnerGov.Business.ClerksLicensing.RenewalPackets.Generators.Alcohol.Models;

public class CorporationClerksCompanyInformation : ClerksCompanyInformation {

    public ClerksCorporation Corporation { get; }
    public ClerksPerson Agent { get; }
    public ClerksPerson President { get; }
    public ClerksPerson VicePresident { get; }
    public ClerksPerson Secretary { get; }
    public ClerksPerson Treasurer { get; }
    public ClerksPerson[] Directors { get; }

    public override ClerksCompanyType CompanyType => ClerksCompanyType.Corporation;

    public CorporationClerksCompanyInformation(
        ClerksCorporation corporation,
        ClerksPerson agent,
        ClerksPerson president,
        ClerksPerson vicePresident,
        ClerksPerson secretary,
        ClerksPerson treasurer,
        IEnumerable<ClerksPerson> directors, string wisconsinSellersPermitNumber, string taxNumber,
        ClerksBusinessInformation businessInformation) : base(wisconsinSellersPermitNumber, taxNumber,
        businessInformation) {
        Corporation = corporation;
        Agent = agent;
        President = president;
        VicePresident = vicePresident;
        Secretary = secretary;
        Treasurer = treasurer;
        Directors = directors.ToArray();
    }

}