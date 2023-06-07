using System;
using System.Threading;
using System.Threading.Tasks;

namespace EnerGov.Services.Email.Senders {

    public interface IEmailSender {

        Task SendEmails(CancellationToken cancellationToken);

        Task ReSendEmail(Guid emailId, CancellationToken cancellationToken);

        Task ReSendEmailsForDate(DateTime date, CancellationToken cancellationToken);

    }

}