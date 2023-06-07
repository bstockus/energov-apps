namespace EnerGov.Business.Exports.MarketDrive {

    public class MarketDriveExportConfiguration {

        public class StatusMapEntry {

            public string Name { get; set; }

            public string[] EnerGovIds { get; set; }

        }

        public string[] IncludePermitTypes { get; set; }

        public string[] ExcludePermitWorkClasses { get; set; }

        public StatusMapEntry[] StatusMap { get; set; }

        public string ExcludePermitsWithNumberPrefix { get; set; }

        public string IncludePermitsWithParcelNumberPrefix { get; set; }

        public int NumberOfDaysToPullClosedPermits { get; set; }

    }

}