using System;
using EnerGov.Data.Configuration;
using Lax.Data.Entities.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace EnerGov.Business.FireOccupancy.InspectionAutomations.Models {

    public class Inspector {

        public Guid CustomFieldPickListItemId { get; set; }
        public string EmailAddress { get; set; }

        public class EntityModelBuilder : EntityFrameworkModelBuilder<ConfigurationDbContext, Inspector> {

            public override void Build(EntityTypeBuilder<Inspector> builder) {

                builder.ToTable("Inspectors", FireOccupancySchemaConstants.SchemaName);

                builder.HasKey(_ => _.CustomFieldPickListItemId);

                builder.Property(_ => _.EmailAddress).IsRequired().HasMaxLength(255);

            }

        }

    }

}