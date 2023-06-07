using System;
using System.Collections.Generic;

namespace EnerGov.Business.UtilityExcavation.UtilityFeeGLAccounts {

    public class UtilityFeeGLAccountDetailedInformation {

        public class MunisAccount {

            public string AccountDescription { get; set; }
            public string OrganizationDescription { get; set; }
            public string AccountType { get; set; }
            public string BalanceType { get; set; }

            public string AccountOrgCode { get; set; }
            public string AccountObjectCode { get; set; }
            public string AccountProjectCode { get; set; }

            public override bool Equals(object obj) {
                var account = obj as MunisAccount;
                return account != null &&
                       AccountDescription == account.AccountDescription &&
                       OrganizationDescription == account.OrganizationDescription &&
                       AccountType == account.AccountType &&
                       BalanceType == account.BalanceType &&
                       AccountOrgCode == account.AccountOrgCode &&
                       AccountObjectCode == account.AccountObjectCode &&
                       AccountProjectCode == account.AccountProjectCode;
            }

            public override int GetHashCode() {
                var hashCode = -591629190;
                hashCode = hashCode * -1521134295 + EqualityComparer<string>.Default.GetHashCode(AccountDescription);
                hashCode = hashCode * -1521134295 +
                           EqualityComparer<string>.Default.GetHashCode(OrganizationDescription);
                hashCode = hashCode * -1521134295 + EqualityComparer<string>.Default.GetHashCode(AccountType);
                hashCode = hashCode * -1521134295 + EqualityComparer<string>.Default.GetHashCode(BalanceType);
                hashCode = hashCode * -1521134295 + EqualityComparer<string>.Default.GetHashCode(AccountOrgCode);
                hashCode = hashCode * -1521134295 + EqualityComparer<string>.Default.GetHashCode(AccountObjectCode);
                hashCode = hashCode * -1521134295 + EqualityComparer<string>.Default.GetHashCode(AccountProjectCode);
                return hashCode;
            }

        }

        public class EnerGovFee {

            public Guid FeeId { get; set; }
            public string FeeName { get; set; }

        }

        public class EnerGovWorkType {

            public Guid EnerGovPickListItemId { get; set; }
            public string WorkTypeName { get; set; }

        }

        public EnerGovFee Fee { get; set; }

        public EnerGovWorkType WorkType { get; set; }

        public MunisAccount RevenueAccount { get; set; }
        public MunisAccount RevenueCashAccount { get; set; }

        public MunisAccount ExpenseAccount { get; set; }
        public MunisAccount ExpenseCashAccount { get; set; }

    }

}