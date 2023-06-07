using System.ComponentModel.DataAnnotations;

namespace EnerGov.Business.ClerksLicensing.RenewalPackets.Generators.RecyclingFacility;

public class RecyclingFacilityLicenseFeeAmounts {

    [Display(Name = "Processing Facility Fee Amount")]
    public decimal ProcessingFacilityFeeAmount { get; set; }

    [Display(Name = "Recycling Center Fee Amount")]
    public decimal RecyclingCenterFeeAmount { get; set; }

    [Display(Name = "Pick Up Station Fee Amount")]
    public decimal PickUpStationFeeAmount { get; set; }

    [Display(Name = "Reverse Vending Machine Fee Amount")]
    public decimal ReverseVendingMachineFeeAmount { get; set; }

}