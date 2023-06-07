using System;
using EnerGov.Data.Configuration;
using Lax.Data.Entities.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace EnerGov.Business.Alerting.GenericCaseAlerts.Models {

    public class GenericCaseAlertFeeScan {

        public string Module { get; set; }
        public Guid CaseId { get; set; }
        public Guid InvoiceId { get; set; }
        public int RowVersion { get; set; }
        public DateTime DateScanned { get; set; }
        public int InvoiceStatusId { get; set; }

        public class EntityModelBuilder : EntityFrameworkModelBuilder<ConfigurationDbContext, GenericCaseAlertFeeScan> {

            public override void Build(EntityTypeBuilder<GenericCaseAlertFeeScan> builder) {

                builder.ToTable("GenericCaseAlertFeeScans", AlertingSchemaConstants.SchemaName);

                builder.HasKey(_ => new {
                    _.Module,
                    _.CaseId,
                    _.InvoiceId,
                    _.RowVersion
                });

                builder.Property(_ => _.Module).IsRequired().HasMaxLength(20);

            }

        }

    }

}