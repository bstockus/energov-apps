using System;
using EnerGov.Data.Configuration;
using Lax.Data.Entities.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace EnerGov.Business.FireOccupancy.InspectionAutomations.Models {

    public class ReInspection {

        public Guid InspectionId { get; set; }
        public int RowVersion { get; set; }
        public Guid ReInspectionId { get; set; }
        public DateTime? DateNotificationSent { get; set; }
        public DateTime? LastNotificationAttemptDate { get; set; }
        public int NotificationFailureCount { get; set; }
        public DateTime? DateReminderSend { get; set; }
        public DateTime? LastReminderAttemptDate { get; set; }
        public int ReminderFailureCount { get; set; }

        public virtual Inspection Inspection { get; set; }

        public class EntityModelBuilder : EntityFrameworkModelBuilder<ConfigurationDbContext, ReInspection> {

            public override void Build(EntityTypeBuilder<ReInspection> builder) {

                builder.ToTable("ReInspections", FireOccupancySchemaConstants.SchemaName);

                builder.HasKey(_ => new {
                    _.InspectionId,
                    _.RowVersion,
                    _.ReInspectionId
                });

                builder
                    .HasOne(_ => _.Inspection)
                    .WithMany(_ => _.ReInspections)
                    .HasForeignKey(_ => new {
                        _.InspectionId,
                        _.RowVersion
                    })
                    .OnDelete(DeleteBehavior.Cascade);

            }

        }

    }

}