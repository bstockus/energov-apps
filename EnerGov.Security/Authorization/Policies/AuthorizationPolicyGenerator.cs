using System;
using System.Collections.Generic;
using Microsoft.AspNetCore.Authorization;

namespace EnerGov.Security.Authorization.Policies {

    public abstract class AuthorizationPolicyGenerator {

        public IDictionary<string, AuthorizationPolicy> Policies { get; set; } =
            new Dictionary<string, AuthorizationPolicy>();

        protected void AddPolicy(string name, Action<AuthorizationPolicyBuilder> configurePolicy) {
            var builder = new AuthorizationPolicyBuilder();
            configurePolicy(builder);

            if (Policies.ContainsKey(name)) {
                Policies[name] = builder.Build();
            } else {
                Policies.Add(name, builder.Build());
            }

        }

    }

}
