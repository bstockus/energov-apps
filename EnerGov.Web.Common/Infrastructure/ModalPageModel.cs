using System;
using System.Linq;
using MediatR;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Filters;
using EnerGov.Security.User;

namespace EnerGov.Web.Common.Infrastructure {

    public abstract class ModalPageModel : BasePageModel {

        protected ModalPageModel(IMediator mediator, IUserService userService) : base(mediator, userService) { }

        [BindProperty]
        public string ReferrerUrl { get; set; }

        public override void OnPageHandlerExecuting(PageHandlerExecutingContext context) {
            base.OnPageHandlerExecuting(context);

            if (context.HandlerMethod.HttpMethod == "Get") {
                var refererUrl = new Uri(context.HttpContext.Request.Headers["Referer"].FirstOrDefault() ?? "");
                ReferrerUrl = refererUrl.PathAndQuery;
                ViewData["ReferrerUrl"] = ReferrerUrl;
            }
        }

        public ActionResult RedirectToReferrer() =>
            Url.IsLocalUrl(ReferrerUrl) ? Redirect(ReferrerUrl) as ActionResult : RedirectToPage("/");

    }

}