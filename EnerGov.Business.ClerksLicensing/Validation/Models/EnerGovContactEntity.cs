namespace EnerGov.Business.ClerksLicensing.Validation.Models; 

public abstract class EnerGovContactEntity {

    protected EnerGovContactEntity(
        BusinessEntityInformation enerGovContactInformation) {

        ContactId = enerGovContactInformation.ContactId ?? "";
        ContactNumber = enerGovContactInformation.ContactNumber ?? "";
        CompanyName = enerGovContactInformation.CompanyName ?? "";
        FirstName = enerGovContactInformation.FirstName ?? "";
        MiddleName = enerGovContactInformation.MiddleName ?? "";
        LastName = enerGovContactInformation.LastName ?? "";
        Title = enerGovContactInformation.Title ?? "";
        Email = enerGovContactInformation.Email ?? "";
        WebSite = enerGovContactInformation.WebSite ?? "";
        BusinessPhoneNumber = enerGovContactInformation.BusinessPhoneNumber ?? "";
        HomePhoneNumber = enerGovContactInformation.HomePhoneNumber ?? "";
        MobilePhoneNumber = enerGovContactInformation.MobilePhoneNumber ?? "";
        FaxNumber = enerGovContactInformation.FaxNumber ?? "";
        OtherPhoneNumber = enerGovContactInformation.OtherPhoneNumber ?? "";
        IsCompany = enerGovContactInformation.IsCompany ?? false;
        IsContact = enerGovContactInformation.IsContact ?? false;
    }

    public string ContactId { get; }
    public string ContactNumber { get; }
    public string CompanyName { get; }
    public string FirstName { get; }
    public string MiddleName { get; }
    public string LastName { get; }
    public string Title { get; }
    public string Email { get; }
    public string WebSite { get; }
    public string BusinessPhoneNumber { get; }
    public string HomePhoneNumber { get; }
    public string MobilePhoneNumber { get; }
    public string FaxNumber { get; }
    public string OtherPhoneNumber { get; }
    public bool IsCompany { get; }
    public bool IsContact { get; }

    public override string ToString() => IsCompany
        ? $"{CompanyName} (BusinessPhone = {BusinessPhoneNumber})"
        : $"{FirstName} {MiddleName} {LastName} (HomePhone = {HomePhoneNumber}, BusinessPhone = {BusinessPhoneNumber})";

}