using System.ComponentModel.DataAnnotations;

namespace EnerGov.Business.ClerksLicensing.RenewalPackets.Generators.Theatre;

public class TheatreLicenseFeeAmounts {

    [Display(Name = "Under 500 Fee Amount")]

    public decimal TheatreUnder500LicenseFeeAmount { get; set; }

    [Display(Name = "500 to 1000 Fee Amount")]
    public decimal Theatre500To1000LicenseFeeAmount { get; set; }

    [Display(Name = "Over 1000 Fee Amount")]
    public decimal TheatreOver1000LicenseFeeAmount { get; set; }

}