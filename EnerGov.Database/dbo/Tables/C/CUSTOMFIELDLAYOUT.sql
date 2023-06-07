CREATE TABLE [dbo].[CUSTOMFIELDLAYOUT] (
    [GCUSTOMFIELDLAYOUTS] CHAR (36)    NOT NULL,
    [SNAME]               VARCHAR (50) NOT NULL,
    [CUSTOMFIELDMODULEID] INT          CONSTRAINT [DF_CustomFieldLayout_CustomFieldModuleId] DEFAULT ((2)) NOT NULL,
    [WIDTH]               INT          CONSTRAINT [DF_CustomFieldLayout_Width] DEFAULT ((0)) NOT NULL,
    [HEIGHT]              INT          CONSTRAINT [DF_CustomFieldLayout_Height] DEFAULT ((0)) NOT NULL,
    [ISVERSION2]          BIT          DEFAULT ((0)) NOT NULL,
    [LASTCHANGEDBY]       CHAR (36)    NULL,
    [LASTCHANGEDON]       DATETIME     CONSTRAINT [DF_CUSTOMFIELDLAYOUT_LASTCHANGEDON] DEFAULT (getutcdate()) NOT NULL,
    [ROWVERSION]          INT          CONSTRAINT [DF_CUSTOMFIELDLAYOUT_ROWVERSION] DEFAULT ((1)) NOT NULL,
    [ISHTMLEXPERIENCE]    BIT          DEFAULT ((0)) NOT NULL,
    [NUMBEROFCOLUMNS]     INT          CONSTRAINT [DF_CustomFieldLayout_NumberOfColumns] DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_CustomFieldLayouts] PRIMARY KEY CLUSTERED ([GCUSTOMFIELDLAYOUTS] ASC) WITH (FILLFACTOR = 80),
    CONSTRAINT [FK_CustomFieldLayout_CustomFie] FOREIGN KEY ([CUSTOMFIELDMODULEID]) REFERENCES [dbo].[CUSTOMFIELDMODULES] ([CUSTOMFIELDMODULEID])
);


GO

CREATE TRIGGER [TG_CUSTOMFIELDLAYOUT_UPDATE] ON CUSTOMFIELDLAYOUT
   AFTER UPDATE
AS 
BEGIN
	SET NOCOUNT ON;
	-- Check if LASTCHANGEDBY contains VALID User Id and it Exists in USERS table, this is in replacement to foreign key reference with USERS table.
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
			[inserted].[GCUSTOMFIELDLAYOUTS],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Name',
			[deleted].[SNAME],
			[inserted].[SNAME],
			'Custom Field Layout (' + [inserted].[SNAME] + ')',
			'CCD23415-9668-462D-AFCC-3794BBAB9ADB',
			2,
			1,
			[inserted].[SNAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[GCUSTOMFIELDLAYOUTS] = [inserted].[GCUSTOMFIELDLAYOUTS]
	WHERE	[deleted].[SNAME] <> [inserted].[SNAME]
	UNION ALL
	SELECT
			[inserted].[GCUSTOMFIELDLAYOUTS],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Module',
			OLD_MODULE.MODULENAME,
			NEW_MODULE.MODULENAME,
			'Custom Field Layout (' + [inserted].[SNAME] + ')',
			'CCD23415-9668-462D-AFCC-3794BBAB9ADB',
			2,
			1,
			[inserted].[SNAME]
	FROM	[deleted]
			INNER JOIN [inserted] ON [deleted].[GCUSTOMFIELDLAYOUTS] = [inserted].[GCUSTOMFIELDLAYOUTS]
			INNER JOIN [dbo].[CUSTOMFIELDMODULES] AS OLD_MODULE ON  OLD_MODULE.[CUSTOMFIELDMODULEID] = [deleted].[CUSTOMFIELDMODULEID]
			INNER JOIN [dbo].[CUSTOMFIELDMODULES] AS NEW_MODULE ON  NEW_MODULE.[CUSTOMFIELDMODULEID] = [inserted].[CUSTOMFIELDMODULEID]
	WHERE	([deleted].[CUSTOMFIELDMODULEID] <> [inserted].[CUSTOMFIELDMODULEID])
	UNION ALL
		SELECT
			[inserted].[GCUSTOMFIELDLAYOUTS],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Width',
			CAST ([deleted].[WIDTH] AS NVARCHAR(MAX)),
			CAST ([inserted].[WIDTH] AS NVARCHAR(MAX)),
			'Custom Field Layout (' + [inserted].[SNAME] + ')',
			'CCD23415-9668-462D-AFCC-3794BBAB9ADB',
			2,
			1,
			[inserted].[SNAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[GCUSTOMFIELDLAYOUTS] = [inserted].[GCUSTOMFIELDLAYOUTS]
	WHERE	[deleted].[WIDTH] <> [inserted].[WIDTH]
	UNION ALL
		SELECT
			[inserted].[GCUSTOMFIELDLAYOUTS],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Height',
			CAST ([deleted].[HEIGHT] AS NVARCHAR(MAX)),
			CAST ([inserted].[HEIGHT] AS NVARCHAR(MAX)),
			'Custom Field Layout (' + [inserted].[SNAME] + ')',
			'CCD23415-9668-462D-AFCC-3794BBAB9ADB',
			2,
			1,
			[inserted].[SNAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[GCUSTOMFIELDLAYOUTS] = [inserted].[GCUSTOMFIELDLAYOUTS]
	WHERE	[deleted].[HEIGHT] <> [inserted].[HEIGHT]
	UNION ALL
	SELECT
			[inserted].[GCUSTOMFIELDLAYOUTS],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Is Version 2 Flag',
			CASE [deleted].[ISVERSION2] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' END,
			CASE [inserted].[ISVERSION2] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' END,
			'Custom Field Layout (' + [inserted].[SNAME] + ')',
			'CCD23415-9668-462D-AFCC-3794BBAB9ADB',
			2,
			1,
			[inserted].[SNAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[GCUSTOMFIELDLAYOUTS] = [inserted].[GCUSTOMFIELDLAYOUTS]
	WHERE	([deleted].[ISVERSION2] <> [inserted].[ISVERSION2])

    UNION ALL
    SELECT 
			[inserted].[GCUSTOMFIELDLAYOUTS],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Number of Columns',
			CAST([deleted].[NUMBEROFCOLUMNS] AS NVARCHAR(MAX)),
			CAST([inserted].[NUMBEROFCOLUMNS] AS NVARCHAR(MAX)),
			'Custom Field Layout (' + [inserted].[SNAME] + ')',
			'CCD23415-9668-462D-AFCC-3794BBAB9ADB',
			2,
			1,
			[inserted].[SNAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[GCUSTOMFIELDLAYOUTS] = [inserted].[GCUSTOMFIELDLAYOUTS]
	WHERE	[deleted].[NUMBEROFCOLUMNS] <> [inserted].[NUMBEROFCOLUMNS]

	UNION ALL

	SELECT
			[inserted].[GCUSTOMFIELDLAYOUTS],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Is Html Experience Flag',
			CASE [deleted].[ISHTMLEXPERIENCE] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' END,
			CASE [inserted].[ISHTMLEXPERIENCE] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' END,
			'Custom Field Layout (' + [inserted].[SNAME] + ')',
			'CCD23415-9668-462D-AFCC-3794BBAB9ADB',
			2,
			1,
			[inserted].[SNAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[GCUSTOMFIELDLAYOUTS] = [inserted].[GCUSTOMFIELDLAYOUTS]
	WHERE	([deleted].[ISHTMLEXPERIENCE] <> [inserted].[ISHTMLEXPERIENCE])
	
END
GO

CREATE TRIGGER [TG_CUSTOMFIELDLAYOUT_INSERT] ON CUSTOMFIELDLAYOUT
   FOR INSERT
AS 
BEGIN
	SET NOCOUNT ON;
	-- Check if LASTCHANGEDBY contains VALID User Id and it Exists in USERS table, this is in replacement to foreign key reference with USERS table.
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
			[inserted].[GCUSTOMFIELDLAYOUTS],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Custom Field Layout Added',
			'',
			'',
			'Custom Field Layout (' + [inserted].[SNAME] + ')',
			'CCD23415-9668-462D-AFCC-3794BBAB9ADB',
			1,
			1,
			[inserted].[SNAME]
	FROM	[inserted]	
END
GO


CREATE TRIGGER [TG_CUSTOMFIELDLAYOUT_DELETE] ON CUSTOMFIELDLAYOUT
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
			[deleted].[GCUSTOMFIELDLAYOUTS],
			[deleted].[ROWVERSION],
			GETUTCDATE(),
			(SELECT dbo.UFN_GET_USERID_FROM_CONTEXT_INFO()),
			'Custom Field Layout Deleted',
			'',
			'',
			'Custom Field Layout (' + [deleted].[SNAME] + ')',
			'CCD23415-9668-462D-AFCC-3794BBAB9ADB',
			3,
			1,
			[deleted].[SNAME]
	FROM	[deleted]
END