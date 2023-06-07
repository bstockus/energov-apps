using EnerGov.Business.UtilityExcavation.UtilityFeeGLAccounts;
using Microsoft.AspNetCore.Html;

namespace EnerGov.Web.UtilityExcavation.Helpers {

    public static class MunisAccountHelper {

        public static IHtmlContent ToMunisAccountDisplayBlock(
            this UtilityFeeGLAccountDetailedInformation.MunisAccount munisAccount) =>
            new HtmlString(
                $"<span class='label label-{munisAccount.ToMunisAccountBootstrapColor()}'>" +
                $"{munisAccount.ToMunisAccountNumber()}</span>" +
                $"<br>{munisAccount.OrganizationDescription} - <strong>{munisAccount.AccountDescription}</strong>");

        public static string ToMunisAccountNumber(
            this UtilityFeeGLAccountDetailedInformation.MunisAccount munisAccount) {

            var accountNumber = $"{munisAccount.AccountOrgCode}-{munisAccount.AccountObjectCode}";
            if (!string.IsNullOrWhiteSpace(munisAccount.AccountProjectCode)) {
                accountNumber += $"-{munisAccount.AccountProjectCode}";
            }

            return accountNumber;
        }

        public static string ToMunisAccountType(this UtilityFeeGLAccountDetailedInformation.MunisAccount munisAccount) {

            if (munisAccount.AccountType.Equals("B")) {
                if (munisAccount.BalanceType.Equals("U")) {
                    return "Fund Balance";
                }

                if (munisAccount.BalanceType.Equals("L")) {
                    return "Liability";
                }

                if (munisAccount.BalanceType.Equals("A")) {
                    return "Asset";
                }
            }

            if (munisAccount.AccountType.Equals("E")) {
                return "Expense";
            }

            if (munisAccount.AccountType.Equals("R")) {
                return "Revenue";
            }

            return "Unknown";

        }

        public static string ToMunisAccountBootstrapColor(
            this UtilityFeeGLAccountDetailedInformation.MunisAccount munisAccount) {

            if (munisAccount.AccountType.Equals("B")) {
                return "default";
            }

            if (munisAccount.AccountType.Equals("E")) {
                return "danger";
            }

            if (munisAccount.AccountType.Equals("R")) {
                return "success";
            }

            return "default";

        }

    }

}