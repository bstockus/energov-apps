﻿CREATE TABLE [dbo].[PRPROJECTTYPEPLANORDER] (
    [PRPROJECTTYPEPLANORDERID] CHAR (36) NOT NULL,
    [PRPROJECTTYPEID]          CHAR (36) NOT NULL,
    [PLPLANTYPEID]             CHAR (36) NOT NULL,
    [PLPLANWORKCLASSID]        CHAR (36) NULL,
    [PLANORDER]                INT       NOT NULL,
    [AUTOADD]                  BIT       CONSTRAINT [DF_PRProjectTypePlanOrder_AutoAdd] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_PRProjectTypePlanOrder] PRIMARY KEY CLUSTERED ([PRPROJECTTYPEPLANORDERID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_PRProjectTypePlanOrder_PLPlanType] FOREIGN KEY ([PLPLANTYPEID]) REFERENCES [dbo].[PLPLANTYPE] ([PLPLANTYPEID]),
    CONSTRAINT [FK_PRProjectTypePlanOrder_PLPlanWorkClass] FOREIGN KEY ([PLPLANWORKCLASSID]) REFERENCES [dbo].[PLPLANWORKCLASS] ([PLPLANWORKCLASSID]),
    CONSTRAINT [FK_PRProjectTypePlanOrder_PRProjectType] FOREIGN KEY ([PRPROJECTTYPEID]) REFERENCES [dbo].[PRPROJECTTYPE] ([PRPROJECTTYPEID])
);


GO
CREATE NONCLUSTERED INDEX [PRPROJECTTYPEPLANORDER_IX_PRPROJECTTYPEID]
    ON [dbo].[PRPROJECTTYPEPLANORDER]([PRPROJECTTYPEID] ASC);


GO

CREATE TRIGGER [dbo].[TG_PRPROJECTTYPEPLANORDER_DELETE]
   ON  [dbo].[PRPROJECTTYPEPLANORDER]
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
        [PRPROJECTTYPE].[PRPROJECTTYPEID],
        [PRPROJECTTYPE].[ROWVERSION],
        GETUTCDATE(),
        (SELECT dbo.UFN_GET_USERID_FROM_CONTEXT_INFO()),
        'Project Type Plan Order Deleted',
        '',
        '',
        'Project Type (' + [PRPROJECTTYPE].[NAME] + '), Plan Order (' + [PLPLANTYPE].[PLANNAME] + ')',
		'3524A7D9-D7E6-44C1-A320-828311F3E4C6',
		3,
		0,
		[PLPLANTYPE].[PLANNAME]
    FROM [deleted]
	INNER JOIN [PRPROJECTTYPE] ON [PRPROJECTTYPE].[PRPROJECTTYPEID] = [deleted].[PRPROJECTTYPEID]
	INNER JOIN PLPLANTYPE PLPLANTYPE WITH (NOLOCK) ON [PLPLANTYPE].[PLPLANTYPEID] = [deleted].[PLPLANTYPEID]
END
GO

CREATE TRIGGER [dbo].[TG_PRPROJECTTYPEPLANORDER_UPDATE] on [dbo].[PRPROJECTTYPEPLANORDER]   
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
			[PRPROJECTTYPE].[PRPROJECTTYPEID],
			[PRPROJECTTYPE].[ROWVERSION],
			GETUTCDATE(),
			[PRPROJECTTYPE].[LASTCHANGEDBY],
			'Plan Type',
			[PLPLANTYPE_DELETED].[PLANNAME],
			[PLPLANTYPE_INSERTED].[PLANNAME],
			'Project Type (' + [PRPROJECTTYPE].[NAME] + '), Plan Order (' + [PLPLANTYPE_INSERTED].[PLANNAME] + ')',
			'3524A7D9-D7E6-44C1-A320-828311F3E4C6',
			2,
			0,
			[PLPLANTYPE_INSERTED].[PLANNAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[PRPROJECTTYPEPLANORDERID] = [inserted].[PRPROJECTTYPEPLANORDERID]
			INNER JOIN [PRPROJECTTYPE] ON [PRPROJECTTYPE].[PRPROJECTTYPEID] = [inserted].[PRPROJECTTYPEID]
			INNER JOIN PLPLANTYPE PLPLANTYPE_DELETED WITH (NOLOCK) ON [PLPLANTYPE_DELETED].[PLPLANTYPEID] = [deleted].[PLPLANTYPEID]
			INNER JOIN PLPLANTYPE PLPLANTYPE_INSERTED WITH (NOLOCK) ON [PLPLANTYPE_INSERTED].[PLPLANTYPEID] = [inserted].[PLPLANTYPEID]
	WHERE	[deleted].[PLPLANTYPEID] <> [inserted].[PLPLANTYPEID]
	UNION ALL

	SELECT 
			[PRPROJECTTYPE].[PRPROJECTTYPEID],
			[PRPROJECTTYPE].[ROWVERSION],
			GETUTCDATE(),
			[PRPROJECTTYPE].[LASTCHANGEDBY],
			'Plan Work Class',
			ISNULL([PLPLANWORKCLASS_DELETED].[NAME], '[none]'),
			ISNULL([PLPLANWORKCLASS_INSERTED].[NAME], '[none]'),
			'Project Type (' + [PRPROJECTTYPE].[NAME] + '), Plan Order (' + [PLPLANTYPE].[PLANNAME] + ')',
			'3524A7D9-D7E6-44C1-A320-828311F3E4C6',
			2,
			0,
			[PLPLANTYPE].[PLANNAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[PRPROJECTTYPEPLANORDERID] = [inserted].[PRPROJECTTYPEPLANORDERID]
			INNER JOIN [PRPROJECTTYPE] ON [PRPROJECTTYPE].[PRPROJECTTYPEID] = [inserted].[PRPROJECTTYPEID]
			INNER JOIN PLPLANTYPE PLPLANTYPE WITH (NOLOCK) ON [PLPLANTYPE].[PLPLANTYPEID] = [inserted].[PLPLANTYPEID]
			LEFT OUTER JOIN PLPLANWORKCLASS PLPLANWORKCLASS_DELETED WITH (NOLOCK) ON [PLPLANWORKCLASS_DELETED].[PLPLANWORKCLASSID] = [deleted].[PLPLANWORKCLASSID]
			LEFT OUTER JOIN PLPLANWORKCLASS PLPLANWORKCLASS_INSERTED WITH (NOLOCK) ON [PLPLANWORKCLASS_INSERTED].[PLPLANWORKCLASSID] = [inserted].[PLPLANWORKCLASSID]
	WHERE	ISNULL([deleted].[PLPLANWORKCLASSID], '') <> ISNULL([inserted].[PLPLANWORKCLASSID], '')
	UNION ALL

	SELECT 
			[PRPROJECTTYPE].[PRPROJECTTYPEID],
			[PRPROJECTTYPE].[ROWVERSION],
			GETUTCDATE(),
			[PRPROJECTTYPE].[LASTCHANGEDBY],
			'Priority Order',
			CAST([deleted].[PLANORDER] AS NVARCHAR(MAX)),
			CAST([inserted].[PLANORDER] AS NVARCHAR(MAX)),
			'Project Type (' + [PRPROJECTTYPE].[NAME] + '), Plan Order (' + [PLPLANTYPE].[PLANNAME] + ')',
			'3524A7D9-D7E6-44C1-A320-828311F3E4C6',
			2,
			0,
			[PLPLANTYPE].[PLANNAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[PRPROJECTTYPEPLANORDERID] = [inserted].[PRPROJECTTYPEPLANORDERID]
			INNER JOIN [PRPROJECTTYPE] ON [PRPROJECTTYPE].[PRPROJECTTYPEID] = [inserted].[PRPROJECTTYPEID]
			INNER JOIN PLPLANTYPE PLPLANTYPE WITH (NOLOCK) ON [PLPLANTYPE].[PLPLANTYPEID] = [inserted].[PLPLANTYPEID]
	WHERE	[deleted].[PLANORDER] <> [inserted].[PLANORDER]
	UNION ALL

	SELECT 
			[PRPROJECTTYPE].[PRPROJECTTYPEID],
			[PRPROJECTTYPE].[ROWVERSION],
			GETUTCDATE(),
			[PRPROJECTTYPE].[LASTCHANGEDBY],
			'Auto Add Flag',
			CASE WHEN [deleted].[AUTOADD] = 1 THEN 'Yes' ELSE 'No' END,
			CASE WHEN [inserted].[AUTOADD] = 1 THEN 'Yes' ELSE 'No' END,
			'Project Type (' + [PRPROJECTTYPE].[NAME] + '), Plan Order (' + [PLPLANTYPE].[PLANNAME] + ')',
			'3524A7D9-D7E6-44C1-A320-828311F3E4C6',
			2,
			0,
			[PLPLANTYPE].[PLANNAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[PRPROJECTTYPEPLANORDERID] = [inserted].[PRPROJECTTYPEPLANORDERID]
			INNER JOIN [PRPROJECTTYPE] ON [PRPROJECTTYPE].[PRPROJECTTYPEID] = [inserted].[PRPROJECTTYPEID]
			INNER JOIN PLPLANTYPE PLPLANTYPE WITH (NOLOCK) ON [PLPLANTYPE].[PLPLANTYPEID] = [inserted].[PLPLANTYPEID]
	WHERE	[deleted].[AUTOADD] <> [inserted].[AUTOADD]
END
GO

CREATE TRIGGER [dbo].[TG_PRPROJECTTYPEPLANORDER_INSERT]
   ON  [dbo].[PRPROJECTTYPEPLANORDER]
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
        [PRPROJECTTYPE].[PRPROJECTTYPEID],
        [PRPROJECTTYPE].[ROWVERSION],
        GETUTCDATE(),
        [PRPROJECTTYPE].[LASTCHANGEDBY],
        'Project Type Plan Order Added',
        '',
        '',
        'Project Type (' + [PRPROJECTTYPE].[NAME] + '), Plan Order (' + [PLPLANTYPE].[PLANNAME] + ')',
		'3524A7D9-D7E6-44C1-A320-828311F3E4C6',
		1,
		0,
		[PLPLANTYPE].[PLANNAME]
    FROM [inserted]
	INNER JOIN [PRPROJECTTYPE] ON [PRPROJECTTYPE].[PRPROJECTTYPEID] = [inserted].[PRPROJECTTYPEID]
	INNER JOIN PLPLANTYPE PLPLANTYPE WITH (NOLOCK) ON [PLPLANTYPE].[PLPLANTYPEID] = [inserted].[PLPLANTYPEID]
END