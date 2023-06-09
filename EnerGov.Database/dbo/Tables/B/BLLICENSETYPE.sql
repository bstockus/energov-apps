﻿CREATE TABLE [dbo].[BLLICENSETYPE] (
    [BLLICENSETYPEID]                  CHAR (36)      NOT NULL,
    [NAME]                             NVARCHAR (50)  NOT NULL,
    [DESCRIPTION]                      NVARCHAR (MAX) NULL,
    [ACTIVE]                           BIT            NOT NULL,
    [DEFAULTSTATUSID]                  CHAR (36)      NULL,
    [PREFIX]                           NVARCHAR (10)  NULL,
    [ISRECEIPTSTYPE]                   BIT            CONSTRAINT [DF_BLLicenseType_IsReceiptsType] DEFAULT ((0)) NOT NULL,
    [ISRENEWABLE]                      BIT            CONSTRAINT [DF_BLLicenseType_IsRenewable] DEFAULT ((0)) NOT NULL,
    [DEFAULTINTERNETBLLICSTATUSID]     CHAR (36)      NULL,
    [ALLOWINTERNETSUBMISSION]          BIT            CONSTRAINT [DF_BLLicenseType_AllowInternetSubmission] DEFAULT ((0)) NOT NULL,
    [ALLOWRENEWALLICENSENUM]           BIT            NULL,
    [DEFAULTRENEWSTATUSID]             CHAR (36)      NULL,
    [SETRENEWISSDATETOPRVEXPDATE]      BIT            DEFAULT ((0)) NOT NULL,
    [SETISSUEDATEONRENEWAL]            BIT            CONSTRAINT [DF_BLLICENSETYPE_SETISSUEDATEONRENEWAL] DEFAULT ((0)) NOT NULL,
    [USEACTUALRECEIPTSASEST]           BIT            CONSTRAINT [DF_BLLICENSETYPE_USEACTUALRECEIPTSASEST] DEFAULT ((0)) NOT NULL,
    [ANNUALIZERECONCILERECEIPTS]       BIT            CONSTRAINT [DF_BLLICENSETYPE_ANNUALIZERECONCILERECEIPTS] DEFAULT ((0)) NOT NULL,
    [CURRENTYEARONRENEWALS]            BIT            CONSTRAINT [DF_BLLICENSETYPE_CURRENTYEARONRENEWALS] DEFAULT ((0)) NOT NULL,
    [CANRENEWONLINE]                   BIT            DEFAULT ((0)) NOT NULL,
    [DEFAULTWEBRENEWSTATUSID]          CHAR (36)      NULL,
    [MANAGEBUSINESSTYPECODES]          BIT            DEFAULT ((0)) NOT NULL,
    [REQUIREBUSINESSTYPECODES]         BIT            DEFAULT ((0)) NOT NULL,
    [REPORTRECEIPTSBYBUSINESSTYPECODE] BIT            DEFAULT ((0)) NOT NULL,
    [SKIPPAYMENT]                      BIT            CONSTRAINT [DF_BLLicenseType_SkipPayment] DEFAULT ((0)) NOT NULL,
    [LASTCHANGEDBY]                    CHAR (36)      NULL,
    [LASTCHANGEDON]                    DATETIME       CONSTRAINT [DF_BLLICENSETYPE_LastChangedOn] DEFAULT (getutcdate()) NOT NULL,
    [ROWVERSION]                       INT            CONSTRAINT [DF_BLLICENSETYPE_RowVersion] DEFAULT ((1)) NOT NULL,
    [BLLICENSETYPEMODULEID]            INT            NULL,
    CONSTRAINT [PK_BLLicenseType] PRIMARY KEY CLUSTERED ([BLLICENSETYPEID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_BLLicenseType_BLStatus] FOREIGN KEY ([DEFAULTSTATUSID]) REFERENCES [dbo].[BLLICENSESTATUS] ([BLLICENSESTATUSID]),
    CONSTRAINT [FK_BLLICENSETYPE_DEFINTERNETST] FOREIGN KEY ([DEFAULTRENEWSTATUSID]) REFERENCES [dbo].[BLLICENSESTATUS] ([BLLICENSESTATUSID]),
    CONSTRAINT [FK_BLLICTYP_DFLTWEBRENEWSTATUS] FOREIGN KEY ([DEFAULTWEBRENEWSTATUSID]) REFERENCES [dbo].[BLLICENSESTATUS] ([BLLICENSESTATUSID]),
    CONSTRAINT [FK_BLLICTYPE_BLLicenseTypeModule] FOREIGN KEY ([BLLICENSETYPEMODULEID]) REFERENCES [dbo].[BLLICENSETYPEMODULE] ([BLLICENSETYPEMODULEID]),
    CONSTRAINT [FK_BLLICTYPE_BLLICSTATUS] FOREIGN KEY ([DEFAULTINTERNETBLLICSTATUSID]) REFERENCES [dbo].[BLLICENSESTATUS] ([BLLICENSESTATUSID])
);


GO
CREATE NONCLUSTERED INDEX [IX_BLLICENSETYPE_BLLICENSETYPEID_NAME]
    ON [dbo].[BLLICENSETYPE]([BLLICENSETYPEID] ASC, [NAME] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_BLLICENSETYPE_BLLICENSETYPEMODULEID]
    ON [dbo].[BLLICENSETYPE]([BLLICENSETYPEMODULEID] ASC);


GO

CREATE TRIGGER [dbo].[TG_BLLICENSETYPE_DELETE] ON [dbo].[BLLICENSETYPE]
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
			[deleted].[BLLICENSETYPEID],
			[deleted].[ROWVERSION],
			GETUTCDATE(),
			(SELECT dbo.UFN_GET_USERID_FROM_CONTEXT_INFO()),
			'Business License Type Deleted',
			'',
			'',
			'Business License Type (' + [deleted].[NAME] + ')',
			'8C9D2A3A-2F18-45CE-B059-33A98C1EA148',
			3,
			1,
			[deleted].[NAME]
	FROM	[deleted]
END
GO
CREATE TRIGGER [dbo].[TG_BLLICENSETYPE_INSERT] ON [dbo].[BLLICENSETYPE]
   FOR INSERT
AS 
BEGIN
	SET NOCOUNT ON;
	-- Check if LASTCHANGEDBY contains VALID User Id and it Exists in USERS table, this is in replacement to foreign key reference of BLLICENSETYPE table with USERS table.
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
			[inserted].[BLLICENSETYPEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Business License Type Added',
			'',
			'',
			'Business License Type (' + [inserted].[NAME] + ')',
			'8C9D2A3A-2F18-45CE-B059-33A98C1EA148',
			1,
			1,
			[inserted].[NAME]
	FROM	[inserted]	
END
GO

CREATE TRIGGER [dbo].[TG_BLLICENSETYPE_UPDATE] ON [dbo].[BLLICENSETYPE] 
	AFTER UPDATE
AS 
BEGIN
	SET NOCOUNT ON;
		
	-- Check if LASTCHANGEDBY contains VALID User Id and it Exists in USERS table, this is in replacement to foreign key reference of BLLICENSETYPE table with USERS table.
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
			[inserted].[BLLICENSETYPEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Name',
			[deleted].[NAME],
			[inserted].[NAME],
			'Business License Type (' + [inserted].[NAME] + ')',
			'8C9D2A3A-2F18-45CE-B059-33A98C1EA148',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[BLLICENSETYPEID] = [inserted].[BLLICENSETYPEID]
	WHERE	[deleted].[NAME] <> [inserted].[NAME]
	
	UNION ALL
	SELECT
			[inserted].[BLLICENSETYPEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Description',
			ISNULL([deleted].[DESCRIPTION],'[none]'),
			ISNULL([inserted].[DESCRIPTION],'[none]'),
			'Business License Type (' + [inserted].[NAME] + ')',
			'8C9D2A3A-2F18-45CE-B059-33A98C1EA148',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[BLLICENSETYPEID] = [inserted].[BLLICENSETYPEID]
	WHERE	ISNULL([deleted].[DESCRIPTION], '') <> ISNULL([inserted].[DESCRIPTION], '')	
	
	UNION ALL
	SELECT
			[inserted].[BLLICENSETYPEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Active Flag',
			CASE [deleted].[ACTIVE] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' END,
			CASE [inserted].[ACTIVE] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' END,
			'Business License Type (' + [inserted].[NAME] + ')',
			'8C9D2A3A-2F18-45CE-B059-33A98C1EA148',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[BLLICENSETYPEID] = [inserted].[BLLICENSETYPEID]
	WHERE	[deleted].[ACTIVE] <> [inserted].[ACTIVE]
	
	UNION ALL
	SELECT
			[inserted].[BLLICENSETYPEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Default Status Name',
			ISNULL(BLLICENSESTATUS_DELETED.[NAME],'[none]'),
			ISNULL(BLLICENSESTATUS_INSERTED.[NAME],'[none]'),
			'Business License Type (' + [inserted].[NAME] + ')',
			'8C9D2A3A-2F18-45CE-B059-33A98C1EA148',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[BLLICENSETYPEID] = [inserted].[BLLICENSETYPEID]
			LEFT JOIN [BLLICENSESTATUS] BLLICENSESTATUS_INSERTED WITH (NOLOCK) ON BLLICENSESTATUS_INSERTED.[BLLICENSESTATUSID] = [inserted].[DEFAULTSTATUSID]
			LEFT JOIN [BLLICENSESTATUS] BLLICENSESTATUS_DELETED WITH (NOLOCK) ON BLLICENSESTATUS_DELETED.[BLLICENSESTATUSID] = [deleted].[DEFAULTSTATUSID]
	WHERE	ISNULL([deleted].[DEFAULTSTATUSID],'') <> ISNULL([inserted].[DEFAULTSTATUSID],'')
	
	UNION ALL
	SELECT
			[inserted].[BLLICENSETYPEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Prefix',
			ISNULL([deleted].[PREFIX],'[none]'),
			ISNULL([inserted].[PREFIX],'[none]'),
			'Business License Type (' + [inserted].[NAME] + ')',
			'8C9D2A3A-2F18-45CE-B059-33A98C1EA148',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[BLLICENSETYPEID] = [inserted].[BLLICENSETYPEID]
	WHERE	ISNULL([deleted].[PREFIX], '') <> ISNULL([inserted].[PREFIX], '')	
	
	UNION ALL
	SELECT
			[inserted].[BLLICENSETYPEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Is Receipts Type Flag',
			CASE [deleted].[ISRECEIPTSTYPE] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' END,
			CASE [inserted].[ISRECEIPTSTYPE] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' END,
			'Business License Type (' + [inserted].[NAME] + ')',
			'8C9D2A3A-2F18-45CE-B059-33A98C1EA148',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[BLLICENSETYPEID] = [inserted].[BLLICENSETYPEID]
	WHERE	[deleted].[ISRECEIPTSTYPE]<> [inserted].[ISRECEIPTSTYPE]
	
	UNION ALL
	SELECT
			[inserted].[BLLICENSETYPEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Is Renewable Flag',
			CASE [deleted].[ISRENEWABLE] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' END,
			CASE [inserted].[ISRENEWABLE] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' END,
			'Business License Type (' + [inserted].[NAME] + ')',
			'8C9D2A3A-2F18-45CE-B059-33A98C1EA148',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[BLLICENSETYPEID] = [inserted].[BLLICENSETYPEID]
	WHERE	[deleted].[ISRENEWABLE]<> [inserted].[ISRENEWABLE]
	
	UNION ALL
	SELECT
			[inserted].[BLLICENSETYPEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Default Internet Status Name',
			ISNULL(BLLICENSESTATUS_DELETED.[NAME],'[none]'),
			ISNULL(BLLICENSESTATUS_INSERTED.[NAME],'[none]'),
			'Business License Type (' + [inserted].[NAME] + ')',
			'8C9D2A3A-2F18-45CE-B059-33A98C1EA148',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[BLLICENSETYPEID] = [inserted].[BLLICENSETYPEID]
			LEFT JOIN [BLLICENSESTATUS] BLLICENSESTATUS_INSERTED WITH (NOLOCK) ON BLLICENSESTATUS_INSERTED.[BLLICENSESTATUSID] = [inserted].[DEFAULTINTERNETBLLICSTATUSID]
			LEFT JOIN [BLLICENSESTATUS] BLLICENSESTATUS_DELETED WITH (NOLOCK) ON BLLICENSESTATUS_DELETED.[BLLICENSESTATUSID] = [deleted].[DEFAULTINTERNETBLLICSTATUSID]
	WHERE	ISNULL([deleted].[DEFAULTINTERNETBLLICSTATUSID],'') <> ISNULL([inserted].[DEFAULTINTERNETBLLICSTATUSID],'')
	
	UNION ALL
	SELECT
			[inserted].[BLLICENSETYPEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Allow Internet Submission Flag',
			CASE [deleted].[ALLOWINTERNETSUBMISSION] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' END,
			CASE [inserted].[ALLOWINTERNETSUBMISSION] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' END,
			'Business License Type (' + [inserted].[NAME] + ')',
			'8C9D2A3A-2F18-45CE-B059-33A98C1EA148',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[BLLICENSETYPEID] = [inserted].[BLLICENSETYPEID]
	WHERE	[deleted].[ALLOWINTERNETSUBMISSION]<> [inserted].[ALLOWINTERNETSUBMISSION]
	
	UNION ALL
	SELECT
			[inserted].[BLLICENSETYPEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Allow Renewal License Num Flag',
			CASE ISNULL([deleted].[ALLOWRENEWALLICENSENUM],'') WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' ELSE '[none]' END,
			CASE ISNULL([inserted].[ALLOWRENEWALLICENSENUM],'') WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' ELSE '[none]' END,
			'Business License Type (' + [inserted].[NAME] + ')',
			'8C9D2A3A-2F18-45CE-B059-33A98C1EA148',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[BLLICENSETYPEID] = [inserted].[BLLICENSETYPEID]
	WHERE	([deleted].[ALLOWRENEWALLICENSENUM] <> [inserted].[ALLOWRENEWALLICENSENUM])
			OR ([deleted].[ALLOWRENEWALLICENSENUM] IS NULL AND [inserted].[ALLOWRENEWALLICENSENUM] <> NULL)
			OR ([deleted].[ALLOWRENEWALLICENSENUM] <> NULL AND [inserted].[ALLOWRENEWALLICENSENUM] IS NULL)
	
	UNION ALL
	SELECT
			[inserted].[BLLICENSETYPEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Default Renew Status Name',
			ISNULL(BLLICENSESTATUS_DELETED.[NAME],'[none]'),
			ISNULL(BLLICENSESTATUS_INSERTED.[NAME],'[none]'),
			'Business License Type (' + [inserted].[NAME] + ')',
			'8C9D2A3A-2F18-45CE-B059-33A98C1EA148',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[BLLICENSETYPEID] = [inserted].[BLLICENSETYPEID]
			LEFT JOIN [BLLICENSESTATUS] BLLICENSESTATUS_INSERTED WITH (NOLOCK) ON BLLICENSESTATUS_INSERTED.[BLLICENSESTATUSID] = [inserted].[DEFAULTRENEWSTATUSID]
			LEFT JOIN [BLLICENSESTATUS] BLLICENSESTATUS_DELETED WITH (NOLOCK) ON BLLICENSESTATUS_DELETED.[BLLICENSESTATUSID] = [deleted].[DEFAULTRENEWSTATUSID]
	WHERE	ISNULL([deleted].[DEFAULTRENEWSTATUSID],'') <> ISNULL([inserted].[DEFAULTRENEWSTATUSID],'')
	
	UNION ALL
	SELECT
			[inserted].[BLLICENSETYPEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Set Renew Issue Date To Previous Expired Date Flag',
			CASE [deleted].[SETRENEWISSDATETOPRVEXPDATE] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' END,
			CASE [inserted].[SETRENEWISSDATETOPRVEXPDATE] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' END,
			'Business License Type (' + [inserted].[NAME] + ')',
			'8C9D2A3A-2F18-45CE-B059-33A98C1EA148',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[BLLICENSETYPEID] = [inserted].[BLLICENSETYPEID]
	WHERE	[deleted].[SETRENEWISSDATETOPRVEXPDATE] <>  [inserted].[SETRENEWISSDATETOPRVEXPDATE]
	
	UNION ALL
	SELECT
			[inserted].[BLLICENSETYPEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Set Issue Date On Renewal Flag',
			CASE [deleted].[SETISSUEDATEONRENEWAL] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' END,
			CASE [inserted].[SETISSUEDATEONRENEWAL] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' END,
			'Business License Type (' + [inserted].[NAME] + ')',
			'8C9D2A3A-2F18-45CE-B059-33A98C1EA148',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[BLLICENSETYPEID] = [inserted].[BLLICENSETYPEID]
	WHERE	[deleted].[SETISSUEDATEONRENEWAL] <>  [inserted].[SETISSUEDATEONRENEWAL]
	
	UNION ALL
	SELECT
			[inserted].[BLLICENSETYPEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Use Actual Receipts Asest Flag',
			CASE [deleted].[USEACTUALRECEIPTSASEST] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' END,
			CASE [inserted].[USEACTUALRECEIPTSASEST] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' END,
			'Business License Type (' + [inserted].[NAME] + ')',
			'8C9D2A3A-2F18-45CE-B059-33A98C1EA148',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[BLLICENSETYPEID] = [inserted].[BLLICENSETYPEID]
	WHERE	[deleted].[USEACTUALRECEIPTSASEST] <>  [inserted].[USEACTUALRECEIPTSASEST]

	UNION ALL
	SELECT
			[inserted].[BLLICENSETYPEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Annualize Reconcile Receipts Flag',
			CASE [deleted].[ANNUALIZERECONCILERECEIPTS] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' END,
			CASE [inserted].[ANNUALIZERECONCILERECEIPTS] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' END,
			'Business License Type (' + [inserted].[NAME] + ')',
			'8C9D2A3A-2F18-45CE-B059-33A98C1EA148',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[BLLICENSETYPEID] = [inserted].[BLLICENSETYPEID]
	WHERE	[deleted].[ANNUALIZERECONCILERECEIPTS] <>  [inserted].[ANNUALIZERECONCILERECEIPTS]
	
	UNION ALL
	SELECT
			[inserted].[BLLICENSETYPEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Current Year On Renewals Flag',
			CASE [deleted].[CURRENTYEARONRENEWALS] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' END,
			CASE [inserted].[CURRENTYEARONRENEWALS] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' END,
			'Business License Type (' + [inserted].[NAME] + ')',
			'8C9D2A3A-2F18-45CE-B059-33A98C1EA148',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[BLLICENSETYPEID] = [inserted].[BLLICENSETYPEID]
	WHERE	[deleted].[CURRENTYEARONRENEWALS] <>  [inserted].[CURRENTYEARONRENEWALS]

	UNION ALL
	SELECT
			[inserted].[BLLICENSETYPEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Can Renew Online Flag',
			CASE [deleted].[CANRENEWONLINE] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' END,
			CASE [inserted].[CANRENEWONLINE] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' END,
			'Business License Type (' + [inserted].[NAME] + ')',
			'8C9D2A3A-2F18-45CE-B059-33A98C1EA148',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[BLLICENSETYPEID] = [inserted].[BLLICENSETYPEID]
	WHERE	[deleted].[CANRENEWONLINE] <>  [inserted].[CANRENEWONLINE]
	
	UNION ALL
	SELECT
			[inserted].[BLLICENSETYPEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Default Web Renew Status Name',
			ISNULL(BLLICENSESTATUS_DELETED.[NAME],'[none]'),
			ISNULL(BLLICENSESTATUS_INSERTED.[NAME],'[none]'),
			'Business License Type (' + [inserted].[NAME] + ')',
			'8C9D2A3A-2F18-45CE-B059-33A98C1EA148',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[BLLICENSETYPEID] = [inserted].[BLLICENSETYPEID]
			LEFT JOIN [BLLICENSESTATUS] BLLICENSESTATUS_INSERTED WITH (NOLOCK) ON BLLICENSESTATUS_INSERTED.[BLLICENSESTATUSID] = [inserted].[DEFAULTWEBRENEWSTATUSID] 
			LEFT JOIN [BLLICENSESTATUS] BLLICENSESTATUS_DELETED WITH (NOLOCK) ON BLLICENSESTATUS_DELETED.[BLLICENSESTATUSID] = [deleted].[DEFAULTWEBRENEWSTATUSID] 
	WHERE	ISNULL([deleted].[DEFAULTWEBRENEWSTATUSID],'') <> ISNULL([inserted].[DEFAULTWEBRENEWSTATUSID],'')

	UNION ALL
	SELECT
			[inserted].[BLLICENSETYPEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Manage Business Type Codes Flag',
			CASE [deleted].[MANAGEBUSINESSTYPECODES] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' END,
			CASE [inserted].[MANAGEBUSINESSTYPECODES] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' END,
			'Business License Type (' + [inserted].[NAME] + ')',
			'8C9D2A3A-2F18-45CE-B059-33A98C1EA148',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[BLLICENSETYPEID] = [inserted].[BLLICENSETYPEID]
	WHERE	[deleted].[MANAGEBUSINESSTYPECODES] <>  [inserted].[MANAGEBUSINESSTYPECODES]

	UNION ALL
	SELECT
			[inserted].[BLLICENSETYPEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Report Receipts By Business Type Code Flag',
			CASE [deleted].[REPORTRECEIPTSBYBUSINESSTYPECODE] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' END,
			CASE [inserted].[REPORTRECEIPTSBYBUSINESSTYPECODE] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' END,
			'Business License Type (' + [inserted].[NAME] + ')',
			'8C9D2A3A-2F18-45CE-B059-33A98C1EA148',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[BLLICENSETYPEID] = [inserted].[BLLICENSETYPEID]
	WHERE	[deleted].[REPORTRECEIPTSBYBUSINESSTYPECODE] <>  [inserted].[REPORTRECEIPTSBYBUSINESSTYPECODE]

	UNION ALL
	SELECT
			[inserted].[BLLICENSETYPEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Skip Payment Flag',
			CASE [deleted].[SKIPPAYMENT] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' END,
			CASE [inserted].[SKIPPAYMENT] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' END,
			'Business License Type (' + [inserted].[NAME] + ')',
			'8C9D2A3A-2F18-45CE-B059-33A98C1EA148',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[BLLICENSETYPEID] = [inserted].[BLLICENSETYPEID]
	WHERE	[deleted].[SKIPPAYMENT] <>  [inserted].[SKIPPAYMENT]
	
	UNION ALL

		SELECT 
			[inserted].[BLLICENSETYPEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Business License Type Module',
			ISNULL([BLLICENSETYPEMODULE_DELETED].[NAME],'[none]'),
			ISNULL([BLLICENSETYPEMODULE_INSERTED].[NAME],'[none]'),
			'Business License Type (' + [inserted].[NAME] + ')',
			'8C9D2A3A-2F18-45CE-B059-33A98C1EA148',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[BLLICENSETYPEID] = [inserted].[BLLICENSETYPEID]
			LEFT JOIN [BLLICENSETYPEMODULE] [BLLICENSETYPEMODULE_DELETED] WITH (NOLOCK) ON [deleted].[BLLICENSETYPEMODULEID] = [BLLICENSETYPEMODULE_DELETED].[BLLICENSETYPEMODULEID]
			LEFT JOIN [BLLICENSETYPEMODULE] [BLLICENSETYPEMODULE_INSERTED] WITH (NOLOCK) ON [inserted].[BLLICENSETYPEMODULEID] = [BLLICENSETYPEMODULE_INSERTED].[BLLICENSETYPEMODULEID]
	WHERE	ISNULL([deleted].[BLLICENSETYPEMODULEID],0) <> ISNULL([inserted].[BLLICENSETYPEMODULEID],0)

END