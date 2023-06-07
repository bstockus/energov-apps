using System.ComponentModel.DataAnnotations;

namespace EnerGov.Business.ClerksLicensing.RenewalPackets.Generators.Alcohol;

public class AlcoholLicenseFeeAmounts {

    [Display(Name = "Class A Beer Fee Amount")]
    public decimal ClassABeerAmount { get; set; }

    [Display(Name = "Class B Beer Fee Amount")]
    public decimal ClassBBeerAmount { get; set; }

    [Display(Name = "Class C Wine Fee Amount")]
    public decimal ClassCWineAmount { get; set; }

    [Display(Name = "Class A Liquor Fee Amount")]
    public decimal ClassALiquorAmount { get; set; }

    [Display(Name = "Class B Liquor Fee Amount")]
    public decimal ClassBLiquorAmount { get; set; }

    [Display(Name = "Reserve Class B Liquor Fee Amount")]
    public decimal ReserveClassBLiquorAmount { get; set; }

    [Display(Name = "Class B Wine Only Fee Amount")]
    public decimal ClassBWineOnlyAmount { get; set; }

    [Display(Name = "Publication Fee Amount")]
    public decimal PublicationFeeAmount { get; set; }

}