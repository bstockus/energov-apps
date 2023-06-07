
public class EnerGovOccupancyPermit {
    public string PERMITNUMBER { get; set; }
    public string DESCRIPTION { get; set; }
    public int? FireNumberOfApartments { get; set; }
    public int? FireNumberOfHotelRooms { get; set; }
    public int? FireCommercialSquareFootage { get; set; }
    public int? FireHighLifeSafetySquareFootage { get; set; }
    public string ZollOccupancyID { get; set; }
    public string PARCELNUMBER { get; set; }
}

public class EnerGovOccupancyParcel {
    public string PERMITNUMBER { get; set; }
    public string PARCELID { get; set; } 
    public bool MAIN { get; set; }
}

public class EnerGovOccupancyAddress {
    public string PERMITNUMBER { get; set; }
    public string MAILINGADDRESSID { get; set; } 
    public bool MAIN { get; set; }
    public string ADDRESSLINE1 { get; set; }
    public string ADDRESSLINE2 { get; set; }
    public string POSTDIRECTION { get; set; }
    public string STREETTYPE { get; set; }
    public string UNITORSUITE { get; set; }
}

public class EnerGovOccupancyContact {
    public string PERMITNUMBER { get; set; }
    public string GLOBALENTITYID { get; set; } 
    public bool ISBILLING { get; set; }
    public string GLOBALENTITYNAME { get; set; }
    public string FIRSTNAME { get; set; }
    public string LASTNAME { get; set; }

    public string EMAIL { get; set; }
}