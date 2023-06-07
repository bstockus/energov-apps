using System;
using EnerGov.Data.Configuration;
using Lax.Data.Entities.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace EnerGov.Business.Alerting.NewCssPermitAlerts.Models {

    public class NewCssPermitAlert {

        public Guid PermitId { get; set; }
        public DateTime TimeStamp { get; set; }
        public string EmailsNotified { get; set; }

        public class EntityModelBuilder : EntityFrameworkModelBuilder<ConfigurationDbContext, NewCssPermitAlert> {

            public override void Build(EntityTypeBuilder<NewCssPermitAlert> builder) {

                builder.ToTable("NewCssPermitAlerts", AlertingSchemaConstants.SchemaName);

                builder.HasKey(_ => _.PermitId);

                builder.Property(_ => _.EmailsNotified).HasMaxLength(1024);

            }

        }

    }

}
