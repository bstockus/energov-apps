CREATE TABLE [dbo].[ILLICENSECLASSIFICATION] (
    [ILLICENSECLASSIFICATIONID] CHAR (36)      NOT NULL,
    [NAME]                      NVARCHAR (255) NOT NULL,
    [DESCRIPTION]               NVARCHAR (MAX) NULL,
    [LASTCHANGEDBY]             CHAR (36)      NULL,
    [LASTCHANGEDON]             DATETIME       CONSTRAINT [DF_ILLICENSECLASSIFICATION_LastChangedOn] DEFAULT (getutcdate()) NOT NULL,
    [ROWVERSION]                INT            CONSTRAINT [DF_ILLICENSECLASSIFICATION_RowVersion] DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_ILLicenseClassification] PRIMARY KEY CLUSTERED ([ILLICENSECLASSIFICATIONID] ASC) WITH (FILLFACTOR = 90)
);


GO
CREATE NONCLUSTERED INDEX [ILLICENSECLASSIFICATION_IX_QUERY]
    ON [dbo].[ILLICENSECLASSIFICATION]([ILLICENSECLASSIFICATIONID] ASC, [NAME] ASC);


GO

CREATE TRIGGER [dbo].[TG_ILLICENSECLASSIFICATION_DELETE] ON  [dbo].[ILLICENSECLASSIFICATION]
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
			[deleted].[ILLICENSECLASSIFICATIONID],
			[deleted].[ROWVERSION],
			GETUTCDATE(),
			(SELECT dbo.UFN_GET_USERID_FROM_CONTEXT_INFO()),
			'Certification Classification Deleted',
			'',
			'',
			'Certification Classification (' + [deleted].[NAME] + ')',
			'91E0E49F-87D6-4E26-BC4E-A5BC22514CC3',
			3,
			1,
			[deleted].[NAME]
	FROM	[deleted]
END
GO

CREATE TRIGGER [dbo].[TG_ILLICENSECLASSIFICATION_UPDATE] ON  [dbo].[ILLICENSECLASSIFICATION]
   AFTER UPDATE
AS 
BEGIN	
	SET NOCOUNT ON;

	-- Check if LASTCHANGEDBY contains VALID User Id and it Exists in USERS table, this is in replacement to foreign key reference of ILLICENSECLASSIFICATION table with USERS table.
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
			[inserted].[ILLICENSECLASSIFICATIONID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Name',
			[deleted].[NAME],
			[inserted].[NAME],
			'Certification Classification (' + [inserted].[NAME] + ')',
			'91E0E49F-87D6-4E26-BC4E-A5BC22514CC3',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[ILLICENSECLASSIFICATIONID] = [inserted].[ILLICENSECLASSIFICATIONID]
	WHERE	[deleted].[NAME] <> [inserted].[NAME]
	UNION ALL
	SELECT
			[inserted].[ILLICENSECLASSIFICATIONID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Description',
			ISNULL([deleted].[DESCRIPTION],'[none]'),
			ISNULL([inserted].[DESCRIPTION],'[none]'),
			'Certification Classification (' + [inserted].[NAME] + ')',
			'91E0E49F-87D6-4E26-BC4E-A5BC22514CC3',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[ILLICENSECLASSIFICATIONID] = [inserted].[ILLICENSECLASSIFICATIONID]
	WHERE	ISNULL([deleted].[DESCRIPTION],'') <> ISNULL([inserted].[DESCRIPTION],'')
END
GO


CREATE TRIGGER [dbo].[TG_ILLICENSECLASSIFICATION_INSERT] ON [dbo].[ILLICENSECLASSIFICATION]
   AFTER INSERT
AS 
BEGIN
	SET NOCOUNT ON;

	-- Check if LASTCHANGEDBY contains VALID User Id and it Exists in USERS table, this is in replacement to foreign key reference of ILLICENSECLASSIFICATION table with USERS table.
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
        [inserted].[ILLICENSECLASSIFICATIONID], 
        [inserted].[ROWVERSION],
        GETUTCDATE(),
        [inserted].[LASTCHANGEDBY],
        'Certification Classification Added',
        '',
        '',
        'Certification Classification (' + [inserted].[NAME] + ')',
		'91E0E49F-87D6-4E26-BC4E-A5BC22514CC3',
        1,
		1,
		[inserted].[NAME]
    FROM [inserted] 
END