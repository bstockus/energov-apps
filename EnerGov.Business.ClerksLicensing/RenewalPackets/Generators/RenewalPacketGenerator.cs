using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Dapper;
using EnerGov.Business.ClerksLicensing.Helpers;
using EnerGov.Business.ClerksLicensing.RenewalPackets.Generators.Models;
using EnerGov.Business.ClerksLicensing.RenewalPackets.Generators.PersonalDataSheet;
using EnerGov.Data.EnerGov;
using EnerGov.Data.LandRecords;
using iText.Kernel.Geom;
using iText.Kernel.Pdf;
using Lax.Data.Sql;
using Lax.Helpers.AssemblyResources;
using Lax.Helpers.AsyncProgress;
using Lax.Helpers.SSRSReports;
using Microsoft.Extensions.Configuration;

namespace EnerGov.Business.ClerksLicensing.RenewalPackets.Generators;

public class RenewalPacketGenerator {

    private readonly IEnumerable<ILicenseRenewalFormGenerator> _licenseRenewalGenerators;
    private readonly ISqlConnectionProvider<EnerGovSqlServerConnection> _enerGovSqlConnectionProvider;
    private readonly ISqlConnectionProvider<LandRecordsSqlServerConnection> _landRecordsSqlConnectionProvider;
    private readonly IConfiguration _configuration;

    public RenewalPacketGenerator(
        IEnumerable<ILicenseRenewalFormGenerator> licenseRenewalGenerators,
        ISqlConnectionProvider<EnerGovSqlServerConnection> enerGovSqlConnectionProvider,
        ISqlConnectionProvider<LandRecordsSqlServerConnection> landRecordsSqlConnectionProvider,
        IConfiguration configuration) {
        _licenseRenewalGenerators = licenseRenewalGenerators;
        _enerGovSqlConnectionProvider = enerGovSqlConnectionProvider;
        _landRecordsSqlConnectionProvider = landRecordsSqlConnectionProvider;
        _configuration = configuration;
    }

    public async Task<byte[]> Generate(
        RenewalRequest renewalRequest,
        string reportEnvironment = "Production",
        string enerGovEnvironment = "Prod",
        IAsyncProgress<ReportGeneratorProgress> reportGeneratorProgress = null) {

        var ssrsConfiguration = new SSRSConfiguration {
            ReportServerUrl = _configuration.GetSection("Reporting")["ReportServerUrl"],
            ReportDomain = _configuration.GetSection("Reporting")["ReportDomain"],
            ReportUserName = _configuration.GetSection("Reporting")["ReportUserName"],
            ReportPassword = _configuration.GetSection("Reporting")["ReportPassword"]
        };

        var enerGovSqlConnection = await _enerGovSqlConnectionProvider.GetDbConnectionAsync();
        var landRecordsSqlConnection = await _landRecordsSqlConnectionProvider.GetDbConnectionAsync();

        if (reportGeneratorProgress != null) {
            await reportGeneratorProgress.Report(new ReportGeneratorProgress(1, "Loading Business Information..."));
        }

        var licenseRenewalGeneratorsTypeLookup =
            _licenseRenewalGenerators.ToDictionary(_ => _.FeeInformationType, _ => _);

        var releventTypeIds = new List<string>();
        var releventClassIds = new List<string>();
        var releventLicenseRenewalGenerators =
            new List<(ILicenseRenewalFormGenerator Generator, object RenewalFees, string Name)>();

        foreach (var renewalRequestFeeInformation in renewalRequest.FeeInformations) {
            if (!licenseRenewalGeneratorsTypeLookup.ContainsKey(renewalRequestFeeInformation.GetType())) {
                continue;
            }

            var licenseRenewalGenerator =
                licenseRenewalGeneratorsTypeLookup[renewalRequestFeeInformation.GetType()];

            releventTypeIds.AddRange(licenseRenewalGenerator.LicenseTypeIds);
            releventClassIds.AddRange(licenseRenewalGenerator.LicenseClassIds);
            releventLicenseRenewalGenerators.Add((licenseRenewalGenerator, renewalRequestFeeInformation,
                licenseRenewalGenerator.LicenseTypeName));
        }

        var deDupedReleventTypeIds = releventTypeIds.GroupBy(_ => _).Select(_ => _.Key);
        var deDupedReleventClassIds = releventClassIds.GroupBy(_ => _).Select(_ => _.Key);

        var enerGovBusinessInformation = (await enerGovSqlConnection.QueryAsync<EnerGovBusinessInformation>(
            await typeof(ClerksLicensingBusinessModule).Assembly.GetAssemblyResource(
                "EnerGovBusinessInformation.sql"),
            new {
                TaxYear = renewalRequest.PreviousLicenseYear,
                LicenseTypeIds = deDupedReleventTypeIds,
                LicenseClassIds = deDupedReleventClassIds
            })).ToList();

        if (reportGeneratorProgress != null) {
            await reportGeneratorProgress.Report(new ReportGeneratorProgress(3, "Loading Parcel Owners..."));
        }

        var parcelOwners = (await landRecordsSqlConnection.QueryAsync<ParcelOwnerInformation>(
                @"SELECT ParcelNumber, OwnerName, CompleteAddress, City, State, ZipCode FROM ParcelMailingAddresses")
            )
            .ToLookup(_ => _.ParcelNumber, _ => _).ToDictionary(_ => _.Key, _ => _.First());

        var totalItems = renewalRequest.IsFinalNoticeRunType()
            ? enerGovBusinessInformation.Count(_ => _.NumberOfRenewedLicenses == 0)
            : enerGovBusinessInformation.Count();
        var currentItemOffset = 1;

        var pdfs = new List<(string, IEnumerable<(int SortOrder, LicenseRenewalDocument Document)>)>();

        foreach (var enerGovBusiness in enerGovBusinessInformation.OrderBy(_ => _.CompanyName)) {
            if (renewalRequest.IsFinalNoticeRunType() &&
                enerGovBusiness.NumberOfRenewedLicenses > 0) {
                continue;
            }

            if (reportGeneratorProgress != null) {
                await reportGeneratorProgress.Report(new ReportGeneratorProgress(
                    (int) ((double) currentItemOffset / totalItems * 100.0d * 0.85d + 5.0d),
                    $"Generating Business Packet for {enerGovBusiness.CompanyName} " +
                    $"d/b/a {enerGovBusiness.TradeName} " +
                    $"({currentItemOffset}/{totalItems})..."));

                currentItemOffset++;
            }

            var enerGovLicenseInformation = (await enerGovSqlConnection.QueryAsync<EnerGovLicenseInformation>(
                await typeof(ClerksLicensingBusinessModule).Assembly.GetAssemblyResource(
                    "EnerGovLicenseInformation.sql"),
                new {
                    enerGovBusiness.BusinessId,
                    TaxYear = renewalRequest.PreviousLicenseYear
                })).ToList();

            if (!enerGovLicenseInformation.Any()) {
                continue;
            }

            var licenseRenewalFees = new List<(int SortOrder, LicenseRenewalFee Fee)>();
            var licenseRenewalDocuments = new List<(int SortOrder, LicenseRenewalDocument Document)>();

            foreach (var (generator, renewalFees, _) in releventLicenseRenewalGenerators.Where(
                         releventLicenseRenewalGenerator =>
                             releventLicenseRenewalGenerator.Generator
                                 .ReleventForAllLicenses(enerGovLicenseInformation))
                    ) {
                licenseRenewalFees.AddRange(
                    (await generator.RenewalFeesForAllLicense(renewalRequest,
                        renewalFees, enerGovLicenseInformation))
                    .Select(_ => (generator.SortOrder, _)).ToArray());

                if (renewalRequest.IsRenewalPacketRunType()) {
                    licenseRenewalDocuments.AddRange(
                        (await generator.RenewalDocumentsForAllLicense(renewalRequest,
                            renewalFees, enerGovLicenseInformation, parcelOwners))
                        .Select(_ => (generator.SortOrder, _)).ToArray());
                }
            }


            var businessLicenses =
                enerGovLicenseInformation.GroupBy(_ => (_.LicenseTypeName, _.LicenseClassName, _.LicenseNumber));

            foreach (var businessLicense in businessLicenses) {
                foreach (var (generator, renewalFees, _) in releventLicenseRenewalGenerators.Where(
                             releventLicenseRenewalGenerator =>
                                 releventLicenseRenewalGenerator.Generator.ReleventLicense(
                                     businessLicense.FirstOrDefault()))
                        ) {
                    licenseRenewalFees.AddRange(
                        (await generator.RenewalFeesForLicense(renewalRequest,
                            renewalFees, businessLicense))
                        .Select(_ => (generator.SortOrder, _)).ToArray());

                    if (renewalRequest.IsRenewalPacketRunType()) {
                        licenseRenewalDocuments.AddRange(
                            (await generator.RenewalDocumentsForLicense(renewalRequest,
                                renewalFees, businessLicense, parcelOwners))
                            .Select(_ => (generator.SortOrder, _)).ToArray());
                    }
                }
            }


            var licenseFeesHtml = new StringBuilder("<ul>");

            foreach (var (_, fee) in licenseRenewalFees.OrderBy(_ => _.SortOrder).ThenBy(_ => _.Fee.Name)) {
                licenseFeesHtml.Append(
                    $"<li>{fee.Name} <i>(Renewal Fee: <b>${fee.Amount + fee.PublicationFeeAmount:F2}</b>" +
                    $"{(fee.PublicationFeeAmount == 0.00m ? "" : " includes publication fee")})</i></li>");
            }

            licenseFeesHtml.Append("</ul>");


            if (renewalRequest.IsRenewalPacketRunType() ||
                renewalRequest.IsCoverLetterRunType()) {
                var coverLetterPdfBytes = await SsrsReportRunner.RenderReportAsPdf(ssrsConfiguration,
                    $"/EnerGov/{reportEnvironment}/{enerGovEnvironment}/_ClerksRenewalReports/Renewal%20Packet%20Cover%20Letter",
                    new {
                        enerGovBusiness.BusinessId,
                        TaxYear = renewalRequest.PreviousLicenseYear,
                        renewalRequest.CoverLetterDates.LetterDate,
                        renewalRequest.CoverLetterDates.ApplicationDueDate,
                        renewalRequest.CoverLetterDates.JADate,
                        renewalRequest.CoverLetterDates.CouncilDate,
                        renewalRequest.CoverLetterDates.PaymentDueDate,
                        renewalRequest.CoverLetterDates.MiscellaneousDueDate,
                        LicenseFees = licenseFeesHtml.ToString(),
                        TotalFee =
                            licenseRenewalFees.Sum(_ => _.Fee.Amount + _.Fee.PublicationFeeAmount).ToString("C2"),
                        IsAllMiscellaneous = licenseRenewalFees.Any(_ => _.Fee.IsNonMiscellaneousFee) ? "0" : "1"
                    });

                licenseRenewalDocuments.Add((1, new LicenseRenewalDocument("Cover Letter", coverLetterPdfBytes)));
            }

            if (renewalRequest.IsFinalNoticeRunType()) {
                var coverLetterPdfBytes = await SsrsReportRunner.RenderReportAsPdf(ssrsConfiguration,
                    $"/EnerGov/{reportEnvironment}/{enerGovEnvironment}/_ClerksRenewalReports/Renewal%20Packet%20Final%20Notice",
                    new {
                        enerGovBusiness.BusinessId,
                        TaxYear = renewalRequest.PreviousLicenseYear,
                        renewalRequest.CoverLetterDates.LetterDate,
                        renewalRequest.CoverLetterDates.ApplicationDueDate,
                        renewalRequest.CoverLetterDates.JADate,
                        renewalRequest.CoverLetterDates.CouncilDate,
                        renewalRequest.CoverLetterDates.PaymentDueDate,
                        renewalRequest.CoverLetterDates.MiscellaneousDueDate,
                        LicenseFees = licenseFeesHtml.ToString(),
                        TotalFee =
                            licenseRenewalFees.Sum(_ => _.Fee.Amount + _.Fee.PublicationFeeAmount).ToString("C2"),
                        IsAllMiscellaneous = licenseRenewalFees.Any(_ => _.Fee.IsNonMiscellaneousFee) ? "0" : "1"
                    });

                licenseRenewalDocuments.Add((1, new LicenseRenewalDocument("Final Notice", coverLetterPdfBytes)));
            }

            if (renewalRequest.IsRenewalPacketRunType()) {
                var addressVerificationPdfBytes = await SsrsReportRunner.RenderReportAsPdf(ssrsConfiguration,
                    $"/EnerGov/{reportEnvironment}/{enerGovEnvironment}/_ClerksRenewalReports/Renewal%20Packet%20Address%20Verification",
                    new {
                        enerGovBusiness.BusinessId,
                        TaxYear = renewalRequest.PreviousLicenseYear
                    });

                licenseRenewalDocuments.Add((5,
                    new LicenseRenewalDocument("Address Verification", addressVerificationPdfBytes)));
            }

            if (renewalRequest.IsPersonalDataSheetRunType()) {
                var personalDataSheet = await PersonalDataSheetGenerator.GeneratePersonalDataSheet(
                    enerGovLicenseInformation,
                    renewalRequest.IsPersonalDataSheetWithDateOfBirthRunType());
                if (personalDataSheet != null) {
                    licenseRenewalDocuments.Add(
                        (200,
                            new LicenseRenewalDocument(
                                "Personal Data Sheet",
                                personalDataSheet)));
                }
            }


            if (licenseRenewalDocuments.Any()) {
                pdfs.Add((enerGovBusiness.TradeName, licenseRenewalDocuments));
            }
        }


        if (reportGeneratorProgress != null) {
            await reportGeneratorProgress.Report(new ReportGeneratorProgress(90, "Merging documents..."));
        }

        var pdfBytes = await MergeDocuments(renewalRequest, pdfs);

        if (reportGeneratorProgress != null) {
            await reportGeneratorProgress.Report(new ReportGeneratorProgress(100, "Finished."));
        }

        return pdfBytes;
    }

    private static async Task<byte[]> MergeDocuments(RenewalRequest renewalRequest,
        List<(string, IEnumerable<(int SortOrder, LicenseRenewalDocument Document)>)> pdfs) {
        await using var memoryStream = new MemoryStream();

        await using var writer = new PdfWriter(memoryStream);
        writer.SetSmartMode(true);
        using var pdfDoc = new PdfDocument(writer);

        var outlineRoot = pdfDoc.GetOutlines(false);

        var pageNumber = 1;

        foreach (var pdfsAlphaGroup in pdfs.GroupBy(_ => _.Item1[0].ToString()).OrderBy(_ => _.Key)) {
            if (pageNumber % 2 != 1 && renewalRequest.AddBlankPagesForDoubleSidedPrinting) {
                pdfDoc.AddNewPage(PageSize.LETTER);
                pageNumber++;
            }


            var groupStartingPage = pageNumber;
            PdfOutline groupOutlineItem = null;

            foreach (var (alphaGroup, pdfEntries) in pdfsAlphaGroup) {
                if (pageNumber % 2 != 1 && renewalRequest.AddBlankPagesForDoubleSidedPrinting) {
                    pdfDoc.AddNewPage(PageSize.LETTER);
                    pageNumber++;
                }


                var businessStartingPage = pageNumber;
                var outlineEntries = new List<(string, int)>();

                foreach (var (_, (title, pdfData)) in pdfEntries.OrderBy(_ => _.SortOrder)
                             .ThenBy(_ => _.Document.Title)) {
                    if (pageNumber % 2 != 1 && renewalRequest.AddBlankPagesForDoubleSidedPrinting) {
                        pdfDoc.AddNewPage(PageSize.LETTER);
                        pageNumber++;
                    }

                    outlineEntries.Add((title, pageNumber));

                    var documentPages = PdfHelper.AppendPagesFromPdf(pdfData, pdfDoc);
                    pageNumber += documentPages;
                }

                groupOutlineItem ??=
                    outlineRoot.AddOutlineActionToPage(pdfDoc, pdfsAlphaGroup.Key, groupStartingPage);

                var outlineItem = groupOutlineItem.AddOutlineActionToPage(pdfDoc, alphaGroup, businessStartingPage);

                foreach (var (outlineEntryTitle, outlineEntryPageNumber) in outlineEntries) {
                    outlineItem.AddOutlineActionToPage(pdfDoc, outlineEntryTitle, outlineEntryPageNumber);
                }
            }
        }


        pdfDoc.Close();
        return memoryStream.ToArray();
    }

}