using Autofac;
using EnerGov.Services.Email.Senders;

namespace EnerGov.Services.Email {

    public static class ContainerBuilderExtensions {

        public static ContainerBuilder RegisterEmailSender(this ContainerBuilder builder) {

            builder
                .RegisterType<SmtpInternalEmailSender>()
                .As<IEmailSender>()
                .AsSelf()
                .SingleInstance();

            builder
                .RegisterType<MailGunExternalEmailSender>()
                .As<IEmailSender>()
                .AsSelf()
                .SingleInstance();

            return builder;
        }

    }

}