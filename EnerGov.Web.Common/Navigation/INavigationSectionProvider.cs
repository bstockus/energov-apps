using System.Threading.Tasks;

namespace EnerGov.Web.Common.Navigation {

    public interface INavigationSectionProvider {

        Task<NavigationSection> GenerateNavigationSection();

    }

}
