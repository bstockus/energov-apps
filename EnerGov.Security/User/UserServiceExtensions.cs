using System.Security.Claims;
using System.Threading.Tasks;

namespace EnerGov.Security.User {

    public static class UserServiceExtensions {

        public static async Task<UserInformation> GetUserInformationForClaimsPrincipal(
            this IUserService userService,
            ClaimsPrincipal claimsPrincipal) =>
            await userService.FetchUserInformationByWindowsSid(
                claimsPrincipal.FindFirst("onprem_sid")?.Value ?? "");

    }

}