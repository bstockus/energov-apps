namespace EnerGov.Web.Common.Navigation {

    public class NavigationSection {

        public string Title { get; }
        public BaseNavigationItem[] NavigationItems { get; }

        public NavigationSection(string title, params BaseNavigationItem[] navigationItems) {
            Title = title;
            NavigationItems = navigationItems;
        }

    }

}