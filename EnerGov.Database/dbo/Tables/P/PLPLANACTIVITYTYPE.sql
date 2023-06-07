CREATE TABLE [dbo].[PLPLANACTIVITYTYPE] (
    [PLPLANACTIVITYTYPEID] CHAR (36)      NOT NULL,
    [NAME]                 NVARCHAR (50)  NOT NULL,
    [DESCRIPTION]          NVARCHAR (MAX) NULL,
    [CANEDIT]              BIT            NULL,
    [CREATEID]             BIT            NULL,
    [PREFIXID]             NVARCHAR (20)  NULL,
    [ALLOWDUPLICATE]       BIT            NULL,
    [CUSTOMFIELDID]        CHAR (36)      NULL,
    [LASTCHANGEDBY]        CHAR (36)      NULL,
    [LASTCHANGEDON]        DATETIME       CONSTRAINT [DF_PLPlanActivityType_LastChangedOn] DEFAULT (getutcdate()) NOT NULL,
    [ROWVERSION]           INT            CONSTRAINT [DF_PLPlanActivityType_RowVersion] DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_PLPlanActivityType] PRIMARY KEY CLUSTERED ([PLPLANACTIVITYTYPEID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_PLPlanActivityType_Custom] FOREIGN KEY ([CUSTOMFIELDID]) REFERENCES [dbo].[CUSTOMFIELDLAYOUT] ([GCUSTOMFIELDLAYOUTS]),
    CONSTRAINT [FK_PLPLANACTIVITYTYPE_USERS] FOREIGN KEY ([LASTCHANGEDBY]) REFERENCES [dbo].[USERS] ([SUSERGUID])
);


GO
CREATE NONCLUSTERED INDEX [PLPlanActivityType_IX_QUERY]
    ON [dbo].[PLPLANACTIVITYTYPE]([PLPLANACTIVITYTYPEID] ASC, [NAME] ASC);


GO


CREATE TRIGGER [TG_PLPLANACTIVITYTYPE_INSERT] ON PLPLANACTIVITYTYPE
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
			[inserted].[PLPLANACTIVITYTYPEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Plan Activity Type Added',
			'',
			'',
			'Plan Activity Type (' + [inserted].[NAME] + ')',
			'9EA5499D-9903-4E67-8A94-EEA624318335',
			1,
			1,
			[inserted].[NAME]
	FROM	[inserted]
END
GO


CREATE TRIGGER [TG_PLPLANACTIVITYTYPE_UPDATE] ON [PLPLANACTIVITYTYPE]
	AFTER UPDATE
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
			[inserted].[PLPLANACTIVITYTYPEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Name',
			[deleted].[NAME],
			[inserted].[NAME],
			'Plan Activity Type (' + [inserted].[NAME] + ')',
			'9EA5499D-9903-4E67-8A94-EEA624318335',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
	JOIN	[inserted] ON [deleted].[PLPLANACTIVITYTYPEID] = [inserted].[PLPLANACTIVITYTYPEID]
	WHERE	[deleted].[NAME] <> [inserted].[NAME]
	UNION ALL
	SELECT
			[inserted].[PLPLANACTIVITYTYPEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Description',
			ISNULL([deleted].[DESCRIPTION],'[none]'),
			ISNULL([inserted].[DESCRIPTION],'[none]'),
			'Plan Activity Type (' + [inserted].[NAME] + ')',
			'9EA5499D-9903-4E67-8A94-EEA624318335',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
	JOIN	[inserted] ON [deleted].[PLPLANACTIVITYTYPEID] = [inserted].[PLPLANACTIVITYTYPEID]
	WHERE	ISNULL([deleted].[DESCRIPTION],'') <> ISNULL([inserted].[DESCRIPTION], '')
	UNION ALL
	SELECT
			[inserted].[PLPLANACTIVITYTYPEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Can Edit Flag',
			CASE [deleted].[CANEDIT] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No'  ELSE '[none]' END,
			CASE [inserted].[CANEDIT] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No'  ELSE '[none]' END,
			'Plan Activity Type (' + [inserted].[NAME] + ')',
			'9EA5499D-9903-4E67-8A94-EEA624318335',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
	JOIN	[inserted] ON [deleted].[PLPLANACTIVITYTYPEID] = [inserted].[PLPLANACTIVITYTYPEID]
	WHERE	([deleted].[CANEDIT] <> [inserted].[CANEDIT]) OR ([deleted].[CANEDIT] IS NULL AND [inserted].[CANEDIT] IS NOT NULL)
			OR ([deleted].[CANEDIT] IS NOT NULL AND [inserted].[CANEDIT] IS NULL)
	UNION ALL
	SELECT
			[inserted].[PLPLANACTIVITYTYPEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Create Id Flag',
			CASE [deleted].[CREATEID] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No'  ELSE '[none]' END,
			CASE [inserted].[CREATEID] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No'  ELSE '[none]' END,
			'Plan Activity Type (' + [inserted].[NAME] + ')',
			'9EA5499D-9903-4E67-8A94-EEA624318335',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
	JOIN	[inserted] ON [deleted].[PLPLANACTIVITYTYPEID] = [inserted].[PLPLANACTIVITYTYPEID]
	WHERE	([deleted].[CREATEID] <> [inserted].[CREATEID]) OR ([deleted].[CREATEID] IS NULL AND [inserted].[CREATEID] IS NOT NULL)
			OR ([deleted].[CREATEID] IS NOT NULL AND [inserted].[CREATEID] IS NULL)
	UNION ALL
	SELECT
			[inserted].[PLPLANACTIVITYTYPEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Prefix Id',
			ISNULL([deleted].[PREFIXID], '[none]'),
			ISNULL([inserted].[PREFIXID], '[none]'),
			'Plan Activity Type (' + [inserted].[NAME] + ')',
			'9EA5499D-9903-4E67-8A94-EEA624318335',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
	JOIN	[inserted] ON [deleted].[PLPLANACTIVITYTYPEID] = [inserted].[PLPLANACTIVITYTYPEID]
	WHERE	ISNULL([deleted].[PREFIXID], '') <> ISNULL([inserted].[PREFIXID], '')
	UNION ALL
	SELECT
			[inserted].[PLPLANACTIVITYTYPEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Allow Duplicate Flag',
			CASE [deleted].[ALLOWDUPLICATE] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No'  ELSE '[none]' END,
			CASE [inserted].[ALLOWDUPLICATE] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No'  ELSE '[none]' END,
			'Plan Activity Type (' + [inserted].[NAME] + ')',
			'9EA5499D-9903-4E67-8A94-EEA624318335',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
	JOIN	[inserted] ON [deleted].[PLPLANACTIVITYTYPEID] = [inserted].[PLPLANACTIVITYTYPEID]
	WHERE	([deleted].[ALLOWDUPLICATE] <> [inserted].[ALLOWDUPLICATE]) OR ([deleted].[ALLOWDUPLICATE] IS NULL AND [inserted].[ALLOWDUPLICATE] IS NOT NULL)
			OR ([deleted].[ALLOWDUPLICATE] IS NOT NULL AND [inserted].[ALLOWDUPLICATE] IS NULL)
	UNION ALL
	SELECT
			[inserted].[PLPLANACTIVITYTYPEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Custom Field',
			ISNULL([CUSTOMFIELDLAYOUT_DELETED].[SNAME], '[none]'),
			ISNULL([CUSTOMFIELDLAYOUT_INSERTED].[SNAME], '[none]'),
			'Plan Activity Type (' + [inserted].[NAME] + ')',
			'9EA5499D-9903-4E67-8A94-EEA624318335',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
	JOIN	[inserted] ON [deleted].[PLPLANACTIVITYTYPEID] = [inserted].[PLPLANACTIVITYTYPEID]
	LEFT JOIN CUSTOMFIELDLAYOUT CUSTOMFIELDLAYOUT_DELETED WITH (NOLOCK) ON [deleted].[CUSTOMFIELDID] = [CUSTOMFIELDLAYOUT_DELETED].[GCUSTOMFIELDLAYOUTS]
	LEFT JOIN CUSTOMFIELDLAYOUT CUSTOMFIELDLAYOUT_INSERTED WITH (NOLOCK) ON [inserted].[CUSTOMFIELDID] = [CUSTOMFIELDLAYOUT_INSERTED].[GCUSTOMFIELDLAYOUTS]
	WHERE	ISNULL([deleted].[CUSTOMFIELDID], '') <> ISNULL([inserted].[CUSTOMFIELDID], '')
	
END
GO

CREATE TRIGGER [TG_PLPLANACTIVITYTYPE_DELETE] ON [PLPLANACTIVITYTYPE]
	AFTER DELETE
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
			[deleted].[PLPLANACTIVITYTYPEID],
			[deleted].[ROWVERSION],
			GETUTCDATE(),
			(SELECT dbo.UFN_GET_USERID_FROM_CONTEXT_INFO()),
			'Plan Activity Type Deleted',
			'',
			'',
			'Plan Activity Type (' + [deleted].[NAME] + ')',
			'9EA5499D-9903-4E67-8A94-EEA624318335',
			3,
			1,
			[deleted].[NAME]
	FROM	[deleted]
END