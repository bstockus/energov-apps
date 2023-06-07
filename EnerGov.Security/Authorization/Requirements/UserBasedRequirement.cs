using System.Threading.Tasks;
using Microsoft.AspNetCore.Authorization;
using EnerGov.Security.User;

namespace EnerGov.Security.Authorization.Requirements {

    public abstract class UserBasedRequirement : IAuthorizationRequirement {

        public abstract class Handler<TRequirement> : AuthorizationHandler<TRequirement>
            where TRequirement : UserBasedRequirement {

            protected readonly IUserService UserService;

            protected Handler(IUserService userService) {
                UserService = userService;
            }

            protected override async Task HandleRequirementAsync(AuthorizationHandlerContext context,
                TRequirement requirement) {

                var userInformation = await UserService.GetUserInformationForClaimsPrincipal(context.User);

                if (userInformation == null || !HandleRequirementForUser(userInformation, requirement)) {
                    return;
                }

                context.Succeed(requirement);

            }

            protected abstract bool HandleRequirementForUser(UserInformation userInformation, TRequirement requirement);

        }

    }
    
    

}