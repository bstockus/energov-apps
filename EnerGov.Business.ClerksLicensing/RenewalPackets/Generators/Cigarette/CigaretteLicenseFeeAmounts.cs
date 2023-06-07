using System.ComponentModel.DataAnnotations;

namespace EnerGov.Business.ClerksLicensing.RenewalPackets.Generators.Cigarette;

public class CigaretteLicenseFeeAmounts {

    [Display(Name = "Fee Amount")]
    public decimal Amount { get; set; }

}