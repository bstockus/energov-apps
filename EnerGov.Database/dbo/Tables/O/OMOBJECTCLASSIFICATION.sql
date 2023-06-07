CREATE TABLE [dbo].[OMOBJECTCLASSIFICATION] (
    [OMOBJECTCLASSIFICATIONID] CHAR (36)      NOT NULL,
    [NAME]                     NVARCHAR (50)  NOT NULL,
    [DESCRIPTION]              NVARCHAR (MAX) NULL,
    [LASTCHANGEDBY]            CHAR (36)      NULL,
    [LASTCHANGEDON]            DATETIME       CONSTRAINT [DF_OMOBJECTCLASSIFICATION_LastChangedOn] DEFAULT (getutcdate()) NOT NULL,
    [ROWVERSION]               INT            CONSTRAINT [DF_OMOBJECTCLASSIFICATION_RowVersion] DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_OMOBJECTCLASSIFICATION] PRIMARY KEY CLUSTERED ([OMOBJECTCLASSIFICATIONID] ASC) WITH (FILLFACTOR = 90)
);


GO
CREATE NONCLUSTERED INDEX [OMOBJECTCLASSIFICATION_IX_QUERY]
    ON [dbo].[OMOBJECTCLASSIFICATION]([OMOBJECTCLASSIFICATIONID] ASC, [NAME] ASC);


GO

CREATE TRIGGER [dbo].[TG_OMOBJECTCLASSIFICATION_DELETE] ON  [dbo].[OMOBJECTCLASSIFICATION]
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
			[deleted].[OMOBJECTCLASSIFICATIONID],
			[deleted].[ROWVERSION],
			GETUTCDATE(),
			(SELECT dbo.UFN_GET_USERID_FROM_CONTEXT_INFO()),
			'Object Classification Deleted',
			'',
			'',
			'Object Classification (' + [deleted].[NAME] + ')',
			'8AD64F22-0C5E-4A23-A85C-2E7033D22FC8',
			3,
			1,
			[deleted].[NAME]
	FROM	[deleted]
END
GO

CREATE TRIGGER [dbo].[TG_OMOBJECTCLASSIFICATION_UPDATE] ON  [dbo].[OMOBJECTCLASSIFICATION]
   AFTER UPDATE
AS 
BEGIN	
	SET NOCOUNT ON;

	-- Check if LASTCHANGEDBY contains VALID User Id and it Exists in USERS table, this is in replacement to foreign key reference of OMOBJECTCLASSIFICATION table with USERS table.
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
			[inserted].[OMOBJECTCLASSIFICATIONID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Name',
			[deleted].[NAME],
			[inserted].[NAME],
			'Object Classification (' + [inserted].[NAME] + ')',
			'8AD64F22-0C5E-4A23-A85C-2E7033D22FC8',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[OMOBJECTCLASSIFICATIONID] = [inserted].[OMOBJECTCLASSIFICATIONID]
	WHERE	[deleted].[NAME] <> [inserted].[NAME]
	UNION ALL
	SELECT
			[inserted].[OMOBJECTCLASSIFICATIONID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Description',
			ISNULL([deleted].[DESCRIPTION],'[none]'),
			ISNULL([inserted].[DESCRIPTION],'[none]'),
			'Object Classification (' + [inserted].[NAME] + ')',
			'8AD64F22-0C5E-4A23-A85C-2E7033D22FC8',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[OMOBJECTCLASSIFICATIONID] = [inserted].[OMOBJECTCLASSIFICATIONID]
	WHERE	ISNULL([deleted].[DESCRIPTION],'') <> ISNULL([inserted].[DESCRIPTION],'')
END
GO


CREATE TRIGGER [dbo].[TG_OMOBJECTCLASSIFICATION_INSERT] ON [dbo].[OMOBJECTCLASSIFICATION]
   AFTER INSERT
AS 
BEGIN
	SET NOCOUNT ON;

	-- Check if LASTCHANGEDBY contains VALID User Id and it Exists in USERS table, this is in replacement to foreign key reference of OMOBJECTCLASSIFICATION table with USERS table.
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
        [inserted].[OMOBJECTCLASSIFICATIONID], 
        [inserted].[ROWVERSION],
        GETUTCDATE(),
        [inserted].[LASTCHANGEDBY],
        'Object Classification Added',
        '',
        '',
        'Object Classification (' + [inserted].[NAME] + ')',
		'8AD64F22-0C5E-4A23-A85C-2E7033D22FC8',
		1,
		1,
		[inserted].[NAME]
    FROM [inserted] 
END