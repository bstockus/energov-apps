using EnerGov.Business.ClerksLicensing.RenewalPackets.Constants;

namespace EnerGov.Business.ClerksLicensing.RenewalPackets.Generators.Models;

public static class EnerGovLicenseInformationContactTypeExtensions {

    public static bool IsAgentContactType(this EnerGovLicenseInformation enerGovLicenseInformation) =>
        enerGovLicenseInformation.IsOfContactType(EnerGovBusinessContactTypeConstants.Agent);

    public static bool IsApplicantContactType(this EnerGovLicenseInformation enerGovLicenseInformation) =>
        enerGovLicenseInformation.IsOfContactType(EnerGovBusinessContactTypeConstants.Applicant);

    public static bool IsBusinessContactType(this EnerGovLicenseInformation enerGovLicenseInformation) =>
        enerGovLicenseInformation.IsOfContactType(EnerGovBusinessContactTypeConstants.Business);

    public static bool IsDirectorContactType(this EnerGovLicenseInformation enerGovLicenseInformation) =>
        enerGovLicenseInformation.IsOfContactType(EnerGovBusinessContactTypeConstants.Director);

    public static bool IsIndividualContactType(this EnerGovLicenseInformation enerGovLicenseInformation) =>
        enerGovLicenseInformation.IsOfContactType(EnerGovBusinessContactTypeConstants.Individual);

    public static bool IsManagerContactType(this EnerGovLicenseInformation enerGovLicenseInformation) =>
        enerGovLicenseInformation.IsOfContactType(EnerGovBusinessContactTypeConstants.Manager);

    public static bool IsMemberContactType(this EnerGovLicenseInformation enerGovLicenseInformation) =>
        enerGovLicenseInformation.IsOfContactType(EnerGovBusinessContactTypeConstants.Member);

    public static bool IsOwnerContactType(this EnerGovLicenseInformation enerGovLicenseInformation) =>
        enerGovLicenseInformation.IsOfContactType(EnerGovBusinessContactTypeConstants.Owner);

    public static bool IsPartnerContactType(this EnerGovLicenseInformation enerGovLicenseInformation) =>
        enerGovLicenseInformation.IsOfContactType(EnerGovBusinessContactTypeConstants.Partner);

    public static bool IsPresidentContactType(this EnerGovLicenseInformation enerGovLicenseInformation) =>
        enerGovLicenseInformation.IsOfContactType(EnerGovBusinessContactTypeConstants.President);

    public static bool IsSecretaryContactType(this EnerGovLicenseInformation enerGovLicenseInformation) =>
        enerGovLicenseInformation.IsOfContactType(EnerGovBusinessContactTypeConstants.Secretary);

    public static bool IsTreasurerContactType(this EnerGovLicenseInformation enerGovLicenseInformation) =>
        enerGovLicenseInformation.IsOfContactType(EnerGovBusinessContactTypeConstants.Treasurer);

    public static bool IsVicePresidentContactType(this EnerGovLicenseInformation enerGovLicenseInformation) =>
        enerGovLicenseInformation.IsOfContactType(EnerGovBusinessContactTypeConstants.VicePresident);

}