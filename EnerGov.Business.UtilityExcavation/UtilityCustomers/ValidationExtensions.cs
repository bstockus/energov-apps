using FluentValidation;

namespace EnerGov.Business.UtilityExcavation.UtilityCustomers {

    public static class ValidationExtensions {

        public static void AsUtilityCustomerName<T>(this IRuleBuilder<T, string> ruleBuilder) =>
            ruleBuilder.NotNull().MaximumLength(250);

    }

}