IF OBJECT_ID(N'[__EFMigrationsHistory]') IS NULL
BEGIN
    CREATE TABLE [__EFMigrationsHistory] (
        [MigrationId] nvarchar(150) NOT NULL,
        [ProductVersion] nvarchar(32) NOT NULL,
        CONSTRAINT [PK___EFMigrationsHistory] PRIMARY KEY ([MigrationId])
    );
END;

GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20190627183924_InitialCreate')
BEGIN
    IF SCHEMA_ID(N'FireOccupancy') IS NULL EXEC(N'CREATE SCHEMA [FireOccupancy];');
END;

GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20190627183924_InitialCreate')
BEGIN
    IF SCHEMA_ID(N'Identity') IS NULL EXEC(N'CREATE SCHEMA [Identity];');
END;

GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20190627183924_InitialCreate')
BEGIN
    IF SCHEMA_ID(N'UtilityExcavation') IS NULL EXEC(N'CREATE SCHEMA [UtilityExcavation];');
END;

GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20190627183924_InitialCreate')
BEGIN
    IF SCHEMA_ID(N'Emails') IS NULL EXEC(N'CREATE SCHEMA [Emails];');
END;

GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20190627183924_InitialCreate')
BEGIN
    CREATE TABLE [Emails].[Emails] (
        [Id] uniqueidentifier NOT NULL,
        [EmailName] nvarchar(100) NOT NULL,
        [EmailType] int NOT NULL,
        [FromAddress] nvarchar(255) NOT NULL,
        [Subject] nvarchar(500) NOT NULL,
        [BodyText] nvarchar(max) NULL,
        [BodyHtml] nvarchar(max) NULL,
        CONSTRAINT [PK_Emails] PRIMARY KEY ([Id])
    );
END;

GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20190627183924_InitialCreate')
BEGIN
    CREATE TABLE [FireOccupancy].[Inspections] (
        [InspectionId] uniqueidentifier NOT NULL,
        [RowVersion] int NOT NULL,
        [DateScanned] datetime2 NOT NULL,
        [InspectionStatusId] uniqueidentifier NOT NULL,
        CONSTRAINT [PK_Inspections] PRIMARY KEY ([InspectionId], [RowVersion])
    );
END;

GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20190627183924_InitialCreate')
BEGIN
    CREATE TABLE [FireOccupancy].[InspectionZones] (
        [InspectionZoneId] uniqueidentifier NOT NULL,
        [ZoneAbbreviation] nvarchar(10) NOT NULL,
        [ZoneName] nvarchar(100) NOT NULL,
        [IsZoneEscalatable] bit NOT NULL,
        [ZoneEscalationContactEmail] nvarchar(255) NOT NULL,
        CONSTRAINT [PK_InspectionZones] PRIMARY KEY ([InspectionZoneId]),
        CONSTRAINT [AK_InspectionZones_ZoneAbbreviation] UNIQUE ([ZoneAbbreviation])
    );
END;

GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20190627183924_InitialCreate')
BEGIN
    CREATE TABLE [FireOccupancy].[Inspectors] (
        [CustomFieldPickListItemId] uniqueidentifier NOT NULL,
        [EmailAddress] nvarchar(255) NOT NULL,
        CONSTRAINT [PK_Inspectors] PRIMARY KEY ([CustomFieldPickListItemId])
    );
END;

GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20190627183924_InitialCreate')
BEGIN
    CREATE TABLE [Identity].[Roles] (
        [Id] uniqueidentifier NOT NULL,
        [RoleName] nvarchar(100) NOT NULL,
        [Description] nvarchar(1000) NOT NULL,
        [IsActive] bit NOT NULL,
        CONSTRAINT [PK_Roles] PRIMARY KEY ([Id])
    );
END;

GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20190627183924_InitialCreate')
BEGIN
    CREATE TABLE [Identity].[Users] (
        [Id] uniqueidentifier NOT NULL,
        [UserName] nvarchar(100) NOT NULL,
        [FirstName] nvarchar(100) NOT NULL,
        [LastName] nvarchar(200) NOT NULL,
        [EmailAddress] nvarchar(255) NOT NULL,
        [WindowsSid] nvarchar(100) NOT NULL,
        [IsActive] bit NOT NULL,
        CONSTRAINT [PK_Users] PRIMARY KEY ([Id]),
        CONSTRAINT [AK_Users_WindowsSid] UNIQUE ([WindowsSid])
    );
END;

GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20190627183924_InitialCreate')
BEGIN
    CREATE TABLE [UtilityExcavation].[UtilityCustomers] (
        [EnerGovGlobalEntityId] uniqueidentifier NOT NULL,
        [CustomerName] nvarchar(250) NOT NULL,
        [IsActive] bit NOT NULL,
        CONSTRAINT [PK_UtilityCustomers] PRIMARY KEY ([EnerGovGlobalEntityId])
    );
END;

GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20190627183924_InitialCreate')
BEGIN
    CREATE TABLE [UtilityExcavation].[UtilityFeeGLAccounts] (
        [EnerGovFeeId] uniqueidentifier NOT NULL,
        [EnerGovPickListItemId] uniqueidentifier NOT NULL,
        [MunisRevenueAccountOrg] nvarchar(7) NOT NULL,
        [MunisRevenueAccountObject] nvarchar(6) NOT NULL,
        [MunisRevenueAccountProject] nvarchar(5) NOT NULL,
        [MunisRevenueCashAccountOrg] nvarchar(7) NOT NULL,
        [MunisRevenueCashAccountObject] nvarchar(6) NOT NULL,
        [MunisExpenseAccountOrg] nvarchar(7) NOT NULL,
        [MunisExpenseAccountObject] nvarchar(6) NOT NULL,
        [MunisExpenseAccountProject] nvarchar(5) NOT NULL,
        [MunisExpenseCashAccountOrg] nvarchar(7) NOT NULL,
        [MunisExpenseCashAccountObject] nvarchar(6) NOT NULL,
        CONSTRAINT [PK_UtilityFeeGLAccounts] PRIMARY KEY ([EnerGovFeeId], [EnerGovPickListItemId])
    );
END;

GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20190627183924_InitialCreate')
BEGIN
    CREATE TABLE [Emails].[EmailAttachments] (
        [EmailId] uniqueidentifier NOT NULL,
        [FileName] nvarchar(60) NOT NULL,
        [MimeType] nvarchar(255) NOT NULL,
        [FileContents] varbinary(max) NULL,
        CONSTRAINT [PK_EmailAttachments] PRIMARY KEY ([EmailId], [FileName]),
        CONSTRAINT [FK_EmailAttachments_Emails_EmailId] FOREIGN KEY ([EmailId]) REFERENCES [Emails].[Emails] ([Id]) ON DELETE CASCADE
    );
END;

GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20190627183924_InitialCreate')
BEGIN
    CREATE TABLE [Emails].[EmailRecipients] (
        [EmailId] uniqueidentifier NOT NULL,
        [ToAddress] nvarchar(255) NOT NULL,
        [DateSent] datetime2 NULL,
        [LastSendAttemptDate] datetime2 NULL,
        [SendFailureCount] int NOT NULL,
        [FailureAddress] nvarchar(255) NULL,
        CONSTRAINT [PK_EmailRecipients] PRIMARY KEY ([EmailId], [ToAddress]),
        CONSTRAINT [FK_EmailRecipients_Emails_EmailId] FOREIGN KEY ([EmailId]) REFERENCES [Emails].[Emails] ([Id]) ON DELETE CASCADE
    );
END;

GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20190627183924_InitialCreate')
BEGIN
    CREATE TABLE [FireOccupancy].[InspectionEmails] (
        [InspectionId] uniqueidentifier NOT NULL,
        [RowVersion] int NOT NULL,
        [EmailId] uniqueidentifier NOT NULL,
        CONSTRAINT [PK_InspectionEmails] PRIMARY KEY ([InspectionId], [RowVersion], [EmailId]),
        CONSTRAINT [FK_InspectionEmails_Emails_EmailId] FOREIGN KEY ([EmailId]) REFERENCES [Emails].[Emails] ([Id]) ON DELETE CASCADE,
        CONSTRAINT [FK_InspectionEmails_Inspections_InspectionId_RowVersion] FOREIGN KEY ([InspectionId], [RowVersion]) REFERENCES [FireOccupancy].[Inspections] ([InspectionId], [RowVersion]) ON DELETE CASCADE
    );
END;

GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20190627183924_InitialCreate')
BEGIN
    CREATE TABLE [FireOccupancy].[InspectionFollowUps] (
        [InspectionId] uniqueidentifier NOT NULL,
        [RowVersion] int NOT NULL,
        [InspectionNonComplianceCodeId] uniqueidentifier NOT NULL,
        [FollowUpDate] datetime2 NOT NULL,
        [DateNotificationSent] datetime2 NULL,
        [LastNotificationAttemptDate] datetime2 NULL,
        [NotificationFailureCount] int NOT NULL,
        [DateReminderSend] datetime2 NULL,
        [LastReminderAttemptDate] datetime2 NULL,
        [ReminderFailureCount] int NOT NULL,
        [ConfirmationDate] datetime2 NULL,
        [ConfirmationUserWindowsSid] nvarchar(100) NULL,
        CONSTRAINT [PK_InspectionFollowUps] PRIMARY KEY ([InspectionId], [RowVersion], [InspectionNonComplianceCodeId]),
        CONSTRAINT [FK_InspectionFollowUps_Inspections_InspectionId_RowVersion] FOREIGN KEY ([InspectionId], [RowVersion]) REFERENCES [FireOccupancy].[Inspections] ([InspectionId], [RowVersion]) ON DELETE CASCADE
    );
END;

GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20190627183924_InitialCreate')
BEGIN
    CREATE TABLE [FireOccupancy].[ReInspections] (
        [InspectionId] uniqueidentifier NOT NULL,
        [RowVersion] int NOT NULL,
        [ReInspectionId] uniqueidentifier NOT NULL,
        [DateNotificationSent] datetime2 NULL,
        [LastNotificationAttemptDate] datetime2 NULL,
        [NotificationFailureCount] int NOT NULL,
        [DateReminderSend] datetime2 NULL,
        [LastReminderAttemptDate] datetime2 NULL,
        [ReminderFailureCount] int NOT NULL,
        CONSTRAINT [PK_ReInspections] PRIMARY KEY ([InspectionId], [RowVersion], [ReInspectionId]),
        CONSTRAINT [FK_ReInspections_Inspections_InspectionId_RowVersion] FOREIGN KEY ([InspectionId], [RowVersion]) REFERENCES [FireOccupancy].[Inspections] ([InspectionId], [RowVersion]) ON DELETE CASCADE
    );
END;

GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20190627183924_InitialCreate')
BEGIN
    CREATE TABLE [Identity].[RolePermissions] (
        [RoleId] uniqueidentifier NOT NULL,
        [PermissionName] nvarchar(200) NOT NULL,
        CONSTRAINT [PK_RolePermissions] PRIMARY KEY ([RoleId], [PermissionName]),
        CONSTRAINT [FK_RolePermissions_Roles_RoleId] FOREIGN KEY ([RoleId]) REFERENCES [Identity].[Roles] ([Id]) ON DELETE CASCADE
    );
END;

GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20190627183924_InitialCreate')
BEGIN
    CREATE TABLE [Identity].[UserRoles] (
        [UserId] uniqueidentifier NOT NULL,
        [RoleId] uniqueidentifier NOT NULL,
        CONSTRAINT [PK_UserRoles] PRIMARY KEY ([UserId], [RoleId]),
        CONSTRAINT [FK_UserRoles_Roles_RoleId] FOREIGN KEY ([RoleId]) REFERENCES [Identity].[Roles] ([Id]) ON DELETE CASCADE,
        CONSTRAINT [FK_UserRoles_Users_UserId] FOREIGN KEY ([UserId]) REFERENCES [Identity].[Users] ([Id]) ON DELETE CASCADE
    );
END;

GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20190627183924_InitialCreate')
BEGIN
    CREATE INDEX [IX_InspectionEmails_EmailId] ON [FireOccupancy].[InspectionEmails] ([EmailId]);
END;

GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20190627183924_InitialCreate')
BEGIN
    CREATE INDEX [IX_UserRoles_RoleId] ON [Identity].[UserRoles] ([RoleId]);
END;

GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20190627183924_InitialCreate')
BEGIN
    INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20190627183924_InitialCreate', N'3.1.9');
END;

GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20190808154505_AddedReInspectionNotifications')
BEGIN
    CREATE TABLE [FireOccupancy].[ReInspectionNotifications] (
        [InspectionId] uniqueidentifier NOT NULL,
        [NotificationDateTime] datetime2 NOT NULL,
        CONSTRAINT [PK_ReInspectionNotifications] PRIMARY KEY ([InspectionId], [NotificationDateTime])
    );
END;

GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20190808154505_AddedReInspectionNotifications')
BEGIN
    INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20190808154505_AddedReInspectionNotifications', N'3.1.9');
END;

GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20190808160106_ChangedInspectionIdToInspectorId')
BEGIN
    EXEC sp_rename N'[FireOccupancy].[ReInspectionNotifications].[InspectionId]', N'InspectorId', N'COLUMN';
END;

GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20190808160106_ChangedInspectionIdToInspectorId')
BEGIN
    INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20190808160106_ChangedInspectionIdToInspectorId', N'3.1.9');
END;

GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20200123152240_AddedNewCssPermitAlertEntities')
BEGIN
    IF SCHEMA_ID(N'Alerting') IS NULL EXEC(N'CREATE SCHEMA [Alerting];');
END;

GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20200123152240_AddedNewCssPermitAlertEntities')
BEGIN
    CREATE TABLE [Alerting].[NewCssPermitAlerts] (
        [PermitId] uniqueidentifier NOT NULL,
        [TimeStamp] datetime2 NOT NULL,
        [EmailsNotified] nvarchar(1024) NULL,
        CONSTRAINT [PK_NewCssPermitAlerts] PRIMARY KEY ([PermitId])
    );
END;

GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20200123152240_AddedNewCssPermitAlertEntities')
BEGIN
    CREATE TABLE [Alerting].[NewCssPermitAlertTypes] (
        [PermitTypeId] uniqueidentifier NOT NULL,
        [PermitWorkClassId] uniqueidentifier NOT NULL,
        [SendAlerts] bit NOT NULL,
        [IsBuildingDistrictRouted] bit NOT NULL,
        [EmailsToAlert] nvarchar(1024) NULL,
        CONSTRAINT [PK_NewCssPermitAlertTypes] PRIMARY KEY ([PermitTypeId], [PermitWorkClassId])
    );
END;

GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20200123152240_AddedNewCssPermitAlertEntities')
BEGIN
    INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20200123152240_AddedNewCssPermitAlertEntities', N'3.1.9');
END;

GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20200311181630_AddedGenericCaseAlerts')
BEGIN
    CREATE TABLE [Alerting].[GenericCaseAlertScan] (
        [Module] nvarchar(450) NOT NULL,
        [CaseId] uniqueidentifier NOT NULL,
        [RowVersion] int NOT NULL,
        [DateScanned] datetime2 NOT NULL,
        [CaseStatusId] uniqueidentifier NULL,
        CONSTRAINT [PK_GenericCaseAlertScan] PRIMARY KEY ([Module], [CaseId], [RowVersion])
    );
END;

GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20200311181630_AddedGenericCaseAlerts')
BEGIN
    CREATE TABLE [Alerting].[GenericCaseAlertSpecifications] (
        [Name] nvarchar(100) NOT NULL,
        [IsEnabled] bit NOT NULL,
        [Module] nvarchar(20) NOT NULL,
        [Event] nvarchar(1000) NOT NULL,
        [TypeFilter] nvarchar(1000) NOT NULL,
        [WorkClassFilter] nvarchar(1000) NOT NULL,
        [Recipients] nvarchar(1000) NOT NULL,
        [Subject] nvarchar(200) NOT NULL,
        [BodyText] nvarchar(max) NOT NULL,
        [BodyHtml] nvarchar(max) NOT NULL,
        CONSTRAINT [PK_GenericCaseAlertSpecifications] PRIMARY KEY ([Name])
    );
END;

GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20200311181630_AddedGenericCaseAlerts')
BEGIN
    CREATE TABLE [Emails].[EmailRecipientEvents] (
        [EmailId] uniqueidentifier NOT NULL,
        [ToAddress] nvarchar(255) NOT NULL,
        [EventId] nvarchar(255) NOT NULL,
        [TimeStamp] datetime2 NOT NULL,
        [EventType] nvarchar(50) NOT NULL,
        [EventContents] nvarchar(max) NULL,
        CONSTRAINT [PK_EmailRecipientEvents] PRIMARY KEY ([EmailId], [ToAddress], [EventId]),
        CONSTRAINT [FK_EmailRecipientEvents_EmailRecipients_EmailId_ToAddress] FOREIGN KEY ([EmailId], [ToAddress]) REFERENCES [Emails].[EmailRecipients] ([EmailId], [ToAddress]) ON DELETE CASCADE
    );
END;

GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20200311181630_AddedGenericCaseAlerts')
BEGIN
    INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20200311181630_AddedGenericCaseAlerts', N'3.1.9');
END;

GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20200311195850_AddedGenericAlertSpec_AdditionalSqlPredicate')
BEGIN
    ALTER TABLE [Alerting].[GenericCaseAlertSpecifications] ADD [AdditionalSqlPredicate] nvarchar(1000) NOT NULL DEFAULT N'';
END;

GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20200311195850_AddedGenericAlertSpec_AdditionalSqlPredicate')
BEGIN
    INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20200311195850_AddedGenericAlertSpec_AdditionalSqlPredicate', N'3.1.9');
END;

GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20200317162541_AddedGenericCaseAlertFeeScans')
BEGIN
    ALTER TABLE [Alerting].[GenericCaseAlertScan] DROP CONSTRAINT [PK_GenericCaseAlertScan];
END;

GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20200317162541_AddedGenericCaseAlertFeeScans')
BEGIN
    EXEC sp_rename N'[Alerting].[GenericCaseAlertScan]', N'GenericCaseAlertScans';
END;

GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20200317162541_AddedGenericCaseAlertFeeScans')
BEGIN
    DECLARE @var0 sysname;
    SELECT @var0 = [d].[name]
    FROM [sys].[default_constraints] [d]
    INNER JOIN [sys].[columns] [c] ON [d].[parent_column_id] = [c].[column_id] AND [d].[parent_object_id] = [c].[object_id]
    WHERE ([d].[parent_object_id] = OBJECT_ID(N'[Alerting].[GenericCaseAlertScans]') AND [c].[name] = N'Module');
    IF @var0 IS NOT NULL EXEC(N'ALTER TABLE [Alerting].[GenericCaseAlertScans] DROP CONSTRAINT [' + @var0 + '];');
    ALTER TABLE [Alerting].[GenericCaseAlertScans] ALTER COLUMN [Module] nvarchar(20) NOT NULL;
END;

GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20200317162541_AddedGenericCaseAlertFeeScans')
BEGIN
    ALTER TABLE [Alerting].[GenericCaseAlertScans] ADD CONSTRAINT [PK_GenericCaseAlertScans] PRIMARY KEY ([Module], [CaseId], [RowVersion]);
END;

GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20200317162541_AddedGenericCaseAlertFeeScans')
BEGIN
    CREATE TABLE [Alerting].[GenericCaseAlertFeeScans] (
        [Module] nvarchar(20) NOT NULL,
        [CaseId] uniqueidentifier NOT NULL,
        [TransactionId] uniqueidentifier NOT NULL,
        [DateScanned] datetime2 NOT NULL,
        CONSTRAINT [PK_GenericCaseAlertFeeScans] PRIMARY KEY ([Module], [CaseId], [TransactionId])
    );
END;

GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20200317162541_AddedGenericCaseAlertFeeScans')
BEGIN
    INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20200317162541_AddedGenericCaseAlertFeeScans', N'3.1.9');
END;

GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20200317163602_ModifiedGenericCaseAlertFeeScans')
BEGIN
    ALTER TABLE [Alerting].[GenericCaseAlertFeeScans] DROP CONSTRAINT [PK_GenericCaseAlertFeeScans];
END;

GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20200317163602_ModifiedGenericCaseAlertFeeScans')
BEGIN
    DECLARE @var1 sysname;
    SELECT @var1 = [d].[name]
    FROM [sys].[default_constraints] [d]
    INNER JOIN [sys].[columns] [c] ON [d].[parent_column_id] = [c].[column_id] AND [d].[parent_object_id] = [c].[object_id]
    WHERE ([d].[parent_object_id] = OBJECT_ID(N'[Alerting].[GenericCaseAlertFeeScans]') AND [c].[name] = N'TransactionId');
    IF @var1 IS NOT NULL EXEC(N'ALTER TABLE [Alerting].[GenericCaseAlertFeeScans] DROP CONSTRAINT [' + @var1 + '];');
    ALTER TABLE [Alerting].[GenericCaseAlertFeeScans] DROP COLUMN [TransactionId];
END;

GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20200317163602_ModifiedGenericCaseAlertFeeScans')
BEGIN
    ALTER TABLE [Alerting].[GenericCaseAlertFeeScans] ADD [InvoiceId] uniqueidentifier NOT NULL DEFAULT '00000000-0000-0000-0000-000000000000';
END;

GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20200317163602_ModifiedGenericCaseAlertFeeScans')
BEGIN
    ALTER TABLE [Alerting].[GenericCaseAlertFeeScans] ADD [RowVersion] int NOT NULL DEFAULT 0;
END;

GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20200317163602_ModifiedGenericCaseAlertFeeScans')
BEGIN
    ALTER TABLE [Alerting].[GenericCaseAlertFeeScans] ADD [InvoiceStatusId] int NOT NULL DEFAULT 0;
END;

GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20200317163602_ModifiedGenericCaseAlertFeeScans')
BEGIN
    ALTER TABLE [Alerting].[GenericCaseAlertFeeScans] ADD CONSTRAINT [PK_GenericCaseAlertFeeScans] PRIMARY KEY ([Module], [CaseId], [InvoiceId], [RowVersion]);
END;

GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20200317163602_ModifiedGenericCaseAlertFeeScans')
BEGIN
    INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20200317163602_ModifiedGenericCaseAlertFeeScans', N'3.1.9');
END;

GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20201015194952_UpdatedUtilityExcavationForCoAMigration')
BEGIN
    DECLARE @var2 sysname;
    SELECT @var2 = [d].[name]
    FROM [sys].[default_constraints] [d]
    INNER JOIN [sys].[columns] [c] ON [d].[parent_column_id] = [c].[column_id] AND [d].[parent_object_id] = [c].[object_id]
    WHERE ([d].[parent_object_id] = OBJECT_ID(N'[UtilityExcavation].[UtilityFeeGLAccounts]') AND [c].[name] = N'MunisRevenueCashAccountOrg');
    IF @var2 IS NOT NULL EXEC(N'ALTER TABLE [UtilityExcavation].[UtilityFeeGLAccounts] DROP CONSTRAINT [' + @var2 + '];');
    ALTER TABLE [UtilityExcavation].[UtilityFeeGLAccounts] ALTER COLUMN [MunisRevenueCashAccountOrg] nvarchar(8) NOT NULL;
END;

GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20201015194952_UpdatedUtilityExcavationForCoAMigration')
BEGIN
    DECLARE @var3 sysname;
    SELECT @var3 = [d].[name]
    FROM [sys].[default_constraints] [d]
    INNER JOIN [sys].[columns] [c] ON [d].[parent_column_id] = [c].[column_id] AND [d].[parent_object_id] = [c].[object_id]
    WHERE ([d].[parent_object_id] = OBJECT_ID(N'[UtilityExcavation].[UtilityFeeGLAccounts]') AND [c].[name] = N'MunisRevenueAccountOrg');
    IF @var3 IS NOT NULL EXEC(N'ALTER TABLE [UtilityExcavation].[UtilityFeeGLAccounts] DROP CONSTRAINT [' + @var3 + '];');
    ALTER TABLE [UtilityExcavation].[UtilityFeeGLAccounts] ALTER COLUMN [MunisRevenueAccountOrg] nvarchar(8) NOT NULL;
END;

GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20201015194952_UpdatedUtilityExcavationForCoAMigration')
BEGIN
    DECLARE @var4 sysname;
    SELECT @var4 = [d].[name]
    FROM [sys].[default_constraints] [d]
    INNER JOIN [sys].[columns] [c] ON [d].[parent_column_id] = [c].[column_id] AND [d].[parent_object_id] = [c].[object_id]
    WHERE ([d].[parent_object_id] = OBJECT_ID(N'[UtilityExcavation].[UtilityFeeGLAccounts]') AND [c].[name] = N'MunisExpenseCashAccountOrg');
    IF @var4 IS NOT NULL EXEC(N'ALTER TABLE [UtilityExcavation].[UtilityFeeGLAccounts] DROP CONSTRAINT [' + @var4 + '];');
    ALTER TABLE [UtilityExcavation].[UtilityFeeGLAccounts] ALTER COLUMN [MunisExpenseCashAccountOrg] nvarchar(8) NOT NULL;
END;

GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20201015194952_UpdatedUtilityExcavationForCoAMigration')
BEGIN
    DECLARE @var5 sysname;
    SELECT @var5 = [d].[name]
    FROM [sys].[default_constraints] [d]
    INNER JOIN [sys].[columns] [c] ON [d].[parent_column_id] = [c].[column_id] AND [d].[parent_object_id] = [c].[object_id]
    WHERE ([d].[parent_object_id] = OBJECT_ID(N'[UtilityExcavation].[UtilityFeeGLAccounts]') AND [c].[name] = N'MunisExpenseAccountOrg');
    IF @var5 IS NOT NULL EXEC(N'ALTER TABLE [UtilityExcavation].[UtilityFeeGLAccounts] DROP CONSTRAINT [' + @var5 + '];');
    ALTER TABLE [UtilityExcavation].[UtilityFeeGLAccounts] ALTER COLUMN [MunisExpenseAccountOrg] nvarchar(8) NOT NULL;
END;

GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20201015194952_UpdatedUtilityExcavationForCoAMigration')
BEGIN
    ALTER TABLE [UtilityExcavation].[UtilityFeeGLAccounts] ADD [MunisExpenseCashAccountProject] nvarchar(5) NOT NULL DEFAULT N'';
END;

GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20201015194952_UpdatedUtilityExcavationForCoAMigration')
BEGIN
    ALTER TABLE [UtilityExcavation].[UtilityFeeGLAccounts] ADD [MunisRevenueCashAccountProject] nvarchar(5) NOT NULL DEFAULT N'';
END;

GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20201015194952_UpdatedUtilityExcavationForCoAMigration')
BEGIN
    INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20201015194952_UpdatedUtilityExcavationForCoAMigration', N'3.1.9');
END;

GO

