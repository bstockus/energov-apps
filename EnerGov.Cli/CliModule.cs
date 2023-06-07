using System.Linq;
using Autofac;
using EnerGov.Business;
using Lax.Cli.Common;

namespace EnerGov.Cli {

    public class CliModule : Module {

        protected override void Load(ContainerBuilder builder) {

            builder
                .RegisterTasksCli(BusinessModule.BusinessAssemblies.Concat(new[] {ThisAssembly}).ToArray());
            

        }

    }

}
