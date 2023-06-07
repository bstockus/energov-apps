using System.Threading.Tasks;
using EnerGov.Business.UtilityExcavation.EnerGovInvoices;
using EnerGov.Security.User;
using EnerGov.Web.Common.Infrastructure;
using MediatR;
using Microsoft.AspNetCore.Mvc;

namespace EnerGov.Web.UtilityExcavation.Areas.UtilityExcavation.Pages.Modals {

    public class MarkInvoicePaidModel : ModalPageModel {

        [BindProperty]
        public string InvoiceId { get; set; }

        [BindProperty]
        public string JournalYear { get; set; }

        [BindProperty]
        public string JournalPeriod { get; set; }

        [BindProperty]
        public string JournalNumber { get; set; }

        public MarkInvoicePaidModel(IMediator mediator, IUserService userService) : base(mediator, userService) { }
        
        public void OnGet(string invoiceId) {

        }

        public async Task<ActionResult> OnPostAsync() {

            await Mediator.Send(new MarkInvoicePaidCommand {
                InvoiceId = InvoiceId,
                JournalYear = JournalYear,
                JournalPeriod = JournalPeriod,
                JournalNumber = JournalNumber
            });

            return RedirectToReferrer();

        }

    }

}
