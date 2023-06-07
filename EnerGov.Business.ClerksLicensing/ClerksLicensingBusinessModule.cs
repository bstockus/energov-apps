using Autofac;
using EnerGov.Business.ClerksLicensing.LicensePackets;
using EnerGov.Business.ClerksLicensing.RenewalPackets.Generators;

namespace EnerGov.Business.ClerksLicensing; 

public class ClerksLicensingBusinessModule : Module {

    protected override void Load(ContainerBuilder builder) {
        builder.RegisterType<RenewalPacketGenerator>().AsSelf().InstancePerDependency();
        builder.RegisterType<LicensePacketGenerator>().AsSelf().InstancePerDependency();
        builder.RegisterAssemblyTypes(ThisAssembly).AssignableTo<ILicenseRenewalFormGenerator>()
            .AsImplementedInterfaces().InstancePerDependency();
    }

}