using System;
using System.Threading;
using System.Threading.Tasks;
using EnerGov.Services.Email.Senders;
using Microsoft.AspNetCore.Mvc;

namespace EnerGov.Web.Controllers {

    public class EmailController : Controller {

        private readonly SmtpInternalEmailSender _smtpInternalEmailSender;
        private readonly MailGunExternalEmailSender _mailGunExternalEmailSender;

        public EmailController(
            SmtpInternalEmailSender smtpInternalEmailSender,
            MailGunExternalEmailSender mailGunExternalEmailSender) {

            _smtpInternalEmailSender = smtpInternalEmailSender;
            _mailGunExternalEmailSender = mailGunExternalEmailSender;
        }

        [HttpGet("~/__automation/send-emails")]
        [ApiExplorerSettings(IgnoreApi = true)]
        public async Task<ActionResult> SendEmails(CancellationToken cancellationToken) {

            await _smtpInternalEmailSender.SendEmails(cancellationToken);
            await _mailGunExternalEmailSender.SendEmails(cancellationToken);

            return Ok();
        }

        [HttpGet("~/__automation/resend-internal-email")]
        [ApiExplorerSettings(IgnoreApi = true)]
        public async Task<ActionResult> ResendInternalEmail(Guid emailId, CancellationToken cancellationToken) {

            await _smtpInternalEmailSender.ReSendEmail(emailId, cancellationToken);

            return Ok();

        }

        [HttpGet("~/__automation/resend-internal-emails-for-date")]
        [ApiExplorerSettings(IgnoreApi = true)]
        public async Task<ActionResult> ResendInternalEmailForDate(DateTime emailDate, CancellationToken cancellationToken) {

            await _smtpInternalEmailSender.ReSendEmailsForDate(emailDate, cancellationToken);

            return Ok();

        }

        [HttpGet("~/__automation/resend-external-email")]
        [ApiExplorerSettings(IgnoreApi = true)]
        public async Task<ActionResult> ResendExternalEmail(Guid emailId, CancellationToken cancellationToken) {

            await _mailGunExternalEmailSender.ReSendEmail(emailId, cancellationToken);

            return Ok();

        }

        [HttpGet("~/__automation/resend-external-emails-for-date")]
        [ApiExplorerSettings(IgnoreApi = true)]
        public async Task<ActionResult> ResendExternalEmailForDate(DateTime emailDate, CancellationToken cancellationToken) {

            await _mailGunExternalEmailSender.ReSendEmailsForDate(emailDate, cancellationToken);

            return Ok();

        }

    }

}