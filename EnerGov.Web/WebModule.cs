using System.Reflection;
using Autofac;
using EnerGov.Web.Tasks;
using Lax.Business.Authorization.HttpContext;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Infrastructure;
using Microsoft.AspNetCore.Mvc.Routing;
using Module = Autofac.Module;

namespace EnerGov.Web {

    public class WebModule : Module {

        private readonly Assembly[] _webAssemblies;

        public WebModule(Assembly[] webAssemblies) {
            _webAssemblies = webAssemblies;
        }

        protected override void Load(ContainerBuilder builder) {

            builder.RegisterType<ActionContextAccessor>().As<IActionContextAccessor>().SingleInstance();
            builder.Register(context => {
                var actionContext = context.Resolve<IActionContextAccessor>().ActionContext;
                var factory = context.Resolve<IUrlHelperFactory>();
                return factory.GetUrlHelper(actionContext);
            }).As<IUrlHelper>().InstancePerLifetimeScope();

            builder.RegisterAssemblyModules(_webAssemblies);

            builder.RegisterType<EmailQueueFixTask>().AsSelf().InstancePerDependency();
            builder.RegisterHttpContextAuthorizationUserProvider();


        }

    }

}