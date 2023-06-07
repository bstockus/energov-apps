CREATE TABLE [dbo].[BLEXTBUSINESSCATEGORY] (
    [BLEXTBUSINESSCATEGORYID] CHAR (36)      NOT NULL,
    [NAME]                    NVARCHAR (100) NOT NULL,
    [DESCRIPTION]             NVARCHAR (MAX) NULL,
    [LASTCHANGEDBY]           CHAR (36)      NULL,
    [LASTCHANGEDON]           DATETIME       CONSTRAINT [DF_BLEXTBUSINESSCATEGORY_LastChangedOn] DEFAULT (getutcdate()) NOT NULL,
    [ROWVERSION]              INT            CONSTRAINT [DF_BLEXTBUSINESSCATEGORY_RowVersion] DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_BLExtBusinessCategory] PRIMARY KEY CLUSTERED ([BLEXTBUSINESSCATEGORYID] ASC) WITH (FILLFACTOR = 90)
);


GO
CREATE NONCLUSTERED INDEX [BLEXTBUSINESSCATEGORY_IX_QUERY]
    ON [dbo].[BLEXTBUSINESSCATEGORY]([BLEXTBUSINESSCATEGORYID] ASC, [NAME] ASC);


GO

CREATE TRIGGER [dbo].[TG_BLEXTBUSINESSCATEGORY_UPDATE] ON  [dbo].[BLEXTBUSINESSCATEGORY]
   AFTER UPDATE
AS 
BEGIN	
	SET NOCOUNT ON;

	-- Check if LASTCHANGEDBY contains VALID User Id and it Exists in USERS table, this is in replacement to foreign key reference of BLEXTBUSINESSCATEGORY table with USERS table.
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
			[inserted].[BLEXTBUSINESSCATEGORYID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Name',
			[deleted].[NAME],
			[inserted].[NAME],
			'Industry Classification Category (' + [inserted].[NAME] + ')',
			'48FB99BF-2316-44FA-958B-D5F8912AADC7',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[BLEXTBUSINESSCATEGORYID] = [inserted].[BLEXTBUSINESSCATEGORYID]
	WHERE	[deleted].[NAME] <> [inserted].[NAME]
	UNION ALL
	SELECT
			[inserted].[BLEXTBUSINESSCATEGORYID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Description',
			ISNULL([deleted].[DESCRIPTION],'[none]'),
			ISNULL([inserted].[DESCRIPTION],'[none]'),
			'Industry Classification Category (' + [inserted].[NAME] + ')',
			'48FB99BF-2316-44FA-958B-D5F8912AADC7',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[BLEXTBUSINESSCATEGORYID] = [inserted].[BLEXTBUSINESSCATEGORYID]
	WHERE	ISNULL([deleted].[DESCRIPTION],'') <> ISNULL([inserted].[DESCRIPTION],'')
END
GO

CREATE TRIGGER [dbo].[TG_BLEXTBUSINESSCATEGORY_INSERT] ON [dbo].[BLEXTBUSINESSCATEGORY]
   AFTER INSERT
AS 
BEGIN
	SET NOCOUNT ON;

	-- Check if LASTCHANGEDBY contains VALID User Id and it Exists in USERS table, this is in replacement to foreign key reference of BLEXTBUSINESSCATEGORY table with USERS table.
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
        [inserted].[BLEXTBUSINESSCATEGORYID], 
        [inserted].[ROWVERSION],
        GETUTCDATE(),
        [inserted].[LASTCHANGEDBY],
        'Industry Classification Category Added',
        '',
        '',
        'Industry Classification Category (' + [inserted].[NAME] + ')',
		'48FB99BF-2316-44FA-958B-D5F8912AADC7',
		1,
		1,
		[inserted].[NAME]
    FROM [inserted] 
END
GO

CREATE TRIGGER [dbo].[TG_BLEXTBUSINESSCATEGORY_DELETE] ON  [dbo].[BLEXTBUSINESSCATEGORY]
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
			[deleted].[BLEXTBUSINESSCATEGORYID],
			[deleted].[ROWVERSION],
			GETUTCDATE(),
			(SELECT dbo.UFN_GET_USERID_FROM_CONTEXT_INFO()),
			'Industry Classification Category Deleted',
			'',
			'',
			'Industry Classification Category (' + [deleted].[NAME] + ')',
			'48FB99BF-2316-44FA-958B-D5F8912AADC7',
			3,
			1,
			[deleted].[NAME]
	FROM	[deleted]
END