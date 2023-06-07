using Autofac;
using EnerGov.Web.Common.Navigation;
using EnerGov.Web.UtilityExcavation.Navigation;

namespace EnerGov.Web.UtilityExcavation {

    public class UtilityExcavationWebModule : Module {

        protected override void Load(ContainerBuilder builder) {

            builder.RegisterType<UtilityExcavationNavigationSectionProvider>().As<INavigationSectionProvider>()
                .InstancePerDependency();

        }

    }

}
