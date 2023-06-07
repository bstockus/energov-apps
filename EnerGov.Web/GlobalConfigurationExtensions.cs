using Microsoft.Extensions.Configuration;

namespace EnerGov.Web {

    public static class GlobalConfigurationExtensions {
        
        public static string GetImpersonateUser(this IConfiguration configuration) =>
            configuration.GetValue<string>("ImpersonateUser");
        
    }

}