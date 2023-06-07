using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Common;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Threading.Tasks;
using Dapper;
using EnerGov.Business.ClerksLicensing.Helpers;
using EnerGov.Data.EnerGov;
using iText.Kernel.Pdf;
using Lax.Data.Sql;
using Lax.Helpers.AssemblyResources;
using Lax.Helpers.AsyncProgress;
using Lax.Helpers.SSRSReports;
using Microsoft.Extensions.Configuration;

namespace EnerGov.Business.ClerksLicensing.LicensePackets;

public class LicensePacketGenerator {

    private readonly ISqlConnectionProvider<EnerGovSqlServerConnection> _enerGovSqlConnectionProvider;
    private readonly IConfiguration _configuration;

    public LicensePacketGenerator(
        ISqlConnectionProvider<EnerGovSqlServerConnection> enerGovSqlConnectionProvider,
        IConfiguration configuration) {
        _enerGovSqlConnectionProvider = enerGovSqlConnectionProvider;
        _configuration = configuration;
    }

    private static async Task<IEnumerable<LicensePacketInfo>> FetchLicensePacketInfo(
        IDbConnection enerGovSqlConnection,
        LicensePacketRequest licensePacketRequest) => await enerGovSqlConnection.QueryAsync<LicensePacketInfo>(
        await typeof(ClerksLicensingBusinessModule).Assembly.GetAssemblyResource(
            "LicensePacketInfo.sql"),
        new {
            licensePacketRequest.TaxYear,
            licensePacketRequest.LicenseTypeIds,
            licensePacketRequest.LicenseStatusIds
        });

    public async Task<IEnumerable<LicensePacketInfo>> Fetch(
        LicensePacketRequest licensePacketRequest) {

        var enerGovSqlConnection = await _enerGovSqlConnectionProvider.GetDbConnectionAsync();

        return await FetchLicensePacketInfo(
            enerGovSqlConnection,
            licensePacketRequest);

    }

    public async Task<byte[]> Generate(
        LicensePacketRequest licensePacketRequest,
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

        if (reportGeneratorProgress != null) {
            await reportGeneratorProgress.Report(new ReportGeneratorProgress(1, "Loading Business Information..."));
        }

        var licenseInfos = await FetchLicensePacketInfo(
            enerGovSqlConnection,
            licensePacketRequest);

        var licenseBusinessGroups = licenseInfos.GroupBy(_ => _.BusinessId);

        var licenseDocuments = new List<byte[]>();

        var totalBusinesses = licenseBusinessGroups.Select(_ => _.Key).Count();
        var currentIndex = 1;

        foreach (var licenseBusinessGroup in licenseBusinessGroups) {

            if (reportGeneratorProgress != null) {
                await reportGeneratorProgress.Report(new ReportGeneratorProgress(
                    (int)((double)currentIndex / totalBusinesses * 100.0d * 0.85d + 5.0d),
                    $"Generating License for {licenseBusinessGroup.First().CompanyName} " +
                    $"d/b/a {licenseBusinessGroup.First().DBA} " +
                    $"({currentIndex}/{totalBusinesses})..."));

                currentIndex++;
            }

            var licensePdfBytes = await SsrsReportRunner.RenderReportAsPdf(
                ssrsConfiguration,
                $"/EnerGov/{reportEnvironment}/{enerGovEnvironment}/_InAppReports/ClerksBusinessLicense",
                new {
                    GLOBALENTITYID = licenseBusinessGroup.Key,
                    LICENSEYEAR = licensePacketRequest.TaxYear,
                    GrantedDate = licensePacketRequest.GrantedDate.ToString(CultureInfo.InvariantCulture),
                    LicenseIds = licenseBusinessGroup.Select(_ => _.LicenseId).ToArray()
                });

            licenseDocuments.Add(licensePdfBytes);

        }

        if (reportGeneratorProgress != null) {
            await reportGeneratorProgress.Report(new ReportGeneratorProgress(95, "Merging PDFs..."));
        }

        await using var memoryStream = new MemoryStream();

        await using var writer = new PdfWriter(memoryStream);
        writer.SetSmartMode(true);
        using var pdfDoc = new PdfDocument(writer);

        foreach (var licenseDocument in licenseDocuments) {
            PdfHelper.AppendPagesFromPdf(licenseDocument, pdfDoc);
        }

        pdfDoc.Close();

        if (reportGeneratorProgress != null) {
            await reportGeneratorProgress.Report(new ReportGeneratorProgress(100, "Finished."));
        }


        return memoryStream.ToArray();

    }

    public record LicensePacketRequest(
        int TaxYear,
        string[] LicenseTypeIds,
        string[] LicenseStatusIds,
        DateTime GrantedDate);

    public record LicensePacketInfo {
        public string LicenseNumber { get; set; }
        public string DBA { get; set; }
        public string BusinessNumber { get; set; }
        public string CompanyNumber { get; set; }
        public string CompanyName { get; set; }
        public string LicenseTypeName { get; set; }
        public string LicenseClassName { get; set; }
        public DateTime? IssuedDate { get; set; }
        public DateTime? ExpirationDate { get; set; }
        public string DisplayName { get; set; }
        public string BusinessId { get; set; }
        public string LicenseId { get; set; }

    }

}