﻿CREATE TABLE [dbo].[SCHEDULEPRIORITYSTATUS] (
    [SCHEDULEPRIORITYSTATUSID] CHAR (36)      NOT NULL,
    [NAME]                     NVARCHAR (100) NOT NULL,
    [SYSTEMPRIORITY]           INT            NOT NULL,
    [LASTCHANGEDBY]            CHAR (36)      NULL,
    [LASTCHANGEDON]            DATETIME       CONSTRAINT [DF_SCHEDULEPRIORITYSTATUS_LastChangedOn] DEFAULT (getutcdate()) NOT NULL,
    [ROWVERSION]               INT            CONSTRAINT [DF_SCHEDULEPRIORITYSTATUS_RowVersion] DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_SchedulePriorityStatus] PRIMARY KEY CLUSTERED ([SCHEDULEPRIORITYSTATUSID] ASC) WITH (FILLFACTOR = 90)
);


GO
CREATE NONCLUSTERED INDEX [SCHEDULEPRIORITYSTATUS_IX_QUERY]
    ON [dbo].[SCHEDULEPRIORITYSTATUS]([SCHEDULEPRIORITYSTATUSID] ASC, [NAME] ASC);


GO

CREATE TRIGGER [TG_SCHEDULEPRIORITYSTATUS_INSERT] ON [SCHEDULEPRIORITYSTATUS]
   FOR INSERT
AS 
BEGIN	
	SET NOCOUNT ON;

	-- Check if LASTCHANGEDBY contains VALID User Id and it Exists in USERS table, this is in replacement to foreign key reference of SCHEDULEPRIORITYSTATUS table with USERS table.
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
			[inserted].[SCHEDULEPRIORITYSTATUSID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Global Schedule Priority Status Added',
			'',
			'',
			'Global Schedule Priority Status (' + [inserted].[NAME] + ')',
			'859EAD1B-FDA5-4D36-9B49-288EC0483D4B',
			1,
			1,
			[inserted].[NAME]
	FROM	[inserted]	
END
GO

CREATE TRIGGER [TG_SCHEDULEPRIORITYSTATUS_UPDATE] ON [SCHEDULEPRIORITYSTATUS]
   AFTER UPDATE
AS 
BEGIN
	SET NOCOUNT ON;

	-- Check if LASTCHANGEDBY contains VALID User Id and it Exists in USERS table, this is in replacement to foreign key reference of SCHEDULEPRIORITYSTATUS table with USERS table.
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
			[inserted].[SCHEDULEPRIORITYSTATUSID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Name',
			[deleted].[NAME],
			[inserted].[NAME],
			'Global Schedule Priority Status (' + [inserted].[NAME] + ')',
			'859EAD1B-FDA5-4D36-9B49-288EC0483D4B',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[SCHEDULEPRIORITYSTATUSID] = [inserted].[SCHEDULEPRIORITYSTATUSID]
	WHERE	[deleted].[NAME] <> [inserted].[NAME]	
	UNION ALL
	SELECT
			[inserted].[SCHEDULEPRIORITYSTATUSID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'System Priority',
			CONVERT(NVARCHAR(MAX), [deleted].[SYSTEMPRIORITY]),
			CONVERT(NVARCHAR(MAX), [inserted].[SYSTEMPRIORITY]),
			'Global Schedule Priority Status (' + [inserted].[NAME] + ')',
			'859EAD1B-FDA5-4D36-9B49-288EC0483D4B',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[SCHEDULEPRIORITYSTATUSID] = [inserted].[SCHEDULEPRIORITYSTATUSID]
	WHERE	[deleted].[SYSTEMPRIORITY] <> [inserted].[SYSTEMPRIORITY]
END
GO

CREATE TRIGGER [TG_SCHEDULEPRIORITYSTATUS_DELETE] ON [SCHEDULEPRIORITYSTATUS]
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
			[deleted].[SCHEDULEPRIORITYSTATUSID],
			[deleted].[ROWVERSION],
			GETUTCDATE(),
			(SELECT dbo.UFN_GET_USERID_FROM_CONTEXT_INFO()),
			'Global Schedule Priority Status Deleted',
			'',
			'',
			'Global Schedule Priority Status (' + [deleted].[NAME] + ')',
			'859EAD1B-FDA5-4D36-9B49-288EC0483D4B',
			3,
			1,
			[deleted].[NAME]
	FROM	[deleted]
END