using System.Collections.Generic;

namespace EnerGov.Services.Email.Helpers {
    public class EmailMessage {

        public string EmailName { get; set; }
        public string[] ToAddresses { get; set; }
        public string FromAddress { get; set; }
        public string Subject { get; set; }
        public string BodyText { get; set; }
        public string BodyHtml { get; set; }
        public string FailureAddress { get; set; }

        public IEnumerable<EmailMessageAttachment> Attachments { get; set; } =
            new List<EmailMessageAttachment>();

    }

}
