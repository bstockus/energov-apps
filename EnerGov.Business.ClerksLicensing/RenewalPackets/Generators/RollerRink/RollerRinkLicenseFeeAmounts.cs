using System.ComponentModel.DataAnnotations;

namespace EnerGov.Business.ClerksLicensing.RenewalPackets.Generators.RollerRink;

public class RollerRinkLicenseFeeAmounts {

    [Display(Name = "Fee Amount")]
    public decimal FeeAmount { get; set; }

}