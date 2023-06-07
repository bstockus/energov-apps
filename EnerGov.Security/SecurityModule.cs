using System.Reflection;
using Autofac;
using EnerGov.Security.Authorization;
using EnerGov.Security.User;
using Module = Autofac.Module;

namespace EnerGov.Security {

    public class SecurityModule : Module {

        private readonly Assembly[] _businessAssemblies;

        public SecurityModule(
            Assembly[] businessAssemblies) {

            _businessAssemblies = businessAssemblies;
        }

        protected override void Load(ContainerBuilder builder) {

            builder
                .RegisterAuthorizationHandlers(ThisAssembly)
                .RegisterAuthorizationPolicyGenerators(_businessAssemblies)
                .RegisterAuthorizationPolicyProvider()
                .RegisterUserService();

        }

    }

}
