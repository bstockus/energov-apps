CREATE TABLE [dbo].[TASKTYPE] (
    [TASKTYPEID]     CHAR (36)      NOT NULL,
    [NAME]           NVARCHAR (50)  NOT NULL,
    [DESCRIPTION]    NVARCHAR (MAX) NULL,
    [ACTIVE]         BIT            NOT NULL,
    [ISDEFAULT]      BIT            NOT NULL,
    [ISGLOBAL]       BIT            DEFAULT ((0)) NOT NULL,
    [DAYSUNTILDUE]   INT            NULL,
    [TASKTEXT]       NVARCHAR (MAX) NULL,
    [DEFAULTSUBJECT] NVARCHAR (200) NULL,
    [TASKSTATUSID]   INT            DEFAULT ((-1)) NOT NULL,
    [TASKPRIORITYID] INT            DEFAULT ((-1)) NOT NULL,
    [LASTCHANGEDBY]  CHAR (36)      NULL,
    [LASTCHANGEDON]  DATETIME       CONSTRAINT [DF_TASKTYPE_LastChangedOn] DEFAULT (getutcdate()) NOT NULL,
    [ROWVERSION]     INT            CONSTRAINT [DF_TASKTYPE_RowVersion] DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_TaskType] PRIMARY KEY CLUSTERED ([TASKTYPEID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_TASKTYPE_USERS] FOREIGN KEY ([LASTCHANGEDBY]) REFERENCES [dbo].[USERS] ([SUSERGUID]),
    CONSTRAINT [FK_TASKTYPEPRIORITY_PRIO] FOREIGN KEY ([TASKPRIORITYID]) REFERENCES [dbo].[TASKPRIORITY] ([TASKPRIORITYID]),
    CONSTRAINT [FK_TASKTYPESTATUS_STATUS] FOREIGN KEY ([TASKSTATUSID]) REFERENCES [dbo].[TASKSTATUS] ([TASKSTATUSID])
);


GO
CREATE TRIGGER [dbo].[TG_TASKTYPE_INSERT]  
   ON  [dbo].[TASKTYPE]
   AFTER INSERT
AS 
BEGIN
	SET NOCOUNT ON;
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
        [inserted].[TASKTYPEID], 
        [inserted].[ROWVERSION],
        GETUTCDATE(),
        [inserted].[LASTCHANGEDBY],
        'Task Type Added',
        '',
        '',
        'Task Type (' + [inserted].[NAME] + ')',
		'DE491E7E-C8DB-443C-87E6-38235F67D89B',
		1,
		1,
		[inserted].[NAME]
    FROM [inserted]	
END
GO
CREATE TRIGGER [dbo].[TG_TASKTYPE_UPDATE]
   ON  [dbo].[TASKTYPE]
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
			[inserted].[TASKTYPEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Name',
			[deleted].[NAME],
			[inserted].[NAME],
			'Task Type (' + [inserted].[NAME] + ')',
			'DE491E7E-C8DB-443C-87E6-38235F67D89B',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].TASKTYPEID = [inserted].TASKTYPEID
	WHERE	[deleted].[NAME] <> [inserted].[NAME]
	UNION ALL

	SELECT 
			[inserted].[TASKTYPEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],			
			'Description',
			ISNULL([deleted].[DESCRIPTION],'[none]'),		
			ISNULL([inserted].[DESCRIPTION],'[none]'),
			'Task Type (' + [inserted].[NAME] + ')',
			'DE491E7E-C8DB-443C-87E6-38235F67D89B',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].TASKTYPEID = [inserted].TASKTYPEID
	WHERE	ISNULL([deleted].[DESCRIPTION],'') <> ISNULL([inserted].[DESCRIPTION],'')
	UNION ALL

	SELECT 
			[inserted].[TASKTYPEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],			
			'Days Until Due',
			ISNULL(CONVERT(NVARCHAR(MAX),[deleted].[DAYSUNTILDUE]),'[none]'),
			ISNULL(CONVERT(NVARCHAR(MAX),[inserted].[DAYSUNTILDUE]),'[none]'),
			'Task Type (' + [inserted].[NAME] + ')',
			'DE491E7E-C8DB-443C-87E6-38235F67D89B',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].TASKTYPEID = [inserted].TASKTYPEID
	WHERE	ISNULL([deleted].[DAYSUNTILDUE],'') <> ISNULL([inserted].[DAYSUNTILDUE],'')
	UNION ALL

	SELECT 
			[inserted].[TASKTYPEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],			
			'Default Task Body',
			ISNULL([deleted].[TASKTEXT],'[none]'),		
			ISNULL([inserted].[TASKTEXT],'[none]'),
			'Task Type (' + [inserted].[NAME] + ')',
			'DE491E7E-C8DB-443C-87E6-38235F67D89B',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].TASKTYPEID = [inserted].TASKTYPEID
	WHERE	ISNULL([deleted].[TASKTEXT],'') <> ISNULL([inserted].[TASKTEXT],'')
	UNION ALL

	SELECT 
			[inserted].[TASKTYPEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],			
			'Subject',
			ISNULL([deleted].[DEFAULTSUBJECT],'[none]'),		
			ISNULL([inserted].[DEFAULTSUBJECT],'[none]'),
			'Task Type (' + [inserted].[NAME] + ')',
			'DE491E7E-C8DB-443C-87E6-38235F67D89B',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].TASKTYPEID = [inserted].TASKTYPEID
	WHERE	ISNULL([deleted].[DEFAULTSUBJECT],'') <> ISNULL([inserted].[DEFAULTSUBJECT],'')
	UNION ALL

	SELECT
			[inserted].[TASKTYPEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Status',			
			[TASKSTATUS_DELETED].[TASKSTATUSNAME],
			[TASKSTATUS_INSERTED].[TASKSTATUSNAME],
			'Task Type (' + [inserted].[NAME] + ')',
			'DE491E7E-C8DB-443C-87E6-38235F67D89B',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[TASKTYPEID] = [inserted].[TASKTYPEID]
			JOIN TASKSTATUS TASKSTATUS_DELETED WITH (NOLOCK) ON [deleted].TASKSTATUSID = [TASKSTATUS_DELETED].TASKSTATUSID
			JOIN TASKSTATUS TASKSTATUS_INSERTED WITH (NOLOCK) ON [inserted].TASKSTATUSID = [TASKSTATUS_INSERTED].TASKSTATUSID
	WHERE	ISNULL([deleted].[TASKSTATUSID],'') <> ISNULL([inserted].[TASKSTATUSID],'')
	UNION ALL

	SELECT
			[inserted].[TASKTYPEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Priority',
			[TASKPRIORITY_DELETED].[TASKPRIORITYNAME],
			[TASKPRIORITY_INSERTED].[TASKPRIORITYNAME],
			'Task Type (' + [inserted].[NAME] + ')',
			'DE491E7E-C8DB-443C-87E6-38235F67D89B',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[TASKTYPEID] = [inserted].[TASKTYPEID]
			JOIN TASKPRIORITY TASKPRIORITY_DELETED WITH (NOLOCK) ON [deleted].TASKPRIORITYID = [TASKPRIORITY_DELETED].TASKPRIORITYID
			JOIN TASKPRIORITY TASKPRIORITY_INSERTED WITH (NOLOCK) ON [inserted].TASKPRIORITYID = [TASKPRIORITY_INSERTED].TASKPRIORITYID
	WHERE	ISNULL([deleted].[TASKPRIORITYID],'') <> ISNULL([inserted].[TASKPRIORITYID],'')
	UNION ALL

	SELECT
			[inserted].[TASKTYPEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Active',
			CASE [deleted].[ACTIVE] WHEN 1 THEN 'Yes' ELSE 'No' END,
			CASE [inserted].[ACTIVE] WHEN 1 THEN 'Yes' ELSE 'No'  END,
			'Task Type (' + [inserted].[NAME] + ')',
			'DE491E7E-C8DB-443C-87E6-38235F67D89B',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].TASKTYPEID = [inserted].TASKTYPEID
	WHERE	([deleted].[ACTIVE] <> [inserted].[ACTIVE]) OR ([deleted].[ACTIVE] IS NULL AND [inserted].[ACTIVE] IS NOT NULL)
			OR ([deleted].[ACTIVE] IS NOT NULL AND [inserted].[ACTIVE] IS NULL)
	UNION ALL

	SELECT
			[inserted].[TASKTYPEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Is Default',
			CASE [deleted].[ISDEFAULT] WHEN 1 THEN 'Yes' ELSE  'No' END,
			CASE [inserted].[ISDEFAULT] WHEN 1 THEN 'Yes' ELSE 'No' END,
			'Task Type (' + [inserted].[NAME] + ')',
			'DE491E7E-C8DB-443C-87E6-38235F67D89B',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].TASKTYPEID = [inserted].TASKTYPEID
	WHERE	([deleted].[ISDEFAULT] <> [inserted].[ISDEFAULT]) OR ([deleted].[ISDEFAULT] IS NULL AND [inserted].[ISDEFAULT] IS NOT NULL)
			OR ([deleted].[ISDEFAULT] IS NOT NULL AND [inserted].[ISDEFAULT] IS NULL)
	UNION ALL

	SELECT
			[inserted].[TASKTYPEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Is Global',
			CASE [deleted].[ISGLOBAL] WHEN 1 THEN 'Yes' ELSE 'No' END,
			CASE [inserted].[ISGLOBAL] WHEN 1 THEN 'Yes' ELSE 'No' END,
			'Task Type (' + [inserted].[NAME] + ')',
			'DE491E7E-C8DB-443C-87E6-38235F67D89B',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].TASKTYPEID = [inserted].TASKTYPEID
	WHERE	([deleted].[ISGLOBAL] <> [inserted].[ISGLOBAL]) OR ([deleted].[ISGLOBAL] IS NULL AND [inserted].[ISGLOBAL] IS NOT NULL)
			OR ([deleted].[ISGLOBAL] IS NOT NULL AND [inserted].[ISGLOBAL] IS NULL)	
END
GO
CREATE TRIGGER [dbo].[TG_TASKTYPE_DELETE]
   ON  [dbo].[TASKTYPE] 
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
    )SELECT
			[deleted].[TASKTYPEID],
			[deleted].[ROWVERSION],
			GETUTCDATE(),
			(SELECT dbo.UFN_GET_USERID_FROM_CONTEXT_INFO()),
			'Task Type Deleted',
			'',
			'',
			'Task Type (' + [deleted].[NAME] + ')',
			'DE491E7E-C8DB-443C-87E6-38235F67D89B',
			3,
			1,
			[deleted].[NAME]
	FROM	[deleted]
END