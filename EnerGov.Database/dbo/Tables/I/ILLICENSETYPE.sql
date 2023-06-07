CREATE TABLE [dbo].[ILLICENSETYPE] (
    [ILLICENSETYPEID]             CHAR (36)      NOT NULL,
    [NAME]                        NVARCHAR (50)  NOT NULL,
    [DESCRIPTION]                 NVARCHAR (MAX) NULL,
    [KEEPLICENSENUMBER]           BIT            NOT NULL,
    [AUTONUMBER]                  BIT            NOT NULL,
    [CUSTOMFIELDLAYOUTID]         CHAR (36)      NULL,
    [PREFIX]                      NVARCHAR (10)  NULL,
    [DEFAULTLICENSESTATUSID]      CHAR (36)      NULL,
    [FRIENDLYNAME]                NVARCHAR (100) NOT NULL,
    [DEFAULTWEBAPPLYSTATUSID]     CHAR (36)      NULL,
    [DEFAULTWEBRENEWSTATUSID]     CHAR (36)      NULL,
    [ACTIVE]                      BIT            NOT NULL,
    [USESLICENSEGROUP]            BIT            NOT NULL,
    [USESLICENSECLASSTYPES]       BIT            NOT NULL,
    [ISRENEWABLE]                 BIT            NOT NULL,
    [ALLOWWEBSUBMISSION]          BIT            NOT NULL,
    [ALLOWRENEWALLICENSENUM]      BIT            NULL,
    [ISRECEIPTSTYPE]              BIT            NULL,
    [DEFAULTRENEWSTATUSID]        CHAR (36)      NULL,
    [SETRENEWISSDATETOPRVEXPDATE] BIT            DEFAULT ((0)) NOT NULL,
    [SETISSUEDATEONRENEWAL]       BIT            CONSTRAINT [DF_ILLICENSETYPE_SETISSUEDATEONRENEWAL] DEFAULT ((0)) NOT NULL,
    [CURRENTYEARONRENEWALS]       BIT            CONSTRAINT [DF_ILLICENSETYPE_CURRENTYEARONRENEWALS] DEFAULT ((0)) NOT NULL,
    [ILLICENSESYSTEMTYPEID]       INT            NULL,
    [ALLOWWEBRENEWAL]             BIT            DEFAULT ((0)) NOT NULL,
    [REQUIRELICENSEGROUP]         BIT            DEFAULT ((0)) NOT NULL,
    [REQUIRELICENSECLASSTYPE]     BIT            DEFAULT ((0)) NOT NULL,
    [SKIPPAYMENT]                 BIT            CONSTRAINT [DF_ILLicenseType_SkipPayment] DEFAULT ((0)) NOT NULL,
    [LASTCHANGEDBY]               CHAR (36)      NULL,
    [LASTCHANGEDON]               DATETIME       CONSTRAINT [DF_ILLICENSETYPE_LastChangedOn] DEFAULT (getutcdate()) NOT NULL,
    [ROWVERSION]                  INT            CONSTRAINT [DF_ILLICENSETYPE_RowVersion] DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_ILLicenseType] PRIMARY KEY CLUSTERED ([ILLICENSETYPEID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_APPLY_ILLICSTATUS] FOREIGN KEY ([DEFAULTWEBAPPLYSTATUSID]) REFERENCES [dbo].[ILLICENSESTATUS] ([ILLICENSESTATUSID]),
    CONSTRAINT [FK_ILLICENSETYPE_SYSTEM] FOREIGN KEY ([ILLICENSESYSTEMTYPEID]) REFERENCES [dbo].[ILLICENSESYSTEMTYPE] ([ILLICENSESYSTEMTYPEID]),
    CONSTRAINT [FK_ILLICTYPE_ILLICSTATUS] FOREIGN KEY ([DEFAULTRENEWSTATUSID]) REFERENCES [dbo].[ILLICENSESTATUS] ([ILLICENSESTATUSID]),
    CONSTRAINT [FK_LicType_CustomFieldLayout] FOREIGN KEY ([CUSTOMFIELDLAYOUTID]) REFERENCES [dbo].[CUSTOMFIELDLAYOUT] ([GCUSTOMFIELDLAYOUTS]),
    CONSTRAINT [FK_LicType_DefaultStatus] FOREIGN KEY ([DEFAULTLICENSESTATUSID]) REFERENCES [dbo].[ILLICENSESTATUS] ([ILLICENSESTATUSID]),
    CONSTRAINT [FK_RENEW_ILLICTYPE] FOREIGN KEY ([DEFAULTWEBRENEWSTATUSID]) REFERENCES [dbo].[ILLICENSESTATUS] ([ILLICENSESTATUSID])
);


GO
CREATE NONCLUSTERED INDEX [IX_ILLICENSETYPE_ILLICENSETYPEID_NAME]
    ON [dbo].[ILLICENSETYPE]([ILLICENSETYPEID] ASC, [NAME] ASC);


GO

CREATE TRIGGER [dbo].[TG_ILLICENSETYPE_INSERT] ON [dbo].[ILLICENSETYPE]
   FOR INSERT
AS 
BEGIN
	SET NOCOUNT ON;
	-- Check if LASTCHANGEDBY contains VALID User Id and it Exists in USERS table, this is in replacement to foreign key reference of ILLICENSETYPE table with USERS table.
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
			[inserted].[ILLICENSETYPEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Professional License Type Added',
			'',
			'',
			'Professional License Type (' + [inserted].[NAME] + ')',
			'67978C16-D720-4F8E-8120-E00FBB732A77',
			1,
			1,
			[inserted].[NAME]
	FROM	[inserted]	
END
GO

CREATE TRIGGER [dbo].[TG_ILLICENSETYPE_UPDATE] ON [dbo].[ILLICENSETYPE] 
	AFTER UPDATE
AS 
BEGIN
	SET NOCOUNT ON;
		
	-- Check if LASTCHANGEDBY contains VALID User Id and it Exists in USERS table, this is in replacement to foreign key reference of ILLICENSETYPE table with USERS table.
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
			[inserted].[ILLICENSETYPEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Type Name',
			[deleted].[NAME],
			[inserted].[NAME],
			'Professional License Type (' + [inserted].[NAME] + ')',
			'67978C16-D720-4F8E-8120-E00FBB732A77',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[ILLICENSETYPEID] = [inserted].[ILLICENSETYPEID]
	WHERE	[deleted].[NAME] <> [inserted].[NAME]
	
	UNION ALL
	SELECT
			[inserted].[ILLICENSETYPEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Description',
			ISNULL([deleted].[DESCRIPTION],'[none]'),
			ISNULL([inserted].[DESCRIPTION],'[none]'),
			'Professional License Type (' + [inserted].[NAME] + ')',
			'67978C16-D720-4F8E-8120-E00FBB732A77',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[ILLICENSETYPEID] = [inserted].[ILLICENSETYPEID]
	WHERE	ISNULL([deleted].[DESCRIPTION], '') <> ISNULL([inserted].[DESCRIPTION], '')	
	
	UNION ALL
	SELECT
			[inserted].[ILLICENSETYPEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Keep License Number Flag',
			CASE [deleted].[KEEPLICENSENUMBER] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' END,
			CASE [inserted].[KEEPLICENSENUMBER] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' END,
			'Professional License Type (' + [inserted].[NAME] + ')',
			'67978C16-D720-4F8E-8120-E00FBB732A77',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[ILLICENSETYPEID] = [inserted].[ILLICENSETYPEID]
	WHERE	[deleted].[KEEPLICENSENUMBER]<> [inserted].[KEEPLICENSENUMBER]
	
	UNION ALL
	SELECT
			[inserted].[ILLICENSETYPEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Auto Number Flag',
			CASE [deleted].[AUTONUMBER] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' END,
			CASE [inserted].[AUTONUMBER] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' END,
			'Professional License Type (' + [inserted].[NAME] + ')',
			'67978C16-D720-4F8E-8120-E00FBB732A77',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[ILLICENSETYPEID] = [inserted].[ILLICENSETYPEID]
	WHERE	[deleted].[AUTONUMBER] <> [inserted].[AUTONUMBER]
	
	UNION ALL
	SELECT
			[inserted].[ILLICENSETYPEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Default Status',
			ISNULL([CUSTOMFIELDLAYOUT_DELETED].[SNAME],'[none]'),
			ISNULL([CUSTOMFIELDLAYOUT_INSERTED].[SNAME],'[none]'),
			'Professional License Type (' + [inserted].[NAME] + ')',
			'67978C16-D720-4F8E-8120-E00FBB732A77',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[ILLICENSETYPEID] = [inserted].[ILLICENSETYPEID]
			LEFT JOIN [CUSTOMFIELDLAYOUT] [CUSTOMFIELDLAYOUT_INSERTED] WITH (NOLOCK) ON [CUSTOMFIELDLAYOUT_INSERTED].[GCUSTOMFIELDLAYOUTS] = [inserted].[CUSTOMFIELDLAYOUTID]
			LEFT JOIN [CUSTOMFIELDLAYOUT] [CUSTOMFIELDLAYOUT_DELETED] WITH (NOLOCK) ON [CUSTOMFIELDLAYOUT_DELETED].[GCUSTOMFIELDLAYOUTS] = [deleted].[CUSTOMFIELDLAYOUTID]
	WHERE	ISNULL([deleted].[CUSTOMFIELDLAYOUTID],'') <> ISNULL([inserted].[CUSTOMFIELDLAYOUTID],'')
	
	UNION ALL
	SELECT
			[inserted].[ILLICENSETYPEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Prefix',
			ISNULL([deleted].[PREFIX],'[none]'),
			ISNULL([inserted].[PREFIX],'[none]'),
			'Professional License Type (' + [inserted].[NAME] + ')',
			'67978C16-D720-4F8E-8120-E00FBB732A77',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[ILLICENSETYPEID] = [inserted].[ILLICENSETYPEID]
	WHERE	ISNULL([deleted].[PREFIX], '') <> ISNULL([inserted].[PREFIX], '')	
	
	UNION ALL
	SELECT
			[inserted].[ILLICENSETYPEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Default License Status',
			ISNULL([ILLICENSESTATUS_DELETED].[NAME],'[none]'),
			ISNULL([ILLICENSESTATUS_INSERTED].[NAME],'[none]'),
			'Professional License Type (' + [inserted].[NAME] + ')',
			'67978C16-D720-4F8E-8120-E00FBB732A77',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[ILLICENSETYPEID] = [inserted].[ILLICENSETYPEID]
			LEFT JOIN [ILLICENSESTATUS] [ILLICENSESTATUS_INSERTED] WITH (NOLOCK) ON [ILLICENSESTATUS_INSERTED].[ILLICENSESTATUSID] = [inserted].[DEFAULTLICENSESTATUSID]
			LEFT JOIN [ILLICENSESTATUS] [ILLICENSESTATUS_DELETED] WITH (NOLOCK) ON [ILLICENSESTATUS_DELETED].[ILLICENSESTATUSID] = [deleted].[DEFAULTLICENSESTATUSID]
	WHERE	ISNULL([deleted].[DEFAULTLICENSESTATUSID],'') <> ISNULL([inserted].[DEFAULTLICENSESTATUSID],'')
	
	UNION ALL
	SELECT
			[inserted].[ILLICENSETYPEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Friendly Name',
			[deleted].[FRIENDLYNAME],
			[inserted].[FRIENDLYNAME],
			'Professional License Type (' + [inserted].[NAME] + ')',
			'67978C16-D720-4F8E-8120-E00FBB732A77',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[ILLICENSETYPEID] = [inserted].[ILLICENSETYPEID]
	WHERE	[deleted].[FRIENDLYNAME] <> [inserted].[FRIENDLYNAME]
	
	UNION ALL
	SELECT
			[inserted].[ILLICENSETYPEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Default Online Apply Status',
			ISNULL([ILLICENSESTATUS_DELETED].[NAME],'[none]'),
			ISNULL([ILLICENSESTATUS_INSERTED].[NAME],'[none]'),
			'Professional License Type (' + [inserted].[NAME] + ')',
			'67978C16-D720-4F8E-8120-E00FBB732A77',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[ILLICENSETYPEID] = [inserted].[ILLICENSETYPEID]
			LEFT JOIN [ILLICENSESTATUS] [ILLICENSESTATUS_INSERTED] WITH (NOLOCK) ON [ILLICENSESTATUS_INSERTED].[ILLICENSESTATUSID] = [inserted].[DEFAULTWEBAPPLYSTATUSID]
			LEFT JOIN [ILLICENSESTATUS] [ILLICENSESTATUS_DELETED] WITH (NOLOCK) ON [ILLICENSESTATUS_DELETED].[ILLICENSESTATUSID] = [deleted].[DEFAULTWEBAPPLYSTATUSID]
	WHERE	ISNULL([deleted].[DEFAULTWEBAPPLYSTATUSID],'') <> ISNULL([inserted].[DEFAULTWEBAPPLYSTATUSID],'')
	
	UNION ALL
	SELECT
			[inserted].[ILLICENSETYPEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Default Online Renew Status',
			ISNULL([ILLICENSESTATUS_DELETED].[NAME],'[none]'),
			ISNULL([ILLICENSESTATUS_INSERTED].[NAME],'[none]'),
			'Professional License Type (' + [inserted].[NAME] + ')',
			'67978C16-D720-4F8E-8120-E00FBB732A77',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[ILLICENSETYPEID] = [inserted].[ILLICENSETYPEID]
			LEFT JOIN [ILLICENSESTATUS] [ILLICENSESTATUS_INSERTED] WITH (NOLOCK) ON [ILLICENSESTATUS_INSERTED].[ILLICENSESTATUSID] = [inserted].[DEFAULTWEBRENEWSTATUSID]
			LEFT JOIN [ILLICENSESTATUS] [ILLICENSESTATUS_DELETED] WITH (NOLOCK) ON [ILLICENSESTATUS_DELETED].[ILLICENSESTATUSID] = [deleted].[DEFAULTWEBRENEWSTATUSID]
	WHERE	ISNULL([deleted].[DEFAULTWEBRENEWSTATUSID],'') <> ISNULL([inserted].[DEFAULTWEBRENEWSTATUSID],'')
	
	UNION ALL
	SELECT
			[inserted].[ILLICENSETYPEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Active Flag',
			CASE [deleted].[ACTIVE] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' END,
			CASE [inserted].[ACTIVE] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' END,
			'Professional License Type (' + [inserted].[NAME] + ')',
			'67978C16-D720-4F8E-8120-E00FBB732A77',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[ILLICENSETYPEID] = [inserted].[ILLICENSETYPEID]
	WHERE	[deleted].[ACTIVE] <> [inserted].[ACTIVE]
	
	UNION ALL
	SELECT
			[inserted].[ILLICENSETYPEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Use License Group Flag',
			CASE [deleted].[USESLICENSEGROUP] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' END,
			CASE [inserted].[USESLICENSEGROUP] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' END,
			'Professional License Type (' + [inserted].[NAME] + ')',
			'67978C16-D720-4F8E-8120-E00FBB732A77',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[ILLICENSETYPEID] = [inserted].[ILLICENSETYPEID]
	WHERE	[deleted].[USESLICENSEGROUP] <> [inserted].[USESLICENSEGROUP]	
	
	UNION ALL
	SELECT
			[inserted].[ILLICENSETYPEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Use License Class Types Flag',
			CASE [deleted].[USESLICENSECLASSTYPES] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' END,
			CASE [inserted].[USESLICENSECLASSTYPES] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' END,
			'Professional License Type (' + [inserted].[NAME] + ')',
			'67978C16-D720-4F8E-8120-E00FBB732A77',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[ILLICENSETYPEID] = [inserted].[ILLICENSETYPEID]
	WHERE	[deleted].[USESLICENSECLASSTYPES]<> [inserted].[USESLICENSECLASSTYPES]
	
	UNION ALL
	SELECT
			[inserted].[ILLICENSETYPEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Is Renewable Flag',
			CASE [deleted].[ISRENEWABLE] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' END,
			CASE [inserted].[ISRENEWABLE] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' END,
			'Professional License Type (' + [inserted].[NAME] + ')',
			'67978C16-D720-4F8E-8120-E00FBB732A77',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[ILLICENSETYPEID] = [inserted].[ILLICENSETYPEID]
	WHERE	[deleted].[ISRENEWABLE]<> [inserted].[ISRENEWABLE]
	
	UNION ALL
	SELECT
			[inserted].[ILLICENSETYPEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Allow Online Submission Flag',
			CASE [deleted].[ALLOWWEBSUBMISSION] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' END,
			CASE [inserted].[ALLOWWEBSUBMISSION] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' END,
			'Professional License Type (' + [inserted].[NAME] + ')',
			'67978C16-D720-4F8E-8120-E00FBB732A77',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[ILLICENSETYPEID] = [inserted].[ILLICENSETYPEID]
	WHERE	[deleted].[ALLOWWEBSUBMISSION]<> [inserted].[ALLOWWEBSUBMISSION]
	
	UNION ALL
	SELECT
			[inserted].[ILLICENSETYPEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Allow Renewal License Number Flag',
			CASE ISNULL([deleted].[ALLOWRENEWALLICENSENUM],'') WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' ELSE '[none]' END,
			CASE ISNULL([inserted].[ALLOWRENEWALLICENSENUM],'') WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' ELSE '[none]' END,
			'Professional License Type (' + [inserted].[NAME] + ')',
			'67978C16-D720-4F8E-8120-E00FBB732A77',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[ILLICENSETYPEID] = [inserted].[ILLICENSETYPEID]
	WHERE	([deleted].[ALLOWRENEWALLICENSENUM] <> [inserted].[ALLOWRENEWALLICENSENUM])
			OR ([deleted].[ALLOWRENEWALLICENSENUM] IS NULL AND [inserted].[ALLOWRENEWALLICENSENUM] <> NULL)
			OR ([deleted].[ALLOWRENEWALLICENSENUM] <> NULL AND [inserted].[ALLOWRENEWALLICENSENUM] IS NULL)
	
	UNION ALL
	SELECT
			[inserted].[ILLICENSETYPEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Is Receipts Type Flag',
			CASE ISNULL([deleted].[ISRECEIPTSTYPE],'') WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' ELSE '[none]' END,
			CASE ISNULL([inserted].[ISRECEIPTSTYPE],'') WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' ELSE '[none]' END,
			'Professional License Type (' + [inserted].[NAME] + ')',
			'67978C16-D720-4F8E-8120-E00FBB732A77',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[ILLICENSETYPEID] = [inserted].[ILLICENSETYPEID]
	WHERE	([deleted].[ISRECEIPTSTYPE] <> [inserted].[ISRECEIPTSTYPE])
			OR ([deleted].[ISRECEIPTSTYPE] IS NULL AND [inserted].[ISRECEIPTSTYPE] <> NULL)
			OR ([deleted].[ISRECEIPTSTYPE] <> NULL AND [inserted].[ISRECEIPTSTYPE] IS NULL)
	
	UNION ALL
	SELECT
			[inserted].[ILLICENSETYPEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Default Renew Status',
			ISNULL([ILLICENSESTATUS_DELETED].[NAME],'[none]'),
			ISNULL([ILLICENSESTATUS_INSERTED].[NAME],'[none]'),
			'Professional License Type (' + [inserted].[NAME] + ')',
			'67978C16-D720-4F8E-8120-E00FBB732A77',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[ILLICENSETYPEID] = [inserted].[ILLICENSETYPEID]
			LEFT JOIN [ILLICENSESTATUS] [ILLICENSESTATUS_INSERTED] WITH (NOLOCK) ON [ILLICENSESTATUS_INSERTED].[ILLICENSESTATUSID] = [inserted].[DEFAULTRENEWSTATUSID]
			LEFT JOIN [ILLICENSESTATUS] [ILLICENSESTATUS_DELETED] WITH (NOLOCK) ON [ILLICENSESTATUS_DELETED].[ILLICENSESTATUSID] = [deleted].[DEFAULTRENEWSTATUSID]
	WHERE	ISNULL([deleted].[DEFAULTRENEWSTATUSID],'') <> ISNULL([inserted].[DEFAULTRENEWSTATUSID],'')
	
	UNION ALL
	SELECT
			[inserted].[ILLICENSETYPEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Set Renew Issue Date To Previous Expire Date Flag',
			CASE [deleted].[SETRENEWISSDATETOPRVEXPDATE] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' END,
			CASE [inserted].[SETRENEWISSDATETOPRVEXPDATE] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' END,
			'Professional License Type (' + [inserted].[NAME] + ')',
			'67978C16-D720-4F8E-8120-E00FBB732A77',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[ILLICENSETYPEID] = [inserted].[ILLICENSETYPEID]
	WHERE	[deleted].[SETRENEWISSDATETOPRVEXPDATE]<> [inserted].[SETRENEWISSDATETOPRVEXPDATE]
		
	UNION ALL
	SELECT
			[inserted].[ILLICENSETYPEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Set Issue Date On Renewal Flag',
			CASE [deleted].[SETISSUEDATEONRENEWAL] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' END,
			CASE [inserted].[SETISSUEDATEONRENEWAL] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' END,
			'Professional License Type (' + [inserted].[NAME] + ')',
			'67978C16-D720-4F8E-8120-E00FBB732A77',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[ILLICENSETYPEID] = [inserted].[ILLICENSETYPEID]
	WHERE	[deleted].[SETISSUEDATEONRENEWAL]<> [inserted].[SETISSUEDATEONRENEWAL]
	
	UNION ALL
	SELECT
			[inserted].[ILLICENSETYPEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Current Year On Renewals Flag',
			CASE [deleted].[CURRENTYEARONRENEWALS] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' END,
			CASE [inserted].[CURRENTYEARONRENEWALS] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' END,
			'Professional License Type (' + [inserted].[NAME] + ')',
			'67978C16-D720-4F8E-8120-E00FBB732A77',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[ILLICENSETYPEID] = [inserted].[ILLICENSETYPEID]
	WHERE	[deleted].[CURRENTYEARONRENEWALS]<> [inserted].[CURRENTYEARONRENEWALS]
		
	UNION ALL
	SELECT
			[inserted].[ILLICENSETYPEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'License System Type Name',
			ISNULL([ILLICENSESYSTEMTYPE_DELETED].[NAME],'[none]'),
			ISNULL([ILLICENSESYSTEMTYPE_INSERTED].[NAME],'[none]'),
			'Professional License Type (' + [inserted].[NAME] + ')',
			'67978C16-D720-4F8E-8120-E00FBB732A77',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[ILLICENSETYPEID] = [inserted].[ILLICENSETYPEID]
			LEFT JOIN [ILLICENSESYSTEMTYPE] [ILLICENSESYSTEMTYPE_INSERTED] WITH (NOLOCK) ON [ILLICENSESYSTEMTYPE_INSERTED].[ILLICENSESYSTEMTYPEID] = [inserted].[ILLICENSESYSTEMTYPEID]
			LEFT JOIN [ILLICENSESYSTEMTYPE] [ILLICENSESYSTEMTYPE_DELETED] WITH (NOLOCK) ON [ILLICENSESYSTEMTYPE_DELETED].[ILLICENSESYSTEMTYPEID] = [deleted].[ILLICENSESYSTEMTYPEID]
	WHERE	ISNULL([deleted].[ILLICENSESYSTEMTYPEID],'') <> ISNULL([inserted].[ILLICENSESYSTEMTYPEID],'')
	
	UNION ALL
	SELECT
			[inserted].[ILLICENSETYPEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Allow Online Renewal Flag',
			CASE [deleted].[ALLOWWEBRENEWAL] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' END,
			CASE [inserted].[ALLOWWEBRENEWAL] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' END,
			'Professional License Type (' + [inserted].[NAME] + ')',
			'67978C16-D720-4F8E-8120-E00FBB732A77',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[ILLICENSETYPEID] = [inserted].[ILLICENSETYPEID]
	WHERE	[deleted].[ALLOWWEBRENEWAL] <>  [inserted].[ALLOWWEBRENEWAL]

	UNION ALL
	SELECT
			[inserted].[ILLICENSETYPEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Require License Group Flag',
			CASE [deleted].[REQUIRELICENSEGROUP] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' END,
			CASE [inserted].[REQUIRELICENSEGROUP] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' END,
			'Professional License Type (' + [inserted].[NAME] + ')',
			'67978C16-D720-4F8E-8120-E00FBB732A77',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[ILLICENSETYPEID] = [inserted].[ILLICENSETYPEID]
	WHERE	[deleted].[REQUIRELICENSEGROUP] <>  [inserted].[REQUIRELICENSEGROUP]
	
	UNION ALL
	SELECT
			[inserted].[ILLICENSETYPEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Require License Class Type Flag',
			CASE [deleted].[REQUIRELICENSECLASSTYPE] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' END,
			CASE [inserted].[REQUIRELICENSECLASSTYPE] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' END,
			'Professional License Type (' + [inserted].[NAME] + ')',
			'67978C16-D720-4F8E-8120-E00FBB732A77',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[ILLICENSETYPEID] = [inserted].[ILLICENSETYPEID]
	WHERE	[deleted].[REQUIRELICENSECLASSTYPE] <>  [inserted].[REQUIRELICENSECLASSTYPE]
	
	UNION ALL
	SELECT
			[inserted].[ILLICENSETYPEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Skip Payment Flag',
			CASE [deleted].[SKIPPAYMENT] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' END,
			CASE [inserted].[SKIPPAYMENT] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' END,
			'Professional License Type (' + [inserted].[NAME] + ')',
			'67978C16-D720-4F8E-8120-E00FBB732A77',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[ILLICENSETYPEID] = [inserted].[ILLICENSETYPEID]
	WHERE	[deleted].[SKIPPAYMENT] <>  [inserted].[SKIPPAYMENT]
END
GO

CREATE TRIGGER [dbo].[TG_ILLICENSETYPE_DELETE] ON [dbo].[ILLICENSETYPE]
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
			[deleted].[ILLICENSETYPEID],
			[deleted].[ROWVERSION],
			GETUTCDATE(),
			(SELECT dbo.UFN_GET_USERID_FROM_CONTEXT_INFO()),
			'Professional License Type Deleted',
			'',
			'',
			'Professional License Type (' + [deleted].[NAME] + ')',
			'67978C16-D720-4F8E-8120-E00FBB732A77',
			3,
			1,
			[deleted].[NAME]
	FROM	[deleted]
END