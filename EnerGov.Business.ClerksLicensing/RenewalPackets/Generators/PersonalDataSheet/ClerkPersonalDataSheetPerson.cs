using System;
using EnerGov.Business.ClerksLicensing.RenewalPackets.Generators.Models;

namespace EnerGov.Business.ClerksLicensing.RenewalPackets.Generators.PersonalDataSheet;

public class ClerkPersonalDataSheetPerson {

    public string FirstName { get; }
    public string MiddleName { get; }
    public string LastName { get; }
    public string AddressStreet { get; }
    public string AddressCity { get; }
    public string AddressState { get; }
    public string AddressZipCode { get; }
    public string PhoneNumber { get; }
    public string Email { get; }
    public DateTime? DateOfBirth { get; }

    public ClerkPersonalDataSheetPerson(
        string firstName,
        string middleName,
        string lastName,
        string addressStreet,
        string addressCity,
        string addressState,
        string addressZipCode,
        string phoneNumber,
        string email,
        DateTime? dateOfBirth) {
        FirstName = firstName;
        MiddleName = middleName;
        LastName = lastName;
        AddressStreet = addressStreet;
        AddressCity = addressCity;
        AddressState = addressState;
        AddressZipCode = addressZipCode;
        PhoneNumber = phoneNumber;
        Email = email;
        DateOfBirth = dateOfBirth;
    }

    public ClerkPersonalDataSheetPerson(
        EnerGovLicenseInformation enerGovLicenseInformation) :
        this(enerGovLicenseInformation.ContactFirstName,
            enerGovLicenseInformation.ContactMiddleName,
            enerGovLicenseInformation.ContactLastName,
            enerGovLicenseInformation.ContactAddress_StreetAddress,
            enerGovLicenseInformation.ContactAddress_City,
            enerGovLicenseInformation.ContactAddress_State,
            enerGovLicenseInformation.ContactAddress_PostalCode,
            enerGovLicenseInformation.ContactHomePhone,
            enerGovLicenseInformation.ContactEmail,
            enerGovLicenseInformation.ContactDateOfBirth) { }

}