CREATE TABLE [dbo].[IPCAPITALPROJECT] (
    [IPCAPITALPROJECTID] CHAR (36)      NOT NULL,
    [NAME]               NVARCHAR (100) NOT NULL,
    [DESCRIPTION]        NVARCHAR (MAX) NULL,
    [ACTIVE]             BIT            NOT NULL,
    [LASTCHANGEDBY]      CHAR (36)      NULL,
    [LASTCHANGEDON]      DATETIME       CONSTRAINT [DF_IPCAPITALPROJECT_LastChangedOn] DEFAULT (getutcdate()) NOT NULL,
    [ROWVERSION]         INT            CONSTRAINT [DF_IPCAPITALPROJECT_RowVersion] DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_IPCAPITALPROJECT] PRIMARY KEY CLUSTERED ([IPCAPITALPROJECTID] ASC) WITH (FILLFACTOR = 90)
);


GO
CREATE NONCLUSTERED INDEX [IPCAPITALPROJECT_IX_QUERY]
    ON [dbo].[IPCAPITALPROJECT]([IPCAPITALPROJECTID] ASC, [NAME] ASC);


GO

CREATE TRIGGER [dbo].[TG_IPCAPITALPROJECT_UPDATE] ON  [dbo].[IPCAPITALPROJECT]
   AFTER UPDATE
AS 
BEGIN	
	SET NOCOUNT ON;

	-- Check if LASTCHANGEDBY contains VALID User Id and it Exists in USERS table, this is in replacement to foreign key reference of IPCAPITALPROJECT table with USERS table.
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
			[inserted].[IPCAPITALPROJECTID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Name',
			[deleted].[NAME],
			[inserted].[NAME],
			'Capital Project (' + [inserted].[NAME] + ')',
			'EF3CE42D-B6BE-4E40-B1ED-4DAA1F186DDB',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[IPCAPITALPROJECTID] = [inserted].[IPCAPITALPROJECTID]
	WHERE	[deleted].[NAME] <> [inserted].[NAME]
	UNION ALL
	SELECT
			[inserted].[IPCAPITALPROJECTID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Description',
			ISNULL([deleted].[DESCRIPTION],'[none]'),
			ISNULL([inserted].[DESCRIPTION],'[none]'),
			'Capital Project (' + [inserted].[NAME] + ')',
			'EF3CE42D-B6BE-4E40-B1ED-4DAA1F186DDB',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[IPCAPITALPROJECTID] = [inserted].[IPCAPITALPROJECTID]
	WHERE	ISNULL([deleted].[DESCRIPTION],'') <> ISNULL([inserted].[DESCRIPTION],'')
	UNION ALL
	SELECT
			[inserted].[IPCAPITALPROJECTID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Active Flag',
			CASE [deleted].[ACTIVE] WHEN 1 THEN 'Yes' ELSE 'No' END,
			CASE [inserted].[ACTIVE] WHEN 1 THEN 'Yes' ELSE 'No' END,
			'Capital Project (' + [inserted].[NAME] + ')',
			'EF3CE42D-B6BE-4E40-B1ED-4DAA1F186DDB',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[IPCAPITALPROJECTID] = [inserted].[IPCAPITALPROJECTID]
	WHERE	[deleted].[ACTIVE] <> [inserted].[ACTIVE]
END
GO

CREATE TRIGGER [dbo].[TG_IPCAPITALPROJECT_INSERT] ON [dbo].[IPCAPITALPROJECT]
   AFTER INSERT
AS 
BEGIN
	SET NOCOUNT ON;

	-- Check if LASTCHANGEDBY contains VALID User Id and it Exists in USERS table, this is in replacement to foreign key reference of IPCAPITALPROJECT table with USERS table.
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
        [inserted].[IPCAPITALPROJECTID], 
        [inserted].[ROWVERSION],
        GETUTCDATE(),
        [inserted].[LASTCHANGEDBY],
        'Capital Project Added',
        '',
        '',
        'Capital Project (' + [inserted].[NAME] + ')',
		'EF3CE42D-B6BE-4E40-B1ED-4DAA1F186DDB',
		1,
		1,
		[inserted].[NAME]
    FROM [inserted] 
END
GO

CREATE TRIGGER [dbo].[TG_IPCAPITALPROJECT_DELETE] ON  [dbo].[IPCAPITALPROJECT]
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
			[deleted].[IPCAPITALPROJECTID],
			[deleted].[ROWVERSION],
			GETUTCDATE(),
			(SELECT dbo.UFN_GET_USERID_FROM_CONTEXT_INFO()),
			'Capital Project Deleted',
			'',
			'',
			'Capital Project (' + [deleted].[NAME] + ')',
			'EF3CE42D-B6BE-4E40-B1ED-4DAA1F186DDB',
			3,
			1,
			[deleted].[NAME]	
	FROM	[deleted]
END