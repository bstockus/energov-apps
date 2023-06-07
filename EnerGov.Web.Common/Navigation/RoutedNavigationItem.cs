using System.Collections.Generic;

namespace EnerGov.Web.Common.Navigation {

    public abstract class BaseNavigationItem {

        protected BaseNavigationItem(string title, string shortTitle) {
            Title = title;
            ShortTitle = shortTitle;
        }

        public string Title { get; }
        public string ShortTitle { get; }

    }

    public class RoutedNavigationItem : BaseNavigationItem {
        
        public string Area { get; }
        public string Page { get; }
        public IDictionary<string, string> RouteValues { get; }

        public RoutedNavigationItem(string title, string shortTitle, string area, string page) : this(title, shortTitle, area,
            page, new Dictionary<string, string>()) { }

        public RoutedNavigationItem(string title, string shortTitle, string area, string page,
            IDictionary<string, string> routeValues) : base(title, shortTitle) {
            Area = area;
            Page = page;
            RouteValues = routeValues;
        }

    }

    public class UrlNavigationItem : BaseNavigationItem {

        public string Url { get; }

        public UrlNavigationItem(string title, string shortTitle, string url) : base(title, shortTitle) {
            Url = url;
        }

    }

}