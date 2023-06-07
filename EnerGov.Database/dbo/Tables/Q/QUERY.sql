CREATE TABLE [dbo].[QUERY] (
    [QUERYID]        CHAR (36)      NOT NULL,
    [NAME]           NVARCHAR (100) NOT NULL,
    [DESCRIPTION]    NVARCHAR (MAX) NULL,
    [PRIORITY]       INT            NOT NULL,
    [ISENABLED]      BIT            NOT NULL,
    [MODULEID]       INT            NOT NULL,
    [QUERYBUILDERID] CHAR (36)      NOT NULL,
    [LASTCHANGEDON]  DATETIME       CONSTRAINT [DF_QUERY_LastChangedOn] DEFAULT (getutcdate()) NOT NULL,
    [LASTCHANGEDBY]  CHAR (36)      NULL,
    [ROWVERSION]     INT            CONSTRAINT [DF_QUERY_RowVersion] DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_QUERY] PRIMARY KEY CLUSTERED ([QUERYID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_QUERY_QUERYBUILDER] FOREIGN KEY ([QUERYBUILDERID]) REFERENCES [dbo].[QUERYBUILDER] ([QUERYBUILDERID]),
    CONSTRAINT [FK_QUERY_SYSTEMMODULE] FOREIGN KEY ([MODULEID]) REFERENCES [dbo].[SYSTEMMODULE] ([SYSTEMMODULEID])
);


GO
CREATE NONCLUSTERED INDEX [QUERY_MODULEID]
    ON [dbo].[QUERY]([MODULEID] ASC);


GO
CREATE NONCLUSTERED INDEX [QUERY_QUERYBUILDERID]
    ON [dbo].[QUERY]([QUERYBUILDERID] ASC);


GO

CREATE TRIGGER [dbo].[TG_QUERY_INSERT]
   ON  [dbo].[QUERY]
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
        [inserted].[QUERYID], 
        [inserted].[ROWVERSION],
        GETUTCDATE(),
        [inserted].[LASTCHANGEDBY],	
        'Intelligent Query Action Added',
        '',
        '',       
		'Intelligent Query Action (' + [inserted].[NAME] + ')',
		'C08776DA-046E-4E9B-9DE4-4CC2005A98CD',
		1,
		1,
		[inserted].[NAME]
    FROM [inserted]
END
GO
CREATE TRIGGER [dbo].[TG_QUERY_UPDATE] 
	ON [dbo].[QUERY]
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
			[inserted].[QUERYID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'IQ Action Set Name',
			[deleted].[NAME],
			[inserted].[NAME],
			'Intelligent Query Action (' + [inserted].[NAME] + ')',
			'C08776DA-046E-4E9B-9DE4-4CC2005A98CD',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			INNER JOIN [inserted] ON [deleted].[QUERYID] = [inserted].[QUERYID]
	WHERE	[deleted].[NAME] <> [inserted].[NAME]

	UNION ALL
	SELECT
			[inserted].[QUERYID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Description',
			ISNULL([deleted].[DESCRIPTION],'[none]'),
			ISNULL([inserted].[DESCRIPTION],'[none]'),
			'Intelligent Query Action (' + [inserted].[NAME] + ')',
			'C08776DA-046E-4E9B-9DE4-4CC2005A98CD',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			INNER JOIN [inserted] ON [deleted].[QUERYID] = [inserted].[QUERYID]
	WHERE	ISNULL([deleted].[DESCRIPTION],'') <> ISNULL([inserted].[DESCRIPTION],'')

	UNION ALL
	SELECT
			[inserted].[QUERYID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Priority',
			CONVERT(NVARCHAR(MAX), [deleted].[PRIORITY]),
			CONVERT(NVARCHAR(MAX), [inserted].[PRIORITY]),
			'Intelligent Query Action (' + [inserted].[NAME] + ')',
			'C08776DA-046E-4E9B-9DE4-4CC2005A98CD',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			INNER JOIN [inserted] ON [deleted].[QUERYID] = [inserted].[QUERYID]
	WHERE	[deleted].[PRIORITY] <> [inserted].[PRIORITY]

	UNION ALL
	SELECT
			[inserted].[QUERYID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Enabled',
			CASE [deleted].[ISENABLED]  WHEN 1 THEN 'Yes' ELSE 'No' END,
			CASE [inserted].[ISENABLED] WHEN 1 THEN 'Yes' ELSE 'No' END,
			'Intelligent Query Action (' + [inserted].[NAME] + ')',
			'C08776DA-046E-4E9B-9DE4-4CC2005A98CD',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			INNER JOIN [inserted] ON [deleted].[QUERYID] = [inserted].[QUERYID]
	WHERE	[deleted].[ISENABLED] <>  [inserted].[ISENABLED]

	UNION ALL
	SELECT
			[inserted].[QUERYID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Module',
			ISNULL(DELETESYSTEMMODULE.[MODULENAME],'[none]'),
			ISNULL(INSERTSYSTEMMODULE.[MODULENAME],'[none]'),
			'Intelligent Query Action (' + [inserted].[NAME] + ')',
			'C08776DA-046E-4E9B-9DE4-4CC2005A98CD',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			INNER JOIN [inserted] ON [deleted].[QUERYID] = [inserted].[QUERYID]
			INNER JOIN [SYSTEMMODULE] AS DELETESYSTEMMODULE WITH (NOLOCK) ON DELETESYSTEMMODULE.[SYSTEMMODULEID] = [deleted].[MODULEID]
			INNER JOIN [SYSTEMMODULE] AS INSERTSYSTEMMODULE WITH (NOLOCK) ON INSERTSYSTEMMODULE.[SYSTEMMODULEID] = [inserted].[MODULEID]
	WHERE	[deleted].[MODULEID] <>  [inserted].[MODULEID]

	UNION ALL
	SELECT
			[inserted].[QUERYID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Query',
			DELETESYQUERYBUILDER.[NAME],
			INSERTSYQUERYBUILDER.[NAME],
			'Intelligent Query Action (' + [inserted].[NAME] + ')',
			'C08776DA-046E-4E9B-9DE4-4CC2005A98CD',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			INNER JOIN [inserted] ON [deleted].[QUERYID] = [inserted].[QUERYID]
			INNER JOIN [QUERYBUILDER] AS DELETESYQUERYBUILDER WITH (NOLOCK) ON DELETESYQUERYBUILDER.[QUERYBUILDERID] = [deleted].[QUERYBUILDERID]
			INNER JOIN [QUERYBUILDER] AS INSERTSYQUERYBUILDER WITH (NOLOCK) ON INSERTSYQUERYBUILDER.[QUERYBUILDERID] = [inserted].[QUERYBUILDERID]
	WHERE	[deleted].[QUERYBUILDERID] <>  [inserted].[QUERYBUILDERID]
END
GO

CREATE TRIGGER [dbo].[TG_QUERY_DELETE] 
	ON [dbo].[QUERY]
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
			[deleted].[QUERYID],
			[deleted].[ROWVERSION],
			GETUTCDATE(),
			(SELECT dbo.UFN_GET_USERID_FROM_CONTEXT_INFO()),
			'Intelligent Query Action Deleted',
			'',
			'',
			'Intelligent Query Action (' + [deleted].[NAME] + ')',
			'C08776DA-046E-4E9B-9DE4-4CC2005A98CD',
			3,
			1,
			[deleted].[NAME]
	FROM	[deleted]
END