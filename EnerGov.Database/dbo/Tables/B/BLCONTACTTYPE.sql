CREATE TABLE [dbo].[BLCONTACTTYPE] (
    [BLCONTACTTYPEID]       CHAR (36)     NOT NULL,
    [NAME]                  VARCHAR (50)  NOT NULL,
    [DESCRIPTION]           VARCHAR (MAX) NULL,
    [BLCONTACTTYPESYSTEMID] INT           NOT NULL,
    [REQUIREDVALIDLIC]      BIT           DEFAULT ((0)) NOT NULL,
    [LASTCHANGEDBY]         CHAR (36)     NULL,
    [LASTCHANGEDON]         DATETIME      CONSTRAINT [DF_BLCONTACTTYPE_LastChangedOn] DEFAULT (getutcdate()) NOT NULL,
    [ROWVERSION]            INT           CONSTRAINT [DF_BLCONTACTTYPE_RowVersion] DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_BLContactType] PRIMARY KEY CLUSTERED ([BLCONTACTTYPEID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_BLContactType_BLContactTypeSystem] FOREIGN KEY ([BLCONTACTTYPESYSTEMID]) REFERENCES [dbo].[BLCONTACTTYPESYSTEM] ([BLCONTACTTYPESYSTEMID])
);


GO
CREATE NONCLUSTERED INDEX [BLCONTACTTYPE_IX_QUERY]
    ON [dbo].[BLCONTACTTYPE]([BLCONTACTTYPEID] ASC, [NAME] ASC);


GO


CREATE TRIGGER [dbo].[TG_BLCONTACTTYPE_DELETE] ON  [dbo].[BLCONTACTTYPE]
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
			[deleted].[BLCONTACTTYPEID],
			[deleted].[ROWVERSION],
			GETUTCDATE(),
			(SELECT dbo.UFN_GET_USERID_FROM_CONTEXT_INFO()),
			'Business License Contact Type Deleted',
			'',
			'',
			'Business License Contact Type (' + [deleted].[NAME] + ')',
			'233B1B04-25D7-464C-8183-49A6D125E760',
			3,
			1,
			[deleted].[NAME]
	FROM	[deleted]
END
GO


CREATE TRIGGER [dbo].[TG_BLCONTACTTYPE_UPDATE] ON  [dbo].[BLCONTACTTYPE]
   AFTER UPDATE
AS 
BEGIN	
	SET NOCOUNT ON;

	-- Check if LASTCHANGEDBY contains VALID User Id and it Exists in USERS table, this is in replacement to foreign key reference of BLCONTACTTYPE table with USERS table.
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
			[inserted].[BLCONTACTTYPEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Name',
			[deleted].[NAME],
			[inserted].[NAME],
			'Business License Contact Type (' + [inserted].[NAME] + ')',
			'233B1B04-25D7-464C-8183-49A6D125E760',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[BLCONTACTTYPEID] = [inserted].[BLCONTACTTYPEID]
	WHERE	[deleted].[NAME] <> [inserted].[NAME]
	UNION ALL
	SELECT
			[inserted].[BLCONTACTTYPEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Description',
			ISNULL([deleted].[DESCRIPTION],'[none]'),
			ISNULL([inserted].[DESCRIPTION],'[none]'),
			'Business License Contact Type (' + [inserted].[NAME] + ')',
			'233B1B04-25D7-464C-8183-49A6D125E760',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[BLCONTACTTYPEID] = [inserted].[BLCONTACTTYPEID]
	WHERE	ISNULL([deleted].[DESCRIPTION],'') <> ISNULL([inserted].[DESCRIPTION],'')
	UNION ALL
	SELECT
			[inserted].[BLCONTACTTYPEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'System Type',
			[BLCONTACTTYPESYSTEM_DELETED].[NAME],
			[BLCONTACTTYPESYSTEM_INSERTED].[NAME],
			'Business License Contact Type (' + [inserted].[NAME] + ')',
			'233B1B04-25D7-464C-8183-49A6D125E760',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[BLCONTACTTYPEID] = [inserted].[BLCONTACTTYPEID]
			INNER JOIN [BLCONTACTTYPESYSTEM] BLCONTACTTYPESYSTEM_INSERTED WITH (NOLOCK) ON [BLCONTACTTYPESYSTEM_INSERTED].[BLCONTACTTYPESYSTEMID] = [inserted].[BLCONTACTTYPESYSTEMID]
			INNER JOIN [BLCONTACTTYPESYSTEM] BLCONTACTTYPESYSTEM_DELETED WITH (NOLOCK) ON [BLCONTACTTYPESYSTEM_DELETED].[BLCONTACTTYPESYSTEMID] = [deleted].[BLCONTACTTYPESYSTEMID]
	WHERE	[deleted].[BLCONTACTTYPESYSTEMID] <> [inserted].[BLCONTACTTYPESYSTEMID]
	UNION ALL
	SELECT
			[inserted].[BLCONTACTTYPEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Valid License Flag',
			CASE [deleted].[REQUIREDVALIDLIC] WHEN 1 THEN 'Yes' ELSE 'No' END,
			CASE [inserted].[REQUIREDVALIDLIC] WHEN 1 THEN 'Yes' ELSE 'No' END,
			'Business License Contact Type (' + [inserted].[NAME] + ')',
			'233B1B04-25D7-464C-8183-49A6D125E760',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[BLCONTACTTYPEID] = [inserted].[BLCONTACTTYPEID]
	WHERE	[deleted].[REQUIREDVALIDLIC] <> [inserted].[REQUIREDVALIDLIC]
END
GO


CREATE TRIGGER [dbo].[TG_BLCONTACTTYPE_INSERT] ON [dbo].[BLCONTACTTYPE]
   AFTER INSERT
AS 
BEGIN
	SET NOCOUNT ON;

	-- Check if LASTCHANGEDBY contains VALID User Id and it Exists in USERS table, this is in replacement to foreign key reference of BLCONTACTTYPE table with USERS table.
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
        [inserted].[BLCONTACTTYPEID], 
        [inserted].[ROWVERSION],
        GETUTCDATE(),
        [inserted].[LASTCHANGEDBY],
        'Business License Contact Type Added',
        '',
        '',
        'Business License Contact Type (' + [inserted].[NAME] + ')',
		'233B1B04-25D7-464C-8183-49A6D125E760',
		1,
		1,
		[inserted].[NAME]
    FROM [inserted] 
END