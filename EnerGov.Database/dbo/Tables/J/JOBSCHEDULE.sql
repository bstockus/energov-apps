CREATE TABLE [dbo].[JOBSCHEDULE] (
    [JOBSCHEDULEID]   CHAR (36)      NOT NULL,
    [NAME]            NVARCHAR (50)  NOT NULL,
    [CRONSTRING]      NVARCHAR (300) NOT NULL,
    [DESCRIPTION]     VARCHAR (MAX)  NULL,
    [ISCUSTOMCRON]    BIT            DEFAULT ((0)) NOT NULL,
    [RECURRANCE]      INT            DEFAULT ((0)) NOT NULL,
    [RECURRANCEID]    INT            DEFAULT ((0)) NOT NULL,
    [RECURRANCESTART] INT            DEFAULT ((0)) NOT NULL,
    [RECURRANCEEND]   INT            DEFAULT ((0)) NOT NULL,
    [LASTCHANGEDBY]   CHAR (36)      NULL,
    [LASTCHANGEDON]   DATETIME       CONSTRAINT [DF_JOBSCHEDULE_LastChangedOn] DEFAULT (getutcdate()) NOT NULL,
    [ROWVERSION]      INT            CONSTRAINT [DF_JOBSCHEDULE_RowVersion] DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_JOBSCHEDULEID] PRIMARY KEY CLUSTERED ([JOBSCHEDULEID] ASC) WITH (FILLFACTOR = 90)
);


GO
CREATE NONCLUSTERED INDEX [JOBSCHEDULE_IX_QUERY]
    ON [dbo].[JOBSCHEDULE]([JOBSCHEDULEID] ASC, [NAME] ASC);


GO

CREATE TRIGGER [dbo].[TG_JOBSCHEDULE_INSERT] ON [dbo].[JOBSCHEDULE]
   FOR INSERT
AS 
BEGIN
	SET NOCOUNT ON;
	-- Check if LASTCHANGEDBY contains VALID User Id and it Exists in USERS table, this is in replacement to foreign key reference of JOBSCHEDULE table with USERS table.
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
			[inserted].[JOBSCHEDULEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Windows Service Job Schedule Added',
			'',
			'',
			'Windows Service Job Schedule (' + [inserted].[NAME] + ')',
			'4BA74AA2-D1C6-49DA-961C-6D253CD00856',
			1,
			1,
			[inserted].[NAME]
	FROM	[inserted]	
END
GO

CREATE TRIGGER [dbo].[TG_JOBSCHEDULE_UPDATE] ON [dbo].[JOBSCHEDULE] 
	AFTER UPDATE
AS 
BEGIN
	SET NOCOUNT ON;
		
	-- Check if LASTCHANGEDBY contains VALID User Id and it Exists in USERS table, this is in replacement to foreign key reference of JOBSCHEDULE table with USERS table.
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
			[inserted].[JOBSCHEDULEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Name',
			[deleted].[NAME],
			[inserted].[NAME],
			'Windows Service Job Schedule (' + [inserted].[NAME] + ')',
			'4BA74AA2-D1C6-49DA-961C-6D253CD00856',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[JOBSCHEDULEID] = [inserted].[JOBSCHEDULEID]
	WHERE	[deleted].[NAME] <> [inserted].[NAME]
	
	UNION ALL
	SELECT
			[inserted].[JOBSCHEDULEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Cron Expression',
			[deleted].[CRONSTRING],
			[inserted].[CRONSTRING],
			'Windows Service Job Schedule (' + [inserted].[NAME] + ')',
			'4BA74AA2-D1C6-49DA-961C-6D253CD00856',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[JOBSCHEDULEID] = [inserted].[JOBSCHEDULEID]
	WHERE	[deleted].[CRONSTRING] <> [inserted].[CRONSTRING]
	
	UNION ALL
	SELECT
			[inserted].[JOBSCHEDULEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Description',
			ISNULL([deleted].[DESCRIPTION],'[none]'),
			ISNULL([inserted].[DESCRIPTION],'[none]'),
			'Windows Service Job Schedule (' + [inserted].[NAME] + ')',
			'4BA74AA2-D1C6-49DA-961C-6D253CD00856',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[JOBSCHEDULEID] = [inserted].[JOBSCHEDULEID]
	WHERE	ISNULL([deleted].[DESCRIPTION], '') <> ISNULL([inserted].[DESCRIPTION], '')

	UNION ALL
	SELECT
			[inserted].[JOBSCHEDULEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Custom Cron Expression Flag',
			CASE [deleted].[ISCUSTOMCRON] WHEN 1 THEN 'Yes' ELSE 'No' END,
			CASE [inserted].[ISCUSTOMCRON] WHEN 1 THEN 'Yes' ELSE 'No' END,
			'Windows Service Job Schedule (' + [inserted].[NAME] + ')',
			'4BA74AA2-D1C6-49DA-961C-6D253CD00856',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[JOBSCHEDULEID] = [inserted].[JOBSCHEDULEID]
	WHERE	[deleted].[ISCUSTOMCRON] <> [inserted].[ISCUSTOMCRON]

	UNION ALL
	SELECT
			[inserted].[JOBSCHEDULEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Recurrence',
			CONVERT(NVARCHAR(MAX), [deleted].[RECURRANCE]),
			CONVERT(NVARCHAR(MAX), [inserted].[RECURRANCE]),
			'Windows Service Job Schedule (' + [inserted].[NAME] + ')',
			'4BA74AA2-D1C6-49DA-961C-6D253CD00856',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[JOBSCHEDULEID] = [inserted].[JOBSCHEDULEID]
	WHERE	[deleted].[RECURRANCE] <> [inserted].[RECURRANCE]

	UNION ALL
	SELECT
			[inserted].[JOBSCHEDULEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Generic Setup',
			CASE
				WHEN [deleted].[RECURRANCEID] = 0 THEN 'Every X Second(s)'
				WHEN [deleted].[RECURRANCEID] = 1 THEN 'Every X Min(s)'
				WHEN [deleted].[RECURRANCEID] = 2 THEN 'Every X Hour(s)'
				WHEN [deleted].[RECURRANCEID] = 3 THEN 'Once A Day At '
				WHEN [deleted].[RECURRANCEID] = 4 THEN 'Every X Second(s) Between'
				WHEN [deleted].[RECURRANCEID] = 5 THEN 'Every X Min(s) Between'
				ELSE '[none]'
			END,
			CASE
				WHEN [inserted].[RECURRANCEID] = 0 THEN 'Every X Second(s)'
				WHEN [inserted].[RECURRANCEID] = 1 THEN 'Every X Min(s)'
				WHEN [inserted].[RECURRANCEID] = 2 THEN 'Every X Hour(s)'
				WHEN [inserted].[RECURRANCEID] = 3 THEN 'Once A Day At '
				WHEN [inserted].[RECURRANCEID] = 4 THEN 'Every X Second(s) Between'
				WHEN [inserted].[RECURRANCEID] = 5 THEN 'Every X Min(s) Between'
				ELSE '[none]'
			END,
			'Windows Service Job Schedule (' + [inserted].[NAME] + ')',
			'4BA74AA2-D1C6-49DA-961C-6D253CD00856',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[JOBSCHEDULEID] = [inserted].[JOBSCHEDULEID]
	WHERE	[deleted].[RECURRANCEID] <> [inserted].[RECURRANCEID]

	UNION ALL
	SELECT
			[inserted].[JOBSCHEDULEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Start Hour',
			CONVERT(NVARCHAR(MAX), [deleted].[RECURRANCESTART]),
			CONVERT(NVARCHAR(MAX), [inserted].[RECURRANCESTART]),
			'Windows Service Job Schedule (' + [inserted].[NAME] + ')',
			'4BA74AA2-D1C6-49DA-961C-6D253CD00856',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[JOBSCHEDULEID] = [inserted].[JOBSCHEDULEID]
	WHERE	[deleted].[RECURRANCESTART] <> [inserted].[RECURRANCESTART]

	UNION ALL
	SELECT
			[inserted].[JOBSCHEDULEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'End Hour',
			CONVERT(NVARCHAR(MAX), [deleted].[RECURRANCEEND]),
			CONVERT(NVARCHAR(MAX), [inserted].[RECURRANCEEND]),
			'Windows Service Job Schedule (' + [inserted].[NAME] + ')',
			'4BA74AA2-D1C6-49DA-961C-6D253CD00856',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[JOBSCHEDULEID] = [inserted].[JOBSCHEDULEID]
	WHERE	[deleted].[RECURRANCEEND] <> [inserted].[RECURRANCEEND]
END
GO

CREATE TRIGGER [dbo].[TG_JOBSCHEDULE_DELETE] ON [dbo].[JOBSCHEDULE]
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
			[deleted].[JOBSCHEDULEID],
			[deleted].[ROWVERSION],
			GETUTCDATE(),
			(SELECT dbo.UFN_GET_USERID_FROM_CONTEXT_INFO()),
			'Windows Service Job Schedule Deleted',
			'',
			'',
			'Windows Service Job Schedule (' + [deleted].[NAME] + ')',
			'4BA74AA2-D1C6-49DA-961C-6D253CD00856',
			3,
			1,
			[deleted].[NAME]
	FROM	[deleted]
END