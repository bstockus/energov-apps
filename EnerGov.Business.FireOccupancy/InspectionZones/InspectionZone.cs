using System;
using EnerGov.Data.Configuration;
using Lax.Data.Entities.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace EnerGov.Business.FireOccupancy.InspectionZones {

    public class InspectionZone {

        public Guid InspectionZoneId { get; set; }
        public string ZoneAbbreviation { get; set; }
        public string ZoneName { get; set; }
        public bool IsZoneEscalatable { get; set; }
        public string ZoneEscalationContactEmail { get; set; }

        public class EntityModelBuilder : EntityFrameworkModelBuilder<ConfigurationDbContext, InspectionZone> {

            public override void Build(EntityTypeBuilder<InspectionZone> builder) {

                builder.ToTable(
                    "InspectionZones",
                    FireOccupancySchemaConstants.SchemaName);

                builder.HasKey(_ => _.InspectionZoneId);
                builder.HasAlternateKey(_ => _.ZoneAbbreviation);

                builder.FromValidator(rules => {
                    rules.RuleFor(_ => _.ZoneAbbreviation).AsInspectionZoneAbbreviation();
                    rules.RuleFor(_ => _.ZoneName).AsInspectionZoneName();
                    rules.RuleFor(_ => _.ZoneEscalationContactEmail).AsInspectionZoneEscalationContactEmail();
                });

            }

        }

    }

}
