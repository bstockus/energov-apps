using System.Collections.Generic;
using System.Threading.Tasks;
using EnerGov.Web.Common.Navigation;
using EnerGov.Web.UtilityExcavation.Constants;

namespace EnerGov.Web.UtilityExcavation.Navigation {

    public class UtilityExcavationNavigationSectionProvider : INavigationSectionProvider {

        public async Task<NavigationSection> GenerateNavigationSection() =>
            await Task.FromResult(
                new NavigationSection(
                    "Utility Excavation",
                    new RoutedNavigationItem(
                        "View GL Account Setup",
                        "GL Account Setup",
                        AreaConstants.UtilityExcavation,
                        PageConstants.GLAccountList),
                    new RoutedNavigationItem(
                        "View Open Invoices",
                        "Open Invoices",
                        AreaConstants.UtilityExcavation,
                        PageConstants.InvoiceList),
                    new RoutedNavigationItem(
                        "View All Invoices",
                        "All Invoices",
                        AreaConstants.UtilityExcavation,
                        PageConstants.InvoiceList,
                        new Dictionary<string, string> {
                            {"includeAllInvoices", "true"}
                        }),
                    new UrlNavigationItem(
                        "Un Invoiced Utility Fees",
                        "Un Invoiced",
                        "http://lax-sql1/Reports/browse/EnerGov/Production/Prod/Un%20Invoiced%20Utility%20Fees")));

    }

}
