using System;
using EnerGov.Data.Configuration;
using EnerGov.Services.Email.Models;
using Lax.Data.Entities.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace EnerGov.Business.FireOccupancy.InspectionAutomations.Models {

    public class InspectionEmail {

        public Guid InspectionId { get; set; }
        public int RowVersion { get; set; }
        public Guid EmailId { get; set; }

        public virtual Inspection Inspection { get; set; }
        public virtual Email Email { get; set; }

        public class EntityModelBuilder : EntityFrameworkModelBuilder<ConfigurationDbContext, InspectionEmail> {

            public override void Build(EntityTypeBuilder<InspectionEmail> builder) {

                builder.ToTable("InspectionEmails", FireOccupancySchemaConstants.SchemaName);

                builder.HasKey(_ => new {
                    _.InspectionId,
                    _.RowVersion,
                    _.EmailId
                });

                builder
                    .HasOne(_ => _.Inspection)
                    .WithMany(_ => _.Emails)
                    .HasForeignKey(_ => new {
                        _.InspectionId,
                        _.RowVersion
                    })
                    .OnDelete(DeleteBehavior.Cascade);

                builder
                    .HasOne(_ => _.Email)
                    .WithMany()
                    .HasForeignKey(_ => _.EmailId)
                    .OnDelete(DeleteBehavior.Cascade);

            }

        }

    }

}