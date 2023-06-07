using System;
using Microsoft.EntityFrameworkCore.Migrations;

namespace EnerGov.Data.Configuration.Migrations {
    public partial class AddedGenericCaseAlertFeeScans : Migration {
        protected override void Up(MigrationBuilder migrationBuilder) {
            migrationBuilder.DropPrimaryKey(
                name: "PK_GenericCaseAlertScan",
                schema: "Alerting",
                table: "GenericCaseAlertScan");

            migrationBuilder.RenameTable(
                name: "GenericCaseAlertScan",
                schema: "Alerting",
                newName: "GenericCaseAlertScans",
                newSchema: "Alerting");

            migrationBuilder.AlterColumn<string>(
                name: "Module",
                schema: "Alerting",
                table: "GenericCaseAlertScans",
                maxLength: 20,
                nullable: false,
                oldClrType: typeof(string),
                oldType: "nvarchar(450)");

            migrationBuilder.AddPrimaryKey(
                name: "PK_GenericCaseAlertScans",
                schema: "Alerting",
                table: "GenericCaseAlertScans",
                columns: new[] { "Module", "CaseId", "RowVersion" });

            migrationBuilder.CreateTable(
                name: "GenericCaseAlertFeeScans",
                schema: "Alerting",
                columns: table => new {
                    Module = table.Column<string>(maxLength: 20, nullable: false),
                    CaseId = table.Column<Guid>(nullable: false),
                    TransactionId = table.Column<Guid>(nullable: false),
                    DateScanned = table.Column<DateTime>(nullable: false)
                },
                constraints: table => {
                    table.PrimaryKey("PK_GenericCaseAlertFeeScans", x => new { x.Module, x.CaseId, x.TransactionId });
                });
        }

        protected override void Down(MigrationBuilder migrationBuilder) {
            migrationBuilder.DropTable(
                name: "GenericCaseAlertFeeScans",
                schema: "Alerting");

            migrationBuilder.DropPrimaryKey(
                name: "PK_GenericCaseAlertScans",
                schema: "Alerting",
                table: "GenericCaseAlertScans");

            migrationBuilder.RenameTable(
                name: "GenericCaseAlertScans",
                schema: "Alerting",
                newName: "GenericCaseAlertScan",
                newSchema: "Alerting");

            migrationBuilder.AlterColumn<string>(
                name: "Module",
                schema: "Alerting",
                table: "GenericCaseAlertScan",
                type: "nvarchar(450)",
                nullable: false,
                oldClrType: typeof(string),
                oldMaxLength: 20);

            migrationBuilder.AddPrimaryKey(
                name: "PK_GenericCaseAlertScan",
                schema: "Alerting",
                table: "GenericCaseAlertScan",
                columns: new[] { "Module", "CaseId", "RowVersion" });
        }
    }
}
