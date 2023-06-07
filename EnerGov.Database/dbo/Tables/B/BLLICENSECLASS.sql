CREATE TABLE [dbo].[BLLICENSECLASS] (
    [BLLICENSECLASSID] CHAR (36)      NOT NULL,
    [NAME]             NVARCHAR (50)  NOT NULL,
    [DESCRIPTION]      NVARCHAR (MAX) NULL,
    [LASTCHANGEDBY]    CHAR (36)      NULL,
    [LASTCHANGEDON]    DATETIME       CONSTRAINT [DF_BLLICENSECLASS_LastChangedOn] DEFAULT (getutcdate()) NOT NULL,
    [ROWVERSION]       INT            CONSTRAINT [DF_BLLICENSECLASS_RowVersion] DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_BLLicenseClass] PRIMARY KEY CLUSTERED ([BLLICENSECLASSID] ASC) WITH (FILLFACTOR = 90)
);


GO
CREATE NONCLUSTERED INDEX [BLLICENSECLASS_IX_QUERY]
    ON [dbo].[BLLICENSECLASS]([BLLICENSECLASSID] ASC, [NAME] ASC);


GO

CREATE TRIGGER [dbo].[TG_BLLICENSECLASS_DELETE] ON  [dbo].[BLLICENSECLASS]
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
			[deleted].[BLLICENSECLASSID],
			[deleted].[ROWVERSION],
			GETUTCDATE(),
			(SELECT dbo.UFN_GET_USERID_FROM_CONTEXT_INFO()),
			'Business License Classification Deleted',
			'',
			'',
			'Business License Classification (' + [deleted].[NAME] + ')',
			'D421A946-9207-4034-8B98-80823509F64C',
			3,
			1,
			[deleted].[NAME]
	FROM	[deleted]
END
GO

CREATE TRIGGER [dbo].[TG_BLLICENSECLASS_INSERT] ON [dbo].[BLLICENSECLASS]
   AFTER INSERT
AS 
BEGIN
	SET NOCOUNT ON;

	-- Check if LASTCHANGEDBY contains VALID User Id and it Exists in USERS table, this is in replacement to foreign key reference of BLLICENSECLASS table with USERS table.
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
        [inserted].[BLLICENSECLASSID], 
        [inserted].[ROWVERSION],
        GETUTCDATE(),
        [inserted].[LASTCHANGEDBY],
        'Business License Classification Added',
        '',
        '',
        'Business License Classification (' + [inserted].[NAME] + ')',
		'D421A946-9207-4034-8B98-80823509F64C',
		1,
		1,
		[inserted].[NAME]
    FROM [inserted] 
END
GO

CREATE TRIGGER [dbo].[TG_BLLICENSECLASS_UPDATE] ON  [dbo].[BLLICENSECLASS]
   AFTER UPDATE
AS 
BEGIN	
	SET NOCOUNT ON;

	-- Check if LASTCHANGEDBY contains VALID User Id and it Exists in USERS table, this is in replacement to foreign key reference of BLLICENSECLASS table with USERS table.
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
			[inserted].[BLLICENSECLASSID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Name',
			[deleted].[NAME],
			[inserted].[NAME],
			'Business License Classification (' + [inserted].[NAME] + ')',
			'D421A946-9207-4034-8B98-80823509F64C',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[BLLICENSECLASSID] = [inserted].[BLLICENSECLASSID]
	WHERE	[deleted].[NAME] <> [inserted].[NAME]
	UNION ALL
	SELECT
			[inserted].[BLLICENSECLASSID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Description',
			ISNULL([deleted].[DESCRIPTION],'[none]'),
			ISNULL([inserted].[DESCRIPTION],'[none]'),
			'Business License Classification (' + [inserted].[NAME] + ')',
			'D421A946-9207-4034-8B98-80823509F64C',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[BLLICENSECLASSID] = [inserted].[BLLICENSECLASSID]
	WHERE	ISNULL([deleted].[DESCRIPTION],'') <> ISNULL([inserted].[DESCRIPTION],'')
END