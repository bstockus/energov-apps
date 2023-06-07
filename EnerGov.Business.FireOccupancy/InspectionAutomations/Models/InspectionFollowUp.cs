using System;
using EnerGov.Data.Configuration;
using Lax.Data.Entities.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace EnerGov.Business.FireOccupancy.InspectionAutomations.Models {

    public class InspectionFollowUp {

        public Guid InspectionId { get; set; }
        public int RowVersion { get; set; }
        public Guid InspectionNonComplianceCodeId { get; set; }
        public DateTime FollowUpDate { get; set; }
        public DateTime? DateNotificationSent { get; set; }
        public DateTime? LastNotificationAttemptDate { get; set; }
        public int NotificationFailureCount { get; set; }
        public DateTime? DateReminderSend { get; set; }
        public DateTime? LastReminderAttemptDate { get; set; }
        public int ReminderFailureCount { get; set; }
        public DateTime? ConfirmationDate { get; set; }
        public string ConfirmationUserWindowsSid { get; set; }

        public virtual Inspection Inspection { get; set; }

        public class EntityModelBuilder : EntityFrameworkModelBuilder<ConfigurationDbContext, InspectionFollowUp> {

            public override void Build(EntityTypeBuilder<InspectionFollowUp> builder) {

                builder.ToTable("InspectionFollowUps", FireOccupancySchemaConstants.SchemaName);

                builder.HasKey(_ => new {
                    _.InspectionId,
                    _.RowVersion,
                    _.InspectionNonComplianceCodeId
                });

                builder
                    .Property(_ => _.ConfirmationUserWindowsSid)
                    .HasMaxLength(100)
                    .IsRequired(false);

                builder
                    .HasOne(_ => _.Inspection)
                    .WithMany(_ => _.InspectionFollowUps)
                    .HasForeignKey(_ => new {
                        _.InspectionId,
                        _.RowVersion
                    })
                    .OnDelete(DeleteBehavior.Cascade);

            }

        }

    }

}