using System;
using Microsoft.EntityFrameworkCore.Migrations;

namespace EnerGov.Data.Configuration.Migrations {
    public partial class InitialCreate : Migration {
        protected override void Up(MigrationBuilder migrationBuilder) {
            migrationBuilder.EnsureSchema(
                name: "FireOccupancy");

            migrationBuilder.EnsureSchema(
                name: "Identity");

            migrationBuilder.EnsureSchema(
                name: "UtilityExcavation");

            migrationBuilder.EnsureSchema(
                name: "Emails");

            migrationBuilder.CreateTable(
                name: "Emails",
                schema: "Emails",
                columns: table => new {
                    Id = table.Column<Guid>(nullable: false),
                    EmailName = table.Column<string>(maxLength: 100, nullable: false),
                    EmailType = table.Column<int>(nullable: false),
                    FromAddress = table.Column<string>(maxLength: 255, nullable: false),
                    Subject = table.Column<string>(maxLength: 500, nullable: false),
                    BodyText = table.Column<string>(nullable: true),
                    BodyHtml = table.Column<string>(nullable: true)
                },
                constraints: table => {
                    table.PrimaryKey("PK_Emails", x => x.Id);
                });

            migrationBuilder.CreateTable(
                name: "Inspections",
                schema: "FireOccupancy",
                columns: table => new {
                    InspectionId = table.Column<Guid>(nullable: false),
                    RowVersion = table.Column<int>(nullable: false),
                    DateScanned = table.Column<DateTime>(nullable: false),
                    InspectionStatusId = table.Column<Guid>(nullable: false)
                },
                constraints: table => {
                    table.PrimaryKey("PK_Inspections", x => new { x.InspectionId, x.RowVersion });
                });

            migrationBuilder.CreateTable(
                name: "InspectionZones",
                schema: "FireOccupancy",
                columns: table => new {
                    InspectionZoneId = table.Column<Guid>(nullable: false),
                    ZoneAbbreviation = table.Column<string>(maxLength: 10, nullable: false),
                    ZoneName = table.Column<string>(maxLength: 100, nullable: false),
                    IsZoneEscalatable = table.Column<bool>(nullable: false),
                    ZoneEscalationContactEmail = table.Column<string>(maxLength: 255, nullable: false)
                },
                constraints: table => {
                    table.PrimaryKey("PK_InspectionZones", x => x.InspectionZoneId);
                    table.UniqueConstraint("AK_InspectionZones_ZoneAbbreviation", x => x.ZoneAbbreviation);
                });

            migrationBuilder.CreateTable(
                name: "Inspectors",
                schema: "FireOccupancy",
                columns: table => new {
                    CustomFieldPickListItemId = table.Column<Guid>(nullable: false),
                    EmailAddress = table.Column<string>(maxLength: 255, nullable: false)
                },
                constraints: table => {
                    table.PrimaryKey("PK_Inspectors", x => x.CustomFieldPickListItemId);
                });

            migrationBuilder.CreateTable(
                name: "Roles",
                schema: "Identity",
                columns: table => new {
                    Id = table.Column<Guid>(nullable: false),
                    RoleName = table.Column<string>(maxLength: 100, nullable: false),
                    Description = table.Column<string>(maxLength: 1000, nullable: false),
                    IsActive = table.Column<bool>(nullable: false)
                },
                constraints: table => {
                    table.PrimaryKey("PK_Roles", x => x.Id);
                });

            migrationBuilder.CreateTable(
                name: "Users",
                schema: "Identity",
                columns: table => new {
                    Id = table.Column<Guid>(nullable: false),
                    UserName = table.Column<string>(maxLength: 100, nullable: false),
                    FirstName = table.Column<string>(maxLength: 100, nullable: false),
                    LastName = table.Column<string>(maxLength: 200, nullable: false),
                    EmailAddress = table.Column<string>(maxLength: 255, nullable: false),
                    WindowsSid = table.Column<string>(maxLength: 100, nullable: false),
                    IsActive = table.Column<bool>(nullable: false)
                },
                constraints: table => {
                    table.PrimaryKey("PK_Users", x => x.Id);
                    table.UniqueConstraint("AK_Users_WindowsSid", x => x.WindowsSid);
                });

            migrationBuilder.CreateTable(
                name: "UtilityCustomers",
                schema: "UtilityExcavation",
                columns: table => new {
                    EnerGovGlobalEntityId = table.Column<Guid>(nullable: false),
                    CustomerName = table.Column<string>(maxLength: 250, nullable: false),
                    IsActive = table.Column<bool>(nullable: false)
                },
                constraints: table => {
                    table.PrimaryKey("PK_UtilityCustomers", x => x.EnerGovGlobalEntityId);
                });

            migrationBuilder.CreateTable(
                name: "UtilityFeeGLAccounts",
                schema: "UtilityExcavation",
                columns: table => new {
                    EnerGovFeeId = table.Column<Guid>(nullable: false),
                    EnerGovPickListItemId = table.Column<Guid>(nullable: false),
                    MunisRevenueAccountOrg = table.Column<string>(maxLength: 7, nullable: false),
                    MunisRevenueAccountObject = table.Column<string>(maxLength: 6, nullable: false),
                    MunisRevenueAccountProject = table.Column<string>(maxLength: 5, nullable: false),
                    MunisRevenueCashAccountOrg = table.Column<string>(maxLength: 7, nullable: false),
                    MunisRevenueCashAccountObject = table.Column<string>(maxLength: 6, nullable: false),
                    MunisExpenseAccountOrg = table.Column<string>(maxLength: 7, nullable: false),
                    MunisExpenseAccountObject = table.Column<string>(maxLength: 6, nullable: false),
                    MunisExpenseAccountProject = table.Column<string>(maxLength: 5, nullable: false),
                    MunisExpenseCashAccountOrg = table.Column<string>(maxLength: 7, nullable: false),
                    MunisExpenseCashAccountObject = table.Column<string>(maxLength: 6, nullable: false)
                },
                constraints: table => {
                    table.PrimaryKey("PK_UtilityFeeGLAccounts", x => new { x.EnerGovFeeId, x.EnerGovPickListItemId });
                });

            migrationBuilder.CreateTable(
                name: "EmailAttachments",
                schema: "Emails",
                columns: table => new {
                    EmailId = table.Column<Guid>(nullable: false),
                    FileName = table.Column<string>(maxLength: 60, nullable: false),
                    MimeType = table.Column<string>(maxLength: 255, nullable: false),
                    FileContents = table.Column<byte[]>(nullable: true)
                },
                constraints: table => {
                    table.PrimaryKey("PK_EmailAttachments", x => new { x.EmailId, x.FileName });
                    table.ForeignKey(
                        name: "FK_EmailAttachments_Emails_EmailId",
                        column: x => x.EmailId,
                        principalSchema: "Emails",
                        principalTable: "Emails",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "EmailRecipients",
                schema: "Emails",
                columns: table => new {
                    EmailId = table.Column<Guid>(nullable: false),
                    ToAddress = table.Column<string>(maxLength: 255, nullable: false),
                    DateSent = table.Column<DateTime>(nullable: true),
                    LastSendAttemptDate = table.Column<DateTime>(nullable: true),
                    SendFailureCount = table.Column<int>(nullable: false),
                    FailureAddress = table.Column<string>(maxLength: 255, nullable: true)
                },
                constraints: table => {
                    table.PrimaryKey("PK_EmailRecipients", x => new { x.EmailId, x.ToAddress });
                    table.ForeignKey(
                        name: "FK_EmailRecipients_Emails_EmailId",
                        column: x => x.EmailId,
                        principalSchema: "Emails",
                        principalTable: "Emails",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "InspectionEmails",
                schema: "FireOccupancy",
                columns: table => new {
                    InspectionId = table.Column<Guid>(nullable: false),
                    RowVersion = table.Column<int>(nullable: false),
                    EmailId = table.Column<Guid>(nullable: false)
                },
                constraints: table => {
                    table.PrimaryKey("PK_InspectionEmails", x => new { x.InspectionId, x.RowVersion, x.EmailId });
                    table.ForeignKey(
                        name: "FK_InspectionEmails_Emails_EmailId",
                        column: x => x.EmailId,
                        principalSchema: "Emails",
                        principalTable: "Emails",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_InspectionEmails_Inspections_InspectionId_RowVersion",
                        columns: x => new { x.InspectionId, x.RowVersion },
                        principalSchema: "FireOccupancy",
                        principalTable: "Inspections",
                        principalColumns: new[] { "InspectionId", "RowVersion" },
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "InspectionFollowUps",
                schema: "FireOccupancy",
                columns: table => new {
                    InspectionId = table.Column<Guid>(nullable: false),
                    RowVersion = table.Column<int>(nullable: false),
                    InspectionNonComplianceCodeId = table.Column<Guid>(nullable: false),
                    FollowUpDate = table.Column<DateTime>(nullable: false),
                    DateNotificationSent = table.Column<DateTime>(nullable: true),
                    LastNotificationAttemptDate = table.Column<DateTime>(nullable: true),
                    NotificationFailureCount = table.Column<int>(nullable: false),
                    DateReminderSend = table.Column<DateTime>(nullable: true),
                    LastReminderAttemptDate = table.Column<DateTime>(nullable: true),
                    ReminderFailureCount = table.Column<int>(nullable: false),
                    ConfirmationDate = table.Column<DateTime>(nullable: true),
                    ConfirmationUserWindowsSid = table.Column<string>(maxLength: 100, nullable: true)
                },
                constraints: table => {
                    table.PrimaryKey("PK_InspectionFollowUps", x => new { x.InspectionId, x.RowVersion, x.InspectionNonComplianceCodeId });
                    table.ForeignKey(
                        name: "FK_InspectionFollowUps_Inspections_InspectionId_RowVersion",
                        columns: x => new { x.InspectionId, x.RowVersion },
                        principalSchema: "FireOccupancy",
                        principalTable: "Inspections",
                        principalColumns: new[] { "InspectionId", "RowVersion" },
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "ReInspections",
                schema: "FireOccupancy",
                columns: table => new {
                    InspectionId = table.Column<Guid>(nullable: false),
                    RowVersion = table.Column<int>(nullable: false),
                    ReInspectionId = table.Column<Guid>(nullable: false),
                    DateNotificationSent = table.Column<DateTime>(nullable: true),
                    LastNotificationAttemptDate = table.Column<DateTime>(nullable: true),
                    NotificationFailureCount = table.Column<int>(nullable: false),
                    DateReminderSend = table.Column<DateTime>(nullable: true),
                    LastReminderAttemptDate = table.Column<DateTime>(nullable: true),
                    ReminderFailureCount = table.Column<int>(nullable: false)
                },
                constraints: table => {
                    table.PrimaryKey("PK_ReInspections", x => new { x.InspectionId, x.RowVersion, x.ReInspectionId });
                    table.ForeignKey(
                        name: "FK_ReInspections_Inspections_InspectionId_RowVersion",
                        columns: x => new { x.InspectionId, x.RowVersion },
                        principalSchema: "FireOccupancy",
                        principalTable: "Inspections",
                        principalColumns: new[] { "InspectionId", "RowVersion" },
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "RolePermissions",
                schema: "Identity",
                columns: table => new {
                    RoleId = table.Column<Guid>(nullable: false),
                    PermissionName = table.Column<string>(maxLength: 200, nullable: false)
                },
                constraints: table => {
                    table.PrimaryKey("PK_RolePermissions", x => new { x.RoleId, x.PermissionName });
                    table.ForeignKey(
                        name: "FK_RolePermissions_Roles_RoleId",
                        column: x => x.RoleId,
                        principalSchema: "Identity",
                        principalTable: "Roles",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "UserRoles",
                schema: "Identity",
                columns: table => new {
                    UserId = table.Column<Guid>(nullable: false),
                    RoleId = table.Column<Guid>(nullable: false)
                },
                constraints: table => {
                    table.PrimaryKey("PK_UserRoles", x => new { x.UserId, x.RoleId });
                    table.ForeignKey(
                        name: "FK_UserRoles_Roles_RoleId",
                        column: x => x.RoleId,
                        principalSchema: "Identity",
                        principalTable: "Roles",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_UserRoles_Users_UserId",
                        column: x => x.UserId,
                        principalSchema: "Identity",
                        principalTable: "Users",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateIndex(
                name: "IX_InspectionEmails_EmailId",
                schema: "FireOccupancy",
                table: "InspectionEmails",
                column: "EmailId");

            migrationBuilder.CreateIndex(
                name: "IX_UserRoles_RoleId",
                schema: "Identity",
                table: "UserRoles",
                column: "RoleId");
        }

        protected override void Down(MigrationBuilder migrationBuilder) {
            migrationBuilder.DropTable(
                name: "EmailAttachments",
                schema: "Emails");

            migrationBuilder.DropTable(
                name: "EmailRecipients",
                schema: "Emails");

            migrationBuilder.DropTable(
                name: "InspectionEmails",
                schema: "FireOccupancy");

            migrationBuilder.DropTable(
                name: "InspectionFollowUps",
                schema: "FireOccupancy");

            migrationBuilder.DropTable(
                name: "InspectionZones",
                schema: "FireOccupancy");

            migrationBuilder.DropTable(
                name: "Inspectors",
                schema: "FireOccupancy");

            migrationBuilder.DropTable(
                name: "ReInspections",
                schema: "FireOccupancy");

            migrationBuilder.DropTable(
                name: "RolePermissions",
                schema: "Identity");

            migrationBuilder.DropTable(
                name: "UserRoles",
                schema: "Identity");

            migrationBuilder.DropTable(
                name: "UtilityCustomers",
                schema: "UtilityExcavation");

            migrationBuilder.DropTable(
                name: "UtilityFeeGLAccounts",
                schema: "UtilityExcavation");

            migrationBuilder.DropTable(
                name: "Emails",
                schema: "Emails");

            migrationBuilder.DropTable(
                name: "Inspections",
                schema: "FireOccupancy");

            migrationBuilder.DropTable(
                name: "Roles",
                schema: "Identity");

            migrationBuilder.DropTable(
                name: "Users",
                schema: "Identity");
        }
    }
}
