using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading;
using System.Threading.Tasks;
using EnerGov.Business.Exports;
using EnerGov.Business.Exports.MarketDrive;
using EnerGov.Security.User;
using EnerGov.Web.Common.Infrastructure;
using MediatR;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Options;

namespace EnerGov.Web.Exports.Areas.Exports.Pages {

    public class MarketDriveModel : BasePageModel {

        private readonly IOptions<ExportConfiguration> _exportConfigurationOptions;

        public IEnumerable<FetchMarketDrivePermitTypesToIncludeQuery.PermitTypeResultItem> PermitTypeResultItems {
            get;
            set;
        }

        public MarketDriveExportConfiguration MarketDriveExportConfiguration { get; set; }

        public MarketDriveModel(
            IMediator mediator,
            IUserService userService,
            IOptions<ExportConfiguration> exportConfigurationOptions) : base(mediator, userService) {

            _exportConfigurationOptions = exportConfigurationOptions;
        }

        public async Task OnGetAsync() {

            MarketDriveExportConfiguration = _exportConfigurationOptions.Value.MarketDrive;
            PermitTypeResultItems = await Mediator.Send(new FetchMarketDrivePermitTypesToIncludeQuery());

        }

        public async Task<ActionResult> OnPostExportAsync(CancellationToken cancellationToken) {

            var marketDriveExportConfiguration = _exportConfigurationOptions.Value.MarketDrive;

            var statusMappings = marketDriveExportConfiguration.StatusMap
                .Select(_ => _.EnerGovIds.Select(x => new Tuple<string, string>(x, _.Name))).SelectMany(x => x)
                .ToDictionary(_ => _.Item1, _ => _.Item2);

            var marketDriveExportEntries = await Mediator.Send(new FetchMarketDriveExportQuery(), cancellationToken);

            var output =
                string.Concat(marketDriveExportEntries.Select(_ =>
                    _.ToExportFileFormat(statusMappings) + Environment.NewLine));

            return File(Encoding.ASCII.GetBytes(output), "text/plain",
                $"MarketDriveExport-{DateTime.Now:yyyyMMddHHmmss}.txt");

        }

    }

}