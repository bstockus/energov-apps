using System.Threading.Tasks;
using EnerGov.Business.LandRecords;
using MediatR;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace EnerGov.Web.LandRecords.Controllers {
    public class LandRecordsTasksController : Controller {

        private readonly IMediator _mediator;

        public LandRecordsTasksController(IMediator mediator) {
            _mediator = mediator;
        }

        [HttpGet("~/land-records/load-land-records"), AllowAnonymous]
        public async Task<IActionResult> LoadLandRecords() {

            await _mediator.Send(new LoadLandRecordsCommand());

            return Ok();

        }

        [HttpGet("~/land-records/load-nuisance-properties"), AllowAnonymous]
        public async Task<IActionResult> LoadNuisanceProperties() {

            await _mediator.Send(new LoadNuisancePropertiesCommand());

            return Ok();

        }

    }
}
