﻿CREATE TABLE [dbo].[WORKFLOWACTIONPARAMETER] (
    [WORKFLOWACTIONPARAMETERID] CHAR (36)      NOT NULL,
    [WORKFLOWACTIONID]          CHAR (36)      NOT NULL,
    [PARAMETERNAME]             NVARCHAR (MAX) NOT NULL,
    [PARAMETERVALUE]            NVARCHAR (MAX) NOT NULL,
    [PARAMETERTYPE]             NVARCHAR (MAX) NOT NULL,
    CONSTRAINT [PK_WorkflowActionParameter] PRIMARY KEY CLUSTERED ([WORKFLOWACTIONPARAMETERID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_WFActionParameter_WFAction] FOREIGN KEY ([WORKFLOWACTIONID]) REFERENCES [dbo].[WORKFLOWACTION] ([WORKFLOWACTIONID])
);


GO
CREATE NONCLUSTERED INDEX [IX_WorkflowActionParameter]
    ON [dbo].[WORKFLOWACTIONPARAMETER]([WORKFLOWACTIONID] ASC) WITH (FILLFACTOR = 90);


GO

CREATE TRIGGER [dbo].[TG_WORKFLOWACTIONPARAMETER_DELETE]
   ON  [dbo].[WORKFLOWACTIONPARAMETER]
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
			'On Fee Template Deleted',
			[CAFEETEMPLATE].[CAFEETEMPLATENAME],
			'(Default)',
			'Intelligent Object (' + [WORKFLOW].[WORKFLOWNAME] + '), Action (' + [WORKFLOWACTION].[ACTIONNAME] +'), Action Type (' + [WORKFLOWACTIONTYPE].[WORKFLOWACTIONTYPENAME] + ')',
			'F053A756-19BE-4A42-A70D-185D5B01C31A',
			3,
			0,
			[WORKFLOWACTION].[ACTIONNAME]
	FROM	[deleted]
			INNER JOIN [WORKFLOWACTION] ON [WORKFLOWACTION].[WORKFLOWACTIONID] = [deleted].[WORKFLOWACTIONID]
			INNER JOIN [WORKFLOW] ON [WORKFLOW].[WORKFLOWID] = [WORKFLOWACTION].[WORKFLOWID]
			INNER JOIN [WORKFLOWACTIONTYPE] WITH (NOLOCK) ON [WORKFLOWACTIONTYPE].[WORKFLOWACTIONTYPEID] = [WORKFLOWACTION].[WORKFLOWACTIONTYPEID]
			INNER JOIN [CAFEETEMPLATE] WITH (NOLOCK) ON [CAFEETEMPLATE].[CAFEETEMPLATEID] = [deleted].[PARAMETERVALUE]
	WHERE 	[deleted].[PARAMETERNAME] = 'FeeTemplateID'

END
GO

CREATE TRIGGER [dbo].[TG_WORKFLOWACTIONPARAMETER_INSERT]
   ON  [dbo].[WORKFLOWACTIONPARAMETER]
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
			'On Fee Template Added',
			'(Default)',
			[CAFEETEMPLATE].[CAFEETEMPLATENAME],
			'Intelligent Object (' + [WORKFLOW].[WORKFLOWNAME] + '), Action (' + [WORKFLOWACTION].[ACTIONNAME] +'), Action Type (' + [WORKFLOWACTIONTYPE].[WORKFLOWACTIONTYPENAME] + ')',
			'F053A756-19BE-4A42-A70D-185D5B01C31A',
			1,
			0,
			[WORKFLOWACTION].[ACTIONNAME]
	FROM	[inserted]
			INNER JOIN [WORKFLOWACTION] ON [WORKFLOWACTION].[WORKFLOWACTIONID] = [inserted].[WORKFLOWACTIONID]
			INNER JOIN [WORKFLOW] ON [WORKFLOW].[WORKFLOWID] = [WORKFLOWACTION].[WORKFLOWID]
			INNER JOIN [WORKFLOWACTIONTYPE] WITH (NOLOCK) ON [WORKFLOWACTIONTYPE].[WORKFLOWACTIONTYPEID] = [WORKFLOWACTION].[WORKFLOWACTIONTYPEID]
			INNER JOIN [CAFEETEMPLATE] WITH (NOLOCK) ON [CAFEETEMPLATE].[CAFEETEMPLATEID] = [inserted].[PARAMETERVALUE]
	WHERE [inserted].[PARAMETERNAME] = 'FeeTemplateID'

END
GO

CREATE TRIGGER [dbo].[TG_WORKFLOWACTIONPARAMETER_UPDATE]
   ON  [dbo].[WORKFLOWACTIONPARAMETER]
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
			CASE  WHEN INSERTCAFEETEMPLATE.[CAFEETEMPLATEID] IS NULL THEN [inserted].[PARAMETERNAME] ELSE 'On Fee Template' END,
			CASE  WHEN DELETECAFEETEMPLATE.[CAFEETEMPLATEID] IS NULL THEN [deleted].[PARAMETERVALUE] ELSE DELETECAFEETEMPLATE.[CAFEETEMPLATENAME] END,
			CASE  WHEN INSERTCAFEETEMPLATE.[CAFEETEMPLATEID] IS NULL THEN [inserted].[PARAMETERVALUE] ELSE INSERTCAFEETEMPLATE.[CAFEETEMPLATENAME] END,
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
			LEFT JOIN [CAFEETEMPLATE]  AS DELETECAFEETEMPLATE WITH (NOLOCK) ON DELETECAFEETEMPLATE.[CAFEETEMPLATEID] = [deleted].[PARAMETERVALUE]
			LEFT JOIN [CAFEETEMPLATE]  AS INSERTCAFEETEMPLATE WITH (NOLOCK) ON INSERTCAFEETEMPLATE.[CAFEETEMPLATEID] = [inserted].[PARAMETERVALUE]
	WHERE	[deleted].[PARAMETERVALUE] <> [inserted].[PARAMETERVALUE]
END