using Autofac;
using EnerGov.Business.Alerting.GenericCaseAlerts;
using EnerGov.Business.Alerting.GenericCaseAlerts.Handlers;
using EnerGov.Business.Alerting.NewCssPermitAlerts;

namespace EnerGov.Business.Alerting {
    public class AlertingBusinessModule : Module {

        protected override void Load(ContainerBuilder builder) {

            builder
                .RegisterType<NewCssPermitAlertTask>()
                .AsSelf()
                .InstancePerDependency();

            builder
                .RegisterType<GenericCaseAlertTask>()
                .AsSelf()
                .InstancePerDependency();

            builder
                .RegisterAssemblyTypes(ThisAssembly)
                .AssignableTo<IModuleHandler>()
                .AsImplementedInterfaces()
                .InstancePerDependency();

        }

    }

}
