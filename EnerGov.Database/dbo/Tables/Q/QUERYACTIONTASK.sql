﻿CREATE TABLE [dbo].[QUERYACTIONTASK] (
    [QUERYACTIONTASKID]   CHAR (36)      NOT NULL,
    [QUERYACTIONID]       CHAR (36)      NOT NULL,
    [TASKSUBJECT]         NVARCHAR (MAX) NOT NULL,
    [TASKTEXT]            NVARCHAR (MAX) NOT NULL,
    [STARTDATE]           NVARCHAR (MAX) NOT NULL,
    [DUEDATE]             NVARCHAR (MAX) NOT NULL,
    [STARTTIME]           NVARCHAR (MAX) NOT NULL,
    [DUETIME]             NVARCHAR (MAX) NOT NULL,
    [STARTDATEOFFSETDAYS] INT            NOT NULL,
    [DUEDATEOFFSETDAYS]   INT            NOT NULL,
    [TASKPRIORITYID]      INT            NOT NULL,
    [SHOWONCALENDAR]      BIT            NOT NULL,
    [ASSIGNEDTO]          NVARCHAR (MAX) NOT NULL,
    CONSTRAINT [PK_QUERYACTIONTASK] PRIMARY KEY CLUSTERED ([QUERYACTIONTASKID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_QUERYACTIONTASK_QA] FOREIGN KEY ([QUERYACTIONID]) REFERENCES [dbo].[QUERYACTION] ([QUERYACTIONID]),
    CONSTRAINT [FK_QUERYACTIONTASK_TP] FOREIGN KEY ([TASKPRIORITYID]) REFERENCES [dbo].[TASKPRIORITY] ([TASKPRIORITYID])
);


GO
CREATE NONCLUSTERED INDEX [QUERYACTIONTASK_QUERYACTIONID]
    ON [dbo].[QUERYACTIONTASK]([QUERYACTIONID] ASC);


GO
CREATE NONCLUSTERED INDEX [QUERYACTIONTASK_TASKPRIORITYID]
    ON [dbo].[QUERYACTIONTASK]([TASKPRIORITYID] ASC);


GO

CREATE TRIGGER [dbo].[TG_QUERYACTIONTASK_UPDATE]
   ON  [dbo].[QUERYACTIONTASK]
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
			[QUERY].[QUERYID], 
			[QUERY].[ROWVERSION],
			GETUTCDATE(),
			[QUERY].[LASTCHANGEDBY],
			'Assigned To',
			[deleted].[ASSIGNEDTO],
			[inserted].[ASSIGNEDTO],
			'Intelligent Query Action (' + [QUERY].[NAME] + '), Action (' + [QUERYACTION].[ACTIONNAME] +'), Action Type (' + [QUERYACTIONTYPE].[NAME] + ')',
			'C08776DA-046E-4E9B-9DE4-4CC2005A98CD',
			2,
			0,
			[QUERYACTION].[ACTIONNAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[QUERYACTIONID] = [inserted].[QUERYACTIONID]
			INNER JOIN [QUERYACTION] ON [QUERYACTION].[QUERYACTIONID] = [inserted].[QUERYACTIONID]
			INNER JOIN [QUERY] ON [QUERY].[QUERYID] = [QUERYACTION].[QUERYID]
			INNER JOIN [QUERYACTIONTYPE] WITH (NOLOCK) ON [QUERYACTIONTYPE].[QUERYACTIONTYPEID] = [QUERYACTION].[QUERYACTIONTYPEID]
	WHERE	[deleted].[ASSIGNEDTO] <> [inserted].[ASSIGNEDTO]

	UNION  ALL
	SELECT
			[QUERY].[QUERYID], 
			[QUERY].[ROWVERSION],
			GETUTCDATE(),
			[QUERY].[LASTCHANGEDBY],
			'Subject',
			[deleted].[TASKSUBJECT],
			[inserted].[TASKSUBJECT],
			'Intelligent Query Action (' + [QUERY].[NAME] + '), Action (' + [QUERYACTION].[ACTIONNAME] +'), Action Type (' + [QUERYACTIONTYPE].[NAME] + ')',
			'C08776DA-046E-4E9B-9DE4-4CC2005A98CD',
			2,
			0,
			[QUERYACTION].[ACTIONNAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[QUERYACTIONID] = [inserted].[QUERYACTIONID]
			INNER JOIN [QUERYACTION] ON [QUERYACTION].[QUERYACTIONID] = [inserted].[QUERYACTIONID]
			INNER JOIN [QUERY] ON [QUERY].[QUERYID] = [QUERYACTION].[QUERYID]
			INNER JOIN [QUERYACTIONTYPE] WITH (NOLOCK) ON [QUERYACTIONTYPE].[QUERYACTIONTYPEID] = [QUERYACTION].[QUERYACTIONTYPEID]
	WHERE	[deleted].[TASKSUBJECT] <> [inserted].[TASKSUBJECT]

	UNION  ALL
	SELECT
			[QUERY].[QUERYID], 
			[QUERY].[ROWVERSION],
			GETUTCDATE(),
			[QUERY].[LASTCHANGEDBY],
			'Body',
			[deleted].[TASKTEXT],
			[inserted].[TASKTEXT],
			'Intelligent Query Action (' + [QUERY].[NAME] + '), Action (' + [QUERYACTION].[ACTIONNAME] +'), Action Type (' + [QUERYACTIONTYPE].[NAME] + ')',
			'C08776DA-046E-4E9B-9DE4-4CC2005A98CD',
			2,
			0,
			[QUERYACTION].[ACTIONNAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[QUERYACTIONID] = [inserted].[QUERYACTIONID]
			INNER JOIN [QUERYACTION] ON [QUERYACTION].[QUERYACTIONID] = [inserted].[QUERYACTIONID]
			INNER JOIN [QUERY] ON [QUERY].[QUERYID] = [QUERYACTION].[QUERYID]
			INNER JOIN [QUERYACTIONTYPE] WITH (NOLOCK) ON [QUERYACTIONTYPE].[QUERYACTIONTYPEID] = [QUERYACTION].[QUERYACTIONTYPEID]
	WHERE	[deleted].[TASKTEXT] <> [inserted].[TASKTEXT]

	UNION  ALL
	SELECT
			[QUERY].[QUERYID], 
			[QUERY].[ROWVERSION],
			GETUTCDATE(),
			[QUERY].[LASTCHANGEDBY],
			'Start Date',
			[deleted].[STARTDATE],
			[inserted].[STARTDATE],
			'Intelligent Query Action (' + [QUERY].[NAME] + '), Action (' + [QUERYACTION].[ACTIONNAME] +'), Action Type (' + [QUERYACTIONTYPE].[NAME] + ')',
			'C08776DA-046E-4E9B-9DE4-4CC2005A98CD',
			2,
			0,
			[QUERYACTION].[ACTIONNAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[QUERYACTIONID] = [inserted].[QUERYACTIONID]
			INNER JOIN [QUERYACTION] ON [QUERYACTION].[QUERYACTIONID] = [inserted].[QUERYACTIONID]
			INNER JOIN [QUERY] ON [QUERY].[QUERYID] = [QUERYACTION].[QUERYID]
			INNER JOIN [QUERYACTIONTYPE] WITH (NOLOCK) ON [QUERYACTIONTYPE].[QUERYACTIONTYPEID] = [QUERYACTION].[QUERYACTIONTYPEID]
	WHERE	[deleted].[STARTDATE] <> [inserted].[STARTDATE]

	UNION  ALL
	SELECT
			[QUERY].[QUERYID], 
			[QUERY].[ROWVERSION],
			GETUTCDATE(),
			[QUERY].[LASTCHANGEDBY],
			'Start Time',
			[deleted].[STARTTIME],
			[inserted].[STARTTIME],
			'Intelligent Query Action (' + [QUERY].[NAME] + '), Action (' + [QUERYACTION].[ACTIONNAME] +'), Action Type (' + [QUERYACTIONTYPE].[NAME] + ')',
			'C08776DA-046E-4E9B-9DE4-4CC2005A98CD',
			2,
			0,
			[QUERYACTION].[ACTIONNAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[QUERYACTIONID] = [inserted].[QUERYACTIONID]
			INNER JOIN [QUERYACTION] ON [QUERYACTION].[QUERYACTIONID] = [inserted].[QUERYACTIONID]
			INNER JOIN [QUERY] ON [QUERY].[QUERYID] = [QUERYACTION].[QUERYID]
			INNER JOIN [QUERYACTIONTYPE] WITH (NOLOCK) ON [QUERYACTIONTYPE].[QUERYACTIONTYPEID] = [QUERYACTION].[QUERYACTIONTYPEID]
	WHERE	[deleted].[STARTTIME] <> [inserted].[STARTTIME]

	UNION  ALL
	SELECT
			[QUERY].[QUERYID], 
			[QUERY].[ROWVERSION],
			GETUTCDATE(),
			[QUERY].[LASTCHANGEDBY],
			'Start Offset Days',
			CONVERT(NVARCHAR(MAX), [deleted].[STARTDATEOFFSETDAYS]),
			CONVERT(NVARCHAR(MAX), [inserted].[STARTDATEOFFSETDAYS]),
			'Intelligent Query Action (' + [QUERY].[NAME] + '), Action (' + [QUERYACTION].[ACTIONNAME] +'), Action Type (' + [QUERYACTIONTYPE].[NAME] + ')',
			'C08776DA-046E-4E9B-9DE4-4CC2005A98CD',
			2,
			0,
			[QUERYACTION].[ACTIONNAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[QUERYACTIONID] = [inserted].[QUERYACTIONID]
			INNER JOIN [QUERYACTION] ON [QUERYACTION].[QUERYACTIONID] = [inserted].[QUERYACTIONID]
			INNER JOIN [QUERY] ON [QUERY].[QUERYID] = [QUERYACTION].[QUERYID]
			INNER JOIN [QUERYACTIONTYPE] WITH (NOLOCK) ON [QUERYACTIONTYPE].[QUERYACTIONTYPEID] = [QUERYACTION].[QUERYACTIONTYPEID]
	WHERE	[deleted].[STARTDATEOFFSETDAYS] <> [inserted].[STARTDATEOFFSETDAYS]

	UNION  ALL
	SELECT
			[QUERY].[QUERYID], 
			[QUERY].[ROWVERSION],
			GETUTCDATE(),
			[QUERY].[LASTCHANGEDBY],
			'Due Date',
			[deleted].[DUEDATE],
			[inserted].[DUEDATE],
			'Intelligent Query Action (' + [QUERY].[NAME] + '), Action (' + [QUERYACTION].[ACTIONNAME] +'), Action Type (' + [QUERYACTIONTYPE].[NAME] + ')',
			'C08776DA-046E-4E9B-9DE4-4CC2005A98CD',
			2,
			0,
			[QUERYACTION].[ACTIONNAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[QUERYACTIONID] = [inserted].[QUERYACTIONID]
			INNER JOIN [QUERYACTION] ON [QUERYACTION].[QUERYACTIONID] = [inserted].[QUERYACTIONID]
			INNER JOIN [QUERY] ON [QUERY].[QUERYID] = [QUERYACTION].[QUERYID]
			INNER JOIN [QUERYACTIONTYPE] WITH (NOLOCK) ON [QUERYACTIONTYPE].[QUERYACTIONTYPEID] = [QUERYACTION].[QUERYACTIONTYPEID]
	WHERE	[deleted].[DUEDATE] <> [inserted].[DUEDATE]

	UNION  ALL
	SELECT
			[QUERY].[QUERYID], 
			[QUERY].[ROWVERSION],
			GETUTCDATE(),
			[QUERY].[LASTCHANGEDBY],
			'Due Time',
			[deleted].[DUETIME],
			[inserted].[DUETIME],
			'Intelligent Query Action (' + [QUERY].[NAME] + '), Action (' + [QUERYACTION].[ACTIONNAME] +'), Action Type (' + [QUERYACTIONTYPE].[NAME] + ')',
			'C08776DA-046E-4E9B-9DE4-4CC2005A98CD',
			2,
			0,
			[QUERYACTION].[ACTIONNAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[QUERYACTIONID] = [inserted].[QUERYACTIONID]
			INNER JOIN [QUERYACTION] ON [QUERYACTION].[QUERYACTIONID] = [inserted].[QUERYACTIONID]
			INNER JOIN [QUERY] ON [QUERY].[QUERYID] = [QUERYACTION].[QUERYID]
			INNER JOIN [QUERYACTIONTYPE] WITH (NOLOCK) ON [QUERYACTIONTYPE].[QUERYACTIONTYPEID] = [QUERYACTION].[QUERYACTIONTYPEID]
	WHERE	[deleted].[DUETIME] <> [inserted].[DUETIME]

	UNION  ALL
	SELECT
			[QUERY].[QUERYID], 
			[QUERY].[ROWVERSION],
			GETUTCDATE(),
			[QUERY].[LASTCHANGEDBY],
			'Due Offset Days',
			CONVERT(NVARCHAR(MAX), [deleted].[DUEDATEOFFSETDAYS]),
			CONVERT(NVARCHAR(MAX), [inserted].[DUEDATEOFFSETDAYS]),
			'Intelligent Query Action (' + [QUERY].[NAME] + '), Action (' + [QUERYACTION].[ACTIONNAME] +'), Action Type (' + [QUERYACTIONTYPE].[NAME] + ')',
			'C08776DA-046E-4E9B-9DE4-4CC2005A98CD',
			2,
			0,
			[QUERYACTION].[ACTIONNAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[QUERYACTIONID] = [inserted].[QUERYACTIONID]
			INNER JOIN [QUERYACTION] ON [QUERYACTION].[QUERYACTIONID] = [inserted].[QUERYACTIONID]
			INNER JOIN [QUERY] ON [QUERY].[QUERYID] = [QUERYACTION].[QUERYID]
			INNER JOIN [QUERYACTIONTYPE] WITH (NOLOCK) ON [QUERYACTIONTYPE].[QUERYACTIONTYPEID] = [QUERYACTION].[QUERYACTIONTYPEID]
	WHERE	[deleted].[DUEDATEOFFSETDAYS] <> [inserted].[DUEDATEOFFSETDAYS]

	UNION  ALL
	SELECT
			[QUERY].[QUERYID], 
			[QUERY].[ROWVERSION],
			GETUTCDATE(),
			[QUERY].[LASTCHANGEDBY],
			'Priority',
			DELETETASKPRIORITY.[TASKPRIORITYNAME],
			INSERTTASKPRIORITY.[TASKPRIORITYNAME],
			'Intelligent Query Action (' + [QUERY].[NAME] + '), Action (' + [QUERYACTION].[ACTIONNAME] +'), Action Type (' + [QUERYACTIONTYPE].[NAME] + ')',
			'C08776DA-046E-4E9B-9DE4-4CC2005A98CD',
			2,
			0,
			[QUERYACTION].[ACTIONNAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[QUERYACTIONID] = [inserted].[QUERYACTIONID]
			INNER JOIN [QUERYACTION] ON [QUERYACTION].[QUERYACTIONID] = [inserted].[QUERYACTIONID]
			INNER JOIN [QUERY] ON [QUERY].[QUERYID] = [QUERYACTION].[QUERYID]
			INNER JOIN [QUERYACTIONTYPE] WITH (NOLOCK) ON [QUERYACTIONTYPE].[QUERYACTIONTYPEID] = [QUERYACTION].[QUERYACTIONTYPEID]
			INNER JOIN [TASKPRIORITY] AS DELETETASKPRIORITY WITH (NOLOCK) ON DELETETASKPRIORITY.[TASKPRIORITYID] = [deleted].[TASKPRIORITYID]
			INNER JOIN [TASKPRIORITY] AS INSERTTASKPRIORITY WITH (NOLOCK) ON INSERTTASKPRIORITY.[TASKPRIORITYID] = [inserted].[TASKPRIORITYID]
	WHERE	[deleted].[TASKPRIORITYID] <> [inserted].[TASKPRIORITYID]

	UNION  ALL
	SELECT
			[QUERY].[QUERYID], 
			[QUERY].[ROWVERSION],
			GETUTCDATE(),
			[QUERY].[LASTCHANGEDBY],
			'Show On Calendar Flag',
			CASE [deleted].[SHOWONCALENDAR]  WHEN 1 THEN 'Yes' ELSE 'No' END,
			CASE [inserted].[SHOWONCALENDAR]  WHEN 1 THEN 'Yes' ELSE 'No' END,
			'Intelligent Query Action (' + [QUERY].[NAME] + '), Action (' + [QUERYACTION].[ACTIONNAME] +'), Action Type (' + [QUERYACTIONTYPE].[NAME] + ')',
			'C08776DA-046E-4E9B-9DE4-4CC2005A98CD',
			2,
			0,
			[QUERYACTION].[ACTIONNAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[QUERYACTIONID] = [inserted].[QUERYACTIONID]
			INNER JOIN [QUERYACTION] ON [QUERYACTION].[QUERYACTIONID] = [inserted].[QUERYACTIONID]
			INNER JOIN [QUERY] ON [QUERY].[QUERYID] = [QUERYACTION].[QUERYID]
			INNER JOIN [QUERYACTIONTYPE] WITH (NOLOCK) ON [QUERYACTIONTYPE].[QUERYACTIONTYPEID] = [QUERYACTION].[QUERYACTIONTYPEID]
	WHERE	[deleted].[SHOWONCALENDAR] <> [inserted].[SHOWONCALENDAR]
END