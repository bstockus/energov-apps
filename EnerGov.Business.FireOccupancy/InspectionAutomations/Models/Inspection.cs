using System;
using System.Collections.Generic;
using EnerGov.Data.Configuration;
using Lax.Data.Entities.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace EnerGov.Business.FireOccupancy.InspectionAutomations.Models {

    public class Inspection {

        public Guid InspectionId { get; set; }
        public int RowVersion { get; set; }
        public DateTime DateScanned { get; set; }
        public Guid InspectionStatusId { get; set; }

        public virtual ICollection<InspectionEmail> Emails { get; set; } = new HashSet<InspectionEmail>();

        public virtual ICollection<ReInspection> ReInspections { get; set; } = new HashSet<ReInspection>();

        public virtual ICollection<InspectionFollowUp> InspectionFollowUps { get; set; } =
            new HashSet<InspectionFollowUp>();

        public class EntityModelBuilder : EntityFrameworkModelBuilder<ConfigurationDbContext, Inspection> {

            public override void Build(EntityTypeBuilder<Inspection> builder) {

                builder.ToTable("Inspections", FireOccupancySchemaConstants.SchemaName);

                builder.HasKey(_ => new {
                    _.InspectionId,
                    _.RowVersion
                });
                
            }

        }

    }

}
