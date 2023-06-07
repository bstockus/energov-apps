CREATE TABLE [dbo].[CAFINANCIALINTEGRATIONSETUP] (
    [CAFINANCIALINTEGRATIONSETUPID] CHAR (36)      NOT NULL,
    [ISACTIVE]                      BIT            CONSTRAINT [DF_CAFINANCIALINTEGRATIONSETUP_ISACTIVE] DEFAULT ((0)) NOT NULL,
    [CAFINANCIALINTEGRATIONTYPEID]  INT            NOT NULL,
    [NAME]                          NVARCHAR (100) NOT NULL,
    [ENABLEGL]                      BIT            CONSTRAINT [DF_CAFINANCIALINTEGRATIONSETUP_ENABLEGL] DEFAULT ((0)) NULL,
    [ENABLEAP]                      BIT            CONSTRAINT [DF_CAFINANCIALINTEGRATIONSETUP_ENABLEAP] DEFAULT ((0)) NULL,
    [ENABLEAR]                      BIT            CONSTRAINT [DF_CAFINANCIALINTEGRATIONSETUP_ENABLEAR] DEFAULT ((0)) NULL,
    [ENABLEEX]                      BIT            CONSTRAINT [DF_CAFINANCIALINTEGRATIONSETUP_ENABLEEX] DEFAULT ((0)) NULL,
    [WEBSERVICEURL]                 NVARCHAR (200) NOT NULL,
    [USERNAME]                      NVARCHAR (100) NULL,
    [PASSWORD]                      NVARCHAR (100) NULL,
    [TENANTNAME]                    NVARCHAR (100) NULL,
    [DOMAINNAME]                    NVARCHAR (100) NULL,
    [GRANTTYPE]                     NVARCHAR (100) NULL,
    [CLIENTID]                      NVARCHAR (100) NULL,
    [CLIENTSECRET]                  NVARCHAR (100) NULL,
    [ARCODE]                        NVARCHAR (100) NULL,
    [FIELDVALUESLAYOUTVERSION]      NVARCHAR (100) NULL,
    [CHARGEINPUTFLDID]              NVARCHAR (100) NULL,
    [CHARGEINPUTFLDNAME]            NVARCHAR (100) NULL,
    [PAYMENTLAYOUTVERSION]          NVARCHAR (100) NULL,
    [WORKSTATION]                   NVARCHAR (100) NULL,
    [ISDEFAULT]                     BIT            CONSTRAINT [DF_CAFINANCIALINTEGRATIONSETUP_ISDEFAULT] DEFAULT ((0)) NOT NULL,
    [LASTCHANGEDBY]                 CHAR (36)      NULL,
    [LASTCHANGEDON]                 DATETIME       CONSTRAINT [DF_CAFINANCIALINTEGRATIONSETUP_LASTCHANGEDON] DEFAULT (getutcdate()) NOT NULL,
    [ROWVERSION]                    INT            CONSTRAINT [DF_CAFINANCIALINTEGRATIONSETUP_ROWVERSION] DEFAULT ((1)) NOT NULL,
    [VENDORNUMBER]                  NVARCHAR (100) NULL,
    [INCLUDENSF]                    BIT            CONSTRAINT [DF_CAFINANCIALINTEGRATIONSETUP_INCLUDENSF] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_CAFINANCIALINTEGRATIONSETUP] PRIMARY KEY CLUSTERED ([CAFINANCIALINTEGRATIONSETUPID] ASC),
    CONSTRAINT [FK_CAFINANCIALINTEGRATIONSETUP_FINANCIALINTEGRATIONTYPE] FOREIGN KEY ([CAFINANCIALINTEGRATIONTYPEID]) REFERENCES [dbo].[CAFINANCIALINTEGRATIONTYPE] ([CAFINANCIALINTEGRATIONTYPEID]),
    CONSTRAINT [FK_CAFINANCIALINTEGRATIONSETUP_USERS] FOREIGN KEY ([LASTCHANGEDBY]) REFERENCES [dbo].[USERS] ([SUSERGUID])
);


GO
CREATE TRIGGER [TG_CAFINANCIALINTEGRATIONSETUP_DELETE] ON [dbo].[CAFINANCIALINTEGRATIONSETUP]
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
			[deleted].[CAFINANCIALINTEGRATIONSETUPID],
			[deleted].[ROWVERSION],
			GETUTCDATE(),
			(SELECT dbo.UFN_GET_USERID_FROM_CONTEXT_INFO()),
			'Tyler Financial Integration Deleted',
			'',
			'',
			'Tyler Financial Integration (' + [deleted].[NAME] + ')',
			'6115EBA3-71FF-4CEA-AB43-759135A83E0F',
			3,
			0,
			[deleted].[NAME]
	FROM	[deleted]
END
GO
CREATE TRIGGER [TG_CAFINANCIALINTEGRATIONSETUP_UPDATE] ON [dbo].[CAFINANCIALINTEGRATIONSETUP]
   AFTER UPDATE
AS 
BEGIN
	SET NOCOUNT ON;

	-- Check if LASTCHANGEDBY contains VALID User Id and it Exists in USERS table, this is in replacement to foreign key reference of CAFINANCIALINTEGRATIONSETUP table with USERS table.
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
			[inserted].[CAFINANCIALINTEGRATIONSETUPID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Name',
			[deleted].[NAME],
			[inserted].[NAME],
			'Tyler Financial Integration (' + [inserted].[NAME] + ')',
			'6115EBA3-71FF-4CEA-AB43-759135A83E0F',
			2,
			0,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[CAFINANCIALINTEGRATIONSETUPID] = [inserted].[CAFINANCIALINTEGRATIONSETUPID]			
	WHERE	[deleted].[NAME] <> [inserted].[NAME]
	UNION ALL

	SELECT
			[inserted].[CAFINANCIALINTEGRATIONSETUPID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Type',
			[deleted_CAFINANCIALINTEGRATIONTYPE].[Name],
			[inserted_CAFINANCIALINTEGRATIONTYPE].[Name],
			'Tyler Financial Integration (' + [inserted].[NAME] + ')',
			'6115EBA3-71FF-4CEA-AB43-759135A83E0F',
			2,
			0,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[CAFINANCIALINTEGRATIONSETUPID] = [inserted].[CAFINANCIALINTEGRATIONSETUPID]			
			INNER JOIN [dbo].[CAFINANCIALINTEGRATIONTYPE] [deleted_CAFINANCIALINTEGRATIONTYPE] WITH (NOLOCK) ON [deleted_CAFINANCIALINTEGRATIONTYPE].[CAFINANCIALINTEGRATIONTYPEID] = [deleted].[CAFINANCIALINTEGRATIONTYPEID]
			INNER JOIN [dbo].[CAFINANCIALINTEGRATIONTYPE] [inserted_CAFINANCIALINTEGRATIONTYPE] WITH (NOLOCK) ON [inserted_CAFINANCIALINTEGRATIONTYPE].[CAFINANCIALINTEGRATIONTYPEID] = [inserted].[CAFINANCIALINTEGRATIONTYPEID]
	WHERE	[deleted].[CAFINANCIALINTEGRATIONTYPEID] <> [inserted].[CAFINANCIALINTEGRATIONTYPEID]
	UNION ALL

	SELECT
			[inserted].[CAFINANCIALINTEGRATIONSETUPID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Web Service URL',
			[deleted].[WEBSERVICEURL],
			[inserted].[WEBSERVICEURL],
			'Tyler Financial Integration (' + [inserted].[NAME] + ')',
			'6115EBA3-71FF-4CEA-AB43-759135A83E0F',
			2,
			0,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[CAFINANCIALINTEGRATIONSETUPID] = [inserted].[CAFINANCIALINTEGRATIONSETUPID]			
	WHERE	[deleted].[WEBSERVICEURL] <> [inserted].[WEBSERVICEURL]
	UNION ALL

	SELECT
			[inserted].[CAFINANCIALINTEGRATIONSETUPID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Username',
			ISNULL([deleted].[USERNAME],'[none]'),
			ISNULL([inserted].[USERNAME],'[none]'),
			'Tyler Financial Integration (' + [inserted].[NAME] + ')',
			'6115EBA3-71FF-4CEA-AB43-759135A83E0F',
			2,
			0,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[CAFINANCIALINTEGRATIONSETUPID] = [inserted].[CAFINANCIALINTEGRATIONSETUPID]			
	WHERE	ISNULL([deleted].[USERNAME],'') <> ISNULL([inserted].[USERNAME],'')
	UNION ALL

	SELECT
			[inserted].[CAFINANCIALINTEGRATIONSETUPID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Password',
			CASE WHEN [deleted].[PASSWORD] IS NULL THEN '[none]' ELSE '*****' END,
			CASE WHEN [inserted].[PASSWORD] IS NULL THEN '[none]' ELSE '*****' END,
			'Tyler Financial Integration (' + [inserted].[NAME] + ')',
			'6115EBA3-71FF-4CEA-AB43-759135A83E0F',
			2,
			0,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[CAFINANCIALINTEGRATIONSETUPID] = [inserted].[CAFINANCIALINTEGRATIONSETUPID]			
	WHERE	ISNULL([deleted].[PASSWORD],'') <> ISNULL([inserted].[PASSWORD],'')
	UNION ALL

	SELECT
			[inserted].[CAFINANCIALINTEGRATIONSETUPID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Tenant name',
			ISNULL([deleted].[TENANTNAME],'[none]'),
			ISNULL([inserted].[TENANTNAME],'[none]'),
			'Tyler Financial Integration (' + [inserted].[NAME] + ')',
			'6115EBA3-71FF-4CEA-AB43-759135A83E0F',
			2,
			0,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[CAFINANCIALINTEGRATIONSETUPID] = [inserted].[CAFINANCIALINTEGRATIONSETUPID]			
	WHERE	ISNULL([deleted].[TENANTNAME],'') <> ISNULL([inserted].[TENANTNAME],'')
	UNION ALL

	SELECT
			[inserted].[CAFINANCIALINTEGRATIONSETUPID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Domain name',
			ISNULL([deleted].[DOMAINNAME],'[none]'),
			ISNULL([inserted].[DOMAINNAME],'[none]'),
			'Tyler Financial Integration (' + [inserted].[NAME] + ')',
			'6115EBA3-71FF-4CEA-AB43-759135A83E0F',
			2,
			0,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[CAFINANCIALINTEGRATIONSETUPID] = [inserted].[CAFINANCIALINTEGRATIONSETUPID]			
	WHERE	ISNULL([deleted].[DOMAINNAME],'') <> ISNULL([inserted].[DOMAINNAME],'')
	UNION ALL

	SELECT
			[inserted].[CAFINANCIALINTEGRATIONSETUPID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Grant type',
			ISNULL([deleted].[GRANTTYPE],'[none]'),
			ISNULL([inserted].[GRANTTYPE],'[none]'),
			'Tyler Financial Integration (' + [inserted].[NAME] + ')',
			'6115EBA3-71FF-4CEA-AB43-759135A83E0F',
			2,
			0,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[CAFINANCIALINTEGRATIONSETUPID] = [inserted].[CAFINANCIALINTEGRATIONSETUPID]			
	WHERE	ISNULL([deleted].[GRANTTYPE],'') <> ISNULL([inserted].[GRANTTYPE],'')
	UNION ALL

	SELECT
			[inserted].[CAFINANCIALINTEGRATIONSETUPID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Client ID',
			ISNULL([deleted].[CLIENTID],'[none]'),
			ISNULL([inserted].[CLIENTID],'[none]'),
			'Tyler Financial Integration (' + [inserted].[NAME] + ')',
			'6115EBA3-71FF-4CEA-AB43-759135A83E0F',
			2,
			0,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[CAFINANCIALINTEGRATIONSETUPID] = [inserted].[CAFINANCIALINTEGRATIONSETUPID]			
	WHERE	ISNULL([deleted].[CLIENTID],'') <> ISNULL([inserted].[CLIENTID],'')
	UNION ALL

	SELECT
			[inserted].[CAFINANCIALINTEGRATIONSETUPID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Client secret',
			CASE WHEN [deleted].[CLIENTSECRET] IS NULL THEN '[none]' ELSE '*****' END,
			CASE WHEN [inserted].[CLIENTSECRET] IS NULL THEN '[none]' ELSE '*****' END,
			'Tyler Financial Integration (' + [inserted].[NAME] + ')',
			'6115EBA3-71FF-4CEA-AB43-759135A83E0F',
			2,
			0,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[CAFINANCIALINTEGRATIONSETUPID] = [inserted].[CAFINANCIALINTEGRATIONSETUPID]			
	WHERE	ISNULL([deleted].[CLIENTSECRET],'') <> ISNULL([inserted].[CLIENTSECRET],'')
	UNION ALL

	SELECT
			[inserted].[CAFINANCIALINTEGRATIONSETUPID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Active Flag',
			CASE [deleted].[ISACTIVE] WHEN 1 THEN 'Yes' ELSE 'No' END,
			CASE [inserted].[ISACTIVE] WHEN 1 THEN 'Yes' ELSE 'No' END,
			'Tyler Financial Integration (' + [inserted].[NAME] + ')',
			'6115EBA3-71FF-4CEA-AB43-759135A83E0F',
			2,
			0,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[CAFINANCIALINTEGRATIONSETUPID] = [inserted].[CAFINANCIALINTEGRATIONSETUPID]			
	WHERE	[deleted].[ISACTIVE] <> [inserted].[ISACTIVE]
	UNION ALL

	SELECT
			[inserted].[CAFINANCIALINTEGRATIONSETUPID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Enable GL Flag',
			CASE [deleted].[ENABLEGL] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' ELSE '[none]' END,
			CASE [inserted].[ENABLEGL] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' ELSE '[none]' END,
			'Tyler Financial Integration (' + [inserted].[NAME] + ')',
			'6115EBA3-71FF-4CEA-AB43-759135A83E0F',
			2,
			0,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[CAFINANCIALINTEGRATIONSETUPID] = [inserted].[CAFINANCIALINTEGRATIONSETUPID]			
	WHERE	([deleted].[ENABLEGL] <> [inserted].[ENABLEGL])
			OR ([deleted].[ENABLEGL] IS NULL AND [inserted].[ENABLEGL] <> NULL)
			OR ([deleted].[ENABLEGL] <> NULL AND [inserted].[ENABLEGL] IS NULL)
	UNION ALL

	SELECT
			[inserted].[CAFINANCIALINTEGRATIONSETUPID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Enable AR Flag',
			CASE [deleted].[ENABLEAR] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' ELSE '[none]' END,
			CASE [inserted].[ENABLEAR] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' ELSE '[none]' END,
			'Tyler Financial Integration (' + [inserted].[NAME] + ')',
			'6115EBA3-71FF-4CEA-AB43-759135A83E0F',
			2,
			0,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[CAFINANCIALINTEGRATIONSETUPID] = [inserted].[CAFINANCIALINTEGRATIONSETUPID]			
	WHERE	([deleted].[ENABLEAR] <> [inserted].[ENABLEAR])
			OR ([deleted].[ENABLEAR] IS NULL AND [inserted].[ENABLEAR] <> NULL)
			OR ([deleted].[ENABLEAR] <> NULL AND [inserted].[ENABLEAR] IS NULL)
	UNION ALL

	SELECT
			[inserted].[CAFINANCIALINTEGRATIONSETUPID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Enable AP Flag',
			CASE [deleted].[ENABLEAP] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' ELSE '[none]' END,
			CASE [inserted].[ENABLEAP] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' ELSE '[none]' END,
			'Tyler Financial Integration (' + [inserted].[NAME] + ')',
			'6115EBA3-71FF-4CEA-AB43-759135A83E0F',
			2,
			0,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[CAFINANCIALINTEGRATIONSETUPID] = [inserted].[CAFINANCIALINTEGRATIONSETUPID]			
	WHERE	([deleted].[ENABLEAP] <> [inserted].[ENABLEAP])
			OR ([deleted].[ENABLEAP] IS NULL AND [inserted].[ENABLEAP] <> NULL)
			OR ([deleted].[ENABLEAP] <> NULL AND [inserted].[ENABLEAP] IS NULL)
	UNION ALL

	SELECT
			[inserted].[CAFINANCIALINTEGRATIONSETUPID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'AR Code',
			ISNULL([deleted].[ARCODE],'[none]'),
			ISNULL([inserted].[ARCODE],'[none]'),
			'Tyler Financial Integration (' + [inserted].[NAME] + ')',
			'6115EBA3-71FF-4CEA-AB43-759135A83E0F',
			2,
			0,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[CAFINANCIALINTEGRATIONSETUPID] = [inserted].[CAFINANCIALINTEGRATIONSETUPID]			
	WHERE	ISNULL([deleted].[ARCODE],'') <> ISNULL([inserted].[ARCODE],'')
	UNION ALL
	
	SELECT
			[inserted].[CAFINANCIALINTEGRATIONSETUPID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Enable Invoice Export Flag',
			CASE [deleted].[ENABLEEX] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' ELSE '[none]' END,
			CASE [inserted].[ENABLEEX] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' ELSE '[none]' END,
			'Tyler Financial Integration (' + [inserted].[NAME] + ')',
			'6115EBA3-71FF-4CEA-AB43-759135A83E0F',
			2,
			0,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[CAFINANCIALINTEGRATIONSETUPID] = [inserted].[CAFINANCIALINTEGRATIONSETUPID]			
	WHERE	([deleted].[ENABLEEX] <> [inserted].[ENABLEEX])
			OR ([deleted].[ENABLEEX] IS NULL AND [inserted].[ENABLEEX] <> NULL)
			OR ([deleted].[ENABLEEX] <> NULL AND [inserted].[ENABLEEX] IS NULL)
	UNION ALL

	SELECT
			[inserted].[CAFINANCIALINTEGRATIONSETUPID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Default Flag',
			CASE [deleted].[ISDEFAULT] WHEN 1 THEN 'Yes' ELSE 'No' END,
			CASE [inserted].[ISDEFAULT] WHEN 1 THEN 'Yes' ELSE 'No' END,
			'Tyler Financial Integration (' + [inserted].[NAME] + ')',
			'6115EBA3-71FF-4CEA-AB43-759135A83E0F',
			2,
			0,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[CAFINANCIALINTEGRATIONSETUPID] = [inserted].[CAFINANCIALINTEGRATIONSETUPID]			
	WHERE	[deleted].[ISDEFAULT] <> [inserted].[ISDEFAULT]
	UNION ALL
	
	SELECT
			[inserted].[CAFINANCIALINTEGRATIONSETUPID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Field Value Layout Version',
			ISNULL([deleted].[FIELDVALUESLAYOUTVERSION],'[none]'),
			ISNULL([inserted].[FIELDVALUESLAYOUTVERSION],'[none]'),
			'Tyler Financial Integration (' + [inserted].[NAME] + ')',
			'6115EBA3-71FF-4CEA-AB43-759135A83E0F',
			2,
			0,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[CAFINANCIALINTEGRATIONSETUPID] = [inserted].[CAFINANCIALINTEGRATIONSETUPID]			
	WHERE	ISNULL([deleted].[FIELDVALUESLAYOUTVERSION],'') <> ISNULL([inserted].[FIELDVALUESLAYOUTVERSION],'')
	UNION ALL

	SELECT
			[inserted].[CAFINANCIALINTEGRATIONSETUPID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Charge Input Field Id',
			ISNULL([deleted].[CHARGEINPUTFLDID],'[none]'),
			ISNULL([inserted].[CHARGEINPUTFLDID],'[none]'),
			'Tyler Financial Integration (' + [inserted].[NAME] + ')',
			'6115EBA3-71FF-4CEA-AB43-759135A83E0F',
			2,
			0,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[CAFINANCIALINTEGRATIONSETUPID] = [inserted].[CAFINANCIALINTEGRATIONSETUPID]			
	WHERE	ISNULL([deleted].[CHARGEINPUTFLDID],'') <> ISNULL([inserted].[CHARGEINPUTFLDID],'')
	UNION ALL

	SELECT
			[inserted].[CAFINANCIALINTEGRATIONSETUPID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Charge Input Field Name',
			ISNULL([deleted].[CHARGEINPUTFLDNAME],'[none]'),
			ISNULL([inserted].[CHARGEINPUTFLDNAME],'[none]'),
			'Tyler Financial Integration (' + [inserted].[NAME] + ')',
			'6115EBA3-71FF-4CEA-AB43-759135A83E0F',
			2,
			0,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[CAFINANCIALINTEGRATIONSETUPID] = [inserted].[CAFINANCIALINTEGRATIONSETUPID]			
	WHERE	ISNULL([deleted].[CHARGEINPUTFLDNAME],'') <> ISNULL([inserted].[CHARGEINPUTFLDNAME],'')
	UNION ALL

	SELECT
			[inserted].[CAFINANCIALINTEGRATIONSETUPID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Payment Layout Version',
			ISNULL([deleted].[PAYMENTLAYOUTVERSION],'[none]'),
			ISNULL([inserted].[PAYMENTLAYOUTVERSION],'[none]'),
			'Tyler Financial Integration (' + [inserted].[NAME] + ')',
			'6115EBA3-71FF-4CEA-AB43-759135A83E0F',
			2,
			0,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[CAFINANCIALINTEGRATIONSETUPID] = [inserted].[CAFINANCIALINTEGRATIONSETUPID]			
	WHERE	ISNULL([deleted].[PAYMENTLAYOUTVERSION],'') <> ISNULL([inserted].[PAYMENTLAYOUTVERSION],'')
	UNION ALL

	SELECT
			[inserted].[CAFINANCIALINTEGRATIONSETUPID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Work Station',
			ISNULL([deleted].[WORKSTATION],'[none]'),
			ISNULL([inserted].[WORKSTATION],'[none]'),
			'Tyler Financial Integration (' + [inserted].[NAME] + ')',
			'6115EBA3-71FF-4CEA-AB43-759135A83E0F',
			2,
			0,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[CAFINANCIALINTEGRATIONSETUPID] = [inserted].[CAFINANCIALINTEGRATIONSETUPID]			
	WHERE	ISNULL([deleted].[WORKSTATION],'') <> ISNULL([inserted].[WORKSTATION],'')
	UNION ALL

	SELECT
			[inserted].[CAFINANCIALINTEGRATIONSETUPID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Vendor number',
			ISNULL([deleted].[VENDORNUMBER],'[none]'),
			ISNULL([inserted].[VENDORNUMBER],'[none]'),
			'Tyler Financial Integration (' + [inserted].[NAME] + ')',
			'6115EBA3-71FF-4CEA-AB43-759135A83E0F',
			2,
			0,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[CAFINANCIALINTEGRATIONSETUPID] = [inserted].[CAFINANCIALINTEGRATIONSETUPID]			
	WHERE	ISNULL([deleted].[VENDORNUMBER],'') <> ISNULL([inserted].[VENDORNUMBER],'')
	UNION ALL

	SELECT
			[inserted].[CAFINANCIALINTEGRATIONSETUPID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Include NSF Flag',
			CASE [deleted].[INCLUDENSF] WHEN 1 THEN 'Yes' ELSE 'No' END,
			CASE [inserted].[INCLUDENSF] WHEN 1 THEN 'Yes' ELSE 'No' END,
			'Tyler Financial Integration (' + [inserted].[NAME] + ')',
			'6115EBA3-71FF-4CEA-AB43-759135A83E0F',
			2,
			0,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[CAFINANCIALINTEGRATIONSETUPID] = [inserted].[CAFINANCIALINTEGRATIONSETUPID]			
	WHERE	[deleted].[INCLUDENSF] <> [inserted].[INCLUDENSF]

END
GO
CREATE TRIGGER [TG_CAFINANCIALINTEGRATIONSETUP_INSERT] ON [dbo].[CAFINANCIALINTEGRATIONSETUP]
   AFTER INSERT
AS 
BEGIN
	SET NOCOUNT ON;	
	
	-- Check if LASTCHANGEDBY contains VALID User Id and it Exists in USERS table, this is in replacement to foreign key reference of CAFINANCIALINTEGRATIONSETUP table with USERS table.
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
			[inserted].[CAFINANCIALINTEGRATIONSETUPID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Tyler Financial Integration Added',
			'',
			'',
			'Tyler Financial Integration (' + [inserted].[NAME] + ')',
			'6115EBA3-71FF-4CEA-AB43-759135A83E0F',
			1,
			0,
			[inserted].[NAME]
	FROM	[inserted]
END