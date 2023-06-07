using EnerGov.Business.ClerksLicensing.RenewalPackets.Constants;
using EnerGov.Business.ClerksLicensing.RenewalPackets.Generators.Models;

namespace EnerGov.Business.ClerksLicensing.RenewalPackets.Generators.Alcohol;

public static class EnerGovLicenseInformationAlcoholLicenseExtensions {

    public static bool IsAlcoholLicenseType(this EnerGovLicenseInformation enerGovLicenseInformation) =>
        enerGovLicenseInformation.IsOfLicenseType(EnerGovLicenseTypeConstants.Alcohol);

    public static bool IsClassALiquorLicenseClass(this EnerGovLicenseInformation enerGovLicenseInformation) =>
        enerGovLicenseInformation.IsOfLicenseClass(EnerGovLicenseClassConstants.ClassALiquor) ||
        enerGovLicenseInformation.IsOfLicenseClass(EnerGovLicenseClassConstants.ClassABeerAndClassALiquor);

    public static bool IsClassBWineryLicenseClass(this EnerGovLicenseInformation enerGovLicenseInformation) =>
        enerGovLicenseInformation.IsOfLicenseClass(EnerGovLicenseClassConstants.ClassBWinery);

    public static bool IsClassCWineLicenseClass(this EnerGovLicenseInformation enerGovLicenseInformation) =>
        enerGovLicenseInformation.IsOfLicenseClass(EnerGovLicenseClassConstants.ClassCWine) ||
        enerGovLicenseInformation.IsOfLicenseClass(EnerGovLicenseClassConstants.ClassBBeerAndClassCWine);

    public static bool IsClassABeerLicenseClass(this EnerGovLicenseInformation enerGovLicenseInformation) =>
        enerGovLicenseInformation.IsOfLicenseClass(EnerGovLicenseClassConstants.ClassABeer) ||
        enerGovLicenseInformation.IsOfLicenseClass(EnerGovLicenseClassConstants.ClassABeerAndClassALiquor);

    public static bool IsClassBBeerLicenseClass(this EnerGovLicenseInformation enerGovLicenseInformation) =>
        enerGovLicenseInformation.IsOfLicenseClass(EnerGovLicenseClassConstants.ClassBBeer) ||
        enerGovLicenseInformation.IsOfLicenseClass(EnerGovLicenseClassConstants.ClassBBeerAndClassCWine);

    public static bool IsCombinationClassBBeerAndLiquorLicenseClass(
        this EnerGovLicenseInformation enerGovLicenseInformation) =>
        enerGovLicenseInformation.IsOfLicenseClass(EnerGovLicenseClassConstants.CombinationClassBBeerAndLiquor);

    public static bool IsCombinationClassBBeerAndLiquorReserveLicenseClass(
        this EnerGovLicenseInformation enerGovLicenseInformation) =>
        enerGovLicenseInformation.IsOfLicenseClass(EnerGovLicenseClassConstants.CombinationClassBBeerAndLiquorReserve);

}