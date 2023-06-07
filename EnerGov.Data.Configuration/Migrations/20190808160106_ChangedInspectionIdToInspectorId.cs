using Microsoft.EntityFrameworkCore.Migrations;

namespace EnerGov.Data.Configuration.Migrations {
    public partial class ChangedInspectionIdToInspectorId : Migration {
        protected override void Up(MigrationBuilder migrationBuilder) {
            migrationBuilder.RenameColumn(
                name: "InspectionId",
                schema: "FireOccupancy",
                table: "ReInspectionNotifications",
                newName: "InspectorId");
        }

        protected override void Down(MigrationBuilder migrationBuilder) {
            migrationBuilder.RenameColumn(
                name: "InspectorId",
                schema: "FireOccupancy",
                table: "ReInspectionNotifications",
                newName: "InspectionId");
        }
    }
}
