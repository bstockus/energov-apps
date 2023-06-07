CREATE TABLE [dbo].[CMCODEACTIVITYTYPE] (
    [CMCODEACTIVITYTYPEID] CHAR (36)      NOT NULL,
    [NAME]                 NVARCHAR (50)  NOT NULL,
    [DESCRIPTION]          NVARCHAR (MAX) NULL,
    [CANEDIT]              BIT            NULL,
    [CREATEID]             BIT            NULL,
    [PREFIXID]             NVARCHAR (20)  NULL,
    [ALLOWDUPLICATE]       BIT            NULL,
    [CUSTOMFIELDID]        CHAR (36)      NULL,
    [LASTCHANGEDBY]        CHAR (36)      NULL,
    [LASTCHANGEDON]        DATETIME       CONSTRAINT [DF_CMCodeActivityType_LastChangedOn] DEFAULT (getutcdate()) NOT NULL,
    [ROWVERSION]           INT            CONSTRAINT [DF_CMCodeActivityType_RowVersion] DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_CMCodeActivityType] PRIMARY KEY CLUSTERED ([CMCODEACTIVITYTYPEID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_CMCODEACTIVITYTYPE_USERS] FOREIGN KEY ([LASTCHANGEDBY]) REFERENCES [dbo].[USERS] ([SUSERGUID]),
    CONSTRAINT [FK_CMCodeActType_Custom] FOREIGN KEY ([CUSTOMFIELDID]) REFERENCES [dbo].[CUSTOMFIELDLAYOUT] ([GCUSTOMFIELDLAYOUTS])
);


GO

CREATE TRIGGER [dbo].[TG_CMCODEACTIVITYTYPE_INSERT] ON [dbo].[CMCODEACTIVITYTYPE]
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
        [inserted].[CMCODEACTIVITYTYPEID], 
        [inserted].[ROWVERSION],
        GETUTCDATE(),
        [inserted].[LASTCHANGEDBY],
        'Code Activity Type Added',
        '',
        '',
        'Code Activity Type (' + [inserted].[NAME] + ')',
		'77E75108-D11A-45DC-BDE2-9F5ED1ECC927',
		1,
		1,
		[inserted].[NAME]
    FROM [inserted] 
END
GO

CREATE TRIGGER [dbo].[TG_CMCODEACTIVITYTYPE_UPDATE] ON  [dbo].[CMCODEACTIVITYTYPE]
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
			[inserted].[CMCODEACTIVITYTYPEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Name',
			[deleted].[NAME],
			[inserted].[NAME],
			'Code Activity Type (' + [inserted].[NAME] + ')',
			'77E75108-D11A-45DC-BDE2-9F5ED1ECC927',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[CMCODEACTIVITYTYPEID] = [inserted].[CMCODEACTIVITYTYPEID]
	WHERE	[deleted].[NAME] <> [inserted].[NAME]	
	UNION ALL
	SELECT
			[inserted].[CMCODEACTIVITYTYPEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Description',
			ISNULL([deleted].[DESCRIPTION],'[none]'),
			ISNULL([inserted].[DESCRIPTION],'[none]'),
			'Code Activity Type (' + [inserted].[NAME] + ')',
			'77E75108-D11A-45DC-BDE2-9F5ED1ECC927',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[CMCODEACTIVITYTYPEID] = [inserted].[CMCODEACTIVITYTYPEID]
	WHERE	ISNULL([deleted].[DESCRIPTION], '') <> ISNULL([inserted].[DESCRIPTION], '')
	UNION ALL
	SELECT
			[inserted].[CMCODEACTIVITYTYPEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Can Edit Flag',
			CASE [deleted].[CANEDIT] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No'  ELSE '[none]' END,
			CASE [inserted].[CANEDIT] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No'  ELSE '[none]' END,
			'Code Activity Type (' + [inserted].[NAME] + ')',
			'77E75108-D11A-45DC-BDE2-9F5ED1ECC927',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
	JOIN	[inserted] ON [deleted].[CMCODEACTIVITYTYPEID] = [inserted].[CMCODEACTIVITYTYPEID]
	WHERE	([deleted].[CANEDIT] <> [inserted].[CANEDIT]) OR ([deleted].[CANEDIT] IS NULL AND [inserted].[CANEDIT] IS NOT NULL)
			OR ([deleted].[CANEDIT] IS NOT NULL AND [inserted].[CANEDIT] IS NULL)
	UNION ALL
	SELECT
			[inserted].[CMCODEACTIVITYTYPEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Create Id Flag',
			CASE [deleted].[CREATEID] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No'  ELSE '[none]' END,
			CASE [inserted].[CREATEID] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No'  ELSE '[none]' END,
			'Code Activity Type (' + [inserted].[NAME] + ')',
			'77E75108-D11A-45DC-BDE2-9F5ED1ECC927',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[CMCODEACTIVITYTYPEID] = [inserted].[CMCODEACTIVITYTYPEID]
	WHERE	([deleted].[CREATEID] <> [inserted].[CREATEID]) OR ([deleted].[CREATEID] IS NULL AND [inserted].[CREATEID] IS NOT NULL)
			OR ([deleted].[CREATEID] IS NOT NULL AND [inserted].[CREATEID] IS NULL)
	UNION ALL
	SELECT
			[inserted].[CMCODEACTIVITYTYPEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Prefix',
			ISNULL([deleted].[PREFIXID],'[none]'),
			ISNULL([inserted].[PREFIXID],'[none]'),			
			'Code Activity Type (' + [inserted].[NAME] + ')',
			'77E75108-D11A-45DC-BDE2-9F5ED1ECC927',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[CMCODEACTIVITYTYPEID] = [inserted].[CMCODEACTIVITYTYPEID]
	WHERE	ISNULL([deleted].[PREFIXID], '') <> ISNULL([inserted].[PREFIXID], '')
	UNION ALL
	SELECT
			[inserted].[CMCODEACTIVITYTYPEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Allow Duplicate Flag',
			CASE [deleted].[ALLOWDUPLICATE] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No'  ELSE '[none]' END,
			CASE [inserted].[ALLOWDUPLICATE] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No'  ELSE '[none]' END,
			'Code Activity Type (' + [inserted].[NAME] + ')',
			'77E75108-D11A-45DC-BDE2-9F5ED1ECC927',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
	JOIN	[inserted] ON [deleted].[CMCODEACTIVITYTYPEID] = [inserted].[CMCODEACTIVITYTYPEID]
	WHERE	([deleted].[ALLOWDUPLICATE] <> [inserted].[ALLOWDUPLICATE]) OR ([deleted].[ALLOWDUPLICATE] IS NULL AND [inserted].[ALLOWDUPLICATE] IS NOT NULL)
			OR ([deleted].[ALLOWDUPLICATE] IS NOT NULL AND [inserted].[ALLOWDUPLICATE] IS NULL)
	UNION ALL
	SELECT
			[inserted].[CMCODEACTIVITYTYPEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Custom Field',
			ISNULL([CUSTOMFIELDLAYOUT_DELETED].[SNAME], '[none]'),
			ISNULL([CUSTOMFIELDLAYOUT_INSERTED].[SNAME], '[none]'),
			'Code Activity Type (' + [inserted].[NAME] + ')',
			'77E75108-D11A-45DC-BDE2-9F5ED1ECC927',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[CMCODEACTIVITYTYPEID] = [inserted].[CMCODEACTIVITYTYPEID]
			LEFT JOIN CUSTOMFIELDLAYOUT CUSTOMFIELDLAYOUT_DELETED WITH (NOLOCK) ON [deleted].[CUSTOMFIELDID] = [CUSTOMFIELDLAYOUT_DELETED].[GCUSTOMFIELDLAYOUTS]
			LEFT JOIN CUSTOMFIELDLAYOUT CUSTOMFIELDLAYOUT_INSERTED WITH (NOLOCK) ON [inserted].[CUSTOMFIELDID] = [CUSTOMFIELDLAYOUT_INSERTED].[GCUSTOMFIELDLAYOUTS]
	WHERE	ISNULL([deleted].[CUSTOMFIELDID], '') <> ISNULL([inserted].[CUSTOMFIELDID], '')
END
GO

CREATE TRIGGER [dbo].[TG_CMCODEACTIVITYTYPE_DELETE]  ON  [dbo].[CMCODEACTIVITYTYPE]
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
			[deleted].[CMCODEACTIVITYTYPEID],
			[deleted].[ROWVERSION],
			GETUTCDATE(),
			(SELECT dbo.UFN_GET_USERID_FROM_CONTEXT_INFO()),
			'Code Activity Type Deleted',
			'',
			'',
			'Code Activity Type (' + [deleted].[NAME] + ')',
			'77E75108-D11A-45DC-BDE2-9F5ED1ECC927',
			3,
			1,
			[deleted].[NAME]
	FROM	[deleted]
END