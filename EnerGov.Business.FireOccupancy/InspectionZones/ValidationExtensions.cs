using FluentValidation;

namespace EnerGov.Business.FireOccupancy.InspectionZones {

    public static class ValidationExtensions {

        public static void AsInspectionZoneAbbreviation<T>(this IRuleBuilder<T, string> ruleBuilder) =>
            ruleBuilder.NotEmpty().MaximumLength(10);

        public static void AsInspectionZoneName<T>(this IRuleBuilder<T, string> ruleBuilder) =>
            ruleBuilder.NotNull().MaximumLength(100);

        public static void AsInspectionZoneEscalationContactEmail<T>(this IRuleBuilder<T, string> ruleBuilder) =>
            ruleBuilder.NotNull().MaximumLength(255);

    }

}