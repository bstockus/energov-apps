CREATE TABLE [dbo].[CONDITIONCATEGORY] (
    [CONDITIONCATEGORYID] CHAR (36)      NOT NULL,
    [NAME]                NVARCHAR (255) NOT NULL,
    [DESCRIPTION]         NVARCHAR (MAX) NOT NULL,
    [LASTCHANGEDBY]       CHAR (36)      NULL,
    [LASTCHANGEDON]       DATETIME       CONSTRAINT [DF_CONDITIONCATEGORY_LastChangedOn] DEFAULT (getutcdate()) NOT NULL,
    [ROWVERSION]          INT            CONSTRAINT [DF_CONDITIONCATEGORY_RowVersion] DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_conConditionCategory] PRIMARY KEY CLUSTERED ([CONDITIONCATEGORYID] ASC) WITH (FILLFACTOR = 90)
);


GO
CREATE NONCLUSTERED INDEX [CONDITIONCATEGORY_IX_QUERY]
    ON [dbo].[CONDITIONCATEGORY]([CONDITIONCATEGORYID] ASC, [NAME] ASC);


GO

CREATE TRIGGER [dbo].[TG_CONDITIONCATEGORY_UPDATE] 
   ON  [dbo].[CONDITIONCATEGORY]
   AFTER UPDATE
AS 
BEGIN	
	SET NOCOUNT ON;

	-- Check if LASTCHANGEDBY contains VALID User Id and it Exists in USERS table, this is in replacement to foreign key reference of CONDITIONCATEGORY table with USERS table.
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
			[inserted].[CONDITIONCATEGORYID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Name',
			[deleted].[NAME],
			[inserted].[NAME],
			'Condition Category (' + [inserted].[NAME] + ')',
			'A3C37291-6DE5-4B71-B44A-5AEF8D93B1AF',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[CONDITIONCATEGORYID] = [inserted].[CONDITIONCATEGORYID]
	WHERE	[deleted].[NAME] <> [inserted].[NAME]
	UNION ALL
	SELECT
			[inserted].[CONDITIONCATEGORYID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Description',
			[deleted].[DESCRIPTION],
			[inserted].[DESCRIPTION],
			'Condition Category (' + [inserted].[NAME] + ')',
			'A3C37291-6DE5-4B71-B44A-5AEF8D93B1AF',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[CONDITIONCATEGORYID] = [inserted].[CONDITIONCATEGORYID]
	WHERE	[deleted].[DESCRIPTION]<> [inserted].[DESCRIPTION]
END
GO

CREATE TRIGGER [dbo].[TG_CONDITIONCATEGORY_INSERT] ON [dbo].[CONDITIONCATEGORY]
   AFTER INSERT
AS 
BEGIN
	SET NOCOUNT ON;

	-- Check if LASTCHANGEDBY contains VALID User Id and it Exists in USERS table, this is in replacement to foreign key reference of CONDITIONCATEGORY table with USERS table.
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
        [inserted].[CONDITIONCATEGORYID], 
        [inserted].[ROWVERSION],
        GETUTCDATE(),
        [inserted].[LASTCHANGEDBY],
        'Condition Category Added',
        '',
        '',
        'Condition Category (' + [inserted].[NAME] + ')',
		'A3C37291-6DE5-4B71-B44A-5AEF8D93B1AF',
		1,
		1,
		[inserted].[NAME]
    FROM [inserted] 
END
GO

CREATE TRIGGER [dbo].[TG_CONDITIONCATEGORY_DELETE]
   ON  [dbo].[CONDITIONCATEGORY]
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
			[deleted].[CONDITIONCATEGORYID],
			[deleted].[ROWVERSION],
			GETUTCDATE(),
			(SELECT dbo.UFN_GET_USERID_FROM_CONTEXT_INFO()),
			'Condition Category Deleted',
			'',
			'',
			'Condition Category (' + [deleted].[NAME] + ')',
			'A3C37291-6DE5-4B71-B44A-5AEF8D93B1AF',
			3,
			1,
			[deleted].[NAME]
	FROM	[deleted]
END