using System.Collections.Generic;
using System.Linq;

namespace EnerGov.Business.Alerting.GenericCaseAlerts.Models {

    public static class GenericCaseAlertSpecificationExtensions {

        public static IEnumerable<string>
            TypeFilters(this GenericCaseAlertSpecification genericCaseAlertSpecification) =>
            genericCaseAlertSpecification.TypeFilter.Split(',').Select(_ => _.ToUpper())
                .Where(_ => !string.IsNullOrWhiteSpace(_)).ToList();

        public static IEnumerable<string> WorkClassFilters(
            this GenericCaseAlertSpecification genericCaseAlertSpecification) =>
            genericCaseAlertSpecification.WorkClassFilter.Split(',').Select(_ => _.ToUpper())
                .Where(_ => !string.IsNullOrWhiteSpace(_)).ToList();

        public static IEnumerable<string> StatusChangeEventStatuses(
            this GenericCaseAlertSpecification genericCaseAlertSpecification) =>
            genericCaseAlertSpecification.Event.Replace("StatusChanged ", "").Split(',').ToList();

        public static bool IsStatusChangeEvent(this GenericCaseAlertSpecification genericCaseAlertSpecification) =>
            genericCaseAlertSpecification.Event.StartsWith("StatusChanged");

        public static bool IsCreatedEvent(this GenericCaseAlertSpecification genericCaseAlertSpecification) =>
            genericCaseAlertSpecification.Event.StartsWith("Created");

        public static bool IsPaidEvent(this GenericCaseAlertSpecification genericCaseAlertSpecification) =>
            genericCaseAlertSpecification.Event.StartsWith("Paid");

        public static IEnumerable<string> AllRecipients(
            this GenericCaseAlertSpecification genericCaseAlertSpecification,
            string assignedTo = null) =>
            genericCaseAlertSpecification.Recipients.Split(';').Select(_ => _.Replace("ASSIGNED-TO", assignedTo ?? ""))
                .Where(_ => !string.IsNullOrWhiteSpace(_)).ToList();

    }

}