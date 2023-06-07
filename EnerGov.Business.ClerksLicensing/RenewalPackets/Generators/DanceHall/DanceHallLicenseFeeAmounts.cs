using System.ComponentModel.DataAnnotations;

namespace EnerGov.Business.ClerksLicensing.RenewalPackets.Generators.DanceHall;

public class DanceHallLicenseFeeAmounts {

    [Display(Name = "Fee Amount")]
    public decimal Amount { get; set; }

}