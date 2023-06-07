using EnerGov.Business.ClerksLicensing.RenewalPackets.Constants;
using EnerGov.Business.ClerksLicensing.RenewalPackets.Generators.Models;

namespace EnerGov.Business.ClerksLicensing.RenewalPackets.Generators.JunkDealer;

public static class EnerGovLicenseInformationJunkDealerLicenseExtensions {

    public static bool IsJunkDealerLicenseType(this EnerGovLicenseInformation enerGovLicenseInformation) =>
        enerGovLicenseInformation.IsOfLicenseType(EnerGovLicenseTypeConstants.JunkDealer);

    public static bool IsJunkDealerLicenseSubType(this EnerGovLicenseInformation enerGovLicenseInformation) =>
        (enerGovLicenseInformation.JunkDealerLicenseType ?? "").Equals(EnerGovJunkDealerLicenseSubTypeConstants
            .JunkDealer);

    public static bool IsItinerantJunkDealerLicenseSubType(this EnerGovLicenseInformation enerGovLicenseInformation) =>
        (enerGovLicenseInformation.JunkDealerLicenseType ?? "").Equals(EnerGovJunkDealerLicenseSubTypeConstants
            .ItinerantJunkDealer);

}