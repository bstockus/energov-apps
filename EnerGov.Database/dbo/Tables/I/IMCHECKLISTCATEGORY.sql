CREATE TABLE [dbo].[IMCHECKLISTCATEGORY] (
    [IMCHECKLISTCATEGORYID] CHAR (36)      NOT NULL,
    [NAME]                  NVARCHAR (255) NOT NULL,
    [DESCRIPTION]           NVARCHAR (MAX) NOT NULL,
    [LASTCHANGEDBY]         CHAR (36)      NULL,
    [LASTCHANGEDON]         DATETIME       CONSTRAINT [DF_IMCHECKLISTCATEGORY_LastChangedOn] DEFAULT (getutcdate()) NOT NULL,
    [ROWVERSION]            INT            CONSTRAINT [DF_IMCHECKLISTCATEGORY_RowVersion] DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_IMCheckListCategory] PRIMARY KEY CLUSTERED ([IMCHECKLISTCATEGORYID] ASC) WITH (FILLFACTOR = 90)
);


GO
CREATE NONCLUSTERED INDEX [IMCHECKLISTCATEGORY_IX_QUERY]
    ON [dbo].[IMCHECKLISTCATEGORY]([IMCHECKLISTCATEGORYID] ASC, [NAME] ASC);


GO

CREATE TRIGGER [dbo].[TG_IMCHECKLISTCATEGORY_INSERT] ON [dbo].[IMCHECKLISTCATEGORY]
   AFTER INSERT
AS 
BEGIN
	SET NOCOUNT ON;

	-- Check if LASTCHANGEDBY contains VALID User Id and it Exists in USERS table, this is in replacement to foreign key reference of IMCHECKLISTCATEGORY table with USERS table.
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
        [inserted].[IMCHECKLISTCATEGORYID], 
        [inserted].[ROWVERSION],
        GETUTCDATE(),
        [inserted].[LASTCHANGEDBY],
        'Inspection Checklist Category Added',
        '',
        '',
        'Inspection Checklist Category (' + [inserted].[NAME] + ')',
		'597056C9-1564-478D-8543-406622FAC1FF',
		1,
		1,
		[inserted].[NAME]
    FROM [inserted] 
END
GO

CREATE TRIGGER [dbo].[TG_IMCHECKLISTCATEGORY_UPDATE] ON  [dbo].[IMCHECKLISTCATEGORY]
   AFTER UPDATE
AS 
BEGIN	
	SET NOCOUNT ON;

	-- Check if LASTCHANGEDBY contains VALID User Id and it Exists in USERS table, this is in replacement to foreign key reference of IMCHECKLISTCATEGORY table with USERS table.
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
			[inserted].[IMCHECKLISTCATEGORYID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Name',
			[deleted].[NAME],
			[inserted].[NAME],
			'Inspection Checklist Category (' + [inserted].[NAME] + ')',
			'597056C9-1564-478D-8543-406622FAC1FF',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[IMCHECKLISTCATEGORYID] = [inserted].[IMCHECKLISTCATEGORYID]
	WHERE	[deleted].[NAME] <> [inserted].[NAME]
	UNION ALL
	SELECT
			[inserted].[IMCHECKLISTCATEGORYID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Description',
			[deleted].[DESCRIPTION],
			[inserted].[DESCRIPTION],
			'Inspection Checklist Category (' + [inserted].[NAME] + ')',
			'597056C9-1564-478D-8543-406622FAC1FF',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[IMCHECKLISTCATEGORYID] = [inserted].[IMCHECKLISTCATEGORYID]
	WHERE	[deleted].[DESCRIPTION] <> [inserted].[DESCRIPTION]
END
GO

CREATE TRIGGER [dbo].[TG_IMCHECKLISTCATEGORY_DELETE] ON  [dbo].[IMCHECKLISTCATEGORY]
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
			[deleted].[IMCHECKLISTCATEGORYID],
			[deleted].[ROWVERSION],
			GETUTCDATE(),
			(SELECT dbo.UFN_GET_USERID_FROM_CONTEXT_INFO()),
			'Inspection Checklist Category Deleted',
			'',
			'',
			'Inspection Checklist Category (' + [deleted].[NAME] + ')',
			'597056C9-1564-478D-8543-406622FAC1FF',
			3,
			1,
			[deleted].[NAME]
	FROM	[deleted]
END