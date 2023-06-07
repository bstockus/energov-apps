using System;

namespace EnerGov.Business.FireOccupancy {

    public class FireOccupancyConfiguration {

        public class ScanningOptions {

            public Guid[] InspectionTypeIds { get; set; }

            public Guid[] ReInspectionNotificationStatusIds { get; set; }

        }

        public class NotificationOptions {

            public string[] ErrorNotifications { get; set; }

            public class StandardNotificationOptions {

                public string[] Recipients { get; set; }
                public string FromAddress { get; set; }

            }

            public StandardNotificationOptions ChangeInOccupancyEmail { get; set; }
            public StandardNotificationOptions ReferredToFirePreventionEmail { get; set; }
            public StandardNotificationOptions ReferredToBuildingSafetyEmail { get; set; }
            public StandardNotificationOptions InternalReportEmail { get; set; }
            public StandardNotificationOptions ExternalReportEmail { get; set; }
            public StandardNotificationOptions ReInspectionNotificationEmail { get; set; }

        }


        public class ReportingOptions {

            public string FireInspectionLetterReportUrl { get; set; }
            public string FireInspectionLetterWithAddressReportUrl { get; set; }

        }

        public ScanningOptions Scanning { get; set; }
        public NotificationOptions Notification { get; set; }
        public ReportingOptions Reporting { get; set; }
    }

}