using System;
using EnerGov.Data.Configuration;
using Lax.Data.Entities.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace EnerGov.Business.Alerting.NewCssPermitAlerts.Models {

    public class NewCssPermitAlertType {

        public Guid PermitTypeId { get; set; }
        public Guid PermitWorkClassId { get; set; }
        public bool SendAlerts { get; set; }
        public bool IsBuildingDistrictRouted { get; set; }
        public string EmailsToAlert { get; set; }

        public class EntityModelBuilder : EntityFrameworkModelBuilder<ConfigurationDbContext, NewCssPermitAlertType> {

            public override void Build(EntityTypeBuilder<NewCssPermitAlertType> builder) {

                builder.ToTable("NewCssPermitAlertTypes", AlertingSchemaConstants.SchemaName);

                builder.HasKey(_ => new {
                    _.PermitTypeId,
                    _.PermitWorkClassId
                });

                builder.Property(_ => _.EmailsToAlert).HasMaxLength(1024);

            }

        }

    }

}