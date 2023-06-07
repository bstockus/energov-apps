CREATE TABLE [dbo].[ILLICENSECLASSTYPECATEGORY] (
    [ILLICENSECLASSTYPECATEGORYID] CHAR (36)      NOT NULL,
    [NAME]                         NVARCHAR (50)  NOT NULL,
    [DESCRIPTION]                  NVARCHAR (MAX) NULL,
    [LASTCHANGEDBY]                CHAR (36)      NULL,
    [LASTCHANGEDON]                DATETIME       CONSTRAINT [DF_ILLICENSECLASSTYPECATEGORY_LastChangedOn] DEFAULT (getutcdate()) NOT NULL,
    [ROWVERSION]                   INT            CONSTRAINT [DF_ILLICENSECLASSTYPECATEGORY_RowVersion] DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_ILLICENSECLASSTYPECATEGORY] PRIMARY KEY CLUSTERED ([ILLICENSECLASSTYPECATEGORYID] ASC) WITH (FILLFACTOR = 90)
);


GO
CREATE NONCLUSTERED INDEX [ILLICENSECLASSTYPECATEGORY_IX_QUERY]
    ON [dbo].[ILLICENSECLASSTYPECATEGORY]([ILLICENSECLASSTYPECATEGORYID] ASC, [NAME] ASC);


GO


CREATE TRIGGER [dbo].[TG_ILLICENSECLASSTYPECATEGORY_INSERT] ON [dbo].[ILLICENSECLASSTYPECATEGORY]
   AFTER INSERT
AS 
BEGIN
	SET NOCOUNT ON;

	-- Check if LASTCHANGEDBY contains VALID User Id and it Exists in USERS table, this is in replacement to foreign key reference of ILLICENSECLASSTYPECATEGORY table with USERS table.
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
        [inserted].[ILLICENSECLASSTYPECATEGORYID], 
        [inserted].[ROWVERSION],
        GETUTCDATE(),
        [inserted].[LASTCHANGEDBY],
        'Professional License Classification Type Category Added',
        '',
        '',
        'Professional License Classification Type Category (' + [inserted].[NAME] + ')',
		'EC3E52B3-D1B2-40CD-8702-7C7A03A35633',
		1,
		1,
		[inserted].[NAME]
    FROM [inserted] 
END
GO


CREATE TRIGGER [dbo].[TG_ILLICENSECLASSTYPECATEGORY_UPDATE] ON  [dbo].[ILLICENSECLASSTYPECATEGORY]
   AFTER UPDATE
AS 
BEGIN	
	SET NOCOUNT ON;

	-- Check if LASTCHANGEDBY contains VALID User Id and it Exists in USERS table, this is in replacement to foreign key reference of ILLICENSECLASSTYPECATEGORY table with USERS table.
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
			[inserted].[ILLICENSECLASSTYPECATEGORYID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Name',
			[deleted].[NAME],
			[inserted].[NAME],
			'Professional License Classification Type Category (' + [inserted].[NAME] + ')',
			'EC3E52B3-D1B2-40CD-8702-7C7A03A35633',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[ILLICENSECLASSTYPECATEGORYID] = [inserted].[ILLICENSECLASSTYPECATEGORYID]
	WHERE	[deleted].[NAME] <> [inserted].[NAME]
	UNION ALL
	SELECT
			[inserted].[ILLICENSECLASSTYPECATEGORYID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Description',
			ISNULL([deleted].[DESCRIPTION],'[none]'),
			ISNULL([inserted].[DESCRIPTION],'[none]'),
			'Professional License Classification Type Category (' + [inserted].[NAME] + ')',
			'EC3E52B3-D1B2-40CD-8702-7C7A03A35633',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[ILLICENSECLASSTYPECATEGORYID] = [inserted].[ILLICENSECLASSTYPECATEGORYID]
	WHERE	ISNULL([deleted].[DESCRIPTION],'') <> ISNULL([inserted].[DESCRIPTION],'')
END
GO


CREATE TRIGGER [dbo].[TG_ILLICENSECLASSTYPECATEGORY_DELETE] ON  [dbo].[ILLICENSECLASSTYPECATEGORY]
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
			[deleted].[ILLICENSECLASSTYPECATEGORYID],
			[deleted].[ROWVERSION],
			GETUTCDATE(),
			(SELECT dbo.UFN_GET_USERID_FROM_CONTEXT_INFO()),
			'Professional License Classification Type Category Deleted',
			'',
			'',
			'Professional License Classification Type Category (' + [deleted].[NAME] + ')',
			'EC3E52B3-D1B2-40CD-8702-7C7A03A35633',
			3,
			1,
			[deleted].[NAME]
	FROM	[deleted]
END