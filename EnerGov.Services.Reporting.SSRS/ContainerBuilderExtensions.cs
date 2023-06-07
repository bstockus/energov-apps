using Autofac;

namespace EnerGov.Services.Reporting.SSRS {

    public static class ContainerBuilderExtensions {

        public static ContainerBuilder RegisterSSRSReporting(this ContainerBuilder builder) {

            builder
                .RegisterType<SSRSReportRenderingService>()
                .As<IReportRenderingService>()
                .SingleInstance();

            return builder;
        }

    }

}