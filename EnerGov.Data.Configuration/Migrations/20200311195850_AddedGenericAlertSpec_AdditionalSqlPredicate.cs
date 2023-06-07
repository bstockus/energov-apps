using Microsoft.EntityFrameworkCore.Migrations;

namespace EnerGov.Data.Configuration.Migrations {
    public partial class AddedGenericAlertSpec_AdditionalSqlPredicate : Migration {
        protected override void Up(MigrationBuilder migrationBuilder) {
            migrationBuilder.AddColumn<string>(
                name: "AdditionalSqlPredicate",
                schema: "Alerting",
                table: "GenericCaseAlertSpecifications",
                maxLength: 1000,
                nullable: false,
                defaultValue: "");
        }

        protected override void Down(MigrationBuilder migrationBuilder) {
            migrationBuilder.DropColumn(
                name: "AdditionalSqlPredicate",
                schema: "Alerting",
                table: "GenericCaseAlertSpecifications");
        }
    }
}
