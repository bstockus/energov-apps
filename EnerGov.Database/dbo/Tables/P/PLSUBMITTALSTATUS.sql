CREATE TABLE [dbo].[PLSUBMITTALSTATUS] (
    [PLSUBMITTALSTATUSID] CHAR (36)      NOT NULL,
    [NAME]                NVARCHAR (50)  NOT NULL,
    [DESCRIPTION]         NVARCHAR (MAX) NULL,
    [SUCCESSFLAG]         BIT            DEFAULT ((0)) NOT NULL,
    [FAILUREFLAG]         BIT            DEFAULT ((0)) NOT NULL,
    [DESCRIPTION_SPANISH] NVARCHAR (MAX) NULL,
    [NOTREQUIREDFLAG]     BIT            DEFAULT ((0)) NOT NULL,
    [LASTCHANGEDBY]       CHAR (36)      NULL,
    [LASTCHANGEDON]       DATETIME       CONSTRAINT [DF_PLSUBMITTALSTATUS_LastChangedOn] DEFAULT (getutcdate()) NOT NULL,
    [ROWVERSION]          INT            CONSTRAINT [DF_PLSUBMITTALSTATUS_RowVersion] DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_PLSubmittalStatus] PRIMARY KEY CLUSTERED ([PLSUBMITTALSTATUSID] ASC) WITH (FILLFACTOR = 90)
);


GO
CREATE NONCLUSTERED INDEX [PLSUBMITTALSTATUS_IX_QUERY]
    ON [dbo].[PLSUBMITTALSTATUS]([PLSUBMITTALSTATUSID] ASC, [NAME] ASC);


GO
CREATE TRIGGER [dbo].[TG_PLSUBMITTALSTATUS_DELETE] ON [dbo].[PLSUBMITTALSTATUS]
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
			[deleted].[PLSUBMITTALSTATUSID],
			[deleted].[ROWVERSION],
			GETUTCDATE(),
			(SELECT dbo.UFN_GET_USERID_FROM_CONTEXT_INFO()),
			'Submittal Status Deleted',
			'',
			'',
			'Submittal Status (' + [deleted].[NAME] + ')',
			'779CD44F-31C0-4D13-A416-CB918F52189B',
			3,
			1,
			[deleted].[NAME]
	FROM	[deleted]
END
GO
CREATE TRIGGER [dbo].[TG_PLSUBMITTALSTATUS_UPDATE] ON [dbo].[PLSUBMITTALSTATUS] 
	AFTER UPDATE
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
			[inserted].[PLSUBMITTALSTATUSID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Name',
			[deleted].[NAME],
			[inserted].[NAME],
			'Submittal Status (' + [inserted].[NAME] + ')',
			'779CD44F-31C0-4D13-A416-CB918F52189B',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[PLSUBMITTALSTATUSID] = [inserted].[PLSUBMITTALSTATUSID]
	WHERE	[deleted].[NAME] <> [inserted].[NAME]
	UNION ALL

	SELECT
			[inserted].[PLSUBMITTALSTATUSID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Description',
			ISNULL([deleted].[DESCRIPTION],'[none]'),
			ISNULL([inserted].[DESCRIPTION],'[none]'),
			'Submittal Status (' + [inserted].[NAME] + ')',
			'779CD44F-31C0-4D13-A416-CB918F52189B',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[PLSUBMITTALSTATUSID] = [inserted].[PLSUBMITTALSTATUSID]
	WHERE	ISNULL([deleted].[DESCRIPTION], '') <> ISNULL([inserted].[DESCRIPTION], '')
	UNION ALL

	SELECT
			[inserted].[PLSUBMITTALSTATUSID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Description Spanish',
			ISNULL([deleted].[DESCRIPTION_SPANISH],'[none]'),
			ISNULL([inserted].[DESCRIPTION_SPANISH],'[none]'),
			'Submittal Status (' + [inserted].[NAME] + ')',
			'779CD44F-31C0-4D13-A416-CB918F52189B',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[PLSUBMITTALSTATUSID] = [inserted].[PLSUBMITTALSTATUSID]
	WHERE	ISNULL([deleted].[DESCRIPTION_SPANISH], '') <> ISNULL([inserted].[DESCRIPTION_SPANISH], '')
	UNION ALL

	SELECT
			[inserted].[PLSUBMITTALSTATUSID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Success Flag',
			CASE [deleted].[SUCCESSFLAG] WHEN 1 THEN 'Yes' ELSE 'No' END,
			CASE [inserted].[SUCCESSFLAG] WHEN 1 THEN 'Yes' ELSE 'No' END,
			'Submittal Status (' + [inserted].[NAME] + ')',
			'779CD44F-31C0-4D13-A416-CB918F52189B',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[PLSUBMITTALSTATUSID] = [inserted].[PLSUBMITTALSTATUSID]
	WHERE	[deleted].[SUCCESSFLAG] <> [inserted].[SUCCESSFLAG]
	UNION ALL

	SELECT
			[inserted].[PLSUBMITTALSTATUSID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Failure Flag',
			CASE [deleted].[FAILUREFLAG] WHEN 1 THEN 'Yes' ELSE 'No' END,
			CASE [inserted].[FAILUREFLAG] WHEN 1 THEN 'Yes' ELSE 'No' END,
			'Submittal Status (' + [inserted].[NAME] + ')',
			'779CD44F-31C0-4D13-A416-CB918F52189B',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[PLSUBMITTALSTATUSID] = [inserted].[PLSUBMITTALSTATUSID]
	WHERE	[deleted].[FAILUREFLAG] <> [inserted].[FAILUREFLAG]
	UNION ALL

	SELECT
			[inserted].[PLSUBMITTALSTATUSID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Not Required Flag',
			CASE [deleted].[NOTREQUIREDFLAG] WHEN 1 THEN 'Yes' ELSE 'No' END,
			CASE [inserted].[NOTREQUIREDFLAG] WHEN 1 THEN 'Yes' ELSE 'No' END,
			'Submittal Status (' + [inserted].[NAME] + ')',
			'779CD44F-31C0-4D13-A416-CB918F52189B',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[PLSUBMITTALSTATUSID] = [inserted].[PLSUBMITTALSTATUSID]
	WHERE	[deleted].[NOTREQUIREDFLAG] <> [inserted].[NOTREQUIREDFLAG]	
END
GO
CREATE TRIGGER [dbo].[TG_PLSUBMITTALSTATUS_INSERT] ON [dbo].[PLSUBMITTALSTATUS]
   FOR INSERT
AS 
BEGIN
	SET NOCOUNT ON;
	-- Check if LASTCHANGEDBY contains VALID User Id and it Exists in USERS table, this is in replacement to foreign key reference of PLITEMREVIEWSTATUS table with USERS table.
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
			[inserted].[PLSUBMITTALSTATUSID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Submittal Status Added',
			'',
			'',
			'Submittal Status (' + [inserted].[NAME] + ')',
			'779CD44F-31C0-4D13-A416-CB918F52189B',
			1,
			1,
			[inserted].[NAME]
	FROM	[inserted]	
END