using System;
using System.Collections.Generic;
using System.Data.Common;
using System.Threading;
using System.Threading.Tasks;
using EnerGov.Business.ClerksLicensing.RenewalPackets.Generators.Models;

namespace EnerGov.Business.ClerksLicensing.RenewalPackets.Generators;

public interface ILicenseRenewalFormGenerator {

    string LicenseTypeName { get; }
    string[] LicenseTypeIds { get; }
    string[] LicenseClassIds { get; }
    Type FeeInformationType { get; }
    int SortOrder { get; }

    bool ReleventLicense(EnerGovLicenseInformation enerGovLicenseInformation);
    bool ReleventForAllLicenses(IEnumerable<EnerGovLicenseInformation> enerGovLicenseInformations);

    Task<IEnumerable<LicenseRenewalFee>> RenewalFeesForLicense(RenewalRequest renewalRequest,
        object feeInformation, IEnumerable<EnerGovLicenseInformation> enerGovLicenseInformations);

    Task<IEnumerable<LicenseRenewalDocument>> RenewalDocumentsForLicense(RenewalRequest renewalRequest,
        object feeInformation,
        IEnumerable<EnerGovLicenseInformation> enerGovLicenseInformations,
        IDictionary<string, ParcelOwnerInformation> parcelOwners);

    Task<IEnumerable<LicenseRenewalFee>> RenewalFeesForAllLicense(RenewalRequest renewalRequest,
        object feeInformation, IEnumerable<EnerGovLicenseInformation> enerGovLicenseInformations);

    Task<IEnumerable<LicenseRenewalDocument>> RenewalDocumentsForAllLicense(RenewalRequest renewalRequest,
        object feeInformation,
        IEnumerable<EnerGovLicenseInformation> enerGovLicenseInformations,
        IDictionary<string, ParcelOwnerInformation> parcelOwners);

    object DefaultFeesForLicense();

    Task<object> CurrentFeesForLicense(
        DbConnection sqlConnection,
        string licenseYear,
        CancellationToken cancellationToken);

}

public record LicenseRenewalFee(
    string Name,
    decimal Amount,
    decimal PublicationFeeAmount = 0.00m,
    bool IsNonMiscellaneousFee = false);

public record LicenseRenewalDocument(
    string Title,
    byte[] PdfData);

public record RenewalRequest(
    int PreviousLicenseYear,
    IEnumerable<object> FeeInformations,
    string RunType,
    bool AddBlankPagesForDoubleSidedPrinting,
    CoverLetterDates CoverLetterDates) {

    public static string RenewalPacketRunType = "Renewal Packet";
    public static string CoverLetterOnlyRunType = "Cover Letter Only";
    public static string PersonalDataSheetWithDateOfBirthsRunType = "Personal Data Sheet w/ DoB";
    public static string PersonalDataSheetWithOutDateOfBirthsRunType = "Personal Data Sheet w/o DoB";
    public static string FinalNoticeRunType = "Final Notice";

    public bool IsFinalNoticeRunType() => RunType.Equals(FinalNoticeRunType);

    public bool IsRenewalPacketRunType() => RunType.Equals(RenewalPacketRunType);
    public bool IsCoverLetterRunType() => RunType.Equals(CoverLetterOnlyRunType);

    public bool IsPersonalDataSheetRunType() => RunType.Equals(PersonalDataSheetWithDateOfBirthsRunType) ||
                                                RunType.Equals(PersonalDataSheetWithOutDateOfBirthsRunType) ||
                                                RunType.Equals(RenewalPacketRunType);

    public bool IsPersonalDataSheetWithDateOfBirthRunType() =>
        RunType.Equals(PersonalDataSheetWithDateOfBirthsRunType);

}

public interface ILicenseRenewalFormGenerator<TFeeInformation> : ILicenseRenewalFormGenerator
    where TFeeInformation : class {

    TFeeInformation DefaultFees { get; }

    Task<IEnumerable<LicenseRenewalFee>> RenewalFees(
        RenewalRequest renewalRequest,
        TFeeInformation feeInformation,
        IEnumerable<EnerGovLicenseInformation> enerGovLicenseInformations);

    Task<IEnumerable<LicenseRenewalDocument>> RenewalDocuments(
        RenewalRequest renewalRequest,
        TFeeInformation feeInformation,
        IEnumerable<EnerGovLicenseInformation> enerGovLicenseInformations,
        IDictionary<string, ParcelOwnerInformation> parcelOwners);

}