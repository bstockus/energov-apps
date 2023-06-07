using System;
using AutoMapper;

namespace EnerGov.Business.UtilityExcavation.UtilityFeeGLAccounts {

    public class UtilityFeeGLAccountInformation {

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

        public class Mapper : Profile {

            public Mapper() {
                CreateMap<UtilityFeeGLAccount, UtilityFeeGLAccountInformation>();
            }

        }

    }

}