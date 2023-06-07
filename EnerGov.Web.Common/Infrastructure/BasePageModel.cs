using System;
using System.Threading.Tasks;
using MediatR;
using Microsoft.AspNetCore.Mvc.RazorPages;
using EnerGov.Security.User;

namespace EnerGov.Web.Common.Infrastructure {

    public abstract class BasePageModel : PageModel {

        protected readonly IMediator Mediator;
        protected readonly IUserService UserService;

        protected BasePageModel(
            IMediator mediator,
            IUserService userService) {

            Mediator = mediator;
            UserService = userService;
        }

        protected async Task<Guid> FetchCurrentUserId() =>
            (await FetchCurrentUser())?.UserId ?? Guid.Empty;

        protected async Task<UserInformation> FetchCurrentUser() =>
            await UserService.GetUserInformationForClaimsPrincipal(HttpContext.User);

    }

}
