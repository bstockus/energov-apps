using System.Collections.Generic;
using System.Security.Claims;

namespace EnerGov.Business.Identity.Users {

    public static class UserExtensions {

        public static ClaimsPrincipal ToClaimsPrincipal(this User user) => new ClaimsPrincipal(new ClaimsIdentity(
            new List<Claim> {
                new Claim(ClaimTypes.PrimarySid, user.WindowsSid)
            }));

    }

}