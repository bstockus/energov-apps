using FluentValidation;

namespace EnerGov.Business.Identity.Users {

    public static class ValidationExtensions {

        public static void AsUserFirstName<T>(this IRuleBuilder<T, string> ruleBuilder) =>
            ruleBuilder.NotEmpty().MaximumLength(100);

        public static void AsUserLastName<T>(this IRuleBuilder<T, string> ruleBuilder) =>
            ruleBuilder.NotEmpty().MaximumLength(200);

        public static void AsUserEmailAddress<T>(this IRuleBuilder<T, string> ruleBuilder) =>
            ruleBuilder.NotEmpty().MaximumLength(255);

        public static void AsUserWindowsSid<T>(this IRuleBuilder<T, string> ruleBuilder) =>
            ruleBuilder.NotEmpty().MaximumLength(100);

        public static void AsUserUserName<T>(this IRuleBuilder<T, string> ruleBuilder) =>
            ruleBuilder.NotEmpty().MaximumLength(100);

    }

}