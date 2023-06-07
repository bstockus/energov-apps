using System;
using Microsoft.EntityFrameworkCore.Migrations;

namespace EnerGov.Data.Configuration.Migrations {
    public partial class AddedGenericCaseAlerts : Migration {
        protected override void Up(MigrationBuilder migrationBuilder) {
            migrationBuilder.CreateTable(
                name: "GenericCaseAlertScan",
                schema: "Alerting",
                columns: table => new {
                    Module = table.Column<string>(nullable: false),
                    CaseId = table.Column<Guid>(nullable: false),
                    RowVersion = table.Column<int>(nullable: false),
                    DateScanned = table.Column<DateTime>(nullable: false),
                    CaseStatusId = table.Column<Guid>(nullable: true)
                },
                constraints: table => {
                    table.PrimaryKey("PK_GenericCaseAlertScan", x => new { x.Module, x.CaseId, x.RowVersion });
                });

            migrationBuilder.CreateTable(
                name: "GenericCaseAlertSpecifications",
                schema: "Alerting",
                columns: table => new {
                    Name = table.Column<string>(maxLength: 100, nullable: false),
                    IsEnabled = table.Column<bool>(nullable: false),
                    Module = table.Column<string>(maxLength: 20, nullable: false),
                    Event = table.Column<string>(maxLength: 1000, nullable: false),
                    TypeFilter = table.Column<string>(maxLength: 1000, nullable: false),
                    WorkClassFilter = table.Column<string>(maxLength: 1000, nullable: false),
                    Recipients = table.Column<string>(maxLength: 1000, nullable: false),
                    Subject = table.Column<string>(maxLength: 200, nullable: false),
                    BodyText = table.Column<string>(nullable: false),
                    BodyHtml = table.Column<string>(nullable: false)
                },
                constraints: table => {
                    table.PrimaryKey("PK_GenericCaseAlertSpecifications", x => x.Name);
                });

            migrationBuilder.CreateTable(
                name: "EmailRecipientEvents",
                schema: "Emails",
                columns: table => new {
                    EmailId = table.Column<Guid>(nullable: false),
                    ToAddress = table.Column<string>(maxLength: 255, nullable: false),
                    EventId = table.Column<string>(maxLength: 255, nullable: false),
                    TimeStamp = table.Column<DateTime>(nullable: false),
                    EventType = table.Column<string>(maxLength: 50, nullable: false),
                    EventContents = table.Column<string>(nullable: true)
                },
                constraints: table => {
                    table.PrimaryKey("PK_EmailRecipientEvents", x => new { x.EmailId, x.ToAddress, x.EventId });
                    table.ForeignKey(
                        name: "FK_EmailRecipientEvents_EmailRecipients_EmailId_ToAddress",
                        columns: x => new { x.EmailId, x.ToAddress },
                        principalSchema: "Emails",
                        principalTable: "EmailRecipients",
                        principalColumns: new[] { "EmailId", "ToAddress" },
                        onDelete: ReferentialAction.Cascade);
                });
        }

        protected override void Down(MigrationBuilder migrationBuilder) {
            migrationBuilder.DropTable(
                name: "GenericCaseAlertScan",
                schema: "Alerting");

            migrationBuilder.DropTable(
                name: "GenericCaseAlertSpecifications",
                schema: "Alerting");

            migrationBuilder.DropTable(
                name: "EmailRecipientEvents",
                schema: "Emails");
        }
    }
}
