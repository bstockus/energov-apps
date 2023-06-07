using System.Linq;
using System.Net;
using System.Net.Http;
using System.Reflection;
using System.Threading.Tasks;
using Microsoft.Extensions.Options;

namespace EnerGov.Services.Reporting.SSRS {

    public class SSRSReportRenderingService : IReportRenderingService {

        private readonly IOptions<SSRSConfiguration> _ssrsConfigurationOptions;

        public SSRSReportRenderingService(
            IOptions<SSRSConfiguration> ssrsConfigurationOptions) {

            _ssrsConfigurationOptions = ssrsConfigurationOptions;
        }

        public async Task<byte[]> RenderReportAsPdf(string reportPath, object reportParams) {
            
            var configurationOptions = _ssrsConfigurationOptions.Value;

            var reportParamsFields = reportParams.GetType().GetProperties(BindingFlags.Public | BindingFlags.Instance);

            var reportUrl = $"{configurationOptions.ReportServerUrl}{reportPath}" +
                            $"{reportParamsFields.Aggregate("", (s, info) => $"{s}&{info.Name}={info.GetValue(reportParams).ToString()}&rs:Format=PDF")}";

            var httpClientHandler = new HttpClientHandler {
                Credentials = string.IsNullOrWhiteSpace(configurationOptions.ReportUserName)
                    ? CredentialCache.DefaultNetworkCredentials
                    : new NetworkCredential(
                        configurationOptions.ReportUserName,
                        configurationOptions.ReportPassword,
                        configurationOptions.ReportDomain)
            };

            using (var httpClient = new HttpClient(httpClientHandler)) {

                return await httpClient.GetByteArrayAsync(reportUrl);

            }

        }

    }

}