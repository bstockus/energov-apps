using System.Threading.Tasks;

namespace EnerGov.Services.Reporting {

    public interface IReportRenderingService {

        Task<byte[]> RenderReportAsPdf(string reportPath, object reportParams);

    }

}
