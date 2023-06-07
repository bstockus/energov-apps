CREATE TABLE [dbo].[IPCONDITIONCATEGORY] (
    [IPCONDITIONCATEGORYID] CHAR (36)      NOT NULL,
    [NAME]                  NVARCHAR (100) NOT NULL,
    [DESCRIPTION]           NVARCHAR (MAX) NULL,
    [PREFIX]                NVARCHAR (10)  NULL,
    [LASTCHANGEDBY]         CHAR (36)      NULL,
    [LASTCHANGEDON]         DATETIME       CONSTRAINT [DF_IPCONDITIONCATEGORY_LastChangedOn] DEFAULT (getutcdate()) NOT NULL,
    [ROWVERSION]            INT            CONSTRAINT [DF_IPCONDITIONCATEGORY_RowVersion] DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_IPCONDITIONCATEGORY] PRIMARY KEY CLUSTERED ([IPCONDITIONCATEGORYID] ASC) WITH (FILLFACTOR = 90)
);


GO
CREATE NONCLUSTERED INDEX [IPCONDITIONCATEGORY_IX_QUERY]
    ON [dbo].[IPCONDITIONCATEGORY]([IPCONDITIONCATEGORYID] ASC, [NAME] ASC);


GO


CREATE TRIGGER [dbo].[TG_IPCONDITIONCATEGORY_INSERT] ON [dbo].[IPCONDITIONCATEGORY]
   AFTER INSERT
AS 
BEGIN
	SET NOCOUNT ON;

	-- Check if LASTCHANGEDBY contains VALID User Id and it Exists in USERS table, this is in replacement to foreign key reference of IPCONDITIONCATEGORY table with USERS table.
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
        [inserted].[IPCONDITIONCATEGORYID], 
        [inserted].[ROWVERSION],
        GETUTCDATE(),
        [inserted].[LASTCHANGEDBY],
        'Impact Condition Category Added',
        '',
        '',
        'Impact Condition Category (' + [inserted].[NAME] + ')',
		'59C00A9E-2B6B-42FB-8A39-6C342C2A81A2',
		1,
		1,
		[inserted].[NAME]
    FROM [inserted] 
END
GO

CREATE TRIGGER [dbo].[TG_IPCONDITIONCATEGORY_UPDATE] ON  [dbo].[IPCONDITIONCATEGORY]
   AFTER UPDATE
AS 
BEGIN	
	SET NOCOUNT ON;

	-- Check if LASTCHANGEDBY contains VALID User Id and it Exists in USERS table, this is in replacement to foreign key reference of IPCONDITIONCATEGORY table with USERS table.
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
			[inserted].[IPCONDITIONCATEGORYID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Name',
			[deleted].[NAME],
			[inserted].[NAME],
			'Impact Condition Category (' + [inserted].[NAME] + ')',
			'59C00A9E-2B6B-42FB-8A39-6C342C2A81A2',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[IPCONDITIONCATEGORYID] = [inserted].[IPCONDITIONCATEGORYID]
	WHERE	[deleted].[NAME] <> [inserted].[NAME]
	UNION ALL
	SELECT
			[inserted].[IPCONDITIONCATEGORYID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Description',
			ISNULL([deleted].[DESCRIPTION],'[none]'),
			ISNULL([inserted].[DESCRIPTION],'[none]'),
			'Impact Condition Category (' + [inserted].[NAME] + ')',
			'59C00A9E-2B6B-42FB-8A39-6C342C2A81A2',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[IPCONDITIONCATEGORYID] = [inserted].[IPCONDITIONCATEGORYID]
	WHERE	ISNULL([deleted].[DESCRIPTION],'') <> ISNULL([inserted].[DESCRIPTION],'')
	UNION ALL
	SELECT
			[inserted].[IPCONDITIONCATEGORYID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Prefix',
			ISNULL([deleted].[PREFIX],'[none]'),
			ISNULL([inserted].[PREFIX],'[none]'),
			'Impact Condition Category (' + [inserted].[NAME] + ')',
			'59C00A9E-2B6B-42FB-8A39-6C342C2A81A2',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[IPCONDITIONCATEGORYID] = [inserted].[IPCONDITIONCATEGORYID]
	WHERE	ISNULL([deleted].[PREFIX],'') <> ISNULL([inserted].[PREFIX],'')
END
GO

CREATE TRIGGER [dbo].[TG_IPCONDITIONCATEGORY_DELETE] ON  [dbo].[IPCONDITIONCATEGORY]
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
			[deleted].[IPCONDITIONCATEGORYID],
			[deleted].[ROWVERSION],
			GETUTCDATE(),
			(SELECT dbo.UFN_GET_USERID_FROM_CONTEXT_INFO()),
			'Impact Condition Category Deleted',
			'',
			'',
			'Impact Condition Category (' + [deleted].[NAME] + ')',
			'59C00A9E-2B6B-42FB-8A39-6C342C2A81A2',
			3,
			1,
			[deleted].[NAME]
	FROM	[deleted]
END