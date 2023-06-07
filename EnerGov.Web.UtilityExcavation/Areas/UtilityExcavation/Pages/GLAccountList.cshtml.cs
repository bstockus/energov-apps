using System.Collections.Generic;
using System.Threading.Tasks;
using EnerGov.Business.UtilityExcavation.UtilityFeeGLAccounts;
using EnerGov.Security.User;
using EnerGov.Web.Common.Infrastructure;
using MediatR;
using Microsoft.AspNetCore.Authorization;

namespace EnerGov.Web.UtilityExcavation.Areas.UtilityExcavation.Pages {

    [Authorize()]
    public class GLAccountListModel : BasePageModel {

        public IEnumerable<UtilityFeeGLAccountDetailedInformation> AccountInfo { get; set; }

        public GLAccountListModel(IMediator mediator, IUserService userService) : base(mediator, userService) { }

        public async Task OnGetAsync() {

            var accounts = await Mediator.Send(new FetchAllUtilityFeeGLAccountsQuery());

            var detailedAccounts = new List<UtilityFeeGLAccountDetailedInformation>();

            foreach (var account in accounts) {
                detailedAccounts.Add(await Mediator.Send(
                    new FetchUtilityFeeGLAccountQuery(account.EnerGovFeeId, account.EnerGovPickListItemId)));
            }

            AccountInfo = detailedAccounts;

        }

    }

}
