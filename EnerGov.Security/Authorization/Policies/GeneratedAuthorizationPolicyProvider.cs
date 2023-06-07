using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Authorization;
using Microsoft.Extensions.Options;

namespace EnerGov.Security.Authorization.Policies {

    public class GeneratedAuthorizationPolicyProvider : IAuthorizationPolicyProvider {

        private readonly ILookup<string, AuthorizationPolicy> _policies;
        private readonly DefaultAuthorizationPolicyProvider _fallbackAuthorizationPolicyProvider;

        public GeneratedAuthorizationPolicyProvider(
            IEnumerable<AuthorizationPolicyGenerator> authorizationPolicyGenerators,
            IOptions<AuthorizationOptions> options) {

            _policies = authorizationPolicyGenerators.SelectMany(_ => _.Policies).ToLookup(_ => _.Key, _ => _.Value);
            _fallbackAuthorizationPolicyProvider = new DefaultAuthorizationPolicyProvider(options);
        }

        public async Task<AuthorizationPolicy> GetPolicyAsync(string policyName) {

            if (_policies.Contains(policyName)) {
                return await Task.FromResult(_policies[policyName].First());
            }

            return await _fallbackAuthorizationPolicyProvider.GetPolicyAsync(policyName);

        }

        public async Task<AuthorizationPolicy> GetDefaultPolicyAsync() =>
            await _fallbackAuthorizationPolicyProvider.GetDefaultPolicyAsync();

        public async Task<AuthorizationPolicy> GetFallbackPolicyAsync() => 
            await _fallbackAuthorizationPolicyProvider.GetDefaultPolicyAsync();

    }

}