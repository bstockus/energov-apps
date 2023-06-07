CREATE TABLE [dbo].[EXAMSTATUS] (
    [EXAMSTATUSID]  CHAR (36)      NOT NULL,
    [NAME]          NVARCHAR (50)  NOT NULL,
    [DESCRIPTION]   NVARCHAR (MAX) NULL,
    [LASTCHANGEDBY] CHAR (36)      NULL,
    [LASTCHANGEDON] DATETIME       CONSTRAINT [DF_EXAMSTATUS_LastChangedOn] DEFAULT (getutcdate()) NOT NULL,
    [ROWVERSION]    INT            CONSTRAINT [DF_EXAMSTATUS_RowVersion] DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_EXAMSTATUS] PRIMARY KEY CLUSTERED ([EXAMSTATUSID] ASC) WITH (FILLFACTOR = 90)
);


GO
CREATE NONCLUSTERED INDEX [EXAMSTATUS_IX_QUERY]
    ON [dbo].[EXAMSTATUS]([EXAMSTATUSID] ASC, [NAME] ASC);


GO

CREATE TRIGGER [dbo].[TG_EXAMSTATUS_DELETE] ON  [dbo].[EXAMSTATUS]
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
			[deleted].[EXAMSTATUSID],
			[deleted].[ROWVERSION],
			GETUTCDATE(),
			(SELECT dbo.UFN_GET_USERID_FROM_CONTEXT_INFO()),
			'Exam Status Deleted',
			'',
			'',
			'Exam Status (' + [deleted].[NAME] + ')',
			'FDD87A9F-978D-4CD8-A406-1507D4426945',
			3,
			1,
			[deleted].[NAME]
	FROM	[deleted]
END
GO

CREATE TRIGGER [dbo].[TG_EXAMSTATUS_UPDATE] ON  [dbo].[EXAMSTATUS]
   AFTER UPDATE
AS 
BEGIN	
	SET NOCOUNT ON;

	-- Check if LASTCHANGEDBY contains VALID User Id and it Exists in USERS table, this is in replacement to foreign key reference of EXAMSTATUS table with USERS table.
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
			[inserted].[EXAMSTATUSID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Name',
			[deleted].[NAME],
			[inserted].[NAME],
			'Exam Status (' + [inserted].[NAME] + ')',
			'FDD87A9F-978D-4CD8-A406-1507D4426945',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[EXAMSTATUSID] = [inserted].[EXAMSTATUSID]
	WHERE	[deleted].[NAME] <> [inserted].[NAME]
	UNION ALL
	SELECT
			[inserted].[EXAMSTATUSID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Description',
			ISNULL([deleted].[DESCRIPTION],'[none]'),
			ISNULL([inserted].[DESCRIPTION],'[none]'),
			'Exam Status (' + [inserted].[NAME] + ')',
			'FDD87A9F-978D-4CD8-A406-1507D4426945',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[EXAMSTATUSID] = [inserted].[EXAMSTATUSID]
	WHERE	ISNULL([deleted].[DESCRIPTION],'') <> ISNULL([inserted].[DESCRIPTION],'')
END
GO


CREATE TRIGGER [dbo].[TG_EXAMSTATUS_INSERT] ON [dbo].[EXAMSTATUS]
   AFTER INSERT
AS 
BEGIN
	SET NOCOUNT ON;

	-- Check if LASTCHANGEDBY contains VALID User Id and it Exists in USERS table, this is in replacement to foreign key reference of EXAMSTATUS table with USERS table.
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
        [inserted].[EXAMSTATUSID], 
        [inserted].[ROWVERSION],
        GETUTCDATE(),
        [inserted].[LASTCHANGEDBY],
        'Exam Status Added',
        '',
        '',
        'Exam Status (' + [inserted].[NAME] + ')',
		'FDD87A9F-978D-4CD8-A406-1507D4426945',
		1,
		1,
		[inserted].[NAME]
    FROM [inserted] 
END