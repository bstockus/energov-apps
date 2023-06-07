using System;

namespace EnerGov.Business.FireOccupancy.InspectionAutomations.Tasks.ExternalReportEmail {

    public class InspectionContactInformation {

        public string GlobalEntityName { get; set; }
        public string PersonName { get; set; }
        public string EmailAddress { get; set; }
        public string InspectionPerformedBy { get; set; }
        public string OccupancyNumber { get; set; }
        public string OccupancyName { get; set; }
        public string InspectionNumber { get; set; }
        public string ParcelNumber { get; set; }
        public string HouseNumber { get; set; }
        public string StreetName { get; set; }
        public string StreetType { get; set; }
        public string PostDirection { get; set; }
        public string UnitNumber { get; set; }
        public string ZoneId { get; set; }
        public DateTime? ActualDate { get; set; }

        public string ContactName =>
            !string.IsNullOrWhiteSpace(PersonName) ? PersonName : GlobalEntityName;

        public string FormattedActualDate => ActualDate?.ToShortDateString() ?? "";

    }

}