using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Lax.Cli.Common;
using MediatR;

namespace EnerGov.Business.Utilities.ResetParcelOwnerContacts {
    public class TestTask : CliTask {

        private readonly IMediator _mediator;

        public TestTask(
            IMediator mediator) {
            _mediator = mediator;
        }

        public override async Task Run(ILookup<string, string> args, IEnumerable<string> flags) {

            await _mediator.Send(
                new ResetParcelOwnerContactCommand {
                    ParcelNumber = "17-20219-20"
                });

        }

        public override string Name => "reset-parcel-owner-contacts";

    }
}
