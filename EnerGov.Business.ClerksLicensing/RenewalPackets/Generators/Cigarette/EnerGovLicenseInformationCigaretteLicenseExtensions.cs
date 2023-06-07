using EnerGov.Business.ClerksLicensing.RenewalPackets.Constants;
using EnerGov.Business.ClerksLicensing.RenewalPackets.Generators.Models;

namespace EnerGov.Business.ClerksLicensing.RenewalPackets.Generators.Cigarette;

public static class EnerGovLicenseInformationCigaretteLicenseExtensions {

    public static bool IsCigaretteLicenseType(this EnerGovLicenseInformation enerGovLicenseInformation) =>
        enerGovLicenseInformation.IsOfLicenseType(EnerGovLicenseTypeConstants.Cigarette);

    public static bool IsOverTheCounterLicenseClass(this EnerGovLicenseInformation enerGovLicenseInformation) =>
        enerGovLicenseInformation.IsOfLicenseClass(EnerGovLicenseClassConstants.OverTheCounter);

    public static bool IsVendingMachineLicenseClass(this EnerGovLicenseInformation enerGovLicenseInformation) =>
        enerGovLicenseInformation.IsOfLicenseClass(EnerGovLicenseClassConstants.VendingMachine);

    public static bool IsBothCigaretteLicenseClass(this EnerGovLicenseInformation enerGovLicenseInformation) =>
        enerGovLicenseInformation.IsOfLicenseClass(EnerGovLicenseClassConstants.Both);

}