using FluentValidation;

namespace EnerGov.Business.UtilityExcavation.UtilityFeeGLAccounts {

    public static class ValidationExtensions {

        public static void AsMunisAccountOrg<T>(this IRuleBuilder<T, string> ruleBuilder) =>
            ruleBuilder.NotEmpty().MaximumLength(8);

        public static void AsMunisAccountObject<T>(this IRuleBuilder<T, string> ruleBuilder) =>
            ruleBuilder.NotEmpty().MaximumLength(6);

        public static void AsMunisAccountProject<T>(this IRuleBuilder<T, string> ruleBuilder) =>
            ruleBuilder.NotNull().MaximumLength(5);

    }

}