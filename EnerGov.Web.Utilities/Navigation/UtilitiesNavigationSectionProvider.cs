using System.Threading.Tasks;
using EnerGov.Web.Common.Navigation;
using EnerGov.Web.Utilities.Constants;

namespace EnerGov.Web.Utilities.Navigation {
    public class UtilitiesNavigationSectionProvider : INavigationSectionProvider {

        public async Task<NavigationSection> GenerateNavigationSection() => await Task.FromResult(new NavigationSection(
            "Utilities",
            new RoutedNavigationItem(
                "Reset Parcel Owner Contacts",
                "Reset Parcel Owner Contacts",
                AreaConstants.Utilities,
                PageConstants.ResetParcelOwnerContacts)));

    }
}
