using System.Collections.Generic;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;
using EnerGov.Business.Alerting.GenericCaseAlerts;
using EnerGov.Services.Email.Senders;
using Lax.Cli.Common;

namespace EnerGov.Business.Alerting {
    public class AlertingTestTask : CliTask {

        private readonly GenericCaseAlertTask _genericCaseAlertTask;
        private readonly SmtpInternalEmailSender _smtpInternalEmailSender;

        public override string Name => "alerting-test";

        public AlertingTestTask(
            GenericCaseAlertTask genericCaseAlertTask,
            SmtpInternalEmailSender smtpInternalEmailSender) {
            _genericCaseAlertTask = genericCaseAlertTask;
            _smtpInternalEmailSender = smtpInternalEmailSender;
        }

        public override async Task Run(ILookup<string, string> args, IEnumerable<string> flags) {

            await _genericCaseAlertTask.Run(CancellationToken.None);
            //await _internalEmailSender.SendEmails(CancellationToken.None);

        }

        

    }
}
