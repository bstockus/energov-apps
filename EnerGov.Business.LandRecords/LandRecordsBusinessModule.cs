using Autofac;

namespace EnerGov.Business.LandRecords {

    public class LandRecordsBusinessModule : Module {

        protected override void Load(ContainerBuilder builder) {
            builder.RegisterAssemblyTypes(ThisAssembly).AssignableTo<IEtlTask>().As<IEtlTask>().InstancePerDependency();
        }

    }

}
