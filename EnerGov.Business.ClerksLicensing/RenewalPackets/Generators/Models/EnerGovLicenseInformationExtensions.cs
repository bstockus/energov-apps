namespace EnerGov.Business.ClerksLicensing.RenewalPackets.Generators.Models;

public static class EnerGovLicenseInformationExtensions {

    public static bool IsOfLicenseType(this EnerGovLicenseInformation enerGovLicenseInformation,
        string licenseTypeId) =>
        enerGovLicenseInformation.LicenseTypeId.ToUpper().Equals(licenseTypeId.ToUpper());

    public static bool IsOfLicenseClass(this EnerGovLicenseInformation enerGovLicenseInformation,
        string licenseClassId) =>
        enerGovLicenseInformation.LicenseClassId.ToUpper().Equals(licenseClassId.ToUpper());

    public static bool IsOfContactType(this EnerGovLicenseInformation enerGovLicenseInformation,
        string contactTypeId) =>
        enerGovLicenseInformation.ContactTypeId.ToUpper().Equals(contactTypeId.ToUpper());

    public static bool IsOfClerksCompanyType(this EnerGovLicenseInformation enerGovLicenseInformation,
        string clerksCompanyTypeId) =>
        enerGovLicenseInformation.ClerksCompanyTypeId.ToUpper().Equals(clerksCompanyTypeId.ToUpper());

}