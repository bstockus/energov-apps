using Autofac;
using EnerGov.Web.Common.Navigation;
using EnerGov.Web.Exports.Navigation;

namespace EnerGov.Web.Exports {
    public class ExportsWebModule : Module {

        protected override void Load(ContainerBuilder builder) {

            builder.RegisterType<ExportNavigationSectionProvider>().As<INavigationSectionProvider>()
                .InstancePerDependency();

        }

    }

}
