using System.Threading.Tasks;
using EnerGov.Web.Common.Navigation;
using EnerGov.Web.Exports.Constants;

namespace EnerGov.Web.Exports.Navigation {
    public class ExportNavigationSectionProvider : INavigationSectionProvider {

        public async Task<NavigationSection> GenerateNavigationSection() =>
            await Task.FromResult(
                new NavigationSection(
                    "Exports",
                    new RoutedNavigationItem(
                        "Market Drive",
                        "Market Drive",
                        AreaConstants.Exports,
                        PageConstants.MarketDrive)));

    }
}
