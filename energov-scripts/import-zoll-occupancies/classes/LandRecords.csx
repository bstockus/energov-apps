
public class ParcelAddress {
    public string ParcelNumber { get; set; }
    public string StreetName { get; set; }
    public string StreetType { get; set; }
    public string StreetDirectionalSuffix { get; set; }
    public string HouseNumber { get; set; }
    public string SecondaryNumber { get; set; }
}

public class ParcelOwner {
    public string ParcelNumber { get; set; }
    public string Owner1Name { get; set; }
    public string Owner2Name { get; set; }
    public string OwnerName { get; set; }
    public string CompleteAddress { get; set; }
}

public class CompleteParcelOwner {
    public int PropertyId { get; set; }
    public int OwnerId { get; set; }
    public string ParcelNumber { get; set; }
    public string LastName { get; set; }
    public string FirstName { get; set; }
    public bool? IsBusiness { get; set; }
    public string StreetName { get; set; }
    public string StreetType { get; set; }
    public string StreetPrefixDirectional { get; set; }
    public string StreetSuffixDirectional { get; set; }
    public string HouseNumber { get; set; }
    public string SecondaryNumber { get; set; }
    public string SecondaryType { get; set; }
    public string City { get; set; }
    public string State { get; set; }
    public string ZipCode { get; set; }
}