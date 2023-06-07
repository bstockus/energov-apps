using System;
using System.Linq;
using EnerGov.Data.Configuration;
using EnerGov.Services.Email.Models;

namespace EnerGov.Services.Email.Helpers {

    public static class EmailHelperExtensions {

        public static Guid QueueInternalEmail(
            this ConfigurationDbContext dbContext,
            EmailMessage emailMessage) {

            var emailId = Guid.NewGuid();

            dbContext.Set<Models.Email>().Add(
                new Models.Email {
                    Id = emailId,
                    EmailName = emailMessage.EmailName,
                    FromAddress = emailMessage.FromAddress,
                    Subject = emailMessage.Subject,
                    BodyHtml = emailMessage.BodyHtml,
                    BodyText = emailMessage.BodyText,
                    EmailType = EmailType.InternalEmail,
                    Recipients = emailMessage.ToAddresses.Select(_ => new EmailRecipient {
                        ToAddress = _,
                        FailureAddress = emailMessage.FailureAddress,
                        SendFailureCount = 0
                    }).ToList(),
                    Attachments = emailMessage.Attachments.Select(_ => new EmailAttachment {
                        FileName = _.FileName,
                        MimeType = _.MimeType,
                        FileContents = _.FileContents
                    }).ToList()
                });

            return emailId;

        }

        public static Guid QueueExternalEmail(
            this ConfigurationDbContext dbContext,
            EmailMessage emailMessage) {

            var emailId = Guid.NewGuid();

            dbContext.Set<Models.Email>().Add(
                new Models.Email {
                    Id = emailId,
                    EmailName = emailMessage.EmailName,
                    FromAddress = emailMessage.FromAddress,
                    Subject = emailMessage.Subject,
                    BodyHtml = emailMessage.BodyHtml,
                    BodyText = emailMessage.BodyText,
                    EmailType = EmailType.ExternalEmail,
                    Recipients = emailMessage.ToAddresses.Select(_ => new EmailRecipient {
                        ToAddress = _,
                        FailureAddress = emailMessage.FailureAddress,
                        SendFailureCount = 0
                    }).ToList(),
                    Attachments = emailMessage.Attachments.Select(_ => new EmailAttachment {
                        FileName = _.FileName,
                        MimeType = _.MimeType,
                        FileContents = _.FileContents
                    }).ToList()
                });

            return emailId;

        }

    }

}