CREATE TABLE [dbo].[BONDINTADJREASON] (
    [BONDINTADJREASONID] CHAR (36)     NOT NULL,
    [NAME]               NVARCHAR (50) NOT NULL,
    [LASTCHANGEDBY]      CHAR (36)     NULL,
    [LASTCHANGEDON]      DATETIME      CONSTRAINT [DF_BONDINTADJREASON_LastChangedOn] DEFAULT (getutcdate()) NOT NULL,
    [ROWVERSION]         INT           CONSTRAINT [DF_BONDINTADJREASON_RowVersion] DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_BONDINTADJREASON] PRIMARY KEY CLUSTERED ([BONDINTADJREASONID] ASC) WITH (FILLFACTOR = 90)
);


GO
CREATE NONCLUSTERED INDEX [BONDINTADJREASON_IX_QUERY]
    ON [dbo].[BONDINTADJREASON]([BONDINTADJREASONID] ASC, [NAME] ASC);


GO

CREATE TRIGGER [dbo].[TG_BONDINTADJREASON_UPDATE] ON  [dbo].[BONDINTADJREASON]
   AFTER UPDATE
AS 
BEGIN	
	SET NOCOUNT ON;

	-- Check if LASTCHANGEDBY contains VALID User Id and it Exists in USERS table, this is in replacement to foreign key reference of BONDINTADJREASON table with USERS table.
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
			[inserted].[BONDINTADJREASONID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Reason Name',
			[deleted].[NAME],
			[inserted].[NAME],
			'Bond Interest Adjustment Reason (' + [inserted].[NAME] + ')',
			'6C18BFD9-375B-4842-8E4A-7200872180BB',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[BONDINTADJREASONID] = [inserted].[BONDINTADJREASONID]
	WHERE	[deleted].[NAME] <> [inserted].[NAME]
END
GO

CREATE TRIGGER [dbo].[TG_BONDINTADJREASON_INSERT] ON [dbo].[BONDINTADJREASON]
   AFTER INSERT
AS 
BEGIN
	SET NOCOUNT ON;

	-- Check if LASTCHANGEDBY contains VALID User Id and it Exists in USERS table, this is in replacement to foreign key reference of BONDINTADJREASON table with USERS table
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
        [inserted].[BONDINTADJREASONID], 
        [inserted].[ROWVERSION],
        GETUTCDATE(),
        [inserted].[LASTCHANGEDBY],
        'Bond Interest Adjustment Reason Added',
        '',
        '',
        'Bond Interest Adjustment Reason (' + [inserted].[NAME] + ')',
		'6C18BFD9-375B-4842-8E4A-7200872180BB',
		1,
		1,
		[inserted].[NAME]
    FROM [inserted] 
END
GO

CREATE TRIGGER [dbo].[TG_BONDINTADJREASON_DELETE]  ON  [dbo].[BONDINTADJREASON]
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
			[deleted].[BONDINTADJREASONID],
			[deleted].[ROWVERSION],
			GETUTCDATE(),
			(SELECT dbo.UFN_GET_USERID_FROM_CONTEXT_INFO()),
			'Bond Interest Adjustment Reason Deleted',
			'',
			'',
			'Bond Interest Adjustment Reason (' + [deleted].[NAME] + ')',
			'6C18BFD9-375B-4842-8E4A-7200872180BB',
			3,
			1,
			[deleted].[NAME]
	FROM	[deleted]
END