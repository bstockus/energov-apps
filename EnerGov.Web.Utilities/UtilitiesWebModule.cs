using Autofac;
using EnerGov.Web.Common.Navigation;
using EnerGov.Web.Utilities.Navigation;

namespace EnerGov.Web.Utilities {
    public class UtilitiesWebModule : Module {

        protected override void Load(ContainerBuilder builder) {

            builder
                .RegisterType<UtilitiesNavigationSectionProvider>()
                .As<INavigationSectionProvider>()
                .InstancePerDependency();

        }

    }
}
