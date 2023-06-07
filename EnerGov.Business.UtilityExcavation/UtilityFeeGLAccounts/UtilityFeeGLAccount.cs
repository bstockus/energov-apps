using System;
using EnerGov.Data.Configuration;
using Lax.Data.Entities.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace EnerGov.Business.UtilityExcavation.UtilityFeeGLAccounts {

    public class UtilityFeeGLAccount {

        public Guid EnerGovFeeId { get; set; }
        public Guid EnerGovPickListItemId { get; set; }

        public string MunisRevenueAccountOrg { get; set; }
        public string MunisRevenueAccountObject { get; set; }
        public string MunisRevenueAccountProject { get; set; }

        public string MunisRevenueCashAccountOrg { get; set; }
        public string MunisRevenueCashAccountObject { get; set; }
        public string MunisRevenueCashAccountProject { get; set; }

        public string MunisExpenseAccountOrg { get; set; }
        public string MunisExpenseAccountObject { get; set; }
        public string MunisExpenseAccountProject { get; set; }

        public string MunisExpenseCashAccountOrg { get; set; }
        public string MunisExpenseCashAccountObject { get; set; }
        public string MunisExpenseCashAccountProject { get; set; }

        public class EntityModelBuilder : EntityFrameworkModelBuilder<ConfigurationDbContext, UtilityFeeGLAccount> {

            public override void Build(EntityTypeBuilder<UtilityFeeGLAccount> builder) {

                builder.ToTable("UtilityFeeGLAccounts", UtilityExcavationSchemaConstants.SchemaName);

                builder.HasKey(_ => new {
                    _.EnerGovFeeId,
                    _.EnerGovPickListItemId
                });

                builder.FromValidator(rules => {

                    rules.RuleFor(_ => _.MunisRevenueAccountOrg).AsMunisAccountOrg();
                    rules.RuleFor(_ => _.MunisRevenueAccountObject).AsMunisAccountObject();
                    rules.RuleFor(_ => _.MunisRevenueAccountProject).AsMunisAccountProject();

                    rules.RuleFor(_ => _.MunisRevenueCashAccountOrg).AsMunisAccountOrg();
                    rules.RuleFor(_ => _.MunisRevenueCashAccountObject).AsMunisAccountObject();
                    rules.RuleFor(_ => _.MunisRevenueCashAccountProject).AsMunisAccountProject();

                    rules.RuleFor(_ => _.MunisExpenseAccountOrg).AsMunisAccountOrg();
                    rules.RuleFor(_ => _.MunisExpenseAccountObject).AsMunisAccountObject();
                    rules.RuleFor(_ => _.MunisExpenseAccountProject).AsMunisAccountProject();

                    rules.RuleFor(_ => _.MunisExpenseCashAccountOrg).AsMunisAccountOrg();
                    rules.RuleFor(_ => _.MunisExpenseCashAccountObject).AsMunisAccountObject();
                    rules.RuleFor(_ => _.MunisExpenseCashAccountProject).AsMunisAccountProject();

                });

            }

        }

    }

}
