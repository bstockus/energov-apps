using Autofac;
using EnerGov.Business.FireOccupancy.InspectionAutomations;
using EnerGov.Business.FireOccupancy.NotificationAutomations;

namespace EnerGov.Business.FireOccupancy {
    public class FireOccupancyBusinessModule : Module {

        protected override void Load(ContainerBuilder builder) {

            builder
                .RegisterAssemblyTypes(ThisAssembly)
                .AssignableTo<IFireOccupancyInspectionTask>()
                .AsImplementedInterfaces()
                .InstancePerDependency();

            builder
                .RegisterType<FireOccupancyInspectionTaskRunner>()
                .AsSelf()
                .InstancePerDependency();

            builder
                .RegisterType<ReInspectionNotificationAutomationTaskRunner>()
                .AsSelf()
                .InstancePerDependency();

        }

    }

}
