using System;
using System.Reflection;
using System.Threading.Tasks;

namespace EnerGov.Services.Templating {

    public interface ITemplateRenderingService {

        Task<string> GenerateAsync(Assembly assembly, string fileName, object model, Type[] additionalTypesToWhitelist = null);

        Task<string> GenerateAsync(string templateText, object model, Type[] additionalTypesToWhitelist = null);

    }

}
