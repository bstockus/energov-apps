using System;
using System.Reflection;
using Jaeger;
using Jaeger.Samplers;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Logging;
using OpenTracing;
using OpenTracing.Contrib.NetCore.Configuration;
using OpenTracing.Util;

namespace EnerGov.Web {

    public static class JaegerServiceCollectionExtensions {
        private static readonly Uri JaegerUri = new("http://localhost:14268/api/traces");

        public static IServiceCollection AddJaeger(this IServiceCollection services) {
            if (services == null) {
                throw new ArgumentNullException(nameof(services));
            }

            services.AddSingleton<ITracer>(serviceProvider => {
                var serviceName = Assembly.GetEntryAssembly()?.GetName().Name;

                var loggerFactory = serviceProvider.GetRequiredService<ILoggerFactory>();

                ISampler sampler = new ConstSampler(sample: true);

                ITracer tracer = new Tracer.Builder(serviceName)
                    .WithLoggerFactory(loggerFactory)
                    .WithSampler(sampler)
                    .Build();

                GlobalTracer.Register(tracer);

                return tracer;
            });

            // Prevent endless loops when OpenTracing is tracking HTTP requests to Jaeger.
            services.Configure<HttpHandlerDiagnosticOptions>(options => {
                options.IgnorePatterns.Add(request => JaegerUri.IsBaseOf(request.RequestUri));
            });

            return services;
        }
    }

}