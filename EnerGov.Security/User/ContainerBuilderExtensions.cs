using Autofac;

namespace EnerGov.Security.User {

    public static class ContainerBuilderExtensions {

        public static ContainerBuilder RegisterUserService(this ContainerBuilder builder) {
            builder.RegisterType<UserService>().As<IUserService>().As<IUserCacheService>().InstancePerDependency();

            return builder;
        }

    }

}