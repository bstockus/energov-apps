﻿CREATE TABLE [dbo].[ENERGOVWIDGETROLEXREF] (
    [WIDGETID]     CHAR (36)    NOT NULL,
    [ROLEID]       CHAR (36)    NOT NULL,
    [VISIBLE]      BIT          NULL,
    [DISPLAYORDER] NUMERIC (18) NULL,
    CONSTRAINT [PK_EnerGovWidgetRoleXREF_1] PRIMARY KEY CLUSTERED ([WIDGETID] ASC, [ROLEID] ASC) WITH (FILLFACTOR = 80),
    CONSTRAINT [FK_EnerGovWidgetRoleXREF_EnerGovWidget] FOREIGN KEY ([WIDGETID]) REFERENCES [dbo].[ENERGOVWIDGET] ([WIDGETID]),
    CONSTRAINT [FK_EnerGovWidgetRoleXREF_Roles] FOREIGN KEY ([ROLEID]) REFERENCES [dbo].[ROLES] ([SROLEGUID])
);


GO
CREATE NONCLUSTERED INDEX [ENERGOVWIDGETROLEXREF_IX_ROLEID]
    ON [dbo].[ENERGOVWIDGETROLEXREF]([ROLEID] ASC);


GO

CREATE TRIGGER [TG_ENERGOVWIDGETROLEXREF_INSERT] ON [ENERGOVWIDGETROLEXREF]
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
			[ROLES].[SROLEGUID],
			[ROLES].[ROWVERSION],
			GETUTCDATE(),
			[ROLES].[LASTCHANGEDBY],
			'User Role - Widget Added',
			'',
			'',
			'User Role (' + [ROLES].[ID] + '), Widget (' + ISNULL([ENERGOVWIDGET].[WIDGETNAME], '[none]') + ')',
			'801F270F-912F-420A-91D6-82EBC3F351F3',
			1,
			0,
			ISNULL([ENERGOVWIDGET].[WIDGETNAME], '[none]')
	FROM	[inserted]
	INNER JOIN [ROLES] ON [inserted].[ROLEID] = [ROLES].[SROLEGUID]
	INNER JOIN [ENERGOVWIDGET] WITH (NOLOCK) ON [ENERGOVWIDGET].[WIDGETID] = [inserted].[WIDGETID]	

END
GO

CREATE TRIGGER [dbo].[TG_ENERGOVWIDGETROLEXREF_UPDATE] ON  [dbo].[ENERGOVWIDGETROLEXREF]
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
			[ROLES].[SROLEGUID],
			[ROLES].[ROWVERSION],
			GETUTCDATE(),
			[ROLES].[LASTCHANGEDBY],
			'Visible Flag',			
			CASE [deleted].[VISIBLE] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' ELSE '[none]' END,
			CASE [inserted].[VISIBLE] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' ELSE '[none]' END,
			'User Role (' + [ROLES].[ID] + '), Widget (' + ISNULL([ENERGOVWIDGET].[WIDGETNAME], '[none]') + ')',
			'801F270F-912F-420A-91D6-82EBC3F351F3',
			2,
			0,
			ISNULL([ENERGOVWIDGET].[WIDGETNAME], '[none]')
	FROM	[deleted] JOIN [inserted] ON [deleted].[WIDGETID] = [inserted].[WIDGETID]
	INNER JOIN [ROLES] ON [ROLES].[SROLEGUID] = [inserted].[ROLEID]
	INNER JOIN [ENERGOVWIDGET] WITH (NOLOCK) ON [ENERGOVWIDGET].[WIDGETID] = [inserted].[WIDGETID]	
	WHERE	[deleted].[VISIBLE] <> [inserted].[VISIBLE]
	OR ([deleted].[VISIBLE] IS NULL AND [inserted].[VISIBLE] IS NOT NULL)
	OR ([deleted].[VISIBLE] IS NOT NULL AND [inserted].[VISIBLE] IS NULL)
	UNION ALL

	SELECT 
			[ROLES].[SROLEGUID],
			[ROLES].[ROWVERSION],
			GETUTCDATE(),
			[ROLES].[LASTCHANGEDBY],
			'Display Order',
			ISNULL(CAST([deleted].[DISPLAYORDER] AS NVARCHAR(MAX)),'[none]'),
			ISNULL(CAST([inserted].[DISPLAYORDER] AS NVARCHAR(MAX)),'[none]'),
			'User Role (' + [ROLES].[ID] + '), Widget (' + ISNULL([ENERGOVWIDGET].[WIDGETNAME], '[none]') + ')',
			'801F270F-912F-420A-91D6-82EBC3F351F3',
			2,
			0,
			ISNULL([ENERGOVWIDGET].[WIDGETNAME], '[none]')
	FROM	[deleted] JOIN [inserted] ON [deleted].[WIDGETID] = [inserted].[WIDGETID]
	INNER JOIN [ROLES] ON [ROLES].[SROLEGUID] = [inserted].[ROLEID]
	INNER JOIN [ENERGOVWIDGET] WITH (NOLOCK) ON [ENERGOVWIDGET].[WIDGETID] = [inserted].[WIDGETID]	
	WHERE ([deleted].[DISPLAYORDER] IS NULL AND [inserted].[DISPLAYORDER] IS NOT NULL)  
    OR ([deleted].[DISPLAYORDER] IS NOT NULL AND [inserted].[DISPLAYORDER] IS NULL)   
    OR ([deleted].[DISPLAYORDER] <> [inserted].[DISPLAYORDER])  
END