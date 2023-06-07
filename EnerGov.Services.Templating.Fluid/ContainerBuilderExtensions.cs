using Autofac;

namespace EnerGov.Services.Templating.Fluid {

    public static class ContainerBuilderExtensions {

        public static ContainerBuilder RegisterFluidTemplating(this ContainerBuilder builder) {

            builder
                .RegisterType<FluidTemplateRenderingService>()
                .As<ITemplateRenderingService>()
                .SingleInstance();

            return builder;
        }

    }

}