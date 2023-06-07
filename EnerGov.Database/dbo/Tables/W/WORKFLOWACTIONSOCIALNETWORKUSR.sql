﻿CREATE TABLE [dbo].[WORKFLOWACTIONSOCIALNETWORKUSR] (
    [WORKFLOWACTISOCNETWRKUSERID]   VARCHAR (36) NOT NULL,
    [WORKFLOWACTIONSOCIALNETWORKID] VARCHAR (36) NOT NULL,
    [USERID]                        VARCHAR (36) NOT NULL,
    CONSTRAINT [PK_WorkflowActionSocialNetworkUser] PRIMARY KEY CLUSTERED ([WORKFLOWACTISOCNETWRKUSERID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_WSocialNetworkUser_ASocialNetwork] FOREIGN KEY ([WORKFLOWACTIONSOCIALNETWORKID]) REFERENCES [dbo].[WORKFLOWACTIONSOCIALNETWORK] ([WORKFLOWACTIONSOCIALNETWORKID]),
    CONSTRAINT [FK_WSocialNetworkUser_USocialNetwork] FOREIGN KEY ([USERID]) REFERENCES [dbo].[WORKFLOWSOCIALNETWORKUSERS] ([GID])
);


GO
CREATE NONCLUSTERED INDEX [WORKFLOWACTIONSOCIALNETWORKUSR_USERID]
    ON [dbo].[WORKFLOWACTIONSOCIALNETWORKUSR]([USERID] ASC);


GO
CREATE NONCLUSTERED INDEX [WORKFLOWACTIONSOCIALNETWORKUSR_WORKFLOWACTIONSOCIALNETWORKID]
    ON [dbo].[WORKFLOWACTIONSOCIALNETWORKUSR]([WORKFLOWACTIONSOCIALNETWORKID] ASC);


GO

CREATE TRIGGER [dbo].[TG_WORKFLOWACTIONSOCIALNETWORKUSR_DELETE]
   ON  [dbo].[WORKFLOWACTIONSOCIALNETWORKUSR]
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
			[WORKFLOW].[WORKFLOWID], 
			[WORKFLOW].[ROWVERSION],
			GETUTCDATE(),
			(SELECT dbo.UFN_GET_USERID_FROM_CONTEXT_INFO()),
			'Workflow Action Social Network User Deleted',
			'',
			'',
			'Intelligent Object (' + [WORKFLOW].[WORKFLOWNAME] + '), Action (' + [WORKFLOWACTION].[ACTIONNAME] +'), Action Type (' + [WORKFLOWACTIONTYPE].[WORKFLOWACTIONTYPENAME] + '), User (' + [WORKFLOWSOCIALNETWORKUSERS].[DESCRIPTION] + ')',
			'F053A756-19BE-4A42-A70D-185D5B01C31A',
			3,
			0,
			[WORKFLOWACTION].[ACTIONNAME]
	FROM	[deleted]
			INNER JOIN [WORKFLOWACTIONSOCIALNETWORK] ON [WORKFLOWACTIONSOCIALNETWORK].[WORKFLOWACTIONSOCIALNETWORKID] = [deleted].[WORKFLOWACTIONSOCIALNETWORKID]
			INNER JOIN [WORKFLOWACTION] ON [WORKFLOWACTION].[WORKFLOWACTIONID] = [WORKFLOWACTIONSOCIALNETWORK].[WORKFLOWACTIONID]
			INNER JOIN [WORKFLOW] ON [WORKFLOW].[WORKFLOWID] = [WORKFLOWACTION].[WORKFLOWID]
			INNER JOIN [WORKFLOWACTIONTYPE] WITH (NOLOCK) ON [WORKFLOWACTIONTYPE].[WORKFLOWACTIONTYPEID] = [WORKFLOWACTION].[WORKFLOWACTIONTYPEID]
			INNER JOIN [WORKFLOWSOCIALNETWORKUSERS] WITH (NOLOCK) ON [WORKFLOWSOCIALNETWORKUSERS].[GID] = [deleted].[USERID]
END
GO

CREATE TRIGGER [dbo].[TG_WORKFLOWACTIONSOCIALNETWORKUSR_INSERT]
   ON  [dbo].[WORKFLOWACTIONSOCIALNETWORKUSR]
   AFTER INSERT
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
			'Workflow Action Social Network User Added',
			'',
			'',
			'Intelligent Object (' + [WORKFLOW].[WORKFLOWNAME] + '), Action (' + [WORKFLOWACTION].[ACTIONNAME] +'), Action Type (' + [WORKFLOWACTIONTYPE].[WORKFLOWACTIONTYPENAME] + '), User (' + [WORKFLOWSOCIALNETWORKUSERS].[DESCRIPTION] + ')',
			'F053A756-19BE-4A42-A70D-185D5B01C31A',
			1,
			0,
			[WORKFLOWACTION].[ACTIONNAME]
	FROM	[inserted]
			INNER JOIN [WORKFLOWACTIONSOCIALNETWORK] ON [WORKFLOWACTIONSOCIALNETWORK].[WORKFLOWACTIONSOCIALNETWORKID] = [inserted].[WORKFLOWACTIONSOCIALNETWORKID]
			INNER JOIN [WORKFLOWACTION] ON [WORKFLOWACTION].[WORKFLOWACTIONID] = [WORKFLOWACTIONSOCIALNETWORK].[WORKFLOWACTIONID]
			INNER JOIN [WORKFLOW] ON [WORKFLOW].[WORKFLOWID] = [WORKFLOWACTION].[WORKFLOWID]
			INNER JOIN [WORKFLOWACTIONTYPE] WITH (NOLOCK) ON [WORKFLOWACTIONTYPE].[WORKFLOWACTIONTYPEID] = [WORKFLOWACTION].[WORKFLOWACTIONTYPEID]
			INNER JOIN [WORKFLOWSOCIALNETWORKUSERS] WITH (NOLOCK) ON [WORKFLOWSOCIALNETWORKUSERS].[GID] = [inserted].[USERID]
END