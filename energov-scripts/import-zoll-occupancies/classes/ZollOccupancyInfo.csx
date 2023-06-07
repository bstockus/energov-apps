
public class ZollOccupancyInfo {
    public string OccupancyNumber { get; set; }
    public string OccupancyName { get; set; }
    public string BusinessLicense { get; set; }
    public string InspectionSchedule { get; set; }
    public string StreetNumber { get; set; }
    public string Street { get; set; }
    public string StreetType { get; set; }
    public string StreetSuffix { get; set; }
    public string ParcelNumber { get; set; }
    public int? NumberOfCommercialUnits { get; set; }
    public int? NumberOfResidentialUnits { get; set; }
    public int? Area { get; set; }
    public string Location { get; set; }
}

public class ZollOccupancyContactInfo {

    public string OccupancyNumber { get; set; }
    public string BusinessName { get; set; }
    public string LastName { get; set; }
    public string FirstName { get; set; }
    public bool? IsOccupant { get; set; }
    public bool? IsOwner { get; set; }
    public bool? IsOther { get; set; }
    public string OtherDescription { get; set; }
    public string StreetNumber { get; set; }
    public string StreetPrefix { get; set; }
    public string StreetName { get; set; }
    public string StreetType { get; set; }
    public string StreetSuffix { get; set; }
    public string PoBox { get; set; }
    public string City { get; set; }
    public string State { get; set; }
    public string PostalCode { get; set; }
    public string WorkPhone { get; set; }
    public string HomePhone { get; set; }
    public string Unit { get; set; }
    public string Email { get; set; }
    public string CellPhone { get; set; }

}