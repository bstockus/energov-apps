using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;
using EnerGov.Data.Configuration;
using EnerGov.Services.Email.Models;
using MailKit.Net.Smtp;
using MailKit.Security;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Options;
using MimeKit;

namespace EnerGov.Services.Email.Senders {

    public class SmtpInternalEmailSender : IEmailSender {

        public record EmailInfo(
            string FromAddress,
            string ToAddress,
            string EmailName,
            Guid EmailId,
            string Subject,
            string BodyText,
            string BodyHtml,
            ICollection<EmailAttachment> Attachments);

        private readonly IOptions<EmailOptions> _emailOptions;

        private readonly ConfigurationDbContext _configurationDbContext;

        public SmtpInternalEmailSender(
            IOptions<EmailOptions> emailOptions,
            ConfigurationDbContext configurationDbContext) {

            _emailOptions = emailOptions;
            _configurationDbContext = configurationDbContext;
        }

        public async Task SendEmails(CancellationToken cancellationToken) {

            var configurationOptions = _emailOptions.Value;

            if (configurationOptions.InternalSender.SendEmails) {

                var emailRecipientsToSend = await _configurationDbContext
                    .Set<EmailRecipient>()
                    .AsNoTracking()
                    .TagWith("Fetch all internal email message recipients that need to be sent")
                    .Include(_ => _.Email)
                    .ThenInclude(_ => _.Attachments)
                    .Where(_ => !_.DateSent.HasValue && _.Email.EmailType.Equals(EmailType.InternalEmail))
                    .Select(_ => new EmailInfo(_.Email.FromAddress, _.ToAddress, _.Email.EmailName, _.Email.Id,
                        _.Email.Subject, _.Email.BodyText, _.Email.BodyHtml, _.Email.Attachments))
                    .ToListAsync(cancellationToken);

                using (var client = new SmtpClient()) {
                    client.ServerCertificateValidationCallback = (sender, certificate, chain, errors) => true;

                    await client.ConnectAsync(
                        configurationOptions.InternalSender.SmtpHostName,
                        25,
                        SecureSocketOptions.None,
                        cancellationToken);

                    foreach (var emailRecipient in emailRecipientsToSend) {
                        var message = new MimeMessage();

                        message.From.Add(new MailboxAddress(emailRecipient.FromAddress, emailRecipient.FromAddress));

                        var appendToBodyText = "";
                        var appendToBodyHtml = "";

                        if (!string.IsNullOrWhiteSpace(configurationOptions.InternalSender.OverideEmailAddress)) {
                            message.To.Add(new MailboxAddress(configurationOptions.InternalSender.OverideEmailAddress,
                                configurationOptions.InternalSender.OverideEmailAddress));
                            appendToBodyText = Environment.NewLine + Environment.NewLine +
                                               $"Would have been sent to: {emailRecipient.ToAddress}";
                            appendToBodyHtml =
                                $"<br><br><p>Would have been sent to: {emailRecipient.ToAddress}</p>";
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

                            builder.Attachments.Add((string)attachment.FileName, (byte[])attachment.FileContents,
                                new ContentType(mimeType, mimeSubType));
                        }

                        message.Body = builder.ToMessageBody();

                        await client.SendAsync(message, cancellationToken);

                        var email = await _configurationDbContext.Set<EmailRecipient>()
                            .TagWith("Fetch Email Recipient to set date sent.").FirstOrDefaultAsync(
                                _ => _.EmailId.Equals(emailRecipient.EmailId) &&
                                     _.ToAddress.Equals(emailRecipient.ToAddress), cancellationToken);
                        email.DateSent = DateTime.Now;
                        await _configurationDbContext.SaveChangesAsync(cancellationToken);

                    }

                    await client.DisconnectAsync(true, cancellationToken);
                }


            }



        }

        public async Task ReSendEmail(Guid emailId, CancellationToken cancellationToken) {

            var configurationOptions = _emailOptions.Value;

            if (configurationOptions.InternalSender.SendEmails) {

                var emailRecipientsToSend = await _configurationDbContext
                    .Set<EmailRecipient>()
                    .AsNoTracking()
                    .TagWith("Fetch all internal email message recipients that need to be sent")
                    .Include(_ => _.Email)
                    .ThenInclude(_ => _.Attachments)
                    .Where(_ => _.EmailId.Equals(emailId) && _.Email.EmailType.Equals(EmailType.InternalEmail))
                    .Select(_ => new EmailInfo(_.Email.FromAddress, _.ToAddress, _.Email.EmailName, _.Email.Id,
                        _.Email.Subject, _.Email.BodyText, _.Email.BodyHtml, _.Email.Attachments))
                    .ToListAsync(cancellationToken);

                await SendEmails(cancellationToken, configurationOptions, emailRecipientsToSend);


            }

        }

        public async Task ReSendEmailsForDate(DateTime date, CancellationToken cancellationToken) {

            var configurationOptions = _emailOptions.Value;

            if (configurationOptions.InternalSender.SendEmails) {
                var emailRecipientsToSend = await _configurationDbContext
                    .Set<EmailRecipient>()
                    .AsNoTracking()
                    .TagWith("Fetch all internal email message recipients that need to be sent")
                    .Include(_ => _.Email)
                    .ThenInclude(_ => _.Attachments)
                    .Where(_ => _.DateSent.HasValue && _.DateSent.Value.Date.Equals(date.Date) &&
                                _.Email.EmailType.Equals(EmailType.InternalEmail))
                    .Select(_ => new EmailInfo(_.Email.FromAddress, _.ToAddress, _.Email.EmailName, _.Email.Id,
                        _.Email.Subject, _.Email.BodyText, _.Email.BodyHtml, _.Email.Attachments))
                    .ToListAsync(cancellationToken);

                await SendEmails(cancellationToken, configurationOptions, emailRecipientsToSend);
            }

        }

        private static async Task SendEmails(
            CancellationToken cancellationToken, 
            EmailOptions configurationOptions,
            List<EmailInfo> emailRecipientsToSend) {
            using (var client = new SmtpClient()) {
                client.ServerCertificateValidationCallback = (sender, certificate, chain, errors) => true;

                await client.ConnectAsync(
                    configurationOptions.InternalSender.SmtpHostName,
                    25,
                    SecureSocketOptions.None,
                    cancellationToken);

                foreach (var emailRecipient in emailRecipientsToSend) {
                    var message = new MimeMessage();

                    message.From.Add(new MailboxAddress(emailRecipient.FromAddress, emailRecipient.FromAddress));

                    var appendToBodyText = "";
                    var appendToBodyHtml = "";

                    if (!string.IsNullOrWhiteSpace(configurationOptions.InternalSender.OverideEmailAddress)) {
                        message.To.Add(new MailboxAddress(configurationOptions.InternalSender.OverideEmailAddress,
                            configurationOptions.InternalSender.OverideEmailAddress));
                        appendToBodyText = Environment.NewLine + Environment.NewLine +
                                           $"Would have been sent to: {emailRecipient.ToAddress}";
                        appendToBodyHtml =
                            $"<br><br><p>Would have been sent to: {emailRecipient.ToAddress}</p>";
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

                        builder.Attachments.Add((string) attachment.FileName, (byte[]) attachment.FileContents,
                            new ContentType(mimeType, mimeSubType));
                    }

                    message.Body = builder.ToMessageBody();

                    await client.SendAsync(message, cancellationToken);
                }

                await client.DisconnectAsync(true, cancellationToken);
            }
        }

    }

}