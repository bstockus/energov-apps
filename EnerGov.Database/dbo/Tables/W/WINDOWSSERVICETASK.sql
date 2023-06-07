CREATE TABLE [dbo].[WINDOWSSERVICETASK] (
    [WINDOWSSERVICETASKID] INT             NOT NULL,
    [NAME]                 NVARCHAR (50)   NOT NULL,
    [DESCRIPTION]          NVARCHAR (2000) NOT NULL,
    [THROTTLE]             INT             DEFAULT ((0)) NOT NULL,
    [ISENABLED]            BIT             DEFAULT ((1)) NOT NULL,
    [JOBSCHEDULEID]        CHAR (36)       NULL,
    [ISREADY]              BIT             DEFAULT ((0)) NOT NULL,
    [RETRY]                INT             DEFAULT ((5)) NULL,
    [LASTCHANGEDBY]        CHAR (36)       NULL,
    [LASTCHANGEDON]        DATETIME        CONSTRAINT [DF_WINDOWSSERVICETASK_LastChangedOn] DEFAULT (getutcdate()) NOT NULL,
    [ROWVERSION]           INT             CONSTRAINT [DF_WINDOWSSERVICETASK_RowVersion] DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_WINDOWSSERVICETASKID] PRIMARY KEY CLUSTERED ([WINDOWSSERVICETASKID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_SERVICETASKTOJOBSCHED] FOREIGN KEY ([JOBSCHEDULEID]) REFERENCES [dbo].[JOBSCHEDULE] ([JOBSCHEDULEID])
);


GO
CREATE NONCLUSTERED INDEX [WINDOWSSERVICETASK_IX_QUERY]
    ON [dbo].[WINDOWSSERVICETASK]([WINDOWSSERVICETASKID] ASC, [NAME] ASC);


GO


CREATE TRIGGER [TG_WINDOWSSERVICETASK_UPDATE] ON [dbo].[WINDOWSSERVICETASK]
   AFTER UPDATE
AS 
BEGIN
	SET NOCOUNT ON;

	-- Check if LASTCHANGEDBY contains VALID User Id and it Exists in USERS table, this is in replacement to foreign key reference of WINDOWSSERVICETASK table with USERS table.
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
			[inserted].[WINDOWSSERVICETASKID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Name',
			[deleted].[NAME],
			[inserted].[NAME],
			'Windows Service Schedule Task (' + [inserted].[NAME] + ')',
			'0235B443-1680-47B9-B273-484A05D57986',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[WINDOWSSERVICETASKID] = [inserted].[WINDOWSSERVICETASKID]
	WHERE	[deleted].[NAME] <> [inserted].[NAME]
	UNION ALL
	SELECT
			[inserted].[WINDOWSSERVICETASKID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Description',
			[deleted].[DESCRIPTION],
			[inserted].[DESCRIPTION],
			'Windows Service Schedule Task (' + [inserted].[NAME] + ')',
			'0235B443-1680-47B9-B273-484A05D57986',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[WINDOWSSERVICETASKID] = [inserted].[WINDOWSSERVICETASKID]
	WHERE	[deleted].[DESCRIPTION] <> [inserted].[DESCRIPTION]
	UNION ALL
	SELECT
			[inserted].[WINDOWSSERVICETASKID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Throttle',
			CONVERT(NVARCHAR(MAX), [deleted].[THROTTLE]),
			CONVERT(NVARCHAR(MAX), [inserted].[THROTTLE]),
			'Windows Service Schedule Task (' + [inserted].[NAME] + ')',
			'0235B443-1680-47B9-B273-484A05D57986',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[WINDOWSSERVICETASKID] = [inserted].[WINDOWSSERVICETASKID]
	WHERE	[deleted].[THROTTLE] <> [inserted].[THROTTLE]
	UNION ALL
	SELECT
			[inserted].[WINDOWSSERVICETASKID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Is Enabled Flag',
			CASE [deleted].[ISENABLED] WHEN 1 THEN 'Yes' ELSE 'No' END,
			CASE [inserted].[ISENABLED] WHEN 1 THEN 'Yes' ELSE 'No' END,
			'Windows Service Schedule Task (' + [inserted].[NAME] + ')',
			'0235B443-1680-47B9-B273-484A05D57986',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[WINDOWSSERVICETASKID] = [inserted].[WINDOWSSERVICETASKID]
	WHERE	[deleted].[ISENABLED] <> [inserted].[ISENABLED]
	UNION ALL
	SELECT
			[inserted].[WINDOWSSERVICETASKID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Ready Flag',
			CASE [deleted].[ISREADY] WHEN 1 THEN 'Yes' ELSE 'No' END,
			CASE [inserted].[ISREADY] WHEN 1 THEN 'Yes' ELSE 'No' END,
			'Windows Service Schedule Task (' + [inserted].[NAME] + ')',
			'0235B443-1680-47B9-B273-484A05D57986',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[WINDOWSSERVICETASKID] = [inserted].[WINDOWSSERVICETASKID]
	WHERE	[deleted].[ISREADY] <> [inserted].[ISREADY]
	UNION ALL
	SELECT
			[inserted].[WINDOWSSERVICETASKID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Schedule',
			ISNULL([JOBSCHEDULE_DELETED].[NAME], '[none]'),
			ISNULL([JOBSCHEDULE_INSERTED].[NAME], '[none]'),
			'Windows Service Schedule Task (' + [inserted].[NAME] + ')',
			'0235B443-1680-47B9-B273-484A05D57986',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[WINDOWSSERVICETASKID] = [inserted].[WINDOWSSERVICETASKID]
			LEFT JOIN [JOBSCHEDULE] JOBSCHEDULE_INSERTED WITH (NOLOCK) ON [JOBSCHEDULE_INSERTED].[JOBSCHEDULEID] = [inserted].[JOBSCHEDULEID]
			LEFT JOIN [JOBSCHEDULE] JOBSCHEDULE_DELETED WITH (NOLOCK) ON [JOBSCHEDULE_DELETED].[JOBSCHEDULEID] = [deleted].[JOBSCHEDULEID]
	WHERE	ISNULL([deleted].[JOBSCHEDULEID], '') <> ISNULL([inserted].[JOBSCHEDULEID], '')
	UNION ALL
	SELECT
			[inserted].[WINDOWSSERVICETASKID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Retry Count',
			ISNULL(CONVERT(NVARCHAR(MAX), [deleted].[RETRY]), '[none]'),
			ISNULL(CONVERT(NVARCHAR(MAX), [inserted].[RETRY]), '[none]'),
			'Windows Service Schedule Task (' + [inserted].[NAME] + ')',
			'0235B443-1680-47B9-B273-484A05D57986',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[WINDOWSSERVICETASKID] = [inserted].[WINDOWSSERVICETASKID]
	WHERE	ISNULL([deleted].[RETRY], '') <> ISNULL([inserted].[RETRY], '')
END