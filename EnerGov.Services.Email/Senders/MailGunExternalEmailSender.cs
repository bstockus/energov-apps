using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;
using EnerGov.Data.Configuration;
using EnerGov.Services.Email.Models;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Options;
using MimeKit;
using Newtonsoft.Json;
using RestSharp;
using RestSharp.Authenticators;

namespace EnerGov.Services.Email.Senders {

    public class MailGunExternalEmailSender : IEmailSender {

        public record EmailInfo(
            string FromAddress,
            string ToAddress,
            string EmailName,
            Guid EmailId,
            string Subject,
            string BodyText,
            string BodyHtml,
            ICollection<EmailAttachment> Attachments);

        //public class EmailInfo {

        //    public string FromAddress { get; }
        //    public string ToAddress { get; }
        //    public string EmailName { get; }
        //    public Guid EmailId { get; }
        //    public string Subject { get; }
        //    public string BodyText { get; }
        //    public string BodyHtml { get; }
        //    public ICollection<EmailAttachment> Attachments { get; }

        //    public EmailInfo(
        //        string fromAddress, 
        //        string toAddress, 
        //        string emailName, 
        //        Guid emailId, 
        //        string subject,
        //        string bodyText, 
        //        string bodyHtml, 
        //        ICollection<EmailAttachment> attachments) {

        //        FromAddress = fromAddress;
        //        ToAddress = toAddress;
        //        EmailName = emailName;
        //        EmailId = emailId;
        //        Subject = subject;
        //        BodyText = bodyText;
        //        BodyHtml = bodyHtml;
        //        Attachments = attachments;
        //    }

        //}

        private readonly IOptions<EmailOptions> _emailOptions;
        private readonly ConfigurationDbContext _configurationDbContext;

        public MailGunExternalEmailSender(
            IOptions<EmailOptions> emailOptions,
            ConfigurationDbContext configurationDbContext) {

            _emailOptions = emailOptions;
            _configurationDbContext = configurationDbContext;
        }

        public async Task SendEmails(
            CancellationToken cancellationToken) {
            
            var configurationOptions = _emailOptions.Value;

            if (configurationOptions.ExternalSender.SendEmails) {

                var emailRecipientsToSend = await _configurationDbContext
                    .Set<EmailRecipient>()
                    .TagWith("Fetch all external email message recipients that need to be sent")
                    .Include(_ => _.Email)
                    .ThenInclude(_ => _.Attachments)
                    .Where(_ => !_.DateSent.HasValue && _.Email.EmailType.Equals(EmailType.ExternalEmail))
                    .Select(_ => new EmailInfo(_.Email.FromAddress, _.ToAddress, _.Email.EmailName, _.Email.Id,
                        _.Email.Subject, _.Email.BodyText, _.Email.BodyHtml, _.Email.Attachments))
                    .ToListAsync(cancellationToken);

                var client = new RestClient(new Uri(configurationOptions.ExternalSender.MailGunApiUrl)) {
                    Authenticator = new HttpBasicAuthenticator(
                        "api",
                        configurationOptions.ExternalSender.MailGunApiKey)
                };

                foreach (var emailRecipient in emailRecipientsToSend) {

                    var message = new MimeMessage();

                    message.Headers.Add("X-Mailgun-Variables", JsonConvert.SerializeObject(new {
                        MessageId = emailRecipient.EmailId,
                        MessageName = emailRecipient.EmailName
                    }));

                    message.From.Add(new MailboxAddress(emailRecipient.FromAddress, emailRecipient.FromAddress));

                    var appendToBodyText = "";
                    var appendToBodyHtml = "";
                    var toAddress = emailRecipient.ToAddress;

                    if (!string.IsNullOrWhiteSpace(configurationOptions.InternalSender.OverideEmailAddress)) {
                        message.To.Add(new MailboxAddress(configurationOptions.InternalSender.OverideEmailAddress,
                            configurationOptions.InternalSender.OverideEmailAddress));
                        appendToBodyText = Environment.NewLine + Environment.NewLine +
                                           $"Would have been sent to: {emailRecipient.ToAddress}";
                        appendToBodyHtml =
                            $"<br><br><p>Would have been sent to: {emailRecipient.ToAddress}</p>";
                        toAddress = configurationOptions.InternalSender.OverideEmailAddress;
                    } else {
                        message.To.Add(new MailboxAddress(emailRecipient.ToAddress, emailRecipient.ToAddress));
                    }

                    if (!string.IsNullOrWhiteSpace(configurationOptions.InternalSender.OverideEmailAddress) ||
                        emailRecipient.ToAddress.EndsWith("@cityoflacrosse.org")) {

                        appendToBodyText += Environment.NewLine +
                                            $"Email Id: {emailRecipient.EmailName}//{emailRecipient.EmailId.ToString()}";

                        appendToBodyHtml +=
                            $"<br><p style='color: gray;'>Email Id: {emailRecipient.EmailName}//{emailRecipient.EmailId.ToString()}";

                    }

                    message.Subject = emailRecipient.Subject;

                    var builder = new BodyBuilder {
                        TextBody = emailRecipient.BodyText + appendToBodyText,
                        HtmlBody = emailRecipient.BodyHtml + appendToBodyHtml
                    };

                    foreach (var attachment in emailRecipient.Attachments) {

                        var mimeTypeSplits = attachment.MimeType.Split('/');

                        var mimeType = mimeTypeSplits.Length >= 1 ? mimeTypeSplits[0] : "";
                        var mimeSubType = mimeTypeSplits.Length >= 2 ? mimeTypeSplits[1] : "";

                        builder.Attachments.Add(attachment.FileName, attachment.FileContents,
                            new ContentType(mimeType, mimeSubType));

                    }

                    message.Body = builder.ToMessageBody();

                    await using (var messageStream = new MemoryStream()) {
                        await message.WriteToAsync(messageStream, cancellationToken);

                        var request = new RestRequest();
                        request.AddParameter("domain", configurationOptions.ExternalSender.MailGunDomain,
                            ParameterType.UrlSegment);
                        request.Resource = "{domain}/messages.mime";
                        request.AddParameter("to", toAddress);
                        request.AddFile(
                            "message",
                            messageStream.ToArray(),
                            "message.mime",
                            "message/rfc2822");
                        request.Method = Method.Post;

                        await client.ExecuteAsync(request, cancellationToken);
                    }

                    var email = await _configurationDbContext.Set<EmailRecipient>()
                            .TagWith("Fetch Email Recipient to set date sent.").FirstOrDefaultAsync(
                                _ => _.EmailId.Equals(emailRecipient.EmailId) &&
                                     _.ToAddress.Equals(emailRecipient.ToAddress), cancellationToken);
                    email.DateSent = DateTime.Now;
                    await _configurationDbContext.SaveChangesAsync(cancellationToken);

                }

            }

        }

        public async Task ReSendEmail(
            Guid emailId, 
            CancellationToken cancellationToken) {

            var configurationOptions = _emailOptions.Value;

            if (configurationOptions.ExternalSender.SendEmails) {
                var emailRecipientsToSend = await _configurationDbContext
                    .Set<EmailRecipient>()
                    .TagWith("Fetch all external email message recipients that need to be sent")
                    .Include(_ => _.Email)
                    .ThenInclude(_ => _.Attachments)
                    .Where(_ => _.EmailId.Equals(emailId) && _.Email.EmailType.Equals(EmailType.ExternalEmail))
                    .Select(_ => new EmailInfo(_.Email.FromAddress, _.ToAddress, _.Email.EmailName, _.Email.Id,
                        _.Email.Subject, _.Email.BodyText, _.Email.BodyHtml, _.Email.Attachments))
                    .ToListAsync(cancellationToken);

                await SendEmails(cancellationToken, configurationOptions, emailRecipientsToSend);
            }

        }

        public async Task ReSendEmailsForDate(
            DateTime date, 
            CancellationToken cancellationToken) {
            
            var configurationOptions = _emailOptions.Value;

            if (configurationOptions.ExternalSender.SendEmails) {
                var emailRecipientsToSend = await _configurationDbContext
                    .Set<EmailRecipient>()
                    .TagWith("Fetch all external email message recipients that need to be sent")
                    .Include(_ => _.Email)
                    .ThenInclude(_ => _.Attachments)
                    .Where(_ => _.DateSent.HasValue && _.DateSent.Value.Date.Equals(date.Date) &&
                                _.Email.EmailType.Equals(EmailType.ExternalEmail))
                    .Select(_ => new EmailInfo(_.Email.FromAddress, _.ToAddress, _.Email.EmailName, _.Email.Id,
                        _.Email.Subject, _.Email.BodyText, _.Email.BodyHtml, _.Email.Attachments))
                    .ToListAsync(cancellationToken);

                await SendEmails(cancellationToken, configurationOptions, emailRecipientsToSend);
            }

        }

        private static async Task SendEmails(
            CancellationToken cancellationToken, 
            EmailOptions configurationOptions,
            IEnumerable<EmailInfo> emailRecipientsToSend) {

            var client = new RestClient(new Uri(configurationOptions.ExternalSender.MailGunApiUrl)) {
                Authenticator = new HttpBasicAuthenticator(
                    "api",
                    configurationOptions.ExternalSender.MailGunApiKey)
            };

            foreach (var emailRecipient in emailRecipientsToSend) {
                var message = new MimeMessage();

                message.Headers.Add("X-Mailgun-Variables", JsonConvert.SerializeObject(new {
                    MessageId = emailRecipient.EmailId,
                    MessageName = emailRecipient.EmailName
                }));

                message.From.Add(new MailboxAddress(emailRecipient.FromAddress, emailRecipient.FromAddress));

                var appendToBodyText = "";
                var appendToBodyHtml = "";
                var toAddress = emailRecipient.ToAddress;

                if (!string.IsNullOrWhiteSpace(configurationOptions.InternalSender.OverideEmailAddress)) {
                    message.To.Add(new MailboxAddress(configurationOptions.InternalSender.OverideEmailAddress,
                        configurationOptions.InternalSender.OverideEmailAddress));
                    appendToBodyText = Environment.NewLine + Environment.NewLine +
                                       $"Would have been sent to: {emailRecipient.ToAddress}";
                    appendToBodyHtml =
                        $"<br><br><p>Would have been sent to: {emailRecipient.ToAddress}</p>";
                    toAddress = configurationOptions.InternalSender.OverideEmailAddress;
                } else {
                    message.To.Add(new MailboxAddress(emailRecipient.ToAddress, emailRecipient.ToAddress));
                }

                if (!string.IsNullOrWhiteSpace(configurationOptions.InternalSender.OverideEmailAddress) ||
                    emailRecipient.ToAddress.EndsWith("@cityoflacrosse.org")) {
                    appendToBodyText += Environment.NewLine +
                                        $"Email Id: {emailRecipient.EmailName}//{emailRecipient.EmailId.ToString()}";

                    appendToBodyHtml +=
                        $"<br><p style='color: gray;'>Email Id: {emailRecipient.EmailName}//{emailRecipient.EmailId.ToString()}";
                }

                message.Subject = emailRecipient.Subject;

                var builder = new BodyBuilder {
                    TextBody = emailRecipient.BodyText + appendToBodyText,
                    HtmlBody = emailRecipient.BodyHtml + appendToBodyHtml
                };

                foreach (var attachment in emailRecipient.Attachments) {
                    var mimeTypeSplits = attachment.MimeType.Split('/');

                    var mimeType = mimeTypeSplits.Length >= 1 ? mimeTypeSplits[0] : "";
                    var mimeSubType = mimeTypeSplits.Length >= 2 ? mimeTypeSplits[1] : "";

                    builder.Attachments.Add(attachment.FileName, attachment.FileContents,
                        new ContentType(mimeType, mimeSubType));
                }

                message.Body = builder.ToMessageBody();

                await using var messageStream = new MemoryStream();
                await message.WriteToAsync(messageStream, cancellationToken);

                var request = new RestRequest();
                request.AddParameter("domain", configurationOptions.ExternalSender.MailGunDomain,
                    ParameterType.UrlSegment);
                request.Resource = "{domain}/messages.mime";
                request.AddParameter("to", toAddress);
                request.AddFile(
                    "message",
                    messageStream.ToArray(),
                    "message.mime",
                    "message/rfc2822");
                request.Method = Method.Post;

                await client.ExecuteAsync(request, cancellationToken);
            }
        }

    }

}