CREATE TABLE [dbo].[CAPRORATESCHEDULE] (
    [CAPRORATESCHEDULEID] CHAR (36)      NOT NULL,
    [NAME]                NVARCHAR (50)  NOT NULL,
    [DESCRIPTION]         NVARCHAR (255) NULL,
    [LASTCHANGEDBY]       CHAR (36)      NULL,
    [LASTCHANGEDON]       DATETIME       CONSTRAINT [DF_CAPRORATESCHEDULE_LastChangedOn] DEFAULT (getutcdate()) NOT NULL,
    [ROWVERSION]          INT            CONSTRAINT [DF_CAPRORATESCHEDULE_RowVersion] DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_CAPRORATESCHEDULEID] PRIMARY KEY NONCLUSTERED ([CAPRORATESCHEDULEID] ASC) WITH (FILLFACTOR = 90)
);


GO
CREATE NONCLUSTERED INDEX [CAPRORATESCHEDULE_IX_QUERY]
    ON [dbo].[CAPRORATESCHEDULE]([CAPRORATESCHEDULEID] ASC, [NAME] ASC);


GO

CREATE TRIGGER [dbo].[TG_CAPRORATESCHEDULE_INSERT] ON [dbo].[CAPRORATESCHEDULE]
   AFTER INSERT
AS 
BEGIN
	SET NOCOUNT ON;

	-- Check if LASTCHANGEDBY contains VALID User Id and it Exists in USERS table, this is in replacement to foreign key reference of CAPRORATESCHEDULE table with USERS table.
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
        [inserted].[CAPRORATESCHEDULEID], 
        [inserted].[ROWVERSION],
        GETUTCDATE(),
        [inserted].[LASTCHANGEDBY],
        'Fee Proration Schedule Added',
        '',
        '',
        'Fee Proration Schedule (' + [inserted].[NAME] + ')',
		'60202A23-63F9-4A1D-AAD1-0D0EA25448DB',
		1,
		1,
		[inserted].[NAME]
    FROM [inserted] 
END
GO

CREATE TRIGGER [dbo].[TG_CAPRORATESCHEDULE_UPDATE] ON [dbo].[CAPRORATESCHEDULE]
   AFTER UPDATE
AS 
BEGIN	
	SET NOCOUNT ON;

	-- Check if LASTCHANGEDBY contains VALID User Id and it Exists in USERS table, this is in replacement to foreign key reference of CAPRORATESCHEDULE table with USERS table.
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
			[inserted].[CAPRORATESCHEDULEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Name',
			[deleted].[NAME],
			[inserted].[NAME],
			'Fee Proration Schedule (' + [inserted].[NAME] + ')',
			'60202A23-63F9-4A1D-AAD1-0D0EA25448DB',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[CAPRORATESCHEDULEID] = [inserted].[CAPRORATESCHEDULEID]
	WHERE	[deleted].[NAME] <> [inserted].[NAME]
	UNION ALL
	SELECT
			[inserted].[CAPRORATESCHEDULEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Description',
			ISNULL([deleted].[DESCRIPTION],'[none]'),
			ISNULL([inserted].[DESCRIPTION],'[none]'),
			'Fee Proration Schedule (' + [inserted].[NAME] + ')',
			'60202A23-63F9-4A1D-AAD1-0D0EA25448DB',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[CAPRORATESCHEDULEID] = [inserted].[CAPRORATESCHEDULEID]
	WHERE	ISNULL([deleted].[DESCRIPTION],'') <> ISNULL([inserted].[DESCRIPTION],'')
END
GO

CREATE TRIGGER [dbo].[TG_CAPRORATESCHEDULE_DELETE] ON [dbo].[CAPRORATESCHEDULE]
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
			[deleted].[CAPRORATESCHEDULEID],
			[deleted].[ROWVERSION],
			GETUTCDATE(),
			(SELECT dbo.UFN_GET_USERID_FROM_CONTEXT_INFO()),
			'Fee Proration Schedule Deleted',
			'',
			'',
			'Fee Proration Schedule (' + [deleted].[NAME] + ')',
			'60202A23-63F9-4A1D-AAD1-0D0EA25448DB',
			3,
			1,
			[deleted].[NAME]
	FROM	[deleted]
END