CREATE TABLE [dbo].[EXAMVERSION] (
    [EXAMVERSIONID] CHAR (36)      NOT NULL,
    [NAME]          NVARCHAR (50)  NOT NULL,
    [DESCRIPTION]   NVARCHAR (MAX) NULL,
    [LASTCHANGEDBY] CHAR (36)      NULL,
    [LASTCHANGEDON] DATETIME       CONSTRAINT [DF_EXAMVERSION_LastChangedOn] DEFAULT (getutcdate()) NOT NULL,
    [ROWVERSION]    INT            CONSTRAINT [DF_EXAMVERSION_RowVersion] DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_EXAMVERSION] PRIMARY KEY CLUSTERED ([EXAMVERSIONID] ASC) WITH (FILLFACTOR = 90)
);


GO
CREATE NONCLUSTERED INDEX [EXAMVERSION_IX_QUERY]
    ON [dbo].[EXAMVERSION]([EXAMVERSIONID] ASC, [NAME] ASC);


GO


CREATE TRIGGER [dbo].[TG_EXAMVERSION_DELETE] ON  [dbo].[EXAMVERSION]
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
			[deleted].[EXAMVERSIONID],
			[deleted].[ROWVERSION],
			GETUTCDATE(),
			(SELECT dbo.UFN_GET_USERID_FROM_CONTEXT_INFO()),
			'Exam Version Deleted',
			'',
			'',
			'Exam Version (' + [deleted].[NAME] + ')',
			'E6DBC06E-F2F7-4F76-B8C8-7156CAA88C9E',
			3,
			1,
			[deleted].[NAME]
	FROM	[deleted]
END
GO


CREATE TRIGGER [dbo].[TG_EXAMVERSION_INSERT] ON [dbo].[EXAMVERSION]
   AFTER INSERT
AS 
BEGIN
	SET NOCOUNT ON;

	-- Check if LASTCHANGEDBY contains VALID User Id and it Exists in USERS table, this is in replacement to foreign key reference of EXAMVERSION table with USERS table.
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
        [inserted].[EXAMVERSIONID], 
        [inserted].[ROWVERSION],
        GETUTCDATE(),
        [inserted].[LASTCHANGEDBY],
        'Exam Version Added',
        '',
        '',
        'Exam Version (' + [inserted].[NAME] + ')',
		'E6DBC06E-F2F7-4F76-B8C8-7156CAA88C9E',
		1,
		1,
		[inserted].[NAME]
    FROM [inserted] 
END
GO


CREATE TRIGGER [dbo].[TG_EXAMVERSION_UPDATE] ON  [dbo].[EXAMVERSION]
   AFTER UPDATE
AS 
BEGIN	
	SET NOCOUNT ON;

	-- Check if LASTCHANGEDBY contains VALID User Id and it Exists in USERS table, this is in replacement to foreign key reference of EXAMVERSION table with USERS table.
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
			[inserted].[EXAMVERSIONID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Name',
			[deleted].[NAME],
			[inserted].[NAME],
			'Exam Version (' + [inserted].[NAME] + ')',
			'E6DBC06E-F2F7-4F76-B8C8-7156CAA88C9E',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[EXAMVERSIONID] = [inserted].[EXAMVERSIONID]
	WHERE	[deleted].[NAME] <> [inserted].[NAME]
	UNION ALL
	SELECT
			[inserted].[EXAMVERSIONID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Description',
			ISNULL([deleted].[DESCRIPTION],'[none]'),
			ISNULL([inserted].[DESCRIPTION],'[none]'),
			'Exam Version (' + [inserted].[NAME] + ')',
			'E6DBC06E-F2F7-4F76-B8C8-7156CAA88C9E',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[EXAMVERSIONID] = [inserted].[EXAMVERSIONID]
	WHERE	ISNULL([deleted].[DESCRIPTION],'') <> ISNULL([inserted].[DESCRIPTION],'')
END