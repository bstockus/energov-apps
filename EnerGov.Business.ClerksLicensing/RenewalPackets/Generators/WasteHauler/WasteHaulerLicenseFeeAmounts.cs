using System.ComponentModel.DataAnnotations;

namespace EnerGov.Business.ClerksLicensing.RenewalPackets.Generators.WasteHauler;

public class WasteHaulerLicenseFeeAmounts {

    [Display(Name = "Fee Amount")]
    public decimal LicenseFeeAmount { get; set; }

}