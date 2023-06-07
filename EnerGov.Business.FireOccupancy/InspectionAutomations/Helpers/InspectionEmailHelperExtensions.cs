using System;
using EnerGov.Business.FireOccupancy.InspectionAutomations.Models;
using EnerGov.Data.Configuration;
using EnerGov.Services.Email.Helpers;

namespace EnerGov.Business.FireOccupancy.InspectionAutomations.Helpers {

    public static class InspectionEmailHelperExtensions {

        public static void QueueInternalInspectionEmail(
            this ConfigurationDbContext dbContext,
            Guid inspectionId,
            int rowVersion,
            EmailMessage emailMessage) {

            var emailId = dbContext.QueueInternalEmail(emailMessage);

            dbContext.Set<InspectionEmail>().Add(
                new InspectionEmail {
                    InspectionId = inspectionId,
                    RowVersion = rowVersion,
                    EmailId = emailId
                });

        }

        public static void QueueExternalInspectionEmail(
            this ConfigurationDbContext dbContext,
            Guid inspectionId,
            int rowVersion,
            EmailMessage emailMessage) {

            var emailId = dbContext.QueueExternalEmail(emailMessage);

            dbContext.Set<InspectionEmail>().Add(
                new InspectionEmail {
                    InspectionId = inspectionId,
                    RowVersion = rowVersion,
                    EmailId = emailId
                });

        }

    }

}
