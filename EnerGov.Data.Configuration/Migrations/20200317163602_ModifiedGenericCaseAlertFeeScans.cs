using System;
using Microsoft.EntityFrameworkCore.Migrations;

namespace EnerGov.Data.Configuration.Migrations {
    public partial class ModifiedGenericCaseAlertFeeScans : Migration {
        protected override void Up(MigrationBuilder migrationBuilder) {
            migrationBuilder.DropPrimaryKey(
                name: "PK_GenericCaseAlertFeeScans",
                schema: "Alerting",
                table: "GenericCaseAlertFeeScans");

            migrationBuilder.DropColumn(
                name: "TransactionId",
                schema: "Alerting",
                table: "GenericCaseAlertFeeScans");

            migrationBuilder.AddColumn<Guid>(
                name: "InvoiceId",
                schema: "Alerting",
                table: "GenericCaseAlertFeeScans",
                nullable: false,
                defaultValue: new Guid("00000000-0000-0000-0000-000000000000"));

            migrationBuilder.AddColumn<int>(
                name: "RowVersion",
                schema: "Alerting",
                table: "GenericCaseAlertFeeScans",
                nullable: false,
                defaultValue: 0);

            migrationBuilder.AddColumn<int>(
                name: "InvoiceStatusId",
                schema: "Alerting",
                table: "GenericCaseAlertFeeScans",
                nullable: false,
                defaultValue: 0);

            migrationBuilder.AddPrimaryKey(
                name: "PK_GenericCaseAlertFeeScans",
                schema: "Alerting",
                table: "GenericCaseAlertFeeScans",
                columns: new[] { "Module", "CaseId", "InvoiceId", "RowVersion" });
        }

        protected override void Down(MigrationBuilder migrationBuilder) {
            migrationBuilder.DropPrimaryKey(
                name: "PK_GenericCaseAlertFeeScans",
                schema: "Alerting",
                table: "GenericCaseAlertFeeScans");

            migrationBuilder.DropColumn(
                name: "InvoiceId",
                schema: "Alerting",
                table: "GenericCaseAlertFeeScans");

            migrationBuilder.DropColumn(
                name: "RowVersion",
                schema: "Alerting",
                table: "GenericCaseAlertFeeScans");

            migrationBuilder.DropColumn(
                name: "InvoiceStatusId",
                schema: "Alerting",
                table: "GenericCaseAlertFeeScans");

            migrationBuilder.AddColumn<Guid>(
                name: "TransactionId",
                schema: "Alerting",
                table: "GenericCaseAlertFeeScans",
                type: "uniqueidentifier",
                nullable: false,
                defaultValue: new Guid("00000000-0000-0000-0000-000000000000"));

            migrationBuilder.AddPrimaryKey(
                name: "PK_GenericCaseAlertFeeScans",
                schema: "Alerting",
                table: "GenericCaseAlertFeeScans",
                columns: new[] { "Module", "CaseId", "TransactionId" });
        }
    }
}
