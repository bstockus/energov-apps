namespace EnerGov.Services.Email {

    public class EmailOptions {

        public abstract class EmailSenderOptions {

            public string OverideEmailAddress { get; set; }
            public bool SendEmails { get; set; }

        }

        public class SmtpInternalEmailSenderOptions : EmailSenderOptions {

            public string SmtpHostName { get; set; }

        }

        public class MailGunExternalEmailSenderOptions : EmailSenderOptions {

            public string MailGunApiKey { get; set; }
            public string MailGunApiUrl { get; set; }
            public string MailGunDomain { get; set; }

        }

        public SmtpInternalEmailSenderOptions InternalSender { get; set; }
        public MailGunExternalEmailSenderOptions ExternalSender { get; set; }

    }

}
