using System.ComponentModel.DataAnnotations;

namespace EnerGov.Business.ClerksLicensing.RenewalPackets.Generators.Secondhand;

public class SecondhandLicenseFeeAmounts {

    [Display(Name = "Secondhand Article Dealer Fee Amount")]
    public decimal SecondhandArticleDealerFeeAmount { get; set; }

    [Display(Name = "Secondhand Jewelry Fee Amount")]
    public decimal SecondhandJewelryFeeAmount { get; set; }

    [Display(Name = "Mall/Flea Market Fee Amount")]
    public decimal MallFleaMarketFeeAmount { get; set; }

    [Display(Name = "Pawnbroker Fee Amount")]
    public decimal PawnbrokerFeeAmount { get; set; }

}