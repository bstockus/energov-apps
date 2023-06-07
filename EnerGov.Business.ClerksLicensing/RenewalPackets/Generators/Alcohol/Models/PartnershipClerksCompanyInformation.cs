using System.Collections.Generic;
using System.Linq;

namespace EnerGov.Business.ClerksLicensing.RenewalPackets.Generators.Alcohol.Models;

public class PartnershipClerksCompanyInformation : ClerksCompanyInformation {

    public ClerksPerson[] Partners { get; }

    public override ClerksCompanyType CompanyType => ClerksCompanyType.Partnership;

    public PartnershipClerksCompanyInformation(
        IEnumerable<ClerksPerson> partners, string wisconsinSellersPermitNumber, string taxNumber,
        ClerksBusinessInformation businessInformation) : base(wisconsinSellersPermitNumber, taxNumber,
        businessInformation) =>
        Partners = partners.ToArray();

}