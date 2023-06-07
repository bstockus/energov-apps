using System;

namespace EnerGov.Business.ClerksLicensing.RenewalPackets.Generators;

public class CoverLetterDates {

    public DateTime LetterDate { get; set; }
    public DateTime ApplicationDueDate { get; set; }
    public DateTime JADate { get; set; }
    public DateTime CouncilDate { get; set; }
    public DateTime PaymentDueDate { get; set; }
    public DateTime MiscellaneousDueDate { get; set; }

}