using System;
using Microsoft.EntityFrameworkCore.Migrations;

namespace EnerGov.Data.Configuration.Migrations {
    public partial class AddedReInspectionNotifications : Migration {
        protected override void Up(MigrationBuilder migrationBuilder) {
            migrationBuilder.CreateTable(
                name: "ReInspectionNotifications",
                schema: "FireOccupancy",
                columns: table => new {
                    InspectionId = table.Column<Guid>(nullable: false),
                    NotificationDateTime = table.Column<DateTime>(nullable: false)
                },
                constraints: table => {
                    table.PrimaryKey("PK_ReInspectionNotifications", x => new { x.InspectionId, x.NotificationDateTime });
                });
        }

        protected override void Down(MigrationBuilder migrationBuilder) {
            migrationBuilder.DropTable(
                name: "ReInspectionNotifications",
                schema: "FireOccupancy");
        }
    }
}
