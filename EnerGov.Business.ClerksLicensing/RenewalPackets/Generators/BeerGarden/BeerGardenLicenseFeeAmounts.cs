using System.ComponentModel.DataAnnotations;

namespace EnerGov.Business.ClerksLicensing.RenewalPackets.Generators.BeerGarden;

public class BeerGardenLicenseFeeAmounts {

    [Display(Name = "Class A Fee Amount")]
    public decimal ClassAFeeAmount { get; set; }

    [Display(Name = "Class B Fee Amount")]
    public decimal ClassBFeeAmount { get; set; }

    [Display(Name = "Class C Fee Amount")]
    public decimal ClassCFeeAmount { get; set; }

    [Display(Name = "Class D Fee Amount")]
    public decimal ClassDFeeAmount { get; set; }

}