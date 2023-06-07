using EnerGov.Business.ClerksLicensing.RenewalPackets.Generators.Alcohol.Models;

namespace EnerGov.Business.ClerksLicensing.RenewalPackets.Generators.Models;

public static class EnerGovLicenseInformationClerksPersonExtension {

    public static ClerksPerson AsClerksPerson(this EnerGovLicenseInformation enerGovLicenseInformation) =>
        new(
            enerGovLicenseInformation.ContactLastName ?? "",
            enerGovLicenseInformation.ContactFirstName ?? "",
            enerGovLicenseInformation.ContactMiddleName ?? "",
            enerGovLicenseInformation.ContactAddress_CompleteAddress?.Replace("TOWN OF ", "")
                ?.Replace("VILLAGE OF ", "")?.Replace("CITY OF ", "") ?? "");

}