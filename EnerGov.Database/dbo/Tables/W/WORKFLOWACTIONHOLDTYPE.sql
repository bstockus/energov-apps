﻿CREATE TABLE [dbo].[WORKFLOWACTIONHOLDTYPE] (
    [WORKFLOWACTIONHOLDTYPEID] CHAR (36)      NOT NULL,
    [WORKFLOWACTIONID]         CHAR (36)      NOT NULL,
    [HOLDSETUPID]              CHAR (36)      NOT NULL,
    [COMMENTS]                 NVARCHAR (MAX) NULL,
    CONSTRAINT [PK_WORKFLOWACTIONHOLDTYPE] PRIMARY KEY CLUSTERED ([WORKFLOWACTIONHOLDTYPEID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_WORKFLOWACTIONHOLDTYPE_HOLDTYPESETUPS] FOREIGN KEY ([HOLDSETUPID]) REFERENCES [dbo].[HOLDTYPESETUPS] ([HOLDSETUPID]),
    CONSTRAINT [FK_WORKFLOWACTIONHOLDTYPE_WORKFLOWACTION] FOREIGN KEY ([WORKFLOWACTIONID]) REFERENCES [dbo].[WORKFLOWACTION] ([WORKFLOWACTIONID])
);


GO
CREATE NONCLUSTERED INDEX [WORKFLOWACTIONHOLDTYPE_HOLDSETUPID]
    ON [dbo].[WORKFLOWACTIONHOLDTYPE]([HOLDSETUPID] ASC);


GO
CREATE NONCLUSTERED INDEX [WORKFLOWACTIONHOLDTYPE_WORKFLOWACTIONID]
    ON [dbo].[WORKFLOWACTIONHOLDTYPE]([WORKFLOWACTIONID] ASC);


GO

CREATE TRIGGER [dbo].[TG_WORKFLOWACTIONHOLDTYPE_UPDATE]
   ON  [dbo].[WORKFLOWACTIONHOLDTYPE]
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
			[WORKFLOW].[WORKFLOWID], 
			[WORKFLOW].[ROWVERSION],
			GETUTCDATE(),
			[WORKFLOW].[LASTCHANGEDBY],
			'Hold Type',
			ISNULL(DELETEHOLDTYPESETUPS.[NAME],'[none]'),
			ISNULL(INSERTHOLDTYPESETUPS.[NAME],'[none]'),
			'Intelligent Object (' + [WORKFLOW].[WORKFLOWNAME] + '), Action (' + [WORKFLOWACTION].[ACTIONNAME] +'), Action Type (' + [WORKFLOWACTIONTYPE].[WORKFLOWACTIONTYPENAME] + ')',
			'F053A756-19BE-4A42-A70D-185D5B01C31A',
			2,
			0,
			[WORKFLOWACTION].[ACTIONNAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[WORKFLOWACTIONID] = [inserted].[WORKFLOWACTIONID]
			INNER JOIN [WORKFLOWACTION] ON [WORKFLOWACTION].[WORKFLOWACTIONID] = [inserted].[WORKFLOWACTIONID]
			INNER JOIN [WORKFLOW] ON [WORKFLOW].[WORKFLOWID] = [WORKFLOWACTION].[WORKFLOWID]
			INNER JOIN [WORKFLOWACTIONTYPE] WITH (NOLOCK) ON [WORKFLOWACTIONTYPE].[WORKFLOWACTIONTYPEID] = [WORKFLOWACTION].[WORKFLOWACTIONTYPEID]
			INNER JOIN [HOLDTYPESETUPS] AS DELETEHOLDTYPESETUPS WITH (NOLOCK) ON DELETEHOLDTYPESETUPS.[HOLDSETUPID] = [deleted].[HOLDSETUPID]
			INNER JOIN [HOLDTYPESETUPS] AS INSERTHOLDTYPESETUPS WITH (NOLOCK) ON INSERTHOLDTYPESETUPS.[HOLDSETUPID] = [inserted].[HOLDSETUPID]
	WHERE	[deleted].[HOLDSETUPID] <> [inserted].[HOLDSETUPID]

	UNION ALL
	SELECT
			[WORKFLOW].[WORKFLOWID], 
			[WORKFLOW].[ROWVERSION],
			GETUTCDATE(),
			[WORKFLOW].[LASTCHANGEDBY],
			'Notes',
			ISNULL([deleted].[COMMENTS],'[none]'),
			ISNULL([inserted].[COMMENTS],'[none]'),
			'Intelligent Object (' + [WORKFLOW].[WORKFLOWNAME] + '), Action (' + [WORKFLOWACTION].[ACTIONNAME] +'), Action Type (' + [WORKFLOWACTIONTYPE].[WORKFLOWACTIONTYPENAME] + ')',
			'F053A756-19BE-4A42-A70D-185D5B01C31A',
			2,
			0,
			[WORKFLOWACTION].[ACTIONNAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[WORKFLOWACTIONID] = [inserted].[WORKFLOWACTIONID]
			INNER JOIN [WORKFLOWACTION] ON [WORKFLOWACTION].[WORKFLOWACTIONID] = [inserted].[WORKFLOWACTIONID]
			INNER JOIN [WORKFLOW] ON [WORKFLOW].[WORKFLOWID] = [WORKFLOWACTION].[WORKFLOWID]
			INNER JOIN [WORKFLOWACTIONTYPE] WITH (NOLOCK) ON [WORKFLOWACTIONTYPE].[WORKFLOWACTIONTYPEID] = [WORKFLOWACTION].[WORKFLOWACTIONTYPEID]
	WHERE	ISNULL([deleted].[COMMENTS],'') <> ISNULL([inserted].[COMMENTS],'')
END