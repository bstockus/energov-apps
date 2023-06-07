CREATE TABLE [dbo].[WORKFLOW] (
    [WORKFLOWID]          CHAR (36)      NOT NULL,
    [MODULEID]            INT            NOT NULL,
    [WORKFLOWNAME]        NVARCHAR (50)  NOT NULL,
    [ROOTCLASSNAME]       NVARCHAR (MAX) NOT NULL,
    [LASTCHANGEDON]       DATETIME       NOT NULL,
    [LASTCHANGEDBY]       CHAR (36)      NOT NULL,
    [ISSERVER]            BIT            CONSTRAINT [DF_Workflow_IsServer] DEFAULT ((1)) NOT NULL,
    [ISCLIENT]            BIT            CONSTRAINT [DF_Workflow_IsClient] DEFAULT ((0)) NOT NULL,
    [WORKFLOWDESCRIPTION] NVARCHAR (MAX) CONSTRAINT [DF_Workflow_WorkflowDescription] DEFAULT ('') NOT NULL,
    [ISENABLED]           BIT            CONSTRAINT [DF_WorkFlow_IsEnabled] DEFAULT ((1)) NOT NULL,
    [ISPOSTPROCESS]       BIT            DEFAULT ((0)) NOT NULL,
    [ROWVERSION]          INT            CONSTRAINT [DF_WORKFLOW_RowVersion] DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_Workflow] PRIMARY KEY CLUSTERED ([WORKFLOWID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Workflow_SystemModule] FOREIGN KEY ([MODULEID]) REFERENCES [dbo].[SYSTEMMODULE] ([SYSTEMMODULEID]),
    CONSTRAINT [FK_Workflow_Users] FOREIGN KEY ([LASTCHANGEDBY]) REFERENCES [dbo].[USERS] ([SUSERGUID])
);


GO
CREATE NONCLUSTERED INDEX [WORKFLOW_IX_QUERY]
    ON [dbo].[WORKFLOW]([WORKFLOWID] ASC, [WORKFLOWNAME] ASC);


GO

CREATE TRIGGER [dbo].[TG_WORKFLOW_DELETE] ON [dbo].[WORKFLOW]
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
			[deleted].[WORKFLOWID],
			[deleted].[ROWVERSION],
			GETUTCDATE(),
			(SELECT dbo.UFN_GET_USERID_FROM_CONTEXT_INFO()),
			'Intelligent Object Deleted',
			'',
			'',
			'Intelligent Object (' + [deleted].[WORKFLOWNAME] + ')',
			'F053A756-19BE-4A42-A70D-185D5B01C31A',
			3,
			1,
			[deleted].[WORKFLOWNAME]
	FROM	[deleted]

END
GO
CREATE TRIGGER [dbo].[TG_WORKFLOW_INSERT] ON [dbo].[WORKFLOW]
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
			[inserted].[WORKFLOWID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Intelligent Object Added',
			'',
			'',
			'Intelligent Object (' + [inserted].[WORKFLOWNAME] + ')',
			'F053A756-19BE-4A42-A70D-185D5B01C31A',
			1,
			1,
			[inserted].[WORKFLOWNAME]
	FROM	[inserted]
END
GO

CREATE TRIGGER [dbo].[TG_WORKFLOW_UPDATE] ON [dbo].[WORKFLOW] 
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
			[inserted].[WORKFLOWID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Intelligent Object Name',
			[deleted].[WORKFLOWNAME],
			[inserted].[WORKFLOWNAME],
			'Intelligent Object (' + [inserted].[WORKFLOWNAME] + ')',
			'F053A756-19BE-4A42-A70D-185D5B01C31A',
			2,
			1,
			[inserted].[WORKFLOWNAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[WORKFLOWID] = [inserted].[WORKFLOWID]
	WHERE	[deleted].[WORKFLOWNAME] <> [inserted].[WORKFLOWNAME]
	UNION ALL

	SELECT
			[inserted].[WORKFLOWID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Description',
			[deleted].[WORKFLOWDESCRIPTION],
			[inserted].[WORKFLOWDESCRIPTION],
			'Intelligent Object (' + [inserted].[WORKFLOWNAME] + ')',
			'F053A756-19BE-4A42-A70D-185D5B01C31A',
			2,
			1,
			[inserted].[WORKFLOWNAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[WORKFLOWID] = [inserted].[WORKFLOWID]
	WHERE	[deleted].[WORKFLOWDESCRIPTION] <> [inserted].[WORKFLOWDESCRIPTION]
	UNION ALL

	SELECT
			[inserted].[WORKFLOWID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Server Flag',
			CASE [deleted].[ISSERVER] WHEN 1 THEN 'Yes' ELSE 'No' END,
			CASE [inserted].[ISSERVER] WHEN 1 THEN 'Yes' ELSE 'No' END,
			'Intelligent Object (' + [inserted].[WORKFLOWNAME] + ')',
			'F053A756-19BE-4A42-A70D-185D5B01C31A',
			2,
			1,
			[inserted].[WORKFLOWNAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[WORKFLOWID] = [inserted].[WORKFLOWID]
	WHERE	[deleted].[ISSERVER]<> [inserted].[ISSERVER]
	UNION ALL

	SELECT
			[inserted].[WORKFLOWID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Client Flag',
			CASE [deleted].[ISCLIENT] WHEN 1 THEN 'Yes' ELSE 'No' END,
			CASE [inserted].[ISCLIENT] WHEN 1 THEN 'Yes' ELSE 'No' END,
			'Intelligent Object (' + [inserted].[WORKFLOWNAME] + ')',
			'F053A756-19BE-4A42-A70D-185D5B01C31A',
			2,
			1,
			[inserted].[WORKFLOWNAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[WORKFLOWID] = [inserted].[WORKFLOWID]
	WHERE	[deleted].[ISCLIENT]<> [inserted].[ISCLIENT]
	UNION ALL

	SELECT
			[inserted].[WORKFLOWID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Post Process Flag',
			CASE [deleted].[ISPOSTPROCESS] WHEN 1 THEN 'Yes' ELSE 'No' END,
			CASE [inserted].[ISPOSTPROCESS] WHEN 1 THEN 'Yes' ELSE 'No' END,
			'Intelligent Object (' + [inserted].[WORKFLOWNAME] + ')',
			'F053A756-19BE-4A42-A70D-185D5B01C31A',
			2,
			1,
			[inserted].[WORKFLOWNAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[WORKFLOWID] = [inserted].[WORKFLOWID]
	WHERE	[deleted].[ISPOSTPROCESS]<> [inserted].[ISPOSTPROCESS]
	UNION ALL

	SELECT
			[inserted].[WORKFLOWID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Enabled Flag',
			CASE [deleted].[ISENABLED] WHEN 1 THEN 'Yes' ELSE 'No' END,
			CASE [inserted].[ISENABLED] WHEN 1 THEN 'Yes' ELSE 'No' END,
			'Intelligent Object (' + [inserted].[WORKFLOWNAME] + ')',
			'F053A756-19BE-4A42-A70D-185D5B01C31A',
			2,
			1,
			[inserted].[WORKFLOWNAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[WORKFLOWID] = [inserted].[WORKFLOWID]
	WHERE	[deleted].[ISENABLED]<> [inserted].[ISENABLED]
	UNION ALL

	SELECT
			[inserted].[WORKFLOWID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Data Source',
			[deleted].[ROOTCLASSNAME],
			[inserted].[ROOTCLASSNAME],
			'Intelligent Object (' + [inserted].[WORKFLOWNAME] + ')',
			'F053A756-19BE-4A42-A70D-185D5B01C31A',
			2,
			1,
			[inserted].[WORKFLOWNAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[WORKFLOWID] = [inserted].[WORKFLOWID]
	WHERE	[deleted].[ROOTCLASSNAME] <> [inserted].[ROOTCLASSNAME]
	UNION ALL

	SELECT
			[inserted].[WORKFLOWID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Module',
			[SYSTEMMODULE_DELETED].[MODULENAME],
			[SYSTEMMODULE_INSERTED].[MODULENAME],
			'Intelligent Object (' + [inserted].[WORKFLOWNAME] + ')',
			'F053A756-19BE-4A42-A70D-185D5B01C31A',
			2,
			1,
			[inserted].[WORKFLOWNAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[WORKFLOWID] = [inserted].[WORKFLOWID]
			INNER JOIN [SYSTEMMODULE] SYSTEMMODULE_DELETED WITH (NOLOCK) ON [SYSTEMMODULE_DELETED].[SYSTEMMODULEID] = [deleted].[MODULEID]
			INNER JOIN [SYSTEMMODULE] SYSTEMMODULE_INSERTED WITH (NOLOCK) ON [SYSTEMMODULE_INSERTED].[SYSTEMMODULEID] = [inserted].[MODULEID]
	WHERE	[deleted].[MODULEID] <> [inserted].[MODULEID]
END