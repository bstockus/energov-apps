using Autofac;
using EnerGov.Web.ClerksLicensing.Navigation;
using EnerGov.Web.Common.Navigation;

namespace EnerGov.Web.ClerksLicensing {
    public class ClerksLicensingWebModule : Module {

        protected override void Load(ContainerBuilder builder) {

            builder.RegisterType<ClerksLicensingNavigationSectionProvider>().As<INavigationSectionProvider>()
                .InstancePerDependency();

        }

    }
}
