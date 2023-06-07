CREATE TABLE [dbo].[PMPERMITTYPE] (
    [PMPERMITTYPEID]                     CHAR (36)      NOT NULL,
    [PMPERMITTYPEGROUPID]                CHAR (36)      NULL,
    [NAME]                               NVARCHAR (50)  NOT NULL,
    [PMPERMITGROUPID]                    CHAR (36)      NULL,
    [DAYSUNTILEXPIRE]                    INT            NOT NULL,
    [ACTIVE]                             BIT            NOT NULL,
    [UNLIMITED]                          BIT            NOT NULL,
    [PERMITPREFIX]                       NVARCHAR (20)  NULL,
    [AUTONUMBER]                         BIT            NOT NULL,
    [LASTNUMBER]                         INT            NOT NULL,
    [REPORTNAME]                         NVARCHAR (100) NULL,
    [COREPORTNAME]                       NVARCHAR (100) NULL,
    [COCREPORTNAME]                      NVARCHAR (100) NULL,
    [PERMITCARDREPORTNAME]               NVARCHAR (100) NULL,
    [ALLOWINTERNETSUBMISSION]            BIT            NOT NULL,
    [COPREFIX]                           NVARCHAR (20)  NULL,
    [REQUIREDPLPLANTYPEID]               CHAR (36)      NULL,
    [PLANCOMPLETIONBEFOREISSUE]          BIT            NOT NULL,
    [PLANCOMPLETIONBEFORECO]             BIT            NOT NULL,
    [COMMERCIAL]                         BIT            NOT NULL,
    [RESIDENTIAL]                        BIT            NOT NULL,
    [DAYSUNTILEXPIREFROMLASTINSPECT]     INT            NOT NULL,
    [ALLOWISSUEOPENINVOICE]              BIT            NOT NULL,
    [ALLOWISSUEUNSATISFIEDCONDITION]     BIT            NOT NULL,
    [SCHEDULEINSPECTWITHOUTISSUED]       BIT            NOT NULL,
    [SCHEDULEINSPECTWITHOPENINVOICE]     BIT            NOT NULL,
    [NOTIFYUSERPERMITONPARCEL]           BIT            NOT NULL,
    [DEFAULTPMPERMITSTATUSID]            CHAR (36)      NULL,
    [TABLENAME]                          NVARCHAR (100) NULL,
    [FRIENDLYNAME]                       NVARCHAR (150) NULL,
    [VALUATION]                          BIT            CONSTRAINT [DF_PMPermitType_Valuation] DEFAULT ((0)) NOT NULL,
    [SQUAREFEET]                         BIT            CONSTRAINT [DF_PMPermitType_SquareFeet] DEFAULT ((0)) NOT NULL,
    [DEFAULTWEBPMPERMITSTATUSID]         CHAR (36)      NULL,
    [USEPREFIXASSUFFIX]                  BIT            CONSTRAINT [DF_PMPERMITTYPE_USEPREASSUF] DEFAULT ((0)) NOT NULL,
    [VALIDATESAGSTCERT]                  BIT            DEFAULT ((1)) NOT NULL,
    [VALIDATESAGSTPROFILE]               BIT            DEFAULT ((1)) NOT NULL,
    [ALLOWOBJECTASSOCIATION]             BIT            DEFAULT ((0)) NOT NULL,
    [USECASETYPENUMBERING]               BIT            DEFAULT ((0)) NOT NULL,
    [PMPERMITTYPECSSUPLOADSETTINGTYPEID] INT            NULL,
    [ASSIGNEDUSER]                       CHAR (36)      NULL,
    [LASTCHANGEDBY]                      CHAR (36)      NULL,
    [LASTCHANGEDON]                      DATETIME       CONSTRAINT [DF_PMPERMITTYPE_LastChangedOn] DEFAULT (getutcdate()) NOT NULL,
    [ROWVERSION]                         INT            CONSTRAINT [DF_PMPERMITTYPE_RowVersion] DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_PMPermitType] PRIMARY KEY CLUSTERED ([PMPERMITTYPEID] ASC),
    CONSTRAINT [FK_PermitType_DefaultStatus] FOREIGN KEY ([DEFAULTPMPERMITSTATUSID]) REFERENCES [dbo].[PMPERMITSTATUS] ([PMPERMITSTATUSID]),
    CONSTRAINT [FK_PMPermitType_Group] FOREIGN KEY ([PMPERMITGROUPID]) REFERENCES [dbo].[PMPERMITGROUP] ([PMPERMITGROUPID]),
    CONSTRAINT [FK_PMPermitType_InterStat] FOREIGN KEY ([DEFAULTWEBPMPERMITSTATUSID]) REFERENCES [dbo].[PMPERMITSTATUS] ([PMPERMITSTATUSID]),
    CONSTRAINT [FK_PMPermitType_PLPlanType] FOREIGN KEY ([REQUIREDPLPLANTYPEID]) REFERENCES [dbo].[PLPLANTYPE] ([PLPLANTYPEID]),
    CONSTRAINT [FK_PMPermitType_PMPermitTypeCssUploadSettingTypes] FOREIGN KEY ([PMPERMITTYPECSSUPLOADSETTINGTYPEID]) REFERENCES [dbo].[PMPERMITTYPECSSUPLOADSETTINGTYPES] ([PMPERMITTYPECSSUPLOADSETTINGTYPEID]),
    CONSTRAINT [FK_PMPermitType_TypeGroup] FOREIGN KEY ([PMPERMITTYPEGROUPID]) REFERENCES [dbo].[PMPERMITTYPEGROUP] ([PMPERMITTYPEGROUPID]),
    CONSTRAINT [FK_PMPERMITTYPE_USER] FOREIGN KEY ([ASSIGNEDUSER]) REFERENCES [dbo].[USERS] ([SUSERGUID])
);


GO
CREATE NONCLUSTERED INDEX [PMPERMITTYPE_IX_QUERY]
    ON [dbo].[PMPERMITTYPE]([PMPERMITTYPEID] ASC, [NAME] ASC);


GO
CREATE TRIGGER [dbo].[TG_PMPERMITTYPE_INSERT] ON [dbo].[PMPERMITTYPE]
   FOR INSERT
AS 
BEGIN
	SET NOCOUNT ON;
	-- Check if LASTCHANGEDBY contains VALID User Id and it Exists in USERS table, this is in replacement to foreign key reference of PMPERMITTYPE table with USERS table.
	IF EXISTS (SELECT * FROM inserted 
		LEFT OUTER JOIN USERS WITH (NOLOCK) ON USERS.SUSERGUID = inserted.LASTCHANGEDBY
		WHERE inserted.LASTCHANGEDBY IS NOT NULL AND USERS.SUSERGUID IS NULL)
	BEGIN		
		RAISERROR ('The INSERT or UPDATE statement conflicted with the FOREIGN KEY to table USERS', 16, 0);
		ROLLBACK;
		RETURN;
	END

    INSERT INTO [HISTORYSYSTEMSETUP]
    (	[ID],
		[ROWVERSION],
		[CHANGEDON],
		[CHANGEDBY],
		[FIELDNAME],
		[OLDVALUE],
		[NEWVALUE],
		[ADDITIONALINFO],
		[FORMID],
		[ACTION],
		[ISROOT],
		[RECORDNAME]
    )
	SELECT
			[inserted].[PMPERMITTYPEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Permit Type Added',
			'',
			'',
			'Permit Type (' + [inserted].[NAME] + ')',
			'4976A4A9-20E8-4B8F-997D-CE244B540104',
			1,
			1,
			[inserted].[NAME]
	FROM	[inserted]	
END
GO

CREATE TRIGGER [dbo].[TG_PMPERMITTYPE_UPDATE] ON [dbo].[PMPERMITTYPE] 
	AFTER UPDATE
AS 
BEGIN
	SET NOCOUNT ON;
		
	-- Check if LASTCHANGEDBY contains VALID User Id and it Exists in USERS table, this is in replacement to foreign key reference of PMPERMITTYPE table with USERS table.
	IF EXISTS (SELECT * FROM inserted 
		LEFT OUTER JOIN USERS WITH (NOLOCK) ON USERS.SUSERGUID = inserted.LASTCHANGEDBY
		WHERE inserted.LASTCHANGEDBY IS NOT NULL AND USERS.SUSERGUID IS NULL)
	BEGIN		
		RAISERROR ('The INSERT or UPDATE statement conflicted with the FOREIGN KEY to table USERS', 16, 0);
		ROLLBACK;
		RETURN;
	END	

    INSERT INTO [HISTORYSYSTEMSETUP]
    (	[ID],
		[ROWVERSION],
		[CHANGEDON],
		[CHANGEDBY],
		[FIELDNAME],
		[OLDVALUE],
		[NEWVALUE],
		[ADDITIONALINFO],
		[FORMID],
		[ACTION],
		[ISROOT],
		[RECORDNAME]
    )
	SELECT
			[inserted].[PMPERMITTYPEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Permit Type Name',
			[deleted].[NAME],
			[inserted].[NAME],
			'Permit Type (' + [inserted].[NAME] + ')',
			'4976A4A9-20E8-4B8F-997D-CE244B540104',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[PMPERMITTYPEID] = [inserted].[PMPERMITTYPEID]
	WHERE	[deleted].[NAME] <> [inserted].[NAME]
	UNION ALL

	SELECT
			[inserted].[PMPERMITTYPEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Friendly Name',
			ISNULL([deleted].[FRIENDLYNAME],'[none]'),
			ISNULL([inserted].[FRIENDLYNAME],'[none]'),
			'Permit Type (' + [inserted].[NAME] + ')',
			'4976A4A9-20E8-4B8F-997D-CE244B540104',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[PMPERMITTYPEID] = [inserted].[PMPERMITTYPEID]
	WHERE	ISNULL([deleted].[FRIENDLYNAME], '') <> ISNULL([inserted].[FRIENDLYNAME], '')	
	UNION ALL

	SELECT
			[inserted].[PMPERMITTYPEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Permit Type Group',
			ISNULL([PMPERMITTYPEGROUP_DELETED].[NAME],'[none]'),
			ISNULL([PMPERMITTYPEGROUP_INSERTED].[NAME],'[none]'),
			'Permit Type (' + [inserted].[NAME] + ')',
			'4976A4A9-20E8-4B8F-997D-CE244B540104',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[PMPERMITTYPEID] = [inserted].[PMPERMITTYPEID]
			LEFT JOIN [PMPERMITTYPEGROUP] PMPERMITTYPEGROUP_INSERTED WITH (NOLOCK) ON [PMPERMITTYPEGROUP_INSERTED].[PMPERMITTYPEGROUPID] = [inserted].[PMPERMITTYPEGROUPID]
			LEFT JOIN [PMPERMITTYPEGROUP] PMPERMITTYPEGROUP_DELETED WITH (NOLOCK) ON [PMPERMITTYPEGROUP_DELETED].[PMPERMITTYPEGROUPID] = [deleted].[PMPERMITTYPEGROUPID]
	WHERE	ISNULL([deleted].[PMPERMITTYPEGROUPID],'') <> ISNULL([inserted].[PMPERMITTYPEGROUPID],'')
	UNION ALL

	SELECT
			[inserted].[PMPERMITTYPEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Default Status',
			ISNULL([PMPERMITSTATUS_DELETED].[NAME],'[none]'),
			ISNULL([PMPERMITSTATUS_INSERTED].[NAME],'[none]'),
			'Permit Type (' + [inserted].[NAME] + ')',
			'4976A4A9-20E8-4B8F-997D-CE244B540104',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[PMPERMITTYPEID] = [inserted].[PMPERMITTYPEID]
			LEFT JOIN [PMPERMITSTATUS] PMPERMITSTATUS_INSERTED WITH (NOLOCK) ON [PMPERMITSTATUS_INSERTED].[PMPERMITSTATUSID] = [inserted].[DEFAULTPMPERMITSTATUSID]
			LEFT JOIN [PMPERMITSTATUS] PMPERMITSTATUS_DELETED WITH (NOLOCK) ON [PMPERMITSTATUS_DELETED].[PMPERMITSTATUSID] = [deleted].[DEFAULTPMPERMITSTATUSID]
	WHERE	ISNULL([deleted].[DEFAULTPMPERMITSTATUSID],'') <> ISNULL([inserted].[DEFAULTPMPERMITSTATUSID],'')
	UNION ALL

	SELECT
			[inserted].[PMPERMITTYPEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Default Internet Status',
			ISNULL([PMPERMITSTATUS_DELETED].[NAME],'[none]'),
			ISNULL([PMPERMITSTATUS_INSERTED].[NAME],'[none]'),
			'Permit Type (' + [inserted].[NAME] + ')',
			'4976A4A9-20E8-4B8F-997D-CE244B540104',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[PMPERMITTYPEID] = [inserted].[PMPERMITTYPEID]
			LEFT JOIN [PMPERMITSTATUS] PMPERMITSTATUS_INSERTED WITH (NOLOCK) ON [PMPERMITSTATUS_INSERTED].[PMPERMITSTATUSID] = [inserted].[DEFAULTWEBPMPERMITSTATUSID]
			LEFT JOIN [PMPERMITSTATUS] PMPERMITSTATUS_DELETED WITH (NOLOCK) ON [PMPERMITSTATUS_DELETED].[PMPERMITSTATUSID] = [deleted].[DEFAULTWEBPMPERMITSTATUSID]
	WHERE	ISNULL([deleted].[DEFAULTWEBPMPERMITSTATUSID],'') <> ISNULL([inserted].[DEFAULTWEBPMPERMITSTATUSID],'')
	UNION ALL

	SELECT
			[inserted].[PMPERMITTYPEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Default Case Assigned To',
			ISNULL([USERS_DELETED].[LNAME] + COALESCE(', ' + [USERS_DELETED].[FNAME], ''),'[none]'),
            ISNULL([USERS_INSERTED].[LNAME] + COALESCE(', ' + [USERS_INSERTED].[FNAME], '') ,'[none]'),
			'Permit Type (' + [inserted].[NAME] + ')',
			'4976A4A9-20E8-4B8F-997D-CE244B540104',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[PMPERMITTYPEID] = [inserted].[PMPERMITTYPEID]
			LEFT JOIN USERS USERS_DELETED WITH (NOLOCK) ON [deleted].[ASSIGNEDUSER] = [USERS_DELETED].[SUSERGUID]
			LEFT JOIN USERS USERS_INSERTED WITH (NOLOCK) ON [inserted].[ASSIGNEDUSER] = [USERS_INSERTED].[SUSERGUID]
	WHERE	ISNULL([deleted].[ASSIGNEDUSER],'') <> ISNULL([inserted].[ASSIGNEDUSER],'')
	UNION ALL

	SELECT
			[inserted].[PMPERMITTYPEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Permit Prefix',
			ISNULL([deleted].[PERMITPREFIX],'[none]'),
			ISNULL([inserted].[PERMITPREFIX],'[none]'),
			'Permit Type (' + [inserted].[NAME] + ')',
			'4976A4A9-20E8-4B8F-997D-CE244B540104',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[PMPERMITTYPEID] = [inserted].[PMPERMITTYPEID]
	WHERE	ISNULL([deleted].[PERMITPREFIX], '') <> ISNULL([inserted].[PERMITPREFIX], '')	
	UNION ALL

	SELECT
			[inserted].[PMPERMITTYPEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Days Until Expire',
			 CONVERT(NVARCHAR(MAX), [deleted].[DAYSUNTILEXPIRE]),
			CONVERT(NVARCHAR(MAX), [inserted].[DAYSUNTILEXPIRE]),
			'Permit Type (' + [inserted].[NAME] + ')',
			'4976A4A9-20E8-4B8F-997D-CE244B540104',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[PMPERMITTYPEID] = [inserted].[PMPERMITTYPEID]
	WHERE	[deleted].[DAYSUNTILEXPIRE]<> [inserted].[DAYSUNTILEXPIRE]
	UNION ALL

	SELECT
			[inserted].[PMPERMITTYPEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Days Until Expire From Last Inspect',
			CONVERT(NVARCHAR(MAX), [deleted].[DAYSUNTILEXPIREFROMLASTINSPECT]),
			CONVERT(NVARCHAR(MAX), [inserted].[DAYSUNTILEXPIREFROMLASTINSPECT]),
			'Permit Type (' + [inserted].[NAME] + ')',
			'4976A4A9-20E8-4B8F-997D-CE244B540104',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[PMPERMITTYPEID] = [inserted].[PMPERMITTYPEID]
	WHERE	[deleted].[DAYSUNTILEXPIREFROMLASTINSPECT] <> [inserted].[DAYSUNTILEXPIREFROMLASTINSPECT]	
	UNION ALL

	SELECT
			[inserted].[PMPERMITTYPEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Active Flag',
			CASE [deleted].[ACTIVE] WHEN 1 THEN 'Yes' ELSE 'No' END,
			CASE [inserted].[ACTIVE] WHEN 1 THEN 'Yes' ELSE 'No' END,
			'Permit Type (' + [inserted].[NAME] + ')',
			'4976A4A9-20E8-4B8F-997D-CE244B540104',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[PMPERMITTYPEID] = [inserted].[PMPERMITTYPEID]
	WHERE	[deleted].[ACTIVE] <> [inserted].[ACTIVE]
	UNION ALL

	SELECT
			[inserted].[PMPERMITTYPEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Auto Number Flag',
			CASE [deleted].[AUTONUMBER] WHEN 1 THEN 'Yes' ELSE 'No' END,
			CASE [inserted].[AUTONUMBER] WHEN 1 THEN 'Yes' ELSE 'No' END,
			'Permit Type (' + [inserted].[NAME] + ')',
			'4976A4A9-20E8-4B8F-997D-CE244B540104',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[PMPERMITTYPEID] = [inserted].[PMPERMITTYPEID]
	WHERE	[deleted].[AUTONUMBER] <> [inserted].[AUTONUMBER]	
	UNION ALL

	SELECT
			[inserted].[PMPERMITTYPEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Use Prefix As Suffix Flag',
			CASE [deleted].[USEPREFIXASSUFFIX] WHEN 1 THEN 'Yes' ELSE 'No' END,
			CASE [inserted].[USEPREFIXASSUFFIX] WHEN 1 THEN 'Yes' ELSE 'No' END,
			'Permit Type (' + [inserted].[NAME] + ')',
			'4976A4A9-20E8-4B8F-997D-CE244B540104',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[PMPERMITTYPEID] = [inserted].[PMPERMITTYPEID]
	WHERE	[deleted].[USEPREFIXASSUFFIX] <> [inserted].[USEPREFIXASSUFFIX]	
	UNION ALL

	SELECT
			[inserted].[PMPERMITTYPEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Case Type Numbering Flag',
			CASE [deleted].[USECASETYPENUMBERING] WHEN 1 THEN 'Yes' ELSE 'No' END,
			CASE [inserted].[USECASETYPENUMBERING] WHEN 1 THEN 'Yes' ELSE 'No' END,
			'Permit Type (' + [inserted].[NAME] + ')',
			'4976A4A9-20E8-4B8F-997D-CE244B540104',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[PMPERMITTYPEID] = [inserted].[PMPERMITTYPEID]
	WHERE	[deleted].[USECASETYPENUMBERING] <> [inserted].[USECASETYPENUMBERING]	
	UNION ALL

	SELECT
			[inserted].[PMPERMITTYPEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Commercial Flag',
			CASE [deleted].[COMMERCIAL] WHEN 1 THEN 'Yes' ELSE 'No' END,
			CASE [inserted].[COMMERCIAL] WHEN 1 THEN 'Yes' ELSE 'No' END,
			'Permit Type (' + [inserted].[NAME] + ')',
			'4976A4A9-20E8-4B8F-997D-CE244B540104',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[PMPERMITTYPEID] = [inserted].[PMPERMITTYPEID]
	WHERE	[deleted].[COMMERCIAL]<> [inserted].[COMMERCIAL]	
	UNION ALL

	SELECT
			[inserted].[PMPERMITTYPEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Residential Flag',
			CASE [deleted].[RESIDENTIAL] WHEN 1 THEN 'Yes' ELSE 'No' END,
			CASE [inserted].[RESIDENTIAL] WHEN 1 THEN 'Yes' ELSE 'No' END,
			'Permit Type (' + [inserted].[NAME] + ')',
			'4976A4A9-20E8-4B8F-997D-CE244B540104',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[PMPERMITTYPEID] = [inserted].[PMPERMITTYPEID]
	WHERE	[deleted].[RESIDENTIAL] <> [inserted].[RESIDENTIAL]	
	UNION ALL

	SELECT
			[inserted].[PMPERMITTYPEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Valuation Control Flag',
			CASE [deleted].[VALUATION] WHEN 1 THEN 'Yes' ELSE 'No' END,
			CASE [inserted].[VALUATION] WHEN 1 THEN 'Yes' ELSE 'No' END,
			'Permit Type (' + [inserted].[NAME] + ')',
			'4976A4A9-20E8-4B8F-997D-CE244B540104',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[PMPERMITTYPEID] = [inserted].[PMPERMITTYPEID]
	WHERE	[deleted].[VALUATION] <> [inserted].[VALUATION]	
	UNION ALL

	SELECT
			[inserted].[PMPERMITTYPEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Square Feet Control Flag',
			CASE [deleted].[SQUAREFEET] WHEN 1 THEN 'Yes' ELSE 'No' END,
			CASE [inserted].[SQUAREFEET] WHEN 1 THEN 'Yes' ELSE 'No' END,
			'Permit Type (' + [inserted].[NAME] + ')',
			'4976A4A9-20E8-4B8F-997D-CE244B540104',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[PMPERMITTYPEID] = [inserted].[PMPERMITTYPEID]
	WHERE	[deleted].[SQUAREFEET] <> [inserted].[SQUAREFEET]	
	UNION ALL

	SELECT
			[inserted].[PMPERMITTYPEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Unlimited Expiration Flag',
			CASE [deleted].[UNLIMITED] WHEN 1 THEN 'Yes' ELSE 'No' END,
			CASE [inserted].[UNLIMITED] WHEN 1 THEN 'Yes' ELSE 'No' END,
			'Permit Type (' + [inserted].[NAME] + ')',
			'4976A4A9-20E8-4B8F-997D-CE244B540104',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[PMPERMITTYPEID] = [inserted].[PMPERMITTYPEID]
	WHERE	[deleted].[UNLIMITED] <> [inserted].[UNLIMITED]	
	UNION ALL

	SELECT
			[inserted].[PMPERMITTYPEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Allow Internet Submission Flag',
			CASE [deleted].[ALLOWINTERNETSUBMISSION] WHEN 1 THEN 'Yes' ELSE 'No' END,
			CASE [inserted].[ALLOWINTERNETSUBMISSION] WHEN 1 THEN 'Yes' ELSE 'No' END,
			'Permit Type (' + [inserted].[NAME] + ')',
			'4976A4A9-20E8-4B8F-997D-CE244B540104',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[PMPERMITTYPEID] = [inserted].[PMPERMITTYPEID]
	WHERE	[deleted].[ALLOWINTERNETSUBMISSION] <> [inserted].[ALLOWINTERNETSUBMISSION]	
	UNION ALL

	SELECT
			[inserted].[PMPERMITTYPEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Allow Object Association Flag',
			CASE [deleted].[ALLOWOBJECTASSOCIATION] WHEN 1 THEN 'Yes' ELSE 'No' END,
			CASE [inserted].[ALLOWOBJECTASSOCIATION] WHEN 1 THEN 'Yes' ELSE 'No' END,
			'Permit Type (' + [inserted].[NAME] + ')',
			'4976A4A9-20E8-4B8F-997D-CE244B540104',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[PMPERMITTYPEID] = [inserted].[PMPERMITTYPEID]
	WHERE	[deleted].[ALLOWOBJECTASSOCIATION] <> [inserted].[ALLOWOBJECTASSOCIATION]	

	UNION ALL

	SELECT
			[inserted].[PMPERMITTYPEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Permit type CSS uploads settings id reference',
			ISNULL([DELETED_TYPE].[NAME],'[none]'),
			ISNULL([INSERTED_TYPE].[NAME],'[none]'),
			'Permit Type (' + [inserted].[NAME] + ')',
			'4976A4A9-20E8-4B8F-997D-CE244B540104',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[PMPERMITTYPEID] = [inserted].[PMPERMITTYPEID]
			LEFT JOIN [PMPERMITTYPECSSUPLOADSETTINGTYPES] INSERTED_TYPE WITH (NOLOCK)
					ON [INSERTED_TYPE].[PMPERMITTYPECSSUPLOADSETTINGTYPEID] = [inserted].[PMPERMITTYPECSSUPLOADSETTINGTYPEID]
			LEFT JOIN [PMPERMITTYPECSSUPLOADSETTINGTYPES] DELETED_TYPE WITH (NOLOCK)
					ON [DELETED_TYPE].[PMPERMITTYPECSSUPLOADSETTINGTYPEID] = [deleted].[PMPERMITTYPECSSUPLOADSETTINGTYPEID]
	WHERE	ISNULL([deleted].[PMPERMITTYPECSSUPLOADSETTINGTYPEID], '') <> ISNULL([inserted].[PMPERMITTYPECSSUPLOADSETTINGTYPEID], '')

END
GO

CREATE TRIGGER [dbo].[TG_PMPERMITTYPE_DELETE] ON [dbo].[PMPERMITTYPE]
   AFTER DELETE
AS 
BEGIN
	SET NOCOUNT ON;

    INSERT INTO [HISTORYSYSTEMSETUP]
    (	[ID],
		[ROWVERSION],
		[CHANGEDON],
		[CHANGEDBY],
		[FIELDNAME],
		[OLDVALUE],
		[NEWVALUE],
		[ADDITIONALINFO],
		[FORMID],
		[ACTION],
		[ISROOT],
		[RECORDNAME]
    )

	SELECT
			[deleted].[PMPERMITTYPEID],
			[deleted].[ROWVERSION],
			GETUTCDATE(),
			(SELECT dbo.UFN_GET_USERID_FROM_CONTEXT_INFO()),
			'Permit Type Deleted',
			'',
			'',
			'Permit Type (' + [deleted].[NAME] + ')',
			'4976A4A9-20E8-4B8F-997D-CE244B540104',
			3,
			1,
			[deleted].[NAME]
	FROM	[deleted]
END