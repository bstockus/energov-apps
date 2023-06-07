using EnerGov.Business.ClerksLicensing.RenewalPackets.Constants;
using EnerGov.Business.ClerksLicensing.RenewalPackets.Generators.Models;

namespace EnerGov.Business.ClerksLicensing.RenewalPackets.Generators.WasteHauler;

public static class EnerGovLicenseInformationWasteHaulerLicenseExtensions {

    public static bool IsWasteHaulerLicenseType(this EnerGovLicenseInformation enerGovLicenseInformation) =>
        enerGovLicenseInformation.IsOfLicenseType(EnerGovLicenseTypeConstants.WasteHauler);

    public static bool
        IsEngagedInCleaningWasteHaulerQuestion(this EnerGovLicenseInformation enerGovLicenseInformation) =>
        (enerGovLicenseInformation.EngagedInCleaningWasteQuestion ?? "").Equals(
            EnerGovWasteHaulerLicenseEngagedInCleaningWasteQuestionConstants.Yes);

    public static bool
        IsNotEngagedInCleaningWasteHaulerQuestion(this EnerGovLicenseInformation enerGovLicenseInformation) =>
        (enerGovLicenseInformation.EngagedInCleaningWasteQuestion ?? "").Equals(
            EnerGovWasteHaulerLicenseEngagedInCleaningWasteQuestionConstants.No);

}