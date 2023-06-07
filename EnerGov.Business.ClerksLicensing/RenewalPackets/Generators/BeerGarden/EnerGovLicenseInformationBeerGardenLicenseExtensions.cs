using EnerGov.Business.ClerksLicensing.RenewalPackets.Constants;
using EnerGov.Business.ClerksLicensing.RenewalPackets.Generators.Models;

namespace EnerGov.Business.ClerksLicensing.RenewalPackets.Generators.BeerGarden;

public static class EnerGovLicenseInformationBeerGardenLicenseExtensions {

    public static bool IsBeerGardenLicenseType(this EnerGovLicenseInformation enerGovLicenseInformation) =>
        enerGovLicenseInformation.IsOfLicenseType(EnerGovLicenseTypeConstants.BeerGarden);

    public static bool IsClassATavernLicenseClass(this EnerGovLicenseInformation enerGovLicenseInformation) =>
        enerGovLicenseInformation.IsOfLicenseClass(EnerGovLicenseClassConstants.ClassATavern);

    public static bool IsClassBRestaurantLicenseClass(this EnerGovLicenseInformation enerGovLicenseInformation) =>
        enerGovLicenseInformation.IsOfLicenseClass(EnerGovLicenseClassConstants.ClassBRestaurant);

    public static bool IsClassCRecreationalLicenseClass(this EnerGovLicenseInformation enerGovLicenseInformation) =>
        enerGovLicenseInformation.IsOfLicenseClass(EnerGovLicenseClassConstants.ClassCRecreational);

    public static bool IsClassDRestaurantLicenseClass(this EnerGovLicenseInformation enerGovLicenseInformation) =>
        enerGovLicenseInformation.IsOfLicenseClass(EnerGovLicenseClassConstants.ClassDRestaurant);

}