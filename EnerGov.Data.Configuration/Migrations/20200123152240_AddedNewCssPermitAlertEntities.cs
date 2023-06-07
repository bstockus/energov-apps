using System;
using Microsoft.EntityFrameworkCore.Migrations;

namespace EnerGov.Data.Configuration.Migrations {
    public partial class AddedNewCssPermitAlertEntities : Migration {
        protected override void Up(MigrationBuilder migrationBuilder) {
            migrationBuilder.EnsureSchema(
                name: "Alerting");

            migrationBuilder.CreateTable(
                name: "NewCssPermitAlerts",
                schema: "Alerting",
                columns: table => new {
                    PermitId = table.Column<Guid>(nullable: false),
                    TimeStamp = table.Column<DateTime>(nullable: false),
                    EmailsNotified = table.Column<string>(maxLength: 1024, nullable: true)
                },
                constraints: table => {
                    table.PrimaryKey("PK_NewCssPermitAlerts", x => x.PermitId);
                });

            migrationBuilder.CreateTable(
                name: "NewCssPermitAlertTypes",
                schema: "Alerting",
                columns: table => new {
                    PermitTypeId = table.Column<Guid>(nullable: false),
                    PermitWorkClassId = table.Column<Guid>(nullable: false),
                    SendAlerts = table.Column<bool>(nullable: false),
                    IsBuildingDistrictRouted = table.Column<bool>(nullable: false),
                    EmailsToAlert = table.Column<string>(maxLength: 1024, nullable: true)
                },
                constraints: table => {
                    table.PrimaryKey("PK_NewCssPermitAlertTypes", x => new { x.PermitTypeId, x.PermitWorkClassId });
                });
        }

        protected override void Down(MigrationBuilder migrationBuilder) {
            migrationBuilder.DropTable(
                name: "NewCssPermitAlerts",
                schema: "Alerting");

            migrationBuilder.DropTable(
                name: "NewCssPermitAlertTypes",
                schema: "Alerting");
        }
    }
}
