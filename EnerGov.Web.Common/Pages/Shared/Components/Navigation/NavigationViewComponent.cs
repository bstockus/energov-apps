using System.Collections.Generic;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using EnerGov.Security.User;
using EnerGov.Web.Common.Navigation;
using Microsoft.Extensions.Logging;

namespace EnerGov.Web.Common.Pages.Shared.Components.Navigation {

    [ViewComponent(Name = "Navigation")]
    public class NavigationViewComponent : ViewComponent {

        public class NavBarViewModel {

            public UserInformation User { get; set; }
            public IEnumerable<NavigationSection> Sections { get; set; }

        }

        private readonly IEnumerable<INavigationSectionProvider> _navigationSectionProviders;
        private readonly IUserService _userService;
        private readonly ILogger<NavigationViewComponent> _logger;

        public NavigationViewComponent(
            IEnumerable<INavigationSectionProvider> navigationSectionProviders,
            IUserService userService,
            ILogger<NavigationViewComponent> logger) {

            _navigationSectionProviders = navigationSectionProviders;
            _userService = userService;
            _logger = logger;
        }

        public async Task<IViewComponentResult> InvokeAsync(bool forHomePage = false) {

            var navigationSections = new List<NavigationSection>();

            foreach (var navigationSectionProvider in _navigationSectionProviders) {

                navigationSections.Add(await navigationSectionProvider.GenerateNavigationSection());

            }

            if (forHomePage) {
                return View("ForHomePage", navigationSections);
            }

            _logger.LogInformation($"******  HttpContext.User.AuthenticationType = {HttpContext.User.Identity.AuthenticationType}");
            _logger.LogInformation($"******  HttpContext.User.Name = {HttpContext.User.Identity.Name}");

            foreach (var userClaim in HttpContext.User.Claims) {
                _logger.LogInformation($"   ********  Claims['{userClaim.Type}'] = '{userClaim.Value}'");
            }

            return View(new NavBarViewModel {
                User = await _userService.GetUserInformationForClaimsPrincipal(HttpContext.User),
                Sections = navigationSections
            });

        }

    }

}
