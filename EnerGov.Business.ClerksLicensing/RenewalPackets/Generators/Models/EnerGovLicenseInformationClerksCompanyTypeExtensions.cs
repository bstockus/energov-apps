using EnerGov.Business.ClerksLicensing.RenewalPackets.Constants;

namespace EnerGov.Business.ClerksLicensing.RenewalPackets.Generators.Models;

public static class EnerGovLicenseInformationClerksCompanyTypeExtensions {

    public static bool IsCorporationClerksCompanyType(this EnerGovLicenseInformation enerGovLicenseInformation) =>
        enerGovLicenseInformation.IsOfClerksCompanyType(EnerGovClerksCompanyTypeConstants.Corporation);

    public static bool IsNonProfitOrganizationClerksCompanyType(
        this EnerGovLicenseInformation enerGovLicenseInformation) =>
        enerGovLicenseInformation.IsOfClerksCompanyType(EnerGovClerksCompanyTypeConstants.NonProfitOrganization);

    public static bool IsPartnershipClerksCompanyType(this EnerGovLicenseInformation enerGovLicenseInformation) =>
        enerGovLicenseInformation.IsOfClerksCompanyType(EnerGovClerksCompanyTypeConstants.Partnership);

    public static bool IsLimitedLiabilityCorporationClerksCompanyType(
        this EnerGovLicenseInformation enerGovLicenseInformation) =>
        enerGovLicenseInformation.IsOfClerksCompanyType(EnerGovClerksCompanyTypeConstants.LimitedLiabilityCorporation);

    public static bool IsIndividualClerksCompanyType(this EnerGovLicenseInformation enerGovLicenseInformation) =>
        enerGovLicenseInformation.IsOfClerksCompanyType(EnerGovClerksCompanyTypeConstants.Individual);

}