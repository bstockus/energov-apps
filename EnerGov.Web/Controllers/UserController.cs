using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using EnerGov.Security.User;

namespace EnerGov.Web.Controllers {

    public class UserController : Controller {

        private readonly IUserService _userService;

        public UserController(
            IUserService userService) {
            _userService = userService;
        }

        [HttpGet("~/__admin/current-user")]
        [ApiExplorerSettings(IgnoreApi = true)]
        public async Task<ActionResult> CurrentUser() =>
            Json(await _userService.GetUserInformationForClaimsPrincipal(HttpContext.User));

    }

}