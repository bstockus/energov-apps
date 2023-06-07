using EnerGov.Business.ClerksLicensing.RenewalPackets.Constants;
using EnerGov.Business.ClerksLicensing.RenewalPackets.Generators.Models;

namespace EnerGov.Business.ClerksLicensing.RenewalPackets.Generators.Cabaret;

public static class EnerGovLicenseInformationCabaretLicenseExtensions {

    public static bool IsCabaretLicenseType(this EnerGovLicenseInformation enerGovLicenseInformation) =>
        enerGovLicenseInformation.IsOfLicenseType(EnerGovLicenseTypeConstants.Cabaret);

    public static bool IsIndoorCabaretLicenseClass(this EnerGovLicenseInformation enerGovLicenseInformation) =>
        enerGovLicenseInformation.IsOfLicenseClass(EnerGovLicenseClassConstants.IndoorCabaret);

    public static bool IsOutdoorCabaretLicenseClass(this EnerGovLicenseInformation enerGovLicenseInformation) =>
        enerGovLicenseInformation.IsOfLicenseClass(EnerGovLicenseClassConstants.OutdoorCabaret);

}