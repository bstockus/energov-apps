using EnerGov.Business.ClerksLicensing.RenewalPackets.Constants;
using EnerGov.Business.ClerksLicensing.RenewalPackets.Generators.Models;

namespace EnerGov.Business.ClerksLicensing.RenewalPackets.Generators.RecyclingFacility;

public static class EnerGovLicenseInformationRecyclingFacilityLicenseExtensions {

    public static bool IsRecyclingFacilityLicenseType(this EnerGovLicenseInformation enerGovLicenseInformation) =>
        enerGovLicenseInformation.IsOfLicenseType(EnerGovLicenseTypeConstants.RecyclingFacility);

    public static bool
        IsProcessingFacilityLicenseSubType(this EnerGovLicenseInformation enerGovLicenseInformation) =>
        (enerGovLicenseInformation.Recycling_ProcessingFacility ?? "").Equals(
            EnerGovRecyclingFacilityLicenseSubTypeConstants.ProcessingFacility);

    public static bool
        IsRecyclingCenterLicenseSubType(this EnerGovLicenseInformation enerGovLicenseInformation) =>
        (enerGovLicenseInformation.Recycling_RecyclingCenter ?? "").Equals(
            EnerGovRecyclingFacilityLicenseSubTypeConstants.RecyclingCenter);

    public static bool
        IsPickUpStationLicenseSubType(this EnerGovLicenseInformation enerGovLicenseInformation) =>
        (enerGovLicenseInformation.Recycling_PickUpStation ?? "").Equals(
            EnerGovRecyclingFacilityLicenseSubTypeConstants.PickUpStation);

    public static bool
        IsReverseVendingMachineLicenseSubType(this EnerGovLicenseInformation enerGovLicenseInformation) =>
        (enerGovLicenseInformation.Recycling_ReverseVendingMachine ?? "").Equals(
            EnerGovRecyclingFacilityLicenseSubTypeConstants.ReverseVendingMachine);

}