using EnerGov.Data.Configuration;
using Lax.Data.Entities.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace EnerGov.Business.Alerting.GenericCaseAlerts.Models {

    public class GenericCaseAlertSpecification {

        public string Name { get; set; }
        public bool IsEnabled { get; set; }
        public string Module { get; set; }
        public string Event { get; set; }
        public string TypeFilter { get; set; }
        public string WorkClassFilter { get; set; }
        public string Recipients { get; set; }
        public string Subject { get; set; }
        public string BodyText { get; set; }
        public string BodyHtml { get; set; }
        public string AdditionalSqlPredicate { get; set; }

        public class EntityModelBuilder : EntityFrameworkModelBuilder<ConfigurationDbContext, GenericCaseAlertSpecification> {

            public override void Build(EntityTypeBuilder<GenericCaseAlertSpecification> builder) {

                builder.ToTable("GenericCaseAlertSpecifications", AlertingSchemaConstants.SchemaName);

                builder.HasKey(_ => _.Name);

                builder.Property(_ => _.Name).HasMaxLength(100);
                builder.Property(_ => _.Module).IsRequired().HasMaxLength(20);
                builder.Property(_ => _.Event).IsRequired().HasMaxLength(1000);
                builder.Property(_ => _.TypeFilter).IsRequired().HasMaxLength(1000);
                builder.Property(_ => _.WorkClassFilter).IsRequired().HasMaxLength(1000);
                builder.Property(_ => _.Recipients).IsRequired().HasMaxLength(1000);
                builder.Property(_ => _.Subject).IsRequired().HasMaxLength(200);
                builder.Property(_ => _.BodyText).IsRequired();
                builder.Property(_ => _.BodyHtml).IsRequired();
                builder.Property(_ => _.AdditionalSqlPredicate).IsRequired().HasMaxLength(1000);

            }

        }

    }

}
