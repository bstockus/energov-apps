CREATE TABLE [dbo].[PLPLANTYPE] (
    [PLPLANTYPEID]                     CHAR (36)      NOT NULL,
    [PLPLANTYPEGROUPID]                CHAR (36)      NULL,
    [PLANNAME]                         NVARCHAR (50)  NOT NULL,
    [PREFIX]                           NVARCHAR (10)  NULL,
    [DAYSTOEXPIRE]                     INT            NULL,
    [ACTIVE]                           BIT            NULL,
    [TABLENAME]                        NVARCHAR (150) NULL,
    [UNLIMITED]                        BIT            NULL,
    [REPORTNAME]                       NVARCHAR (50)  NULL,
    [ALLOWINTERNETSUBMISSION]          BIT            NULL,
    [EXPIRABLE]                        BIT            NULL,
    [ASSIGNEDUSER]                     CHAR (36)      NULL,
    [DEFAULTSTATUS]                    CHAR (36)      NULL,
    [DEFAULTUSER]                      CHAR (36)      NULL,
    [SHOWINLICENSING]                  BIT            NULL,
    [ALLOWCOMPLETEWITHOPENINVOICE]     BIT            NULL,
    [DAYSTOPLANAPPROVALEXPIRE]         INT            NULL,
    [VALUATION]                        BIT            CONSTRAINT [DF_PLPlanType_Valuation] DEFAULT ((0)) NOT NULL,
    [SQUAREFEET]                       BIT            CONSTRAINT [DF_PLPlanType_SquareFeet] DEFAULT ((0)) NOT NULL,
    [USINGCLOCK]                       BIT            NULL,
    [CLOCKLIMITEDDAYS]                 INT            NULL,
    [DEFAULTINTERNETPLPLANSTATUSID]    CHAR (36)      NULL,
    [USEPREFIXASSUFFIX]                BIT            CONSTRAINT [DF_PLPLANTYPE_USEPREASSUF] DEFAULT ((0)) NOT NULL,
    [ALLOWOBJECTASSOCIATION]           BIT            DEFAULT ((0)) NOT NULL,
    [USECASETYPENUMBERING]             BIT            DEFAULT ((0)) NOT NULL,
    [PLPLANTYPECSSUPLOADSETTINGTYPEID] INT            NULL,
    [LASTCHANGEDBY]                    CHAR (36)      NULL,
    [LASTCHANGEDON]                    DATETIME       CONSTRAINT [DF_PLPLANTYPE_LastChangedOn] DEFAULT (getutcdate()) NOT NULL,
    [ROWVERSION]                       INT            CONSTRAINT [DF_PLPLANTYPE_RowVersion] DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_PLPlanType] PRIMARY KEY CLUSTERED ([PLPLANTYPEID] ASC),
    CONSTRAINT [FK_PLPlanType_Assigned] FOREIGN KEY ([ASSIGNEDUSER]) REFERENCES [dbo].[USERS] ([SUSERGUID]),
    CONSTRAINT [FK_PLPlanType_Default] FOREIGN KEY ([DEFAULTUSER]) REFERENCES [dbo].[USERS] ([SUSERGUID]),
    CONSTRAINT [FK_PLPlanType_PLPlanStatus] FOREIGN KEY ([DEFAULTSTATUS]) REFERENCES [dbo].[PLPLANSTATUS] ([PLPLANSTATUSID]),
    CONSTRAINT [FK_PLPlanType_PlPlanTypeCssUploadSettingTypes] FOREIGN KEY ([PLPLANTYPECSSUPLOADSETTINGTYPEID]) REFERENCES [dbo].[PLPLANTYPECSSUPLOADSETTINGTYPES] ([PLPLANTYPECSSUPLOADSETTINGTYPEID]),
    CONSTRAINT [FK_PLPlanType_Status] FOREIGN KEY ([DEFAULTINTERNETPLPLANSTATUSID]) REFERENCES [dbo].[PLPLANSTATUS] ([PLPLANSTATUSID]),
    CONSTRAINT [FK_PLPlanType_TypeGroup] FOREIGN KEY ([PLPLANTYPEGROUPID]) REFERENCES [dbo].[PLPLANTYPEGROUP] ([PLPLANTYPEGROUPID])
);


GO
CREATE NONCLUSTERED INDEX [PLPLANTYPE_IX_QUERY]
    ON [dbo].[PLPLANTYPE]([PLPLANTYPEID] ASC, [PLANNAME] ASC);


GO
CREATE TRIGGER [dbo].[TG_PLPLANTYPE_INSERT] ON [dbo].[PLPLANTYPE]
   FOR INSERT
AS 
BEGIN
	SET NOCOUNT ON;
	-- Check if LASTCHANGEDBY contains VALID User Id and it Exists in USERS table, this is in replacement to foreign key reference of PLPLANTYPE table with USERS table.
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
			[inserted].[PLPLANTYPEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Plan Type Added',
			'',
			'',
			'Plan Type (' + [inserted].[PLANNAME] + ')',
			'DEC0149B-EF4A-4E0F-AA4A-E622B90C1545',
			1,
			1,
			[inserted].[PLANNAME]
	FROM	[inserted]	
END
GO
CREATE TRIGGER [dbo].[TG_PLPLANTYPE_UPDATE] ON [dbo].[PLPLANTYPE]
   AFTER UPDATE
AS 
BEGIN
	SET NOCOUNT ON;
	-- Check if LASTCHANGEDBY contains VALID User Id and it Exists in USERS table, this is in replacement to foreign key reference of PLPLANTYPE table with USERS table.
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
			[inserted].[PLPLANTYPEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Plan Name',
			[deleted].[PLANNAME],
			[inserted].[PLANNAME],
			'Plan Type (' + [inserted].[PLANNAME] + ')',
			'DEC0149B-EF4A-4E0F-AA4A-E622B90C1545',
			2,
			1,
			[inserted].[PLANNAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[PLPLANTYPEID] = [inserted].[PLPLANTYPEID]
	WHERE	[deleted].[PLANNAME] <> [inserted].[PLANNAME]
	UNION ALL
	SELECT
			[inserted].[PLPLANTYPEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Prefix',
			ISNULL([deleted].[PREFIX],'[none]'),
			ISNULL([inserted].[PREFIX],'[none]'),
			'Plan Type (' + [inserted].[PLANNAME] + ')',
			'DEC0149B-EF4A-4E0F-AA4A-E622B90C1545',
			2,
			1,
			[inserted].[PLANNAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[PLPLANTYPEID] = [inserted].[PLPLANTYPEID]
	WHERE	ISNULL([deleted].[PREFIX], '') <> ISNULL([inserted].[PREFIX], '')
	UNION ALL
	SELECT
			[inserted].[PLPLANTYPEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Days To Expire',
			ISNULL(CONVERT(NVARCHAR(MAX),[deleted].[DAYSTOEXPIRE]),'[none]'),
			ISNULL(CONVERT(NVARCHAR(MAX),[inserted].[DAYSTOEXPIRE]),'[none]'),
			'Plan Type (' + [inserted].[PLANNAME] + ')',
			'DEC0149B-EF4A-4E0F-AA4A-E622B90C1545',
			2,
			1,
			[inserted].[PLANNAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[PLPLANTYPEID] = [inserted].[PLPLANTYPEID]
	WHERE	ISNULL([deleted].[DAYSTOEXPIRE], '') <> ISNULL([inserted].[DAYSTOEXPIRE], '')
	UNION ALL
	SELECT
			[inserted].[PLPLANTYPEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Active Flag',
			CASE [deleted].[ACTIVE] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' ELSE '[none]' END,
			CASE [inserted].[ACTIVE] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' ELSE '[none]' END,			
			'Plan Type (' + [inserted].[PLANNAME] + ')',
			'DEC0149B-EF4A-4E0F-AA4A-E622B90C1545',
			2,
			1,
			[inserted].[PLANNAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[PLPLANTYPEID] = [inserted].[PLPLANTYPEID]
	WHERE	[deleted].[ACTIVE] <> [inserted].[ACTIVE]
			OR ([deleted].[ACTIVE] IS NULL AND [inserted].[ACTIVE] IS NOT NULL)
			OR ([deleted].[ACTIVE] IS NOT NULL AND [inserted].[ACTIVE] IS NULL)
	UNION ALL
	SELECT
			[inserted].[PLPLANTYPEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Table Name',
			ISNULL([deleted].[TABLENAME],'[none]'),
			ISNULL([inserted].[TABLENAME],'[none]'),
			'Plan Type (' + [inserted].[PLANNAME] + ')',
			'DEC0149B-EF4A-4E0F-AA4A-E622B90C1545',
			2,
			1,
			[inserted].[PLANNAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[PLPLANTYPEID] = [inserted].[PLPLANTYPEID]
	WHERE	ISNULL([deleted].[TABLENAME], '') <> ISNULL([inserted].[TABLENAME], '')
	UNION ALL
	SELECT
			[inserted].[PLPLANTYPEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Plan Type Group',
			ISNULL([PLPLANTYPEGROUP_DELETED].[NAME],'[none]'),
			ISNULL([PLPLANTYPEGROUP_INSERTED].[NAME],'[none]'),
			'Plan Type (' + [inserted].[PLANNAME] + ')',
			'DEC0149B-EF4A-4E0F-AA4A-E622B90C1545',
			2,
			1,
			[inserted].[PLANNAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[PLPLANTYPEID] = [inserted].[PLPLANTYPEID]
			LEFT JOIN [PLPLANTYPEGROUP] [PLPLANTYPEGROUP_INSERTED] WITH (NOLOCK) ON [PLPLANTYPEGROUP_INSERTED].[PLPLANTYPEGROUPID] = [inserted].[PLPLANTYPEGROUPID]
			LEFT JOIN [PLPLANTYPEGROUP] [PLPLANTYPEGROUP_DELETED] WITH (NOLOCK) ON [PLPLANTYPEGROUP_DELETED].[PLPLANTYPEGROUPID] = [deleted].[PLPLANTYPEGROUPID]
	WHERE	ISNULL([deleted].[PLPLANTYPEGROUPID],'') <> ISNULL([inserted].[PLPLANTYPEGROUPID],'')
	UNION ALL	
	SELECT
			[inserted].[PLPLANTYPEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Default Internet Status',
			ISNULL([PLPLANSTATUS_DELETED].[NAME],'[none]'),
			ISNULL([PLPLANSTATUS_INSERTED].[NAME],'[none]'),
			'Plan Type (' + [inserted].[PLANNAME] + ')',
			'DEC0149B-EF4A-4E0F-AA4A-E622B90C1545',
			2,
			1,
			[inserted].[PLANNAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[PLPLANTYPEID] = [inserted].[PLPLANTYPEID]
			LEFT JOIN [PLPLANSTATUS] [PLPLANSTATUS_INSERTED] WITH (NOLOCK) ON [PLPLANSTATUS_INSERTED].[PLPLANSTATUSID] = [inserted].[DEFAULTINTERNETPLPLANSTATUSID]
			LEFT JOIN [PLPLANSTATUS] [PLPLANSTATUS_DELETED] WITH (NOLOCK) ON [PLPLANSTATUS_DELETED].[PLPLANSTATUSID] = [deleted].[DEFAULTINTERNETPLPLANSTATUSID]
	WHERE	ISNULL([deleted].[DEFAULTINTERNETPLPLANSTATUSID],'') <> ISNULL([inserted].[DEFAULTINTERNETPLPLANSTATUSID],'')
	UNION ALL
	SELECT
			[inserted].[PLPLANTYPEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Default Status',
			ISNULL([PLPLANSTATUS_DELETED].[NAME],'[none]'),
			ISNULL([PLPLANSTATUS_INSERTED].[NAME],'[none]'),
			'Plan Type (' + [inserted].[PLANNAME] + ')',
			'DEC0149B-EF4A-4E0F-AA4A-E622B90C1545',
			2,
			1,
			[inserted].[PLANNAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[PLPLANTYPEID] = [inserted].[PLPLANTYPEID]
			LEFT JOIN [PLPLANSTATUS] [PLPLANSTATUS_INSERTED] WITH (NOLOCK) ON [PLPLANSTATUS_INSERTED].[PLPLANSTATUSID] = [inserted].[DEFAULTSTATUS]
			LEFT JOIN [PLPLANSTATUS] [PLPLANSTATUS_DELETED] WITH (NOLOCK) ON [PLPLANSTATUS_DELETED].[PLPLANSTATUSID] = [deleted].[DEFAULTSTATUS]
	WHERE	ISNULL([deleted].[DEFAULTSTATUS],'') <> ISNULL([inserted].[DEFAULTSTATUS],'')
	UNION ALL	
	SELECT
			[inserted].[PLPLANTYPEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Default Case AssignedTo',
			ISNULL([USERS_DELETED].[LNAME] + COALESCE(', ' + [USERS_DELETED].[FNAME], ''),'[none]'),
            ISNULL([USERS_INSERTED].[LNAME] + COALESCE(', ' + [USERS_INSERTED].[FNAME], '') ,'[none]'),
			'Plan Type (' + [inserted].[PLANNAME] + ')',
			'DEC0149B-EF4A-4E0F-AA4A-E622B90C1545',
			2,
			1,
			[inserted].[PLANNAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[PLPLANTYPEID] = [inserted].[PLPLANTYPEID]
			LEFT JOIN [USERS] [USERS_DELETED] WITH (NOLOCK) ON [deleted].[ASSIGNEDUSER] = [USERS_DELETED].[SUSERGUID]
			LEFT JOIN [USERS] [USERS_INSERTED] WITH (NOLOCK) ON [inserted].[ASSIGNEDUSER] = [USERS_INSERTED].[SUSERGUID]
	WHERE	ISNULL([deleted].[ASSIGNEDUSER],'') <> ISNULL([inserted].[ASSIGNEDUSER],'')
	UNION ALL
	SELECT
			[inserted].[PLPLANTYPEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Default User',
			ISNULL([USERS_DELETED].[LNAME] + COALESCE(', ' + [USERS_DELETED].[FNAME], ''),'[none]'),
            ISNULL([USERS_INSERTED].[LNAME] + COALESCE(', ' + [USERS_INSERTED].[FNAME], '') ,'[none]'),
			'Plan Type (' + [inserted].[PLANNAME] + ')',
			'DEC0149B-EF4A-4E0F-AA4A-E622B90C1545',
			2,
			1,
			[inserted].[PLANNAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[PLPLANTYPEID] = [inserted].[PLPLANTYPEID]
			LEFT JOIN [USERS] [USERS_DELETED] WITH (NOLOCK) ON [deleted].[DEFAULTUSER] = [USERS_DELETED].[SUSERGUID]
			LEFT JOIN [USERS] [USERS_INSERTED] WITH (NOLOCK) ON [inserted].[DEFAULTUSER] = [USERS_INSERTED].[SUSERGUID]
	WHERE	ISNULL([deleted].[DEFAULTUSER],'') <> ISNULL([inserted].[DEFAULTUSER],'')
	UNION ALL
	SELECT
			[inserted].[PLPLANTYPEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Unlimited Flag',
			CASE [deleted].[UNLIMITED] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' ELSE '[none]' END,
			CASE [inserted].[UNLIMITED] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' ELSE '[none]' END,
			'Plan Type (' + [inserted].[PLANNAME] + ')',
			'DEC0149B-EF4A-4E0F-AA4A-E622B90C1545',
			2,
			1,
			[inserted].[PLANNAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[PLPLANTYPEID] = [inserted].[PLPLANTYPEID]
	WHERE	[deleted].[UNLIMITED] <> [inserted].[UNLIMITED]
			OR ([deleted].[UNLIMITED] IS NULL AND [inserted].[UNLIMITED] IS NOT NULL)
			OR ([deleted].[UNLIMITED] IS NOT NULL AND [inserted].[UNLIMITED] IS NULL)
	UNION ALL
	SELECT
			[inserted].[PLPLANTYPEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Report Name',
			ISNULL([deleted].[REPORTNAME],'[none]'),
			ISNULL([inserted].[REPORTNAME],'[none]'),
			'Plan Type (' + [inserted].[PLANNAME] + ')',
			'DEC0149B-EF4A-4E0F-AA4A-E622B90C1545',
			2,
			1,
			[inserted].[PLANNAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[PLPLANTYPEID] = [inserted].[PLPLANTYPEID]
	WHERE	ISNULL([deleted].[REPORTNAME], '') <> ISNULL([inserted].[REPORTNAME], '')
	UNION ALL
	SELECT
			[inserted].[PLPLANTYPEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Allow Internet Submission Flag',			
			CASE [deleted].[ALLOWINTERNETSUBMISSION] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' ELSE '[none]' END,
			CASE [inserted].[ALLOWINTERNETSUBMISSION] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' ELSE '[none]' END,
			'Plan Type (' + [inserted].[PLANNAME] + ')',
			'DEC0149B-EF4A-4E0F-AA4A-E622B90C1545',
			2,
			1,
			[inserted].[PLANNAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[PLPLANTYPEID] = [inserted].[PLPLANTYPEID]
	WHERE	[deleted].[ALLOWINTERNETSUBMISSION] <> [inserted].[ALLOWINTERNETSUBMISSION]
			OR ([deleted].[ALLOWINTERNETSUBMISSION] IS NULL AND [inserted].[ALLOWINTERNETSUBMISSION] IS NOT NULL)
			OR ([deleted].[ALLOWINTERNETSUBMISSION] IS NOT NULL AND [inserted].[ALLOWINTERNETSUBMISSION] IS NULL)
	UNION ALL
	SELECT
			[inserted].[PLPLANTYPEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Expirable Flag',			
			CASE [deleted].[EXPIRABLE] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' ELSE '[none]' END,
			CASE [inserted].[EXPIRABLE] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' ELSE '[none]' END,
			'Plan Type (' + [inserted].[PLANNAME] + ')',
			'DEC0149B-EF4A-4E0F-AA4A-E622B90C1545',
			2,
			1,
			[inserted].[PLANNAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[PLPLANTYPEID] = [inserted].[PLPLANTYPEID]
	WHERE	[deleted].[EXPIRABLE] <> [inserted].[EXPIRABLE]
			OR ([deleted].[EXPIRABLE] IS NULL AND [inserted].[EXPIRABLE] IS NOT NULL)
			OR ([deleted].[EXPIRABLE] IS NOT NULL AND [inserted].[EXPIRABLE] IS NULL)
	UNION ALL
	SELECT
			[inserted].[PLPLANTYPEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Show In Licensing Flag',			
			CASE [deleted].[SHOWINLICENSING] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' ELSE '[none]' END,
			CASE [inserted].[SHOWINLICENSING] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' ELSE '[none]' END,
			'Plan Type (' + [inserted].[PLANNAME] + ')',
			'DEC0149B-EF4A-4E0F-AA4A-E622B90C1545',
			2,
			1,
			[inserted].[PLANNAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[PLPLANTYPEID] = [inserted].[PLPLANTYPEID]
	WHERE	[deleted].[SHOWINLICENSING] <> [inserted].[SHOWINLICENSING]
			OR ([deleted].[SHOWINLICENSING] IS NULL AND [inserted].[SHOWINLICENSING] IS NOT NULL)
			OR ([deleted].[SHOWINLICENSING] IS NOT NULL AND [inserted].[SHOWINLICENSING] IS NULL)
	UNION ALL
	SELECT
			[inserted].[PLPLANTYPEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Allow Complete with Open Invoice Flag',
			CASE [deleted].[ALLOWCOMPLETEWITHOPENINVOICE] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' ELSE '[none]' END,
			CASE [inserted].[ALLOWCOMPLETEWITHOPENINVOICE] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' ELSE '[none]' END,
			'Plan Type (' + [inserted].[PLANNAME] + ')',
			'DEC0149B-EF4A-4E0F-AA4A-E622B90C1545',
			2,
			1,
			[inserted].[PLANNAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[PLPLANTYPEID] = [inserted].[PLPLANTYPEID]
	WHERE	[deleted].[ALLOWCOMPLETEWITHOPENINVOICE] <> [inserted].[ALLOWCOMPLETEWITHOPENINVOICE]
			OR ([deleted].[ALLOWCOMPLETEWITHOPENINVOICE] IS NULL AND [inserted].[ALLOWCOMPLETEWITHOPENINVOICE] IS NOT NULL)
			OR ([deleted].[ALLOWCOMPLETEWITHOPENINVOICE] IS NOT NULL AND [inserted].[ALLOWCOMPLETEWITHOPENINVOICE] IS NULL)
	UNION ALL
	SELECT
			[inserted].[PLPLANTYPEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Days To Plan Approval Expire',
			ISNULL(CONVERT(NVARCHAR(MAX),[deleted].[DAYSTOPLANAPPROVALEXPIRE]),'[none]'),
			ISNULL(CONVERT(NVARCHAR(MAX),[inserted].[DAYSTOPLANAPPROVALEXPIRE]),'[none]'),
			'Plan Type (' + [inserted].[PLANNAME] + ')',
			'DEC0149B-EF4A-4E0F-AA4A-E622B90C1545',
			2,
			1,
			[inserted].[PLANNAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[PLPLANTYPEID] = [inserted].[PLPLANTYPEID]
	WHERE	ISNULL([deleted].[DAYSTOPLANAPPROVALEXPIRE], '') <> ISNULL([inserted].[DAYSTOPLANAPPROVALEXPIRE], '')
	UNION ALL
	SELECT
			[inserted].[PLPLANTYPEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Valuation Control Flag',
			CASE [deleted].[VALUATION] WHEN 1 THEN 'Yes' ELSE 'No' END,
			CASE [inserted].[VALUATION] WHEN 1 THEN 'Yes' ELSE 'No' END,
			'Plan Type (' + [inserted].[PLANNAME] + ')',
			'DEC0149B-EF4A-4E0F-AA4A-E622B90C1545',
			2,
			1,
			[inserted].[PLANNAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[PLPLANTYPEID] = [inserted].[PLPLANTYPEID]
	WHERE	[deleted].[VALUATION] <> [inserted].[VALUATION]
	UNION ALL
	SELECT
			[inserted].[PLPLANTYPEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Squarefeet Control Flag',
			CASE [deleted].[SQUAREFEET] WHEN 1 THEN 'Yes' ELSE 'No' END,
			CASE [inserted].[SQUAREFEET] WHEN 1 THEN 'Yes' ELSE 'No' END,
			'Plan Type (' + [inserted].[PLANNAME] + ')',
			'DEC0149B-EF4A-4E0F-AA4A-E622B90C1545',
			2,
			1,
			[inserted].[PLANNAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[PLPLANTYPEID] = [inserted].[PLPLANTYPEID]
	WHERE	[deleted].[SQUAREFEET] <> [inserted].[SQUAREFEET]	
	UNION ALL	
	SELECT
			[inserted].[PLPLANTYPEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Using Clock Flag',
			CASE [deleted].[USINGCLOCK] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' ELSE '[none]' END,
			CASE [inserted].[USINGCLOCK] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' ELSE '[none]' END,
			'Plan Type (' + [inserted].[PLANNAME] + ')',
			'DEC0149B-EF4A-4E0F-AA4A-E622B90C1545',
			2,
			1,
			[inserted].[PLANNAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[PLPLANTYPEID] = [inserted].[PLPLANTYPEID]
	WHERE	[deleted].[USINGCLOCK] <> [inserted].[USINGCLOCK]
			OR ([deleted].[USINGCLOCK] IS NULL AND [inserted].[USINGCLOCK] IS NOT NULL)
			OR ([deleted].[USINGCLOCK] IS NOT NULL AND [inserted].[USINGCLOCK] IS NULL)
	UNION ALL
	SELECT
			[inserted].[PLPLANTYPEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Clock Limited Days',
			ISNULL(CONVERT(NVARCHAR(MAX),[deleted].[CLOCKLIMITEDDAYS]),'[none]'),
			ISNULL(CONVERT(NVARCHAR(MAX),[inserted].[CLOCKLIMITEDDAYS]),'[none]'),
			'Plan Type (' + [inserted].[PLANNAME] + ')',
			'DEC0149B-EF4A-4E0F-AA4A-E622B90C1545',
			2,
			1,
			[inserted].[PLANNAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[PLPLANTYPEID] = [inserted].[PLPLANTYPEID]
	WHERE	ISNULL([deleted].[CLOCKLIMITEDDAYS], '') <> ISNULL([inserted].[CLOCKLIMITEDDAYS], '')
	UNION ALL
	SELECT
			[inserted].[PLPLANTYPEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Use Prefix As Suffix Flag',			
			CASE [deleted].[USEPREFIXASSUFFIX] WHEN 1 THEN 'Yes' ELSE 'No' END,
			CASE [inserted].[USEPREFIXASSUFFIX] WHEN 1 THEN 'Yes' ELSE 'No' END,
			'Plan Type (' + [inserted].[PLANNAME] + ')',
			'DEC0149B-EF4A-4E0F-AA4A-E622B90C1545',
			2,
			1,
			[inserted].[PLANNAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[PLPLANTYPEID] = [inserted].[PLPLANTYPEID]
	WHERE	[deleted].[USEPREFIXASSUFFIX] <> [inserted].[USEPREFIXASSUFFIX]
	UNION ALL
	SELECT
			[inserted].[PLPLANTYPEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Allow Object Association Flag',			
			CASE [deleted].[ALLOWOBJECTASSOCIATION] WHEN 1 THEN 'Yes' ELSE 'No' END,
			CASE [inserted].[ALLOWOBJECTASSOCIATION] WHEN 1 THEN 'Yes' ELSE 'No' END,
			'Plan Type (' + [inserted].[PLANNAME] + ')',
			'DEC0149B-EF4A-4E0F-AA4A-E622B90C1545',
			2,
			1,
			[inserted].[PLANNAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[PLPLANTYPEID] = [inserted].[PLPLANTYPEID]
	WHERE	[deleted].[ALLOWOBJECTASSOCIATION] <> [inserted].[ALLOWOBJECTASSOCIATION]
	UNION ALL
	SELECT
			[inserted].[PLPLANTYPEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Case Type Numbering Flag',			
			CASE [deleted].[USECASETYPENUMBERING] WHEN 1 THEN 'Yes' ELSE 'No' END,
			CASE [inserted].[USECASETYPENUMBERING] WHEN 1 THEN 'Yes' ELSE 'No' END,
			'Plan Type (' + [inserted].[PLANNAME] + ')',
			'DEC0149B-EF4A-4E0F-AA4A-E622B90C1545',
			2,
			1,
			[inserted].[PLANNAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[PLPLANTYPEID] = [inserted].[PLPLANTYPEID]
	WHERE	[deleted].[USECASETYPENUMBERING] <> [inserted].[USECASETYPENUMBERING]

	UNION ALL
	
	SELECT
			[inserted].[PLPLANTYPEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Plan type CSS uploads settings id reference',
			ISNULL([DELETED_TYPE].[NAME],'[none]'),
			ISNULL([INSERTED_TYPE].[NAME],'[none]'),
			'Plan Type (' + [inserted].[PLANNAME] + ')',
			'DEC0149B-EF4A-4E0F-AA4A-E622B90C1545',
			2,
			1,
			[inserted].[PLANNAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[PLPLANTYPEID] = [inserted].[PLPLANTYPEID]
			LEFT JOIN [PLPLANTYPECSSUPLOADSETTINGTYPES] INSERTED_TYPE WITH (NOLOCK)
						ON [INSERTED_TYPE].[PLPLANTYPECSSUPLOADSETTINGTYPEID] = [inserted].[PLPLANTYPECSSUPLOADSETTINGTYPEID]
			LEFT JOIN [PLPLANTYPECSSUPLOADSETTINGTYPES] DELETED_TYPE WITH (NOLOCK)
						ON [DELETED_TYPE].[PLPLANTYPECSSUPLOADSETTINGTYPEID] = [deleted].[PLPLANTYPECSSUPLOADSETTINGTYPEID]
	WHERE	ISNULL([deleted].[PLPLANTYPECSSUPLOADSETTINGTYPEID], '') <> ISNULL([inserted].[PLPLANTYPECSSUPLOADSETTINGTYPEID], '')

END
GO
CREATE TRIGGER [dbo].[TG_PLPLANTYPE_DELETE] ON [dbo].[PLPLANTYPE]
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
			[deleted].[PLPLANTYPEID],
			[deleted].[ROWVERSION],
			GETUTCDATE(),
			(SELECT dbo.UFN_GET_USERID_FROM_CONTEXT_INFO()),
			'Plan Type Deleted',
			'',
			'',
			'Plan Type (' + [deleted].[PLANNAME] + ')',
			'DEC0149B-EF4A-4E0F-AA4A-E622B90C1545',
			3,
			1,
			[deleted].[PLANNAME]
	FROM	[deleted]
END