using Microsoft.AspNetCore.Authorization;
using EnerGov.Security.Authorization.Requirements;

namespace EnerGov.Security.Authorization {

    public static class AuthorizationOptionsExtensions {

        public static void RegisterAuthorizationPolicies(this AuthorizationOptions authorizationOptions) {
            authorizationOptions.AddPolicy(AuthorizationPolicies.MustBeActiveUser, policy =>
                policy.Requirements.Add(new MustBeActiveUserRequirement()));
        }

    }

}