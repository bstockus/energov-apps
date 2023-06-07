using Microsoft.EntityFrameworkCore.Migrations;

namespace EnerGov.Data.Configuration.Migrations
{
    public partial class UpdatedUtilityExcavationForCoAMigration : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AlterColumn<string>(
                name: "MunisRevenueCashAccountOrg",
                schema: "UtilityExcavation",
                table: "UtilityFeeGLAccounts",
                maxLength: 8,
                nullable: false,
                oldClrType: typeof(string),
                oldType: "nvarchar(7)",
                oldMaxLength: 7);

            migrationBuilder.AlterColumn<string>(
                name: "MunisRevenueAccountOrg",
                schema: "UtilityExcavation",
                table: "UtilityFeeGLAccounts",
                maxLength: 8,
                nullable: false,
                oldClrType: typeof(string),
                oldType: "nvarchar(7)",
                oldMaxLength: 7);

            migrationBuilder.AlterColumn<string>(
                name: "MunisExpenseCashAccountOrg",
                schema: "UtilityExcavation",
                table: "UtilityFeeGLAccounts",
                maxLength: 8,
                nullable: false,
                oldClrType: typeof(string),
                oldType: "nvarchar(7)",
                oldMaxLength: 7);

            migrationBuilder.AlterColumn<string>(
                name: "MunisExpenseAccountOrg",
                schema: "UtilityExcavation",
                table: "UtilityFeeGLAccounts",
                maxLength: 8,
                nullable: false,
                oldClrType: typeof(string),
                oldType: "nvarchar(7)",
                oldMaxLength: 7);

            migrationBuilder.AddColumn<string>(
                name: "MunisExpenseCashAccountProject",
                schema: "UtilityExcavation",
                table: "UtilityFeeGLAccounts",
                maxLength: 5,
                nullable: false,
                defaultValue: "");

            migrationBuilder.AddColumn<string>(
                name: "MunisRevenueCashAccountProject",
                schema: "UtilityExcavation",
                table: "UtilityFeeGLAccounts",
                maxLength: 5,
                nullable: false,
                defaultValue: "");
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "MunisExpenseCashAccountProject",
                schema: "UtilityExcavation",
                table: "UtilityFeeGLAccounts");

            migrationBuilder.DropColumn(
                name: "MunisRevenueCashAccountProject",
                schema: "UtilityExcavation",
                table: "UtilityFeeGLAccounts");

            migrationBuilder.AlterColumn<string>(
                name: "MunisRevenueCashAccountOrg",
                schema: "UtilityExcavation",
                table: "UtilityFeeGLAccounts",
                type: "nvarchar(7)",
                maxLength: 7,
                nullable: false,
                oldClrType: typeof(string),
                oldMaxLength: 8);

            migrationBuilder.AlterColumn<string>(
                name: "MunisRevenueAccountOrg",
                schema: "UtilityExcavation",
                table: "UtilityFeeGLAccounts",
                type: "nvarchar(7)",
                maxLength: 7,
                nullable: false,
                oldClrType: typeof(string),
                oldMaxLength: 8);

            migrationBuilder.AlterColumn<string>(
                name: "MunisExpenseCashAccountOrg",
                schema: "UtilityExcavation",
                table: "UtilityFeeGLAccounts",
                type: "nvarchar(7)",
                maxLength: 7,
                nullable: false,
                oldClrType: typeof(string),
                oldMaxLength: 8);

            migrationBuilder.AlterColumn<string>(
                name: "MunisExpenseAccountOrg",
                schema: "UtilityExcavation",
                table: "UtilityFeeGLAccounts",
                type: "nvarchar(7)",
                maxLength: 7,
                nullable: false,
                oldClrType: typeof(string),
                oldMaxLength: 8);
        }
    }
}
