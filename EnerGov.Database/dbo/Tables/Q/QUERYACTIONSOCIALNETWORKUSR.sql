﻿CREATE TABLE [dbo].[QUERYACTIONSOCIALNETWORKUSR] (
    [QUERYACTIONSOCIALNETWORKUSRID] VARCHAR (36) NOT NULL,
    [QUERYACTIONSOCIALNETWORKID]    VARCHAR (36) NOT NULL,
    [USERID]                        VARCHAR (36) NOT NULL,
    CONSTRAINT [PK_QUERYACTIONSOCNETWORKUSR] PRIMARY KEY CLUSTERED ([QUERYACTIONSOCIALNETWORKUSRID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_QASOCIALNETWORKUSR_QASONET] FOREIGN KEY ([QUERYACTIONSOCIALNETWORKID]) REFERENCES [dbo].[QUERYACTIONSOCIALNETWORK] ([QUERYACTIONSOCIALNETWORKID]),
    CONSTRAINT [FK_QASOCIALNETWORKUSR_USER] FOREIGN KEY ([USERID]) REFERENCES [dbo].[WORKFLOWSOCIALNETWORKUSERS] ([GID])
);


GO
CREATE NONCLUSTERED INDEX [QUERYACTIONSOCIALNETWORKUSR_QUERYACTIONSOCIALNETWORKID]
    ON [dbo].[QUERYACTIONSOCIALNETWORKUSR]([QUERYACTIONSOCIALNETWORKID] ASC);


GO
CREATE NONCLUSTERED INDEX [QUERYACTIONSOCIALNETWORKUSR_USERID]
    ON [dbo].[QUERYACTIONSOCIALNETWORKUSR]([USERID] ASC);


GO

CREATE TRIGGER [dbo].[TG_QUERYACTIONSOCIALNETWORKUSR_INSERT]
   ON  [dbo].[QUERYACTIONSOCIALNETWORKUSR]
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
			[QUERY].[QUERYID], 
			[QUERY].[ROWVERSION],
			GETUTCDATE(),
			[QUERY].[LASTCHANGEDBY],
			'Intelligent Query Action Social Network User Added',
			'',
			'',
			'Intelligent Query Action (' + [QUERY].[NAME] + '), Action (' + [QUERYACTION].[ACTIONNAME] +'), Action Type (' + [QUERYACTIONTYPE].[NAME] + '), User (' + [WORKFLOWSOCIALNETWORKUSERS].[DESCRIPTION] + ')',
			'C08776DA-046E-4E9B-9DE4-4CC2005A98CD',
			1,
			0,
			[QUERYACTION].[ACTIONNAME]
	FROM	[inserted]
			INNER JOIN [QUERYACTIONSOCIALNETWORK] ON [QUERYACTIONSOCIALNETWORK].[QUERYACTIONSOCIALNETWORKID] = [inserted].[QUERYACTIONSOCIALNETWORKID]
			INNER JOIN [QUERYACTION] ON [QUERYACTION].[QUERYACTIONID] = [QUERYACTIONSOCIALNETWORK].[QUERYACTIONID]
			INNER JOIN [QUERY] ON [QUERY].[QUERYID] = [QUERYACTION].[QUERYID]
			INNER JOIN [QUERYACTIONTYPE] WITH (NOLOCK) ON [QUERYACTIONTYPE].[QUERYACTIONTYPEID] = [QUERYACTION].[QUERYACTIONTYPEID]
			INNER JOIN [WORKFLOWSOCIALNETWORKUSERS] WITH (NOLOCK) ON [WORKFLOWSOCIALNETWORKUSERS].[GID] = [inserted].[USERID]
END
GO

CREATE TRIGGER [dbo].[TG_QUERYACTIONSOCIALNETWORKUSR_DELETE]
   ON  [dbo].[QUERYACTIONSOCIALNETWORKUSR]
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
			[QUERY].[QUERYID], 
			[QUERY].[ROWVERSION],
			GETUTCDATE(),
			(SELECT dbo.UFN_GET_USERID_FROM_CONTEXT_INFO()),
			'Intelligent Query Action Social Network User Deleted',
			'',
			'',
			'Intelligent Query Action (' + [QUERY].[NAME] + '), Action (' + [QUERYACTION].[ACTIONNAME] +'), Action Type (' + [QUERYACTIONTYPE].[NAME] + '), User (' + [WORKFLOWSOCIALNETWORKUSERS].[DESCRIPTION] + ')',
			'C08776DA-046E-4E9B-9DE4-4CC2005A98CD',
			3,
			0,
			[QUERYACTION].[ACTIONNAME]
	FROM	[deleted]
			INNER JOIN [QUERYACTIONSOCIALNETWORK] ON [QUERYACTIONSOCIALNETWORK].[QUERYACTIONSOCIALNETWORKID] = [deleted].[QUERYACTIONSOCIALNETWORKID]
			INNER JOIN [QUERYACTION] ON [QUERYACTION].[QUERYACTIONID] = [QUERYACTIONSOCIALNETWORK].[QUERYACTIONID]
			INNER JOIN [QUERY] ON [QUERY].[QUERYID] = [QUERYACTION].[QUERYID]
			INNER JOIN [QUERYACTIONTYPE] WITH (NOLOCK) ON [QUERYACTIONTYPE].[QUERYACTIONTYPEID] = [QUERYACTION].[QUERYACTIONTYPEID]
			INNER JOIN [WORKFLOWSOCIALNETWORKUSERS] WITH (NOLOCK) ON [WORKFLOWSOCIALNETWORKUSERS].[GID] = [deleted].[USERID]
END