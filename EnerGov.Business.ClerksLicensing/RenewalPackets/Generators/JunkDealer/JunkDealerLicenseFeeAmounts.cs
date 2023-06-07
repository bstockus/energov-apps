using System.ComponentModel.DataAnnotations;

namespace EnerGov.Business.ClerksLicensing.RenewalPackets.Generators.JunkDealer;

public class JunkDealerLicenseFeeAmounts {

    [Display(Name = "Junk Dealer Fee Amount")]
    public decimal JunkDealerFeeAmount { get; set; }

    [Display(Name = "Itinerant Junk Dealer Fee Amount")]
    public decimal ItinerantJunkDealerFeeAmount { get; set; }

}