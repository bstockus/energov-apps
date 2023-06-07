using System;
using EnerGov.Data.Configuration;
using Lax.Data.Entities.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace EnerGov.Business.UtilityExcavation.UtilityCustomers {

    public class UtilityCustomer {

        public Guid EnerGovGlobalEntityId { get; set; }

        public string CustomerName { get; set; }
        public bool IsActive { get; set; }

        public class EntityModelBuilder : EntityFrameworkModelBuilder<ConfigurationDbContext, UtilityCustomer> {

            public override void Build(EntityTypeBuilder<UtilityCustomer> builder) {

                builder.ToTable("UtilityCustomers", UtilityExcavationSchemaConstants.SchemaName);

                builder.HasKey(_ => _.EnerGovGlobalEntityId);

                builder.FromValidator(rules => { rules.RuleFor(_ => _.CustomerName).AsUtilityCustomerName(); });

            }

        }

    }

}