using System;
using System.Collections.Generic;
using System.Data.Common;
using System.Threading;
using System.Threading.Tasks;
using EnerGov.Business.ClerksLicensing.RenewalPackets.Generators.Models;

namespace EnerGov.Business.ClerksLicensing.RenewalPackets.Generators;

public abstract class LicenseRenewalFormGenerator<TFeeInformation> : ILicenseRenewalFormGenerator<TFeeInformation>
    where TFeeInformation : class {

    public abstract string LicenseTypeName { get; }
    public abstract string[] LicenseTypeIds { get; }
    public abstract string[] LicenseClassIds { get; }
    public Type FeeInformationType => typeof(TFeeInformation);
    public abstract int SortOrder { get; }
    public abstract bool ReleventLicense(EnerGovLicenseInformation enerGovLicenseInformation);

    public virtual bool ReleventForAllLicenses(IEnumerable<EnerGovLicenseInformation> enerGovLicenseInformations) =>
        false;

    public abstract TFeeInformation DefaultFees { get; }

    public abstract Task<IEnumerable<LicenseRenewalFee>> RenewalFees(RenewalRequest renewalRequest,
        TFeeInformation feeInformation, IEnumerable<EnerGovLicenseInformation> enerGovLicenseInformations);

    public abstract Task<IEnumerable<LicenseRenewalDocument>> RenewalDocuments(RenewalRequest renewalRequest,
        TFeeInformation feeInformation,
        IEnumerable<EnerGovLicenseInformation> enerGovLicenseInformations,
        IDictionary<string, ParcelOwnerInformation> parcelOwners);

    public async Task<IEnumerable<LicenseRenewalFee>> RenewalFeesForLicense(RenewalRequest renewalRequest,
        object feeInformation, IEnumerable<EnerGovLicenseInformation> enerGovLicenseInformations) =>
        await RenewalFees(
            renewalRequest,
            feeInformation as TFeeInformation,
            enerGovLicenseInformations);

    public async Task<IEnumerable<LicenseRenewalDocument>> RenewalDocumentsForLicense(RenewalRequest renewalRequest,
        object feeInformation,
        IEnumerable<EnerGovLicenseInformation> enerGovLicenseInformations,
        IDictionary<string, ParcelOwnerInformation> parcelOwners) =>
        await RenewalDocuments(
            renewalRequest,
            feeInformation as TFeeInformation,
            enerGovLicenseInformations,
            parcelOwners);

    public virtual async Task<IEnumerable<LicenseRenewalFee>> AllRenewalFees(
        RenewalRequest renewalRequest,
        TFeeInformation feeInformation,
        IEnumerable<EnerGovLicenseInformation> enerGovLicenseInformations) =>
        await Task.FromResult(Array.Empty<LicenseRenewalFee>());

    public virtual async Task<IEnumerable<LicenseRenewalDocument>> AllRenewalDocuments(
        RenewalRequest renewalRequest,
        TFeeInformation feeInformation,
        IEnumerable<EnerGovLicenseInformation> enerGovLicenseInformations,
        IDictionary<string, ParcelOwnerInformation> parcelOwners) =>
        await Task.FromResult(Array.Empty<LicenseRenewalDocument>());

    public async Task<IEnumerable<LicenseRenewalFee>> RenewalFeesForAllLicense(
        RenewalRequest renewalRequest, object feeInformation,
        IEnumerable<EnerGovLicenseInformation> enerGovLicenseInformations) =>
        await AllRenewalFees(
            renewalRequest,
            feeInformation as TFeeInformation,
            enerGovLicenseInformations);

    public async Task<IEnumerable<LicenseRenewalDocument>> RenewalDocumentsForAllLicense(
        RenewalRequest renewalRequest, object feeInformation,
        IEnumerable<EnerGovLicenseInformation> enerGovLicenseInformations,
        IDictionary<string, ParcelOwnerInformation> parcelOwners) =>
        await AllRenewalDocuments(
            renewalRequest,
            feeInformation as TFeeInformation,
            enerGovLicenseInformations,
            parcelOwners);

    public object DefaultFeesForLicense() => DefaultFees;

    public virtual async Task<object> CurrentFeesForLicense(
        DbConnection sqlConnection,
        string licenseYear,
        CancellationToken cancellationToken) => await Task.FromResult(DefaultFees);

}