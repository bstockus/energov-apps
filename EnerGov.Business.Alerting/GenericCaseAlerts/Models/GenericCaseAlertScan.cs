using System;
using EnerGov.Data.Configuration;
using Lax.Data.Entities.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace EnerGov.Business.Alerting.GenericCaseAlerts.Models {

    public class GenericCaseAlertScan {

        public string Module { get; set; }
        public Guid CaseId { get; set; }
        public int RowVersion { get; set; }
        public DateTime DateScanned { get; set; }
        public Guid? CaseStatusId { get; set; }

        public class EntityModelBuilder : EntityFrameworkModelBuilder<ConfigurationDbContext, GenericCaseAlertScan> {
            
            public override void Build(EntityTypeBuilder<GenericCaseAlertScan> builder) {

                builder.ToTable("GenericCaseAlertScans", AlertingSchemaConstants.SchemaName);

                builder.HasKey(_ => new {
                    _.Module,
                    _.CaseId,
                    _.RowVersion
                });

                builder.Property(_ => _.Module).IsRequired().HasMaxLength(20);

            }

        }

    }

}