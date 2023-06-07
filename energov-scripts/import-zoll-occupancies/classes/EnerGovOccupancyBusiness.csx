
public class EnerGovOccupancyBusiness {
    public string BLGLOBALENTITYEXTENSIONID { get; set; }
    public string DBA { get; set; }
    public string REGISTRATIONID { get; set; }
    public string STATETAXNUMBER { get; set; }
    public string ZoneId { get; set; }
    public string TypeId { get; set; }
    public double? FireHighLifeSafetySquareFootage { get; set; }
    public double? FireCommercialSquareFootage { get; set; }
    public int? FireNumberOfHotelRooms { get; set; }
    public int? FireNumberOfApartments { get; set; }
}

public class EnerGovOccupancyBusinessParcel {
    public string BLGLOBALENTITYEXTENSIONID { get; set; }
    public string PARCELID { get; set; }
    public bool MAIN { get; set; }
    public string PARCELNUMBER { get; set; }
}

public class EnerGovOccupancyBusinessAddress {
    public string BLGLOBALENTITYEXTENSIONID { get; set; }
    public string MAILINGADDRESSID { get; set; }
    public bool MAIN { get; set; }
}

public class EnerGovOccupancyBusinessContact {
    public string BLGLOBALENTITYEXTENSIONID { get; set; }
    public string GLOBALENTITYID { get; set; }
    public string BLCONTACTTYPEID { get; set; }
}

public class EnerGovOccupancyBusinessInspection {
    public string BusinessId { get; set; }
    public string InspectionId { get; set; }
    public string InspectionNumber { get; set; }
    public int InspectionOrder { get; set; }
    public string ParentInspectionNumber { get; set; }
    public string InspectionStatusId { get; set; }
    public string InspectionStatus { get; set; }
    public string InspectionTypeId { get; set; }
    public DateTime? RequestedDate { get; set; }
    public DateTime? ScheduledDate { get; set; }
    public DateTime? ActualStartDate { get; set; }
    public string NonComplianceId { get; set; }
    public string CodeId { get; set; }
    public string CodeRevisionId { get; set; }
    public string ResPartyId { get; set; }
    public string RiskId { get; set; }
    public string CodeDescription { get; set; }
    public string CodeNumber { get; set; }
    public string Comments { get; set; }
    public DateTime DeadlineDate { get; set; }
    public DateTime? ResolvedDate { get; set; }

    public DateTime CreatedDate { get; set; }

    public DateTime InspectionDate =>
        ActualStartDate ?? ScheduledDate ?? RequestedDate ?? CreatedDate;
}