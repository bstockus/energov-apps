using EnerGov.Business.ClerksLicensing.RenewalPackets.Constants;
using EnerGov.Business.ClerksLicensing.RenewalPackets.Generators.Models;

namespace EnerGov.Business.ClerksLicensing.RenewalPackets.Generators.Secondhand;

public static class EnerGovLicenseInformationSecondHandLicenseExtensions {

    public static bool IsSecondhandLicenseType(this EnerGovLicenseInformation enerGovLicenseInformation) =>
        enerGovLicenseInformation.IsOfLicenseType(EnerGovLicenseTypeConstants.Secondhand);

    public static bool IsPawnbrokerLicenseType(this EnerGovLicenseInformation enerGovLicenseInformation) =>
        enerGovLicenseInformation.IsOfLicenseType(EnerGovLicenseTypeConstants.Pawnbroker);

    public static bool IsMallFleaMarketLicenseType(this EnerGovLicenseInformation enerGovLicenseInformation) =>
        enerGovLicenseInformation.IsOfLicenseType(EnerGovLicenseTypeConstants.MallFleaMarket);

    public static bool
        IsSecondhandJewelryLicenseSubClass(this EnerGovLicenseInformation enerGovLicenseInformation) =>
        (enerGovLicenseInformation.Secondhand_Jewelry ?? "").Equals(
            EnerGovSecondhandLicenseSubTypeConstants.Jewelry);

    public static bool
        IsSecondhandArticleLicenseSubClass(this EnerGovLicenseInformation enerGovLicenseInformation) =>
        (enerGovLicenseInformation.Secondhand_Article ?? "").Equals(
            EnerGovSecondhandLicenseSubTypeConstants.Article);

}