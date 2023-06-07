using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace EnerGov.Web.Controllers;

public class KeepAliveController : Controller {

    [HttpGet("~/__keepalive")]
    [ApiExplorerSettings(IgnoreApi = true)]
    [AllowAnonymous]
    public ActionResult KeepAlive() => Ok();

}