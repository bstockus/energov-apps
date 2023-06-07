using System.ComponentModel.DataAnnotations;

namespace EnerGov.Business.ClerksLicensing.RenewalPackets.Generators.Cabaret;

public class CabaretLicenseFeeAmounts {

    [Display(Name = "Indoor Cabaret Fee Amount")]
    public decimal IndoorCabaretAmount { get; set; }


    [Display(Name = "Outdoor Cabaret Fee Amount")]
    public decimal OutdoorCabaretAmount { get; set; }

}