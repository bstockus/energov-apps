using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using EnerGov.Business.UtilityExcavation.EnerGovInvoices;
using EnerGov.Business.UtilityExcavation.UtilityCustomers;
using EnerGov.Security.User;
using EnerGov.Web.Common.Infrastructure;
using MediatR;
using Microsoft.AspNetCore.Authorization;

namespace EnerGov.Web.UtilityExcavation.Areas.UtilityExcavation.Pages {

    [Authorize]
    public class InvoiceListModel : BasePageModel {

        public IDictionary<Guid, UtilityCustomerInfo> UtilityCustomerInfo { get; set; }
        public IEnumerable<FetchAllInvoicesForCustomersQuery.ResultInvoiceItem> Invoices { get; set; }
        public bool IncludeAllInvoices { get; set; }

        public InvoiceListModel(IMediator mediator, IUserService userService) : base(mediator, userService) { }

        public async Task OnGetAsync(bool includeAllInvoices = false) {

            IncludeAllInvoices = includeAllInvoices;

            var utilityCustomers = await Mediator.Send(new FetchAllActiveUtilityCustomersQuery());

            UtilityCustomerInfo = utilityCustomers.ToDictionary(_ => _.EnerGovGlobalEntityId, _ => _);

            Invoices =
                await Mediator.Send(
                    new FetchAllInvoicesForCustomersQuery(includeAllInvoices, utilityCustomers
                        .Select(_ => _.EnerGovGlobalEntityId)
                        .ToArray()));

        }

    }

}
