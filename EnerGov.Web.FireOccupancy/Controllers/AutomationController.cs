using System.Threading;
using System.Threading.Tasks;
using EnerGov.Business.FireOccupancy.InspectionAutomations;
using Microsoft.AspNetCore.Mvc;

namespace EnerGov.Web.FireOccupancy.Controllers {

    public class AutomationController : Controller {

        private readonly FireOccupancyInspectionTaskRunner _fireOccupancyInspectionTaskRunner;

        public AutomationController(
            FireOccupancyInspectionTaskRunner fireOccupancyInspectionTaskRunner) {

            _fireOccupancyInspectionTaskRunner = fireOccupancyInspectionTaskRunner;
        }

        [HttpGet("~/FireOccupancy/__automation/run")]
        public async Task<ActionResult> Run(CancellationToken cancellationToken) {
            await _fireOccupancyInspectionTaskRunner.RunTasks(cancellationToken);
            return Ok();
        }

    }

}
