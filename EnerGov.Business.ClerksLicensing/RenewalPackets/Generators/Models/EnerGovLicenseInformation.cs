using System;

namespace EnerGov.Business.ClerksLicensing.RenewalPackets.Generators.Models;

public class EnerGovLicenseInformation {

    public string BusinessId { get; set; }
    public string CompanyId { get; set; }
    public string LicenseId { get; set; }
    public string ContactId { get; set; }
    public string PersonId { get; set; }
    public string TaxNumber { get; set; }
    public string WisconsinSellersPermitNumber { get; set; }
    public string TradeName { get; set; }
    public string BusinessNumber { get; set; }
    public string LicenseNumber { get; set; }
    public string ClerksCompanyTypeName { get; set; }
    public string ClerksCompanyTypeId { get; set; }
    public string FullLegalName { get; set; }
    public string BusinessPhoneNumber { get; set; }
    public string LocationAddress_StreetAddress { get; set; }
    public string LocationAddress_PostOfficeAddress { get; set; }
    public string LocationAddress_City { get; set; }
    public string LocationAddress_State { get; set; }
    public string LocationAddress_PostalCode { get; set; }
    public string RenewalMailingAddress_CompleteAddressLines { get; set; }
    public string LicenseMailingAddress_CompleteAddressLines { get; set; }
    public string CompanyMailingAddress_CompleteAddressLines { get; set; }
    public string CompanyMailingAddress_CompleteAddress { get; set; }
    public string CompanyMailingAddress_CompleteAddressNoBreaks { get; set; }
    public string CompanyMailingAddress_StreetAddress { get; set; }
    public string CompanyMailingAddress_City { get; set; }
    public string CompanyMailingAddress_State { get; set; }
    public string CompanyMailingAddress_PostalCode { get; set; }
    public int LicenseYear { get; set; }
    public DateTime? LicenseAppliedDate { get; set; }
    public DateTime? LicenseIssuedDate { get; set; }
    public DateTime? LicenseExpirationDate { get; set; }
    public string LicenseTypeName { get; set; }
    public string LicenseTypeId { get; set; }
    public string LicenseClassName { get; set; }
    public string LicenseClassId { get; set; }
    public string AlchoholLicenseSalesAndServiceArea { get; set; }
    public string AlcoholLicenseStorageArea { get; set; }
    public string BeerGardenDescription { get; set; }
    public string OtherBusinessConductedOnPremise { get; set; }
    public string IndoorCabaretDescription { get; set; }
    public string IndoorCabaretNatureOfEntertainment { get; set; }
    public string OutdoorCabaretDescription { get; set; }
    public string OutdoorCabaretNatureOfEntertainment { get; set; }
    public int? TheatreScreens500OrUnder { get; set; }
    public int? TheatreScreens500To1000 { get; set; }
    public int? TheatreScreensOver1000 { get; set; }
    public string KindOfMaterialToBeHandled { get; set; }
    public string DetailedNatureOfBusiness { get; set; }
    public string JunkDealerLicenseType { get; set; }
    public string NameOfMobileHomePark { get; set; }
    public int? NumberOfLots { get; set; }
    public string Recycling_ProcessingFacility { get; set; }
    public string Recycling_PickUpStation { get; set; }
    public string Recycling_RecyclingCenter { get; set; }
    public string Recycling_ReverseVendingMachine { get; set; }
    public string EngagedInCleaningWasteQuestion { get; set; }
    public string Secondhand_Jewelry { get; set; }
    public string Secondhand_Article { get; set; }
    public string ContactFirstName { get; set; }
    public string ContactMiddleName { get; set; }
    public string ContactLastName { get; set; }
    public string ContactType { get; set; }
    public string ContactTypeId { get; set; }
    public string ContactAddress_CompleteAddress { get; set; }
    public string ContactAddress_CompleteAddressNoBreaks { get; set; }
    public string ContactAddress_StreetAddress { get; set; }
    public string ContactAddress_City { get; set; }
    public string ContactAddress_State { get; set; }
    public string ContactAddress_PostalCode { get; set; }
    public string ContactHomePhone { get; set; }
    public string ContactBusinessPhone { get; set; }
    public string ContactEmail { get; set; }
    public DateTime? ContactDateOfBirth { get; set; }
    public string ManagerName { get; set; }
    public string ManagerName_First { get; set; }
    public string ManagerName_Middle { get; set; }
    public string ManagerName_Last { get; set; }
    public string ManagerHomePhone { get; set; }
    public string ManagerBusinessPhone { get; set; }
    public string ManagerCompleteAddress { get; set; }
    public string ManagerCompleteAddress_StreetAddress { get; set; }
    public string ManagerCompleteAddress_City { get; set; }
    public string ManagerCompleteAddress_State { get; set; }
    public string ManagerCompleteAddress_PostalCode { get; set; }

    public string ParcelNumber { get; set; }

}