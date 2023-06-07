CREATE TABLE [dbo].[QUERYBUILDER] (
    [QUERYBUILDERID] CHAR (36)      NOT NULL,
    [NAME]           NVARCHAR (100) NOT NULL,
    [DESCRIPTION]    NVARCHAR (MAX) NULL,
    [QUERYMODULEID]  INT            NOT NULL,
    [ROOTCLASSNAME]  NVARCHAR (MAX) NOT NULL,
    [QUERY]          NVARCHAR (MAX) NOT NULL,
    [SEARCHOBJECTID] CHAR (36)      NULL,
    [ISCUSTOM]       BIT            DEFAULT ((0)) NOT NULL,
    [LASTCHANGEDON]  DATETIME       CONSTRAINT [DF_QUERYBUILDER_LastChangedOn] DEFAULT (getutcdate()) NOT NULL,
    [LASTCHANGEDBY]  CHAR (36)      NULL,
    [ROWVERSION]     INT            CONSTRAINT [DF_QUERYBUILDER_RowVersion] DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_QUERYBUILDER] PRIMARY KEY CLUSTERED ([QUERYBUILDERID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_QUERYBUILDER_SYSTEMMODULE] FOREIGN KEY ([QUERYMODULEID]) REFERENCES [dbo].[SYSTEMMODULE] ([SYSTEMMODULEID])
);


GO
CREATE NONCLUSTERED INDEX [QUERYBUILDER_IX_QUERYMODULEID]
    ON [dbo].[QUERYBUILDER]([QUERYMODULEID] ASC);


GO

CREATE TRIGGER [dbo].[TG_QUERYBUILDER_INSERT] 
	ON [dbo].[QUERYBUILDER]
	AFTER INSERT
AS 
BEGIN
	SET NOCOUNT ON;
	-- Check if LASTCHANGEDBY contains VALID User Id and it Exists in USERS table, this is in replacement to foreign key reference of RPTREPORT table with USERS table.
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
			[inserted].[QUERYBUILDERID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Intelligent Query Setup Added',
			'',
			'',
			'Intelligent Query Setup (' + [inserted].[NAME] + ')',
			'D8B8FAE3-94A6-4113-BE59-73B4B890CFE7',
			1,
			1,
			[inserted].[NAME]
	FROM	[inserted]
END
GO


CREATE TRIGGER [dbo].[TG_QUERYBUILDER_UPDATE] 
	ON [dbo].[QUERYBUILDER]
    AFTER UPDATE
AS 
BEGIN
	SET NOCOUNT ON;
	-- Check if LASTCHANGEDBY contains VALID User Id and it Exists in USERS table, this is in replacement to foreign key reference of RPTREPORT table with USERS table.
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
			[inserted].[QUERYBUILDERID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Name',
			[deleted].[NAME],
			[inserted].[NAME],
			'Intelligent Query Setup (' + [inserted].[NAME] + ')',
			'D8B8FAE3-94A6-4113-BE59-73B4B890CFE7',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			INNER JOIN [inserted] ON [deleted].[QUERYBUILDERID] = [inserted].[QUERYBUILDERID]
	WHERE	[deleted].[NAME] <> [inserted].[NAME]

	UNION ALL
	SELECT
			[inserted].[QUERYBUILDERID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Description',
			ISNULL([deleted].[DESCRIPTION],'[none]'),
			ISNULL([inserted].[DESCRIPTION],'[none]'),
			'Intelligent Query Setup (' + [inserted].[NAME] + ')',
			'D8B8FAE3-94A6-4113-BE59-73B4B890CFE7',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			INNER JOIN [inserted] ON [deleted].[QUERYBUILDERID] = [inserted].[QUERYBUILDERID]
	WHERE	ISNULL([deleted].[DESCRIPTION],'') <> ISNULL([inserted].[DESCRIPTION],'')

	UNION ALL
	SELECT
			[inserted].[QUERYBUILDERID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Module',
			ISNULL(DELETESYSTEMMODULE.[MODULENAME],'[none]'),
			ISNULL(INSERTSYSTEMMODULE.[MODULENAME],'[none]'),
			'Intelligent Query Setup (' + [inserted].[NAME] + ')',
			'D8B8FAE3-94A6-4113-BE59-73B4B890CFE7',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			INNER JOIN [inserted] ON [deleted].[QUERYBUILDERID] = [inserted].[QUERYBUILDERID]
			INNER JOIN [SYSTEMMODULE] AS DELETESYSTEMMODULE WITH (NOLOCK) ON DELETESYSTEMMODULE.[SYSTEMMODULEID] = [deleted].[QUERYMODULEID]
			INNER JOIN [SYSTEMMODULE] AS INSERTSYSTEMMODULE WITH (NOLOCK) ON INSERTSYSTEMMODULE.[SYSTEMMODULEID] = [inserted].[QUERYMODULEID]
	WHERE	[deleted].[QUERYMODULEID] <> [inserted].[QUERYMODULEID]

	UNION ALL
	SELECT
			[inserted].[QUERYBUILDERID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Object Class',
			[deleted].[ROOTCLASSNAME],
			[inserted].[ROOTCLASSNAME],
			'Intelligent Query Setup (' + [inserted].[NAME] + ')',
			'D8B8FAE3-94A6-4113-BE59-73B4B890CFE7',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			INNER JOIN [inserted] ON [deleted].[QUERYBUILDERID] = [inserted].[QUERYBUILDERID]
	WHERE	[deleted].[ROOTCLASSNAME] <> [inserted].[ROOTCLASSNAME]

	UNION ALL
	SELECT
			[inserted].[QUERYBUILDERID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Query',
			[deleted].[QUERY],
			[inserted].[QUERY],
			'Intelligent Query Setup (' + [inserted].[NAME] + ')',
			'D8B8FAE3-94A6-4113-BE59-73B4B890CFE7',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			INNER JOIN [inserted] ON [deleted].[QUERYBUILDERID] = [inserted].[QUERYBUILDERID]
	WHERE	[deleted].[QUERY] <> [inserted].[QUERY]

	UNION ALL
	SELECT
			[inserted].[QUERYBUILDERID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Search Object ID',
			ISNULL([deleted].[SEARCHOBJECTID],'[none]'),
			ISNULL([inserted].[SEARCHOBJECTID],'[none]'),
			'Intelligent Query Setup (' + [inserted].[NAME] + ')',
			'D8B8FAE3-94A6-4113-BE59-73B4B890CFE7',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			INNER JOIN [inserted] ON [deleted].[QUERYBUILDERID] = [inserted].[QUERYBUILDERID]
	WHERE	ISNULL([deleted].[SEARCHOBJECTID],'') <> ISNULL([inserted].[SEARCHOBJECTID],'')

	UNION ALL
	SELECT
			[inserted].[QUERYBUILDERID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Custom Query',
			CASE [deleted].[ISCUSTOM]  WHEN 1 THEN 'Yes' ELSE 'No' END,
			CASE [inserted].[ISCUSTOM] WHEN 1 THEN 'Yes' ELSE 'No' END,
			'Intelligent Query Setup (' + [inserted].[NAME] + ')',
			'D8B8FAE3-94A6-4113-BE59-73B4B890CFE7',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			INNER JOIN [inserted] ON [deleted].[QUERYBUILDERID] = [inserted].[QUERYBUILDERID]
	WHERE	[deleted].[ISCUSTOM] <> [inserted].[ISCUSTOM]
END
GO

CREATE TRIGGER [dbo].[TG_QUERYBUILDER_DELETE] 
	ON [dbo].[QUERYBUILDER]
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
			[deleted].[QUERYBUILDERID],
			[deleted].[ROWVERSION],
			GETUTCDATE(),
			(SELECT dbo.UFN_GET_USERID_FROM_CONTEXT_INFO()),
			'Intelligent Query Setup Deleted',
			'',
			'',
			'Intelligent Query Setup (' + [deleted].[NAME] + ')',
			'D8B8FAE3-94A6-4113-BE59-73B4B890CFE7',
			3,
			1,
			[deleted].[NAME]
	FROM	[deleted]
END