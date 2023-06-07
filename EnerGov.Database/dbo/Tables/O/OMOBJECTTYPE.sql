CREATE TABLE [dbo].[OMOBJECTTYPE] (
    [OMOBJECTTYPEID]        CHAR (36)      NOT NULL,
    [PREFIX]                NVARCHAR (10)  NULL,
    [NAME]                  NVARCHAR (50)  NOT NULL,
    [DESCRIPTION]           NVARCHAR (MAX) NULL,
    [AUTONUMBER]            BIT            NOT NULL,
    [DEFAULTOBJECTSTATUSID] CHAR (36)      NULL,
    [ACTIVE]                BIT            NOT NULL,
    [LASTCHANGEDBY]         CHAR (36)      NULL,
    [LASTCHANGEDON]         DATETIME       CONSTRAINT [DF_OMOBJECTTYPE_LastChangedOn] DEFAULT (getutcdate()) NOT NULL,
    [ROWVERSION]            INT            CONSTRAINT [DF_OMOBJECTTYPE_RowVersion] DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_OMOBJECTTYPE] PRIMARY KEY CLUSTERED ([OMOBJECTTYPEID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_OMOBJECTTYPE_OMOBJECTSTATUS] FOREIGN KEY ([DEFAULTOBJECTSTATUSID]) REFERENCES [dbo].[OMOBJECTSTATUS] ([OMOBJECTSTATUSID])
);


GO
CREATE NONCLUSTERED INDEX [OMOBJECTTYPE_IX_QUERY]
    ON [dbo].[OMOBJECTTYPE]([OMOBJECTTYPEID] ASC, [NAME] ASC);


GO

CREATE TRIGGER [dbo].[TG_OMOBJECTTYPE_DELETE] ON  [dbo].[OMOBJECTTYPE]
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
			[deleted].[OMOBJECTTYPEID],
			[deleted].[ROWVERSION],
			GETUTCDATE(),
			(SELECT dbo.UFN_GET_USERID_FROM_CONTEXT_INFO()),
			'Object Type Deleted',
			'',
			'',
			'Object Type (' + [deleted].[NAME] + ')',
			'95F19699-6655-4399-ACC3-CF4EE9043E4F',
			3,
			1,
			[deleted].[NAME]
	FROM	[deleted]
END
GO

CREATE TRIGGER [dbo].[TG_OMOBJECTTYPE_INSERT] ON [dbo].[OMOBJECTTYPE]
   AFTER INSERT
AS 
BEGIN
	SET NOCOUNT ON;

	-- Check if LASTCHANGEDBY contains VALID User Id and it Exists in USERS table, this is in replacement to foreign key reference of OMOBJECTTYPE table with USERS table.
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
        [inserted].[OMOBJECTTYPEID], 
        [inserted].[ROWVERSION],
        GETUTCDATE(),
        [inserted].[LASTCHANGEDBY],
        'Object Type Added',
        '',
        '',
        'Object Type (' + [inserted].[NAME] + ')',
		'95F19699-6655-4399-ACC3-CF4EE9043E4F',
		1,
		1,
		[inserted].[NAME]
    FROM [inserted] 
END
GO

CREATE TRIGGER [dbo].[TG_OMOBJECTTYPE_UPDATE] ON  [dbo].[OMOBJECTTYPE]
   AFTER UPDATE
AS 
BEGIN	
	SET NOCOUNT ON;

	-- Check if LASTCHANGEDBY contains VALID User Id and it Exists in USERS table, this is in replacement to foreign key reference of OMOBJECTTYPE table with USERS table.
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
			[inserted].[OMOBJECTTYPEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Name',
			[deleted].[NAME],
			[inserted].[NAME],
			'Object Type (' + [inserted].[NAME] + ')',
			'95F19699-6655-4399-ACC3-CF4EE9043E4F',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[OMOBJECTTYPEID] = [inserted].[OMOBJECTTYPEID]
	WHERE	[deleted].[NAME] <> [inserted].[NAME]
	UNION ALL

	SELECT
			[inserted].[OMOBJECTTYPEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Description',
			ISNULL([deleted].[DESCRIPTION],'[none]'),
			ISNULL([inserted].[DESCRIPTION],'[none]'),
			'Object Type (' + [inserted].[NAME] + ')',
			'95F19699-6655-4399-ACC3-CF4EE9043E4F',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[OMOBJECTTYPEID] = [inserted].[OMOBJECTTYPEID]
	WHERE	ISNULL([deleted].[DESCRIPTION],'') <> ISNULL([inserted].[DESCRIPTION],'')
	UNION ALL

	SELECT
			[inserted].[OMOBJECTTYPEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Prefix',
			ISNULL([deleted].[PREFIX],'[none]'),
			ISNULL([inserted].[PREFIX],'[none]'),
			'Object Type (' + [inserted].[NAME] + ')',
			'95F19699-6655-4399-ACC3-CF4EE9043E4F',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[OMOBJECTTYPEID] = [inserted].[OMOBJECTTYPEID]
	WHERE	ISNULL([deleted].[PREFIX],'') <> ISNULL([inserted].[PREFIX],'')
	UNION ALL

	SELECT
			[inserted].[OMOBJECTTYPEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Default Status',
			ISNULL([OMOBJECTSTATUS_DELETED].[NAME],'[none]'),
			ISNULL([OMOBJECTSTATUS_INSERTED].[NAME],'[none]'),
			'Object Type (' + [inserted].[NAME] + ')',
			'95F19699-6655-4399-ACC3-CF4EE9043E4F',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[OMOBJECTTYPEID] = [inserted].[OMOBJECTTYPEID]
			LEFT JOIN [OMOBJECTSTATUS] OMOBJECTSTATUS_INSERTED WITH (NOLOCK) ON [OMOBJECTSTATUS_INSERTED].[OMOBJECTSTATUSID] = [inserted].[DEFAULTOBJECTSTATUSID]
			LEFT JOIN [OMOBJECTSTATUS] OMOBJECTSTATUS_DELETED WITH (NOLOCK) ON [OMOBJECTSTATUS_DELETED].[OMOBJECTSTATUSID] = [deleted].[DEFAULTOBJECTSTATUSID]
	WHERE	ISNULL([deleted].[DEFAULTOBJECTSTATUSID], '') <> ISNULL([inserted].[DEFAULTOBJECTSTATUSID], '')
	UNION ALL

	SELECT
			[inserted].[OMOBJECTTYPEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Active Flag',
			CASE [deleted].[ACTIVE] WHEN 1 THEN 'Yes' ELSE 'No' END,
			CASE [inserted].[ACTIVE] WHEN 1 THEN 'Yes' ELSE 'No' END,
			'Object Type (' + [inserted].[NAME] + ')',
			'95F19699-6655-4399-ACC3-CF4EE9043E4F',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[OMOBJECTTYPEID] = [inserted].[OMOBJECTTYPEID]
	WHERE	[deleted].[ACTIVE] <> [inserted].[ACTIVE]
	UNION ALL

	SELECT
			[inserted].[OMOBJECTTYPEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Autonumber Flag',
			CASE [deleted].[AUTONUMBER] WHEN 1 THEN 'Yes' ELSE 'No' END,
			CASE [inserted].[AUTONUMBER] WHEN 1 THEN 'Yes' ELSE 'No' END,
			'Object Type (' + [inserted].[NAME] + ')',
			'95F19699-6655-4399-ACC3-CF4EE9043E4F',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[OMOBJECTTYPEID] = [inserted].[OMOBJECTTYPEID]
	WHERE	[deleted].[AUTONUMBER] <> [inserted].[AUTONUMBER]
END