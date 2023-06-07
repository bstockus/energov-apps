using System.Linq;
using System.Threading.Tasks;
using EnerGov.Business.Utilities.ResetParcelOwnerContacts;
using EnerGov.Security.User;
using EnerGov.Web.Common.Infrastructure;
using MediatR;
using Microsoft.AspNetCore.Mvc;

namespace EnerGov.Web.Utilities.Areas.Utilities.Pages {

    public class ResetParcelOwnerContactsModel : BasePageModel {

        [BindProperty]
        public string ParcelNumber { get; set; }

        [TempData]
        public string Message { get; set; }



        public ResetParcelOwnerContactsModel(
            IMediator mediator, 
            IUserService userService) :
            base(mediator, userService) { }

        public async Task<ActionResult> OnPostAsync() {

            var parcelsAffected = await Mediator.Send(new ResetParcelOwnerContactCommand {
                ParcelNumber = ParcelNumber
            });

            Message =
                $"Updated Parcel(s): {parcelsAffected.Aggregate("", (s, information) => s + $", {information.ParcelNumber}")}.";

            return Page();
        }

    }

}