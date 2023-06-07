CREATE TABLE [dbo].[BLEXTBUSINESSTYPE] (
    [BLEXTBUSINESSTYPEID]     CHAR (36)      NOT NULL,
    [CODENUMBER]              NVARCHAR (10)  NOT NULL,
    [NAME]                    NVARCHAR (250) NOT NULL,
    [DESCRIPTION]             NVARCHAR (MAX) NULL,
    [BLEXTBUSINESSCATEGORYID] CHAR (36)      NOT NULL,
    [LASTCHANGEDBY]           CHAR (36)      NULL,
    [LASTCHANGEDON]           DATETIME       CONSTRAINT [DF_BLEXTBUSINESSTYPE_LastChangedOn] DEFAULT (getutcdate()) NOT NULL,
    [ROWVERSION]              INT            CONSTRAINT [DF_BLEXTBUSINESSTYPE_RowVersion] DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_BLExtBusinessType] PRIMARY KEY CLUSTERED ([BLEXTBUSINESSTYPEID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_BLExtBusinessType_BLExtBusinessCategory] FOREIGN KEY ([BLEXTBUSINESSCATEGORYID]) REFERENCES [dbo].[BLEXTBUSINESSCATEGORY] ([BLEXTBUSINESSCATEGORYID])
);


GO
CREATE NONCLUSTERED INDEX [BLEXTBUSINESSTYPE_IX_QUERY]
    ON [dbo].[BLEXTBUSINESSTYPE]([BLEXTBUSINESSTYPEID] ASC, [NAME] ASC);


GO

CREATE TRIGGER [dbo].[TG_BLEXTBUSINESSTYPE_DELETE] ON  [dbo].[BLEXTBUSINESSTYPE]
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
		[ADDITIONALINFO]
    )
	SELECT
			[deleted].[BLEXTBUSINESSTYPEID],
			[deleted].[ROWVERSION],
			GETUTCDATE(),
			(SELECT dbo.UFN_GET_USERID_FROM_CONTEXT_INFO()),
			'Industry Classification Deleted',
			'',
			'',
			'Industry Classification (' + [deleted].[NAME] + ')'
	FROM	[deleted]
END
GO

CREATE TRIGGER [dbo].[TG_BLEXTBUSINESSTYPE_INSERT] ON [dbo].[BLEXTBUSINESSTYPE]
   AFTER INSERT
AS 
BEGIN
	SET NOCOUNT ON;

	-- Check if LASTCHANGEDBY contains VALID User Id and it Exists in USERS table, this is in replacement to foreign key reference of BLEXTBUSINESSTYPE table with USERS table.
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
        [ADDITIONALINFO]
    )
	SELECT 
        [inserted].[BLEXTBUSINESSTYPEID], 
        [inserted].[ROWVERSION],
        GETUTCDATE(),
        [inserted].[LASTCHANGEDBY],
        'Industry Classification Added',
        '',
        '',
        'Industry Classification (' + [inserted].[NAME] + ')'
    FROM [inserted] 
END
GO

CREATE TRIGGER [dbo].[TG_BLEXTBUSINESSTYPE_UPDATE] ON  [dbo].[BLEXTBUSINESSTYPE]
   AFTER UPDATE
AS 
BEGIN	
	SET NOCOUNT ON;

	-- Check if LASTCHANGEDBY contains VALID User Id and it Exists in USERS table, this is in replacement to foreign key reference of BLEXTBUSINESSTYPE table with USERS table.
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
		[ADDITIONALINFO]
    )
	SELECT 
			[inserted].[BLEXTBUSINESSTYPEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Industry Classification Name',
			[deleted].[NAME],
			[inserted].[NAME],
			'Industry Classification (' + [inserted].[NAME] + ')'
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[BLEXTBUSINESSTYPEID] = [inserted].[BLEXTBUSINESSTYPEID]
	WHERE	[deleted].[NAME] <> [inserted].[NAME]
	UNION ALL
	SELECT
			[inserted].[BLEXTBUSINESSTYPEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Industry Classification Description',
			ISNULL([deleted].[DESCRIPTION],'[none]'),
			ISNULL([inserted].[DESCRIPTION],'[none]'),
			'Industry Classification (' + [inserted].[NAME] + ')'
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[BLEXTBUSINESSTYPEID] = [inserted].[BLEXTBUSINESSTYPEID]
	WHERE	ISNULL([deleted].[DESCRIPTION],'') <> ISNULL([inserted].[DESCRIPTION],'')
	UNION ALL
	SELECT
			[inserted].[BLEXTBUSINESSTYPEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Industry Classification Code Number',
			[deleted].[CODENUMBER],
			[inserted].[CODENUMBER],
			'Industry Classification (' + [inserted].[NAME] + ')'
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[BLEXTBUSINESSTYPEID] = [inserted].[BLEXTBUSINESSTYPEID]
	WHERE	[deleted].[CODENUMBER] <> [inserted].[CODENUMBER]
	UNION ALL
	SELECT
			[inserted].[BLEXTBUSINESSTYPEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Industry Classification Category Name',
			BLEXTBUSINESSCATEGORY_DELETED.[NAME],
			BLEXTBUSINESSCATEGORY_INSERTED.[NAME],
			'Industry Classification (' + [inserted].[NAME] + ')'
	FROM	[deleted] JOIN [inserted] ON [deleted].[BLEXTBUSINESSTYPEID] = [inserted].[BLEXTBUSINESSTYPEID]
			 INNER JOIN [BLEXTBUSINESSCATEGORY]  AS BLEXTBUSINESSCATEGORY_DELETED WITH (NOLOCK)
				ON [deleted].[BLEXTBUSINESSCATEGORYID]= BLEXTBUSINESSCATEGORY_DELETED.[BLEXTBUSINESSCATEGORYID] 
			 INNER JOIN [BLEXTBUSINESSCATEGORY] AS BLEXTBUSINESSCATEGORY_INSERTED WITH (NOLOCK)
				ON [inserted].[BLEXTBUSINESSCATEGORYID] = BLEXTBUSINESSCATEGORY_INSERTED.[BLEXTBUSINESSCATEGORYID]
			WHERE	[deleted].[BLEXTBUSINESSCATEGORYID]<> [inserted].[BLEXTBUSINESSCATEGORYID]
END