﻿CREATE TABLE [dbo].[GEORULEPROCESS] (
    [GEORULEPROCESSID]     CHAR (36)      NOT NULL,
    [GEORULEID]            CHAR (36)      NOT NULL,
    [GEORULEPROCESSTYPEID] CHAR (36)      NOT NULL,
    [GEORULECOMPARERID]    INT            NOT NULL,
    [PROCESSNAME]          NVARCHAR (30)  NOT NULL,
    [MESSAGETEXT]          NVARCHAR (MAX) NULL,
    [WORKFLOWSTEPID]       CHAR (36)      NULL,
    [WORKFLOWACTIONSTEPID] CHAR (36)      NULL,
    [COMPARER]             NVARCHAR (150) NULL,
    [PRIORITY]             INT            CONSTRAINT [DF_GeoRuleProcess_Priority] DEFAULT ((0)) NOT NULL,
    [PLSUBMITTALTYPEID]    CHAR (36)      NULL,
    [PLITEMREVIEWTYPEID]   CHAR (36)      NULL,
    [GEORULEMULTIRETURNID] INT            NULL,
    [MULTIRETURNVALUE]     NVARCHAR (150) NULL,
    [GISATTRIBUTENAME]     NVARCHAR (250) NULL,
    CONSTRAINT [PK_PLGeoRuleProcess] PRIMARY KEY CLUSTERED ([GEORULEPROCESSID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_GEORULEPROCESS_GEORULEMUL] FOREIGN KEY ([GEORULEMULTIRETURNID]) REFERENCES [dbo].[GEORULEMULTIRETURN] ([GEORULEMULTIRETURNID]),
    CONSTRAINT [FK_GeoRuleProcess_WFAction] FOREIGN KEY ([WORKFLOWACTIONSTEPID]) REFERENCES [dbo].[WFACTION] ([WFACTIONID]),
    CONSTRAINT [FK_GeoRuleProcess_WFStep] FOREIGN KEY ([WORKFLOWSTEPID]) REFERENCES [dbo].[WFSTEP] ([WFSTEPID]),
    CONSTRAINT [FK_GRP_ReviewItemType] FOREIGN KEY ([PLITEMREVIEWTYPEID]) REFERENCES [dbo].[PLITEMREVIEWTYPE] ([PLITEMREVIEWTYPEID]),
    CONSTRAINT [FK_GRP_SubmittalType] FOREIGN KEY ([PLSUBMITTALTYPEID]) REFERENCES [dbo].[PLSUBMITTALTYPE] ([PLSUBMITTALTYPEID]),
    CONSTRAINT [FK_Process_GeoRule] FOREIGN KEY ([GEORULEID]) REFERENCES [dbo].[GEORULE] ([GEORULEID]),
    CONSTRAINT [FK_Process_ProcessType] FOREIGN KEY ([GEORULEPROCESSTYPEID]) REFERENCES [dbo].[GEORULEPROCESSTYPE] ([GEORULEPROCESSTYPEID]),
    CONSTRAINT [FK_RuleProcess_Comparer] FOREIGN KEY ([GEORULECOMPARERID]) REFERENCES [dbo].[GEORULECOMPARER] ([GEORULECOMPARERID])
);


GO
CREATE NONCLUSTERED INDEX [GEORULEPROCESS_IX_GEORULEID]
    ON [dbo].[GEORULEPROCESS]([GEORULEID] ASC);


GO

CREATE TRIGGER [TG_GEORULEPROCESS_DELETE] ON [GEORULEPROCESS]
	AFTER DELETE
AS
BEGIN
	SET NOCOUNT ON

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
			[GEORULE].[GEORULEID],
			[GEORULE].[ROWVERSION],
			GETUTCDATE(),
			(SELECT dbo.UFN_GET_USERID_FROM_CONTEXT_INFO()),
			'Geo Rule Process Deleted',
			'',
			'',
			'Geo Rule (' + [GEORULE].[RULENAME] + '), Process (' + [deleted].[PROCESSNAME] + ')',
			'92E08D84-E807-4CC4-936A-04DCD65AF43A',
			3,
			0,
			[deleted].[PROCESSNAME]
	FROM	[deleted]
			JOIN [GEORULE] ON [deleted].[GEORULEID] = [GEORULE].[GEORULEID]
END
GO

CREATE TRIGGER [TG_GEORULEPROCESS_INSERT] ON [GEORULEPROCESS]
	AFTER INSERT
AS
BEGIN
	SET NOCOUNT ON

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
			[GEORULE].[GEORULEID],
			[GEORULE].[ROWVERSION],
			GETUTCDATE(),
			[GEORULE].[LASTCHANGEDBY],
			'Geo Rule Process Added',
			'',
			'',
			'Geo Rule (' + [GEORULE].[RULENAME] + '), Process (' + [inserted].[PROCESSNAME] + ')',
			'92E08D84-E807-4CC4-936A-04DCD65AF43A',
			1,
			0,
			[inserted].[PROCESSNAME]
	FROM	[inserted]
			JOIN [GEORULE] ON [inserted].[GEORULEID] = [GEORULE].[GEORULEID]
END
GO

CREATE TRIGGER [dbo].[TG_GEORULEPROCESS_UPDATE] ON [dbo].[GEORULEPROCESS] 
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
			[GEORULE].[GEORULEID],
			[GEORULE].[ROWVERSION],
			GETUTCDATE(),
			[GEORULE].[LASTCHANGEDBY],
			'Process Type',
			[GEORULEPROCESSTYPE_DELETED].[GEORULEPROCESSTYPENAME],
			[GEORULEPROCESSTYPE_INSERTED].[GEORULEPROCESSTYPENAME],
			'Geo Rule (' + [GEORULE].[RULENAME] + '), Process (' + [inserted].[PROCESSNAME] + ')',
			'92E08D84-E807-4CC4-936A-04DCD65AF43A',
			2,
			0,
			[inserted].[PROCESSNAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[GEORULEPROCESSID] = [inserted].[GEORULEPROCESSID]
			JOIN [GEORULE] ON [GEORULE].[GEORULEID] = [inserted].[GEORULEID]
			JOIN [GEORULEPROCESSTYPE] [GEORULEPROCESSTYPE_DELETED] WITH (NOLOCK) ON [deleted].[GEORULEPROCESSTYPEID] = [GEORULEPROCESSTYPE_DELETED].[GEORULEPROCESSTYPEID]
			JOIN [GEORULEPROCESSTYPE] [GEORULEPROCESSTYPE_INSERTED] WITH (NOLOCK) ON [inserted].[GEORULEPROCESSTYPEID] = [GEORULEPROCESSTYPE_INSERTED].[GEORULEPROCESSTYPEID]
	WHERE	[deleted].[GEORULEPROCESSTYPEID] <> [inserted].[GEORULEPROCESSTYPEID]

	UNION ALL
	SELECT
			[GEORULE].[GEORULEID],
			[GEORULE].[ROWVERSION],
			GETUTCDATE(),
			[GEORULE].[LASTCHANGEDBY],
			'Comparer Name',
			[GEORULECOMPARER_DELETED].[COMPARERNAME],
			[GEORULECOMPARER_INSERTED].[COMPARERNAME],
			'Geo Rule (' + [GEORULE].[RULENAME] + '), Process (' + [inserted].[PROCESSNAME] + ')',
			'92E08D84-E807-4CC4-936A-04DCD65AF43A',
			2,
			0,
			[inserted].[PROCESSNAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[GEORULEPROCESSID] = [inserted].[GEORULEPROCESSID]
			JOIN [GEORULE] ON [GEORULE].[GEORULEID] = [inserted].[GEORULEID]
			JOIN [GEORULECOMPARER] [GEORULECOMPARER_DELETED] WITH (NOLOCK) ON [deleted].[GEORULECOMPARERID] = [GEORULECOMPARER_DELETED].[GEORULECOMPARERID]
			JOIN [GEORULECOMPARER] [GEORULECOMPARER_INSERTED] WITH (NOLOCK) ON [inserted].[GEORULECOMPARERID] = [GEORULECOMPARER_INSERTED].[GEORULECOMPARERID]
	WHERE	[deleted].[GEORULECOMPARERID] <> [inserted].[GEORULECOMPARERID]

	UNION ALL
	SELECT
			[GEORULE].[GEORULEID],
			[GEORULE].[ROWVERSION],
			GETUTCDATE(),
			[GEORULE].[LASTCHANGEDBY],
			'Process Name',
			[deleted].[PROCESSNAME],
			[inserted].[PROCESSNAME],
			'Geo Rule (' + [GEORULE].[RULENAME] + '), Process (' + [inserted].[PROCESSNAME] + ')',
			'92E08D84-E807-4CC4-936A-04DCD65AF43A',
			2,
			0,
			[inserted].[PROCESSNAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[GEORULEPROCESSID] = [inserted].[GEORULEPROCESSID]
			JOIN [GEORULE] ON [GEORULE].[GEORULEID] = [inserted].[GEORULEID]
	WHERE	[deleted].[PROCESSNAME] <> [inserted].[PROCESSNAME]

	UNION ALL
	SELECT
			[GEORULE].[GEORULEID],
			[GEORULE].[ROWVERSION],
			GETUTCDATE(),
			[GEORULE].[LASTCHANGEDBY],
			'Process Message',
			ISNULL([deleted].[MESSAGETEXT], '[none]'),
			ISNULL([inserted].[MESSAGETEXT], '[none]'),
			'Geo Rule (' + [GEORULE].[RULENAME] + '), Process (' + [inserted].[PROCESSNAME] + ')',
			'92E08D84-E807-4CC4-936A-04DCD65AF43A',
			2,
			0,
			[inserted].[PROCESSNAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[GEORULEPROCESSID] = [inserted].[GEORULEPROCESSID]
			JOIN [GEORULE] ON [GEORULE].[GEORULEID] = [inserted].[GEORULEID]
	WHERE	ISNULL([deleted].[MESSAGETEXT], '') <> ISNULL([inserted].[MESSAGETEXT], '')

	UNION ALL
	SELECT
			[GEORULE].[GEORULEID],
			[GEORULE].[ROWVERSION],
			GETUTCDATE(),
			[GEORULE].[LASTCHANGEDBY],
			'Wofkflow Step',
			ISNULL([WFSTEP_DELETED].[NAME], '[none]'),
			ISNULL([WFSTEP_INSERTED].[NAME], '[none]'),
			'Geo Rule (' + [GEORULE].[RULENAME] + '), Process (' + [inserted].[PROCESSNAME] + ')',
			'92E08D84-E807-4CC4-936A-04DCD65AF43A',
			2,
			0,
			[inserted].[PROCESSNAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[GEORULEPROCESSID] = [inserted].[GEORULEPROCESSID]
			JOIN [GEORULE] ON [GEORULE].[GEORULEID] = [inserted].[GEORULEID]
			LEFT JOIN [WFSTEP] [WFSTEP_DELETED] WITH (NOLOCK) ON [deleted].[WORKFLOWSTEPID] = [WFSTEP_DELETED].[WFSTEPID]
			LEFT JOIN [WFSTEP] [WFSTEP_INSERTED] WITH (NOLOCK) ON [inserted].[WORKFLOWSTEPID] = [WFSTEP_INSERTED].[WFSTEPID]
	WHERE	ISNULL([deleted].[WORKFLOWSTEPID], '') <> ISNULL([inserted].[WORKFLOWSTEPID], '')

	UNION ALL
	SELECT
			[GEORULE].[GEORULEID],
			[GEORULE].[ROWVERSION],
			GETUTCDATE(),
			[GEORULE].[LASTCHANGEDBY],
			'Wofkflow Action',
			ISNULL([WFACTION_DELETED].[NAME], '[none]'),
			ISNULL([WFACTION_INSERTED].[NAME], '[none]'),
			'Geo Rule (' + [GEORULE].[RULENAME] + '), Process (' + [inserted].[PROCESSNAME] + ')',
			'92E08D84-E807-4CC4-936A-04DCD65AF43A',
			2,
			0,
			[inserted].[PROCESSNAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[GEORULEPROCESSID] = [inserted].[GEORULEPROCESSID]
			JOIN [GEORULE] ON [GEORULE].[GEORULEID] = [inserted].[GEORULEID]
			LEFT JOIN [WFACTION] [WFACTION_DELETED] WITH (NOLOCK) ON [deleted].[WORKFLOWACTIONSTEPID] = [WFACTION_DELETED].[WFACTIONID]
			LEFT JOIN [WFACTION] [WFACTION_INSERTED] WITH (NOLOCK) ON [inserted].[WORKFLOWACTIONSTEPID] = [WFACTION_INSERTED].[WFACTIONID]
	WHERE	ISNULL([deleted].[WORKFLOWACTIONSTEPID], '') <> ISNULL([inserted].[WORKFLOWACTIONSTEPID], '')

	UNION ALL
	SELECT
			[GEORULE].[GEORULEID],
			[GEORULE].[ROWVERSION],
			GETUTCDATE(),
			[GEORULE].[LASTCHANGEDBY],
			'Compare',
			ISNULL([deleted].[COMPARER], '[none]'),
			ISNULL([inserted].[COMPARER], '[none]'),
			'Geo Rule (' + [GEORULE].[RULENAME] + '), Process (' + [inserted].[PROCESSNAME] + ')',
			'92E08D84-E807-4CC4-936A-04DCD65AF43A',
			2,
			0,
			[inserted].[PROCESSNAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[GEORULEPROCESSID] = [inserted].[GEORULEPROCESSID]
			JOIN [GEORULE] ON [GEORULE].[GEORULEID] = [inserted].[GEORULEID]
	WHERE	ISNULL([deleted].[COMPARER], '') <> ISNULL([inserted].[COMPARER], '')

	UNION ALL
	SELECT
			[GEORULE].[GEORULEID],
			[GEORULE].[ROWVERSION],
			GETUTCDATE(),
			[GEORULE].[LASTCHANGEDBY],
			'Priority',
			CAST([deleted].[PRIORITY] AS NVARCHAR(MAX)),
			CAST([inserted].[PRIORITY] AS NVARCHAR(MAX)),
			'Geo Rule (' + [GEORULE].[RULENAME] + '), Process (' + [inserted].[PROCESSNAME] + ')',
			'92E08D84-E807-4CC4-936A-04DCD65AF43A',
			2,
			0,
			[inserted].[PROCESSNAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[GEORULEPROCESSID] = [inserted].[GEORULEPROCESSID]
			JOIN [GEORULE] ON [GEORULE].[GEORULEID] = [inserted].[GEORULEID]
	WHERE	[deleted].[PRIORITY] <> [inserted].[PRIORITY]

	UNION ALL
	SELECT
			[GEORULE].[GEORULEID],
			[GEORULE].[ROWVERSION],
			GETUTCDATE(),
			[GEORULE].[LASTCHANGEDBY],
			'Submittal Type',
			ISNULL([PLSUBMITTALTYPE_DELETED].[TYPENAME], '[none]'),
			ISNULL([PLSUBMITTALTYPE_INSERTED].[TYPENAME], '[none]'),
			'Geo Rule (' + [GEORULE].[RULENAME] + '), Process (' + [inserted].[PROCESSNAME] + ')',
			'92E08D84-E807-4CC4-936A-04DCD65AF43A',
			2,
			0,
			[inserted].[PROCESSNAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[GEORULEPROCESSID] = [inserted].[GEORULEPROCESSID]
			JOIN [GEORULE] ON [GEORULE].[GEORULEID] = [inserted].[GEORULEID]
			LEFT JOIN [PLSUBMITTALTYPE] [PLSUBMITTALTYPE_DELETED] WITH (NOLOCK) ON [deleted].[PLSUBMITTALTYPEID] = [PLSUBMITTALTYPE_DELETED].[PLSUBMITTALTYPEID]
			LEFT JOIN [PLSUBMITTALTYPE] [PLSUBMITTALTYPE_INSERTED] WITH (NOLOCK) ON [inserted].[PLSUBMITTALTYPEID] = [PLSUBMITTALTYPE_INSERTED].[PLSUBMITTALTYPEID]
	WHERE	ISNULL([deleted].[PLSUBMITTALTYPEID], '') <> ISNULL([inserted].[PLSUBMITTALTYPEID], '')

	UNION ALL
	SELECT
			[GEORULE].[GEORULEID],
			[GEORULE].[ROWVERSION],
			GETUTCDATE(),
			[GEORULE].[LASTCHANGEDBY],
			'Review Item Type',
			ISNULL([PLITEMREVIEWTYPE_DELETED].[NAME], '[none]'),
			ISNULL([PLITEMREVIEWTYPE_INSERTED].[NAME], '[none]'),
			'Geo Rule (' + [GEORULE].[RULENAME] + '), Process (' + [inserted].[PROCESSNAME] + ')',
			'92E08D84-E807-4CC4-936A-04DCD65AF43A',
			2,
			0,
			[inserted].[PROCESSNAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[GEORULEPROCESSID] = [inserted].[GEORULEPROCESSID]
			JOIN [GEORULE] ON [GEORULE].[GEORULEID] = [inserted].[GEORULEID]
			LEFT JOIN [PLITEMREVIEWTYPE] [PLITEMREVIEWTYPE_DELETED] WITH (NOLOCK) ON [deleted].[PLITEMREVIEWTYPEID] = [PLITEMREVIEWTYPE_DELETED].[PLITEMREVIEWTYPEID]
			LEFT JOIN [PLITEMREVIEWTYPE] [PLITEMREVIEWTYPE_INSERTED] WITH (NOLOCK) ON [inserted].[PLITEMREVIEWTYPEID] = [PLITEMREVIEWTYPE_INSERTED].[PLITEMREVIEWTYPEID]
	WHERE	ISNULL([deleted].[PLITEMREVIEWTYPEID], '') <> ISNULL([inserted].[PLITEMREVIEWTYPEID], '')

	UNION ALL
	SELECT
			[GEORULE].[GEORULEID],
			[GEORULE].[ROWVERSION],
			GETUTCDATE(),
			[GEORULE].[LASTCHANGEDBY],
			'Multi-Return Options',
			ISNULL([GEORULEMULTIRETURN_DELETED].[NAME], '[none]'),
			ISNULL([GEORULEMULTIRETURN_INSERTED].[NAME], '[none]'),
			'Geo Rule (' + [GEORULE].[RULENAME] + '), Process (' + [inserted].[PROCESSNAME] + ')',
			'92E08D84-E807-4CC4-936A-04DCD65AF43A',
			2,
			0,
			[inserted].[PROCESSNAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[GEORULEPROCESSID] = [inserted].[GEORULEPROCESSID]
			JOIN [GEORULE] ON [GEORULE].[GEORULEID] = [inserted].[GEORULEID]
			LEFT JOIN [GEORULEMULTIRETURN] [GEORULEMULTIRETURN_DELETED] WITH (NOLOCK) ON [deleted].[GEORULEMULTIRETURNID] = [GEORULEMULTIRETURN_DELETED].[GEORULEMULTIRETURNID]
			LEFT JOIN [GEORULEMULTIRETURN] [GEORULEMULTIRETURN_INSERTED] WITH (NOLOCK) ON [inserted].[GEORULEMULTIRETURNID] = [GEORULEMULTIRETURN_INSERTED].[GEORULEMULTIRETURNID]
	WHERE	ISNULL([deleted].[GEORULEMULTIRETURNID], '') <> ISNULL([inserted].[GEORULEMULTIRETURNID], '')

	UNION ALL
	SELECT
			[GEORULE].[GEORULEID],
			[GEORULE].[ROWVERSION],
			GETUTCDATE(),
			[GEORULE].[LASTCHANGEDBY],
			'Multi-Return Options Value',
			ISNULL([deleted].[MULTIRETURNVALUE], '[none]'),
			ISNULL([inserted].[MULTIRETURNVALUE], '[none]'),
			'Geo Rule (' + [GEORULE].[RULENAME] + '), Process (' + [inserted].[PROCESSNAME] + ')',
			'92E08D84-E807-4CC4-936A-04DCD65AF43A',
			2,
			0,
			[inserted].[PROCESSNAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[GEORULEPROCESSID] = [inserted].[GEORULEPROCESSID]
			JOIN [GEORULE] ON [GEORULE].[GEORULEID] = [inserted].[GEORULEID]
	WHERE	ISNULL([deleted].[MULTIRETURNVALUE], '') <> ISNULL([inserted].[MULTIRETURNVALUE], '')

	UNION ALL
	SELECT
			[GEORULE].[GEORULEID],
			[GEORULE].[ROWVERSION],
			GETUTCDATE(),
			[GEORULE].[LASTCHANGEDBY],
			'Returned Field is',
			ISNULL([deleted].[GISATTRIBUTENAME], '[none]'),
			ISNULL([inserted].[GISATTRIBUTENAME], '[none]'),
			'Geo Rule (' + [GEORULE].[RULENAME] + '), Process (' + [inserted].[PROCESSNAME] + ')',
			'92E08D84-E807-4CC4-936A-04DCD65AF43A',
			2,
			0,
			[inserted].[PROCESSNAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[GEORULEPROCESSID] = [inserted].[GEORULEPROCESSID]
			JOIN [GEORULE] ON [GEORULE].[GEORULEID] = [inserted].[GEORULEID]
	WHERE	ISNULL([deleted].[GISATTRIBUTENAME], '') <> ISNULL([inserted].[GISATTRIBUTENAME], '')
END