using System;

namespace EnerGov.Business.FireOccupancy.InspectionAutomations.Tasks.ReInspectionCreation {

    public class InspectionInformation {

        public string InspectionPerformedBy { get; set; }
        public string InspectionTypeId { get; set; }
        public string GlobalEntityExtensionId { get; set; }
        public string GlobalEntityDBA { get; set; }
        public string RegistrationNumber { get; set; }
        public string ZoneId { get; set; }
        public int OrderNumber { get; set; }
        public string InspectionNumber { get; set; }
        public string Comments { get; set; }
        public int OpenNonCompliances { get; set; }
        public DateTime? NextDeadlineResolveDate { get; set; }

    }

}