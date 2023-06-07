using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Caching.Memory;

namespace EnerGov.Web.ClerksLicensing.Controllers {

    public class CachedDownloadsResultController : Controller {

        private readonly IMemoryCache _memoryCache;

        public CachedDownloadsResultController(
            IMemoryCache memoryCache) {

            _memoryCache = memoryCache;
        }

        [HttpGet("~/cached-file/fetch")]
        public ActionResult Fetch(string fileId, string fileName) {
            if (_memoryCache.TryGetValue(fileId, out byte[] fileContents)) {
                return File(fileContents, "application/pdf", $"{fileName}.pdf");
            }

            return NotFound();
        }

    }

}
