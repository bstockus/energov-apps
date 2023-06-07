using System.Threading.Tasks;
using EnerGov.Web.ClerksLicensing.Constants;
using EnerGov.Web.Common.Navigation;

namespace EnerGov.Web.ClerksLicensing.Navigation {
    public class ClerksLicensingNavigationSectionProvider : INavigationSectionProvider {

        public async Task<NavigationSection> GenerateNavigationSection() =>
            await Task.FromResult(
                new NavigationSection(
                    "Clerks Licensing",
                    new RoutedNavigationItem(
                        "Renewal Packet Generator",
                        "Renewal Packet",
                        AreaConstants.ClerksLicensing,
                        PageConstants.LicenseRenewalPacket),
                    new RoutedNavigationItem(
                        "License Packet Generator",
                        "License Packet",
                        AreaConstants.ClerksLicensing,
                        PageConstants.LicenseRenewalGenerator)));

    }
}
