﻿CREATE TABLE [dbo].[TASKSTATUS] (
    [TASKSTATUSID]   INT           NOT NULL,
    [TASKSTATUSNAME] NVARCHAR (30) NOT NULL,
    [ISCOMPLETED]    BIT           DEFAULT ((0)) NOT NULL,
    [LASTCHANGEDBY]  CHAR (36)     NULL,
    [LASTCHANGEDON]  DATETIME      CONSTRAINT [DF_TaskStatus_LastChangedOn] DEFAULT (getutcdate()) NOT NULL,
    [ROWVERSION]     INT           CONSTRAINT [DF_TaskStatus_RowVersion] DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_TaskStatus] PRIMARY KEY CLUSTERED ([TASKSTATUSID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_TASKSTATUS_USERS] FOREIGN KEY ([LASTCHANGEDBY]) REFERENCES [dbo].[USERS] ([SUSERGUID])
);


GO
CREATE NONCLUSTERED INDEX [TASKSTATUS_IX_QUERY]
    ON [dbo].[TASKSTATUS]([TASKSTATUSID] ASC, [TASKSTATUSNAME] ASC);


GO

CREATE TRIGGER [TG_TASKSTATUS_INSERT] ON TASKSTATUS
   FOR INSERT
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
			[inserted].[TASKSTATUSID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Task Status Added',
			'',
			'',
			'Task Status (' + [inserted].[TASKSTATUSNAME] + ')',
			'0E63515A-6BC3-4582-803B-7A1A396164DD',
			1,
			1,
			[inserted].[TASKSTATUSNAME]
	FROM	[inserted]	
END
GO

CREATE TRIGGER [TG_TASKSTATUS_UPDATE] ON TASKSTATUS
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
			[inserted].[TASKSTATUSID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Name',
			[deleted].[TASKSTATUSNAME],
			[inserted].[TASKSTATUSNAME],
			'Task Status (' + [inserted].[TASKSTATUSNAME] + ')',
			'0E63515A-6BC3-4582-803B-7A1A396164DD',
			2,
			1,
			[inserted].[TASKSTATUSNAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[TASKSTATUSID] = [inserted].[TASKSTATUSID]
	WHERE	[deleted].[TASKSTATUSNAME] <> [inserted].[TASKSTATUSNAME]	
	UNION ALL
	SELECT
			[inserted].[TASKSTATUSID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Is Completed Flag',
			CASE WHEN [deleted].[ISCOMPLETED] = 1 THEN 'Yes' ELSE 'No' END,
			CASE WHEN [inserted].[ISCOMPLETED] = 1 THEN 'Yes' ELSE 'No' END,
			'Task Status (' + [inserted].[TASKSTATUSNAME] + ')',
			'0E63515A-6BC3-4582-803B-7A1A396164DD',
			2,
			1,
			[inserted].[TASKSTATUSNAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[TASKSTATUSID] = [inserted].[TASKSTATUSID]
	WHERE	[deleted].[ISCOMPLETED] <> [inserted].[ISCOMPLETED]	
END
GO

CREATE TRIGGER [TG_TASKSTATUS_DELETE] ON TASKSTATUS
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
			[deleted].[TASKSTATUSID],
			[deleted].[ROWVERSION],
			GETUTCDATE(),
			(SELECT dbo.UFN_GET_USERID_FROM_CONTEXT_INFO()),
			'Task Status Deleted',
			'',
			'',
			'Task Status (' + [deleted].[TASKSTATUSNAME] + ')',
			'0E63515A-6BC3-4582-803B-7A1A396164DD',
			3,
			1,
			[deleted].[TASKSTATUSNAME]
	FROM	[deleted]
END