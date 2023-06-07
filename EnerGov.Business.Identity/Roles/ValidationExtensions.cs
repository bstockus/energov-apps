using FluentValidation;

namespace EnerGov.Business.Identity.Roles {

    public static class ValidationExtensions {

        public static void AsRoleRoleName<T>(this IRuleBuilder<T, string> ruleBuilder) =>
            ruleBuilder.NotEmpty().MaximumLength(100);

        public static void AsRoleDescription<T>(this IRuleBuilder<T, string> ruleBuilder) =>
            ruleBuilder.NotNull().MaximumLength(1000);

        public static void AsRolePermissionPermissionName<T>(this IRuleBuilder<T, string> ruleBuilder) =>
            ruleBuilder.NotEmpty().MaximumLength(200);

    }

}