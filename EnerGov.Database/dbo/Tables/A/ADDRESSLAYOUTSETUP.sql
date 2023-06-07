CREATE TABLE [dbo].[ADDRESSLAYOUTSETUP] (
    [ADDRESSLAYOUTSETUPID]   CHAR (36)     NOT NULL,
    [COUNTRYID]              INT           DEFAULT ((0)) NOT NULL,
    [KEYTEXTBLOCKNAME]       VARCHAR (100) NOT NULL,
    [KEYCONTROLNAME]         VARCHAR (100) NULL,
    [KEYBINDINGPROPERTYNAME] VARCHAR (100) NULL,
    [DEFAULTLABEL]           VARCHAR (100) NOT NULL,
    [NEWLABEL]               VARCHAR (100) NULL,
    [DEFAULTTABINDEX]        INT           DEFAULT ((0)) NOT NULL,
    [NEWTABINDEX]            INT           DEFAULT ((0)) NOT NULL,
    [ISHIDE]                 BIT           DEFAULT ((0)) NOT NULL,
    [LASTCHANGEDBY]          CHAR (36)     NULL,
    [LASTCHANGEDON]          DATETIME      CONSTRAINT [DF_ADDRESSLAYOUTSETUP_LastChangedOn] DEFAULT (getutcdate()) NOT NULL,
    [ROWVERSION]             INT           CONSTRAINT [DF_ADDRESSLAYOUTSETUP_RowVersion] DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_ADDRESSLAYOUTSETUP] PRIMARY KEY CLUSTERED ([ADDRESSLAYOUTSETUPID] ASC) WITH (FILLFACTOR = 80)
);


GO
CREATE NONCLUSTERED INDEX [ADDRESSLAYOUTSETUP_IX_QUERY]
    ON [dbo].[ADDRESSLAYOUTSETUP]([ADDRESSLAYOUTSETUPID] ASC);


GO

CREATE TRIGGER [dbo].[TG_ADDRESSLAYOUTSETUP_UPDATE] ON  [dbo].[ADDRESSLAYOUTSETUP]
   AFTER UPDATE
AS 
BEGIN	
	SET NOCOUNT ON;

	-- Check if LASTCHANGEDBY contains VALID User Id and it Exists in USERS table, this is in replacement to foreign key reference of ADDRESSLAYOUTSETUP table with USERS table.
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
			[inserted].[ADDRESSLAYOUTSETUPID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Country',
			CAST([deleted].[COUNTRYID] AS NVARCHAR(MAX)),
			CAST([inserted].[COUNTRYID] AS NVARCHAR(MAX)),
			'Address (' + [inserted].[DEFAULTLABEL] + ')',
			'110D27F8-B93A-4A9B-B2BE-A80970FDE72B',
			2,
			1,
			[inserted].[DEFAULTLABEL]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[ADDRESSLAYOUTSETUPID] = [inserted].[ADDRESSLAYOUTSETUPID]			
	WHERE	[deleted].[COUNTRYID] <> [inserted].[COUNTRYID]
	UNION ALL

	SELECT 
			[inserted].[ADDRESSLAYOUTSETUPID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Block Name',
			[deleted].[KEYTEXTBLOCKNAME],
			[inserted].[KEYTEXTBLOCKNAME],
			'Address (' + [inserted].[DEFAULTLABEL] + ')',
			'110D27F8-B93A-4A9B-B2BE-A80970FDE72B',
			2,
			1,
			[inserted].[DEFAULTLABEL]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[ADDRESSLAYOUTSETUPID] = [inserted].[ADDRESSLAYOUTSETUPID]			
	WHERE	[deleted].[KEYTEXTBLOCKNAME] <> [inserted].[KEYTEXTBLOCKNAME]
	UNION ALL

	SELECT 
			[inserted].[ADDRESSLAYOUTSETUPID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Control Name',
			ISNULL([deleted].[KEYCONTROLNAME],'[none]'),
			ISNULL([inserted].[KEYCONTROLNAME],'[none]'),	
			'Address (' + [inserted].[DEFAULTLABEL] + ')',
			'110D27F8-B93A-4A9B-B2BE-A80970FDE72B',
			2,
			1,
			[inserted].[DEFAULTLABEL]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[ADDRESSLAYOUTSETUPID] = [inserted].[ADDRESSLAYOUTSETUPID]			
	WHERE	ISNULL([deleted].[KEYCONTROLNAME], '') <> ISNULL([inserted].[KEYCONTROLNAME], '')
	UNION ALL

	SELECT 
			[inserted].[ADDRESSLAYOUTSETUPID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Binding Property Name',
			ISNULL([deleted].[KEYBINDINGPROPERTYNAME],'[none]'),
			ISNULL([inserted].[KEYBINDINGPROPERTYNAME],'[none]'),	
			'Address (' + [inserted].[DEFAULTLABEL] + ')',
			'110D27F8-B93A-4A9B-B2BE-A80970FDE72B',
			2,
			1,
			[inserted].[DEFAULTLABEL]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[ADDRESSLAYOUTSETUPID] = [inserted].[ADDRESSLAYOUTSETUPID]			
	WHERE	ISNULL([deleted].[KEYBINDINGPROPERTYNAME], '') <> ISNULL([inserted].[KEYBINDINGPROPERTYNAME], '')
	UNION ALL

	SELECT 
			[inserted].[ADDRESSLAYOUTSETUPID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Default Label',
			[deleted].[DEFAULTLABEL],
			[inserted].[DEFAULTLABEL],
			'Address (' + [inserted].[DEFAULTLABEL] + ')',
			'110D27F8-B93A-4A9B-B2BE-A80970FDE72B',
			2,
			1,
			[inserted].[DEFAULTLABEL]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[ADDRESSLAYOUTSETUPID] = [inserted].[ADDRESSLAYOUTSETUPID]			
	WHERE	[deleted].[DEFAULTLABEL] <> [inserted].[DEFAULTLABEL]
	UNION ALL

	SELECT 
			[inserted].[ADDRESSLAYOUTSETUPID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'New Label',
			ISNULL([deleted].[NEWLABEL],'[none]'),
			ISNULL([inserted].[NEWLABEL],'[none]'),	
			'Address (' + [inserted].[DEFAULTLABEL] + ')',
			'110D27F8-B93A-4A9B-B2BE-A80970FDE72B',
			2,
			1,
			[inserted].[DEFAULTLABEL]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[ADDRESSLAYOUTSETUPID] = [inserted].[ADDRESSLAYOUTSETUPID]			
	WHERE	ISNULL([deleted].[NEWLABEL], '') <> ISNULL([inserted].[NEWLABEL], '')
	UNION ALL

	SELECT 
			[inserted].[ADDRESSLAYOUTSETUPID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Default Tab Order',
			CAST([deleted].[DEFAULTTABINDEX] AS NVARCHAR(MAX)),
			CAST([inserted].[DEFAULTTABINDEX] AS NVARCHAR(MAX)),
			'Address (' + [inserted].[DEFAULTLABEL] + ')',
			'110D27F8-B93A-4A9B-B2BE-A80970FDE72B',
			2,
			1,
			[inserted].[DEFAULTLABEL]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[ADDRESSLAYOUTSETUPID] = [inserted].[ADDRESSLAYOUTSETUPID]			
	WHERE	[deleted].[DEFAULTTABINDEX] <> [inserted].[DEFAULTTABINDEX]
	UNION ALL

	SELECT 
			[inserted].[ADDRESSLAYOUTSETUPID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'New Tab Order',
			CAST([deleted].[NEWTABINDEX] AS NVARCHAR(MAX)),
			CAST([inserted].[NEWTABINDEX] AS NVARCHAR(MAX)),
			'Address (' + [inserted].[DEFAULTLABEL] + ')',
			'110D27F8-B93A-4A9B-B2BE-A80970FDE72B',
			2,
			1,
			[inserted].[DEFAULTLABEL]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[ADDRESSLAYOUTSETUPID] = [inserted].[ADDRESSLAYOUTSETUPID]			
	WHERE	[deleted].[NEWTABINDEX] <> [inserted].[NEWTABINDEX]
	UNION ALL

	SELECT 
			[inserted].[ADDRESSLAYOUTSETUPID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Hide Flag',
			CASE [deleted].[ISHIDE] WHEN 1 THEN 'Yes' ELSE 'No' END,
			CASE [inserted].[ISHIDE] WHEN 1 THEN 'Yes' ELSE 'No' END,
			'Address (' + [inserted].[DEFAULTLABEL] + ')',
			'110D27F8-B93A-4A9B-B2BE-A80970FDE72B',
			2,
			1,
			[inserted].[DEFAULTLABEL]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[ADDRESSLAYOUTSETUPID] = [inserted].[ADDRESSLAYOUTSETUPID]			
	WHERE	[deleted].[ISHIDE] <> [inserted].[ISHIDE]	
END
GO

CREATE TRIGGER [dbo].[TG_ADDRESSLAYOUTSETUP_INSERT] ON [dbo].[ADDRESSLAYOUTSETUP]
   AFTER INSERT
AS 
BEGIN
	SET NOCOUNT ON;

	-- Check if LASTCHANGEDBY contains VALID User Id and it Exists in USERS table, this is in replacement to foreign key reference of ADDRESSLAYOUTSETUP table with USERS table.
	IF EXISTS (SELECT * FROM inserted 
		LEFT OUTER JOIN USERS WITH (NOLOCK) ON USERS.SUSERGUID = inserted.LASTCHANGEDBY
		WHERE inserted.LASTCHANGEDBY IS NOT NULL AND USERS.SUSERGUID IS NULL)
	BEGIN		
		RAISERROR ('The INSERT or UPDATE statement conflicted with the FOREIGN KEY to table USERS', 16, 0);
		ROLLBACK;
		RETURN;
	END

	INSERT INTO [HISTORYSYSTEMSETUP]
    (
        [ID],
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
        [inserted].[ADDRESSLAYOUTSETUPID], 
        [inserted].[ROWVERSION],
        GETUTCDATE(),
        [inserted].[LASTCHANGEDBY],
        'Address Added',
        '',
        '',
        'Address (' + [inserted].[DEFAULTLABEL] + ')',
		'110D27F8-B93A-4A9B-B2BE-A80970FDE72B',
		1,
		1,
		[inserted].[DEFAULTLABEL]
	FROM [inserted] 
END
GO

CREATE TRIGGER [dbo].[TG_ADDRESSLAYOUTSETUP_DELETE] ON  [dbo].[ADDRESSLAYOUTSETUP]
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
			[deleted].[ADDRESSLAYOUTSETUPID],
			[deleted].[ROWVERSION],
			GETUTCDATE(),
			(SELECT dbo.UFN_GET_USERID_FROM_CONTEXT_INFO()),
			'Address Deleted',
			'',
			'',
			'Address (' + [deleted].[DEFAULTLABEL] + ')',
			'110D27F8-B93A-4A9B-B2BE-A80970FDE72B',
			3,
			1,
			[deleted].[DEFAULTLABEL]
	FROM	[deleted]
END