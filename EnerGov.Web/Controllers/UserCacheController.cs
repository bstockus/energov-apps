using System.Linq;
using Microsoft.AspNetCore.Mvc;
using EnerGov.Security.User;

namespace EnerGov.Web.Controllers {

    public class UserCacheController : Controller {

        private readonly IUserCacheService _userCacheService;

        public UserCacheController(
            IUserCacheService userCacheService) {

            _userCacheService = userCacheService;
        }

        [HttpGet("~/__admin/flush-user-cache")]
        [ApiExplorerSettings(IgnoreApi = true)]
        public ActionResult FlushUserCache() {
            _userCacheService.FlushEntireCache();
            return Redirect(HttpContext.Request.Headers["Referer"].FirstOrDefault() ?? "/");
        }
        
    }

}
