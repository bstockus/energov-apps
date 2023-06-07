CREATE TABLE [dbo].[BONDSTATUS] (
    [BONDSTATUSID]  CHAR (36)      NOT NULL,
    [NAME]          NVARCHAR (50)  NOT NULL,
    [DESCRIPTION]   NVARCHAR (MAX) NULL,
    [SUCCESSFLAG]   BIT            NOT NULL,
    [FAILUREFLAG]   BIT            NOT NULL,
    [CANCELLEDFLAG] BIT            DEFAULT ((0)) NOT NULL,
    [LASTCHANGEDBY] CHAR (36)      NULL,
    [LASTCHANGEDON] DATETIME       CONSTRAINT [DF_BONDSTATUS_LastChangedOn] DEFAULT (getutcdate()) NOT NULL,
    [ROWVERSION]    INT            CONSTRAINT [DF_BONDSTATUS_RowVersion] DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_BondStatus] PRIMARY KEY CLUSTERED ([BONDSTATUSID] ASC) WITH (FILLFACTOR = 90)
);


GO
CREATE NONCLUSTERED INDEX [BONDSTATUS_IX_QUERY]
    ON [dbo].[BONDSTATUS]([BONDSTATUSID] ASC, [NAME] ASC);


GO

CREATE TRIGGER [dbo].[TG_BONDSTATUS_DELETE]
   ON  [dbo].[BONDSTATUS]
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
			[deleted].[BONDSTATUSID],
			[deleted].[ROWVERSION],
			GETUTCDATE(),
			(SELECT dbo.UFN_GET_USERID_FROM_CONTEXT_INFO()),
			'Bond Status Deleted',
			'',
			'',
			'Bond Status (' + [deleted].[NAME] + ')',
			'2C2A2D24-8650-4703-B4DC-F030B50B74C8',
			3,
			1,
			[deleted].[NAME]
	FROM	[deleted]
END
GO

CREATE TRIGGER [dbo].[TG_BONDSTATUS_INSERT] ON [dbo].[BONDSTATUS]
   AFTER INSERT
AS 
BEGIN
	SET NOCOUNT ON;

	-- Check if LASTCHANGEDBY contains VALID User Id and it Exists in USERS table, this is in replacement to foreign key reference of BONDSTATUS table with USERS table.
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
        [inserted].[BONDSTATUSID], 
        [inserted].[ROWVERSION],
        GETUTCDATE(),
        [inserted].[LASTCHANGEDBY],
        'Bond Status Added',
        '',
        '',
        'Bond Status (' + [inserted].[NAME] + ')',
		'2C2A2D24-8650-4703-B4DC-F030B50B74C8',
		1,
		1,
		[inserted].[NAME]
    FROM [inserted] 
END
GO

CREATE TRIGGER [dbo].[TG_BONDSTATUS_UPDATE] 
   ON  [dbo].[BONDSTATUS]
   AFTER UPDATE
AS 
BEGIN	
	SET NOCOUNT ON;

	-- Check if LASTCHANGEDBY contains VALID User Id and it Exists in USERS table, this is in replacement to foreign key reference of BONDSTATUS table with USERS table.
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
			[inserted].[BONDSTATUSID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Name',
			[deleted].[NAME],
			[inserted].[NAME],
			'Bond Status (' + [inserted].[NAME] + ')',
			'2C2A2D24-8650-4703-B4DC-F030B50B74C8',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[BONDSTATUSID] = [inserted].[BONDSTATUSID]
	WHERE	[deleted].[NAME] <> [inserted].[NAME]
	UNION ALL
	SELECT
			[inserted].[BONDSTATUSID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Description',
			ISNULL([deleted].[DESCRIPTION],'[none]'),
			ISNULL([inserted].[DESCRIPTION],'[none]'),
			'Bond Status (' + [inserted].[NAME] + ')',
			'2C2A2D24-8650-4703-B4DC-F030B50B74C8',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[BONDSTATUSID] = [inserted].[BONDSTATUSID]
	WHERE	ISNULL([deleted].[DESCRIPTION],'') <> ISNULL([inserted].[DESCRIPTION],'')
	UNION ALL
	SELECT
			[inserted].[BONDSTATUSID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Active Flag',
			CASE WHEN [deleted].[SUCCESSFLAG] = 1 THEN 'Yes' ELSE 'No' END,
			CASE WHEN [inserted].[SUCCESSFLAG] = 1 THEN 'Yes' ELSE 'No' END,
			'Bond Status (' + [inserted].[NAME] + ')',
			'2C2A2D24-8650-4703-B4DC-F030B50B74C8',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[BONDSTATUSID] = [inserted].[BONDSTATUSID]
	WHERE	[deleted].[SUCCESSFLAG] <> [inserted].[SUCCESSFLAG]
	UNION ALL
	SELECT
			[inserted].[BONDSTATUSID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Non-Active Flag',
			CASE WHEN [deleted].[FAILUREFLAG] = 1 THEN 'Yes' ELSE 'No' END,
			CASE WHEN [inserted].[FAILUREFLAG] = 1 THEN 'Yes' ELSE 'No' END,
			'Bond Status (' + [inserted].[NAME] + ')',
			'2C2A2D24-8650-4703-B4DC-F030B50B74C8',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[BONDSTATUSID] = [inserted].[BONDSTATUSID]
	WHERE	[deleted].[FAILUREFLAG] <> [inserted].[FAILUREFLAG]
	UNION ALL
	SELECT
			[inserted].[BONDSTATUSID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Cancelled Flag',
			CASE WHEN [deleted].[CANCELLEDFLAG] = 1 THEN 'Yes' ELSE 'No' END,
			CASE WHEN [inserted].[CANCELLEDFLAG] = 1 THEN 'Yes' ELSE 'No' END,
			'Bond Status (' + [inserted].[NAME] + ')',
			'2C2A2D24-8650-4703-B4DC-F030B50B74C8',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[BONDSTATUSID] = [inserted].[BONDSTATUSID]
	WHERE	[deleted].[CANCELLEDFLAG] <> [inserted].[CANCELLEDFLAG]
END