using System.Linq;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.ApplicationParts;
using Microsoft.AspNetCore.Mvc.Controllers;
using Microsoft.AspNetCore.Mvc.Razor.TagHelpers;
using Microsoft.AspNetCore.Mvc.ViewComponents;
using Microsoft.Extensions.Hosting;

namespace EnerGov.Web.Controllers {

    public class FeaturesController : Controller {

        private readonly ApplicationPartManager _applicationPartManager;
        private readonly IWebHostEnvironment _hostingEnvironment;

        public FeaturesController(
            ApplicationPartManager applicationPartManager,
            IWebHostEnvironment hostingEnvironment) {
            _applicationPartManager = applicationPartManager;
            _hostingEnvironment = hostingEnvironment;
        }

        [HttpGet("~/__debug/features/controllers")]
        [ApiExplorerSettings(IgnoreApi = true)]
        public ActionResult ListController() {
            if (!_hostingEnvironment.IsDevelopment()) {
                return BadRequest();
            }

            var controllerFeature = new ControllerFeature();
            _applicationPartManager.PopulateFeature(controllerFeature);

            return Json(controllerFeature.Controllers.Select(_ => _.FullName));



        }

        [HttpGet("~/__debug/features/tag-helpers")]
        [ApiExplorerSettings(IgnoreApi = true)]
        public ActionResult ListTagHelpers() {
            if (!_hostingEnvironment.IsDevelopment()) {
                return BadRequest();
            }

            var tagHelperFeature = new TagHelperFeature();
            _applicationPartManager.PopulateFeature(tagHelperFeature);

            return Json(tagHelperFeature.TagHelpers.Select(_ => _.FullName));


        }

        [HttpGet("~/__debug/features/view-components")]
        [ApiExplorerSettings(IgnoreApi = true)]
        public ActionResult ListViewComponents() {
            if (!_hostingEnvironment.IsDevelopment()) {
                return BadRequest();
            }

            var viewComponentFeature = new ViewComponentFeature();
            _applicationPartManager.PopulateFeature(viewComponentFeature);

            return Json(viewComponentFeature.ViewComponents.Select(_ => _.FullName));


        }

    }

}