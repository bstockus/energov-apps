CREATE TABLE [dbo].[CUSTOMFIELDTABLE] (
    [CUSTOMFIELDTABLEID] CHAR (36)     NOT NULL,
    [NAME]               NVARCHAR (50) NOT NULL,
    [REQUIRED]           BIT           DEFAULT ((0)) NOT NULL,
    [DEFAULTROWNUM]      INT           DEFAULT ((0)) NOT NULL,
    [TOOLTIP]            VARCHAR (MAX) NULL,
    [SHOWONMOBILE]       BIT           DEFAULT ((0)) NOT NULL,
    [ISEDITINMOBILE]     BIT           DEFAULT ((0)) NOT NULL,
    [LASTCHANGEDBY]      CHAR (36)     NULL,
    [LASTCHANGEDON]      DATETIME      CONSTRAINT [DF_CUSTOMFIELDTABLE_LastChangedOn] DEFAULT (getutcdate()) NOT NULL,
    [ROWVERSION]         INT           CONSTRAINT [DF_CUSTOMFIELDTABLE_RowVersion] DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_CUSTOMFIELDTABLE] PRIMARY KEY CLUSTERED ([CUSTOMFIELDTABLEID] ASC) WITH (FILLFACTOR = 90)
);


GO


CREATE TRIGGER [dbo].[TG_CUSTOMFIELDTABLE_DELETE] ON [dbo].[CUSTOMFIELDTABLE]
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
        [deleted].[CUSTOMFIELDTABLEID], 
        [deleted].[ROWVERSION],
        GETUTCDATE(),
		(SELECT dbo.UFN_GET_USERID_FROM_CONTEXT_INFO()),	
        'Custom Field Table Deleted',
        '',
        '',       
		'Custom Field Table (' + [deleted].[NAME] + ')',
		'490AC525-36DE-475D-8951-13C1F7066C51',
		3,
		1,
		[deleted].[NAME]
	FROM	[deleted]
END
GO

CREATE TRIGGER [dbo].[TG_CUSTOMFIELDTABLE_UPDATE] ON [dbo].[CUSTOMFIELDTABLE] 
	AFTER UPDATE
AS 
BEGIN
	SET NOCOUNT ON;
		
	-- Check if LASTCHANGEDBY contains VALID User Id and it Exists in USERS table, this is in replacement to foreign key reference of CUSTOMFIELDTABLE table with USERS table.
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
			[inserted].[CUSTOMFIELDTABLEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Name',
			[deleted].[NAME],
			[inserted].[NAME],
			'Custom Field Table (' + [inserted].[NAME] + ')',
			'490AC525-36DE-475D-8951-13C1F7066C51',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[CUSTOMFIELDTABLEID] = [inserted].[CUSTOMFIELDTABLEID]
	WHERE	[deleted].[NAME] <> [inserted].[NAME]
	
	UNION ALL
	SELECT
			[inserted].[CUSTOMFIELDTABLEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Required Flag',
			CASE [deleted].[REQUIRED] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' END,
			CASE [inserted].[REQUIRED] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' END,
			'Custom Field Table (' + [inserted].[NAME] + ')',
			'490AC525-36DE-475D-8951-13C1F7066C51',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[CUSTOMFIELDTABLEID] = [inserted].[CUSTOMFIELDTABLEID]
	WHERE	[deleted].[REQUIRED] <> [inserted].[REQUIRED]

	UNION ALL
	SELECT
			[inserted].[CUSTOMFIELDTABLEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Show On Mobile Flag',
			CASE [deleted].[SHOWONMOBILE] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' END,
			CASE [inserted].[SHOWONMOBILE] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' END,
			'Custom Field Table (' + [inserted].[NAME] + ')',
			'490AC525-36DE-475D-8951-13C1F7066C51',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[CUSTOMFIELDTABLEID] = [inserted].[CUSTOMFIELDTABLEID]
	WHERE	[deleted].[SHOWONMOBILE] <> [inserted].[SHOWONMOBILE]

	UNION ALL
	SELECT
			[inserted].[CUSTOMFIELDTABLEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Is Edit In Mobile Flag',
			CASE [deleted].[ISEDITINMOBILE] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' END,
			CASE [inserted].[ISEDITINMOBILE] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' END,
			'Custom Field Table (' + [inserted].[NAME] + ')',
			'490AC525-36DE-475D-8951-13C1F7066C51',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[CUSTOMFIELDTABLEID] = [inserted].[CUSTOMFIELDTABLEID]
	WHERE	[deleted].[ISEDITINMOBILE] <> [inserted].[ISEDITINMOBILE]

	UNION ALL
	SELECT
			[inserted].[CUSTOMFIELDTABLEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Tool Tip',
			ISNULL([deleted].[TOOLTIP],'[none]'),
			ISNULL([inserted].[TOOLTIP],'[none]'),
			'Custom Field Table (' + [inserted].[NAME] + ')',
			'490AC525-36DE-475D-8951-13C1F7066C51',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[CUSTOMFIELDTABLEID] = [inserted].[CUSTOMFIELDTABLEID]
	WHERE	ISNULL([deleted].[TOOLTIP],'') <> ISNULL( [inserted].[TOOLTIP],'')

	UNION ALL
	SELECT
			[inserted].[CUSTOMFIELDTABLEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Default Row Number',
			CONVERT(NVARCHAR(MAX), [deleted].[DEFAULTROWNUM]),
			CONVERT(NVARCHAR(MAX),[inserted].[DEFAULTROWNUM]),
			'Custom Field Table (' + [inserted].[NAME] + ')',
			'490AC525-36DE-475D-8951-13C1F7066C51',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[CUSTOMFIELDTABLEID] = [inserted].[CUSTOMFIELDTABLEID]
	WHERE	[deleted].[DEFAULTROWNUM] <> [inserted].[DEFAULTROWNUM]
	
END
GO
CREATE TRIGGER [dbo].[TG_CUSTOMFIELDTABLE_INSERT] ON  [dbo].[CUSTOMFIELDTABLE]
   AFTER INSERT
AS 
BEGIN	
	SET NOCOUNT ON;	
	-- Check if LASTCHANGEDBY contains VALID User Id and it Exists in USERS table, this is in replacement to foreign key reference of CUSTOMFIELDTABLE table with USERS table.
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
        [inserted].[CUSTOMFIELDTABLEID], 
        [inserted].[ROWVERSION],
        GETUTCDATE(),
        [inserted].[LASTCHANGEDBY],	
        'Custom Field Table Added',
        '',
        '',       
		'Custom Field Table (' + [inserted].[NAME] + ')',
		'490AC525-36DE-475D-8951-13C1F7066C51',
		1,
		1,
		[inserted].[NAME]
    FROM [inserted]
END