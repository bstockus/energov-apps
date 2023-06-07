using System.Linq;
using Lax.Cli.Common;
using Microsoft.AspNetCore.Hosting;
using Microsoft.Extensions.Configuration;
using EnerGov.Cli;
using Serilog;
using System.Threading.Tasks;
using Autofac.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;


namespace EnerGov.Web {

    public class Program {
        
        public static async Task Main(string[] args) {
            
            if (args.Length > 0 && args.First().ToUpper().Trim().Equals("RUN")) {
                
                await (new CliExecutor(new CliStartup())).Run(args.Skip(1).ToArray());
            } else {

                CreateIISWebHostBuilder(args).Build().Run();
            }

            
        }

        public static IHostBuilder CreateIISWebHostBuilder(string[] args) =>
            Host.CreateDefaultBuilder(args)
                .UseServiceProviderFactory(new AutofacServiceProviderFactory())
                .UseSerilog((context, services, configuration) => 
                    configuration.ReadFrom.Configuration(context.Configuration))
                .ConfigureWebHostDefaults(webBuilder => {
                    webBuilder.UseStartup<Startup>()
                        .ConfigureAppConfiguration((context, builder) => {
                            var env = context.HostingEnvironment;
                            builder
                                .AddYamlFile("appsettings.yml", optional: false)
                                .AddYamlFile($"appsettings.{env.EnvironmentName}.yml", optional: true)
                                .AddEnvironmentVariables()
                                .AddCommandLine(args);
                        });
                });




    }

}
