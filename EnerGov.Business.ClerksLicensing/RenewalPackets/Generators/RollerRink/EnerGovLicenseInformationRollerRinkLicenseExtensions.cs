using EnerGov.Business.ClerksLicensing.RenewalPackets.Constants;
using EnerGov.Business.ClerksLicensing.RenewalPackets.Generators.Models;

namespace EnerGov.Business.ClerksLicensing.RenewalPackets.Generators.RollerRink;

public static class EnerGovLicenseInformationRollerRinkLicenseExtensions {

    public static bool IsRollerRinkLicenseType(this EnerGovLicenseInformation enerGovLicenseInformation) =>
        enerGovLicenseInformation.IsOfLicenseType(EnerGovLicenseTypeConstants.RollerRink);

}