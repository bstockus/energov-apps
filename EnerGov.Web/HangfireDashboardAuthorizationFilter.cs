using Hangfire.Dashboard;

namespace EnerGov.Web {

    public class HangfireDashboardAuthorizationFilter : IDashboardAuthorizationFilter {

        public bool Authorize(DashboardContext context) => context.GetHttpContext().User.Identity.IsAuthenticated;

    }

}