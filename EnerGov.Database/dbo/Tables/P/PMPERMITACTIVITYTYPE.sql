CREATE TABLE [dbo].[PMPERMITACTIVITYTYPE] (
    [PMPERMITACTIVITYTYPEID] CHAR (36)      NOT NULL,
    [NAME]                   NVARCHAR (50)  NOT NULL,
    [DESCRIPTION]            NVARCHAR (MAX) NULL,
    [CANEDIT]                BIT            NOT NULL,
    [PREFIXID]               NVARCHAR (10)  NULL,
    [ALLOWDUPLICATE]         BIT            NOT NULL,
    [CREATEID]               BIT            NULL,
    [CUSTOMFIELDID]          CHAR (36)      NULL,
    [LASTCHANGEDBY]          CHAR (36)      NULL,
    [LASTCHANGEDON]          DATETIME       CONSTRAINT [DF_PMPermitActivityType_LastChangedOn] DEFAULT (getutcdate()) NOT NULL,
    [ROWVERSION]             INT            CONSTRAINT [DF_PMPermitActivityType_RowVersion] DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_PMPermitActivityType] PRIMARY KEY CLUSTERED ([PMPERMITACTIVITYTYPEID] ASC) WITH (FILLFACTOR = 80),
    CONSTRAINT [FK_PermitActivityType_Cus] FOREIGN KEY ([CUSTOMFIELDID]) REFERENCES [dbo].[CUSTOMFIELDLAYOUT] ([GCUSTOMFIELDLAYOUTS]),
    CONSTRAINT [FK_PMPERMITACTIVITYTYPE_USERS] FOREIGN KEY ([LASTCHANGEDBY]) REFERENCES [dbo].[USERS] ([SUSERGUID])
);


GO
 
 
CREATE TRIGGER [TG_PMPERMITACTIVITYTYPE_UPDATE] ON [dbo].[PMPERMITACTIVITYTYPE]
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
			[inserted].[PMPERMITACTIVITYTYPEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Name',
			[deleted].[NAME],
			[inserted].[NAME],
			'Permit Activity Type (' + [inserted].[NAME] + ')',
			'82473E28-FD59-48C5-8F4B-51A3DBBEF3EF',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[PMPERMITACTIVITYTYPEID] = [inserted].[PMPERMITACTIVITYTYPEID]
	WHERE	[deleted].[NAME] <> [inserted].[NAME]
	UNION ALL
	SELECT
			[inserted].[PMPERMITACTIVITYTYPEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Description',
			ISNULL([deleted].[DESCRIPTION],'[none]'),
			ISNULL([inserted].[DESCRIPTION],'[none]'),
			'Permit Activity Type (' + [inserted].[NAME] + ')',
			'82473E28-FD59-48C5-8F4B-51A3DBBEF3EF',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[PMPERMITACTIVITYTYPEID] = [inserted].[PMPERMITACTIVITYTYPEID]
	WHERE	ISNULL([deleted].[DESCRIPTION], '') <> ISNULL([inserted].[DESCRIPTION], '')
	UNION ALL
	SELECT
			[inserted].[PMPERMITACTIVITYTYPEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Can Edit Flag',
			CASE WHEN [deleted].[CANEDIT] = 1 THEN 'Yes' ELSE 'No' END,
			CASE WHEN [inserted].[CANEDIT] = 1 THEN 'Yes' ELSE 'No' END,
			'Permit Activity Type (' + [inserted].[NAME] + ')',
			'82473E28-FD59-48C5-8F4B-51A3DBBEF3EF',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[PMPERMITACTIVITYTYPEID] = [inserted].[PMPERMITACTIVITYTYPEID]
	WHERE	[deleted].[CANEDIT] <> [inserted].[CANEDIT]
	UNION ALL
	SELECT
			[inserted].[PMPERMITACTIVITYTYPEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Create Id Flag',
			CASE [deleted].[CREATEID] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' ELSE '[none]' END,
			CASE [inserted].[CREATEID] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' ELSE '[none]' END,
			'Permit Activity Type (' + [inserted].[NAME] + ')',
			'82473E28-FD59-48C5-8F4B-51A3DBBEF3EF',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[PMPERMITACTIVITYTYPEID] = [inserted].[PMPERMITACTIVITYTYPEID]
	WHERE	([deleted].[CREATEID] <> [inserted].[CREATEID]) OR ([deleted].[CREATEID] IS NULL AND [inserted].[CREATEID] IS NOT NULL)
			OR ([deleted].[CREATEID] IS NOT NULL AND [inserted].[CREATEID] IS NULL)
	UNION ALL
	SELECT
			[inserted].[PMPERMITACTIVITYTYPEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Prefix',
			ISNULL([deleted].[PREFIXID],'[none]'),
			ISNULL([inserted].[PREFIXID],'[none]'),			
			'Permit Activity Type (' + [inserted].[NAME] + ')',
			'82473E28-FD59-48C5-8F4B-51A3DBBEF3EF',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[PMPERMITACTIVITYTYPEID] = [inserted].[PMPERMITACTIVITYTYPEID]
	WHERE	ISNULL([deleted].[PREFIXID], '') <> ISNULL([inserted].[PREFIXID], '')
	UNION ALL
	SELECT
			[inserted].[PMPERMITACTIVITYTYPEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Allow Duplicate Flag',
			CASE WHEN [deleted].[ALLOWDUPLICATE] = 1 THEN 'Yes' ELSE 'No' END,
			CASE WHEN [inserted].[ALLOWDUPLICATE] = 1 THEN 'Yes' ELSE 'No' END,
			'Permit Activity Type (' + [inserted].[NAME] + ')',
			'82473E28-FD59-48C5-8F4B-51A3DBBEF3EF',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[PMPERMITACTIVITYTYPEID] = [inserted].[PMPERMITACTIVITYTYPEID]
	WHERE	[deleted].[ALLOWDUPLICATE] <> [inserted].[ALLOWDUPLICATE]
	UNION ALL
	SELECT
			[inserted].[PMPERMITACTIVITYTYPEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Custom Field Layout',
			ISNULL([CUSTOMFIELDLAYOUT_DELETED].[SNAME], '[none]'),
			ISNULL([CUSTOMFIELDLAYOUT_INSERTED].[SNAME], '[none]'),
			'Permit Activity Type (' + [inserted].[NAME] + ')',
			'82473E28-FD59-48C5-8F4B-51A3DBBEF3EF',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[PMPERMITACTIVITYTYPEID] = [inserted].[PMPERMITACTIVITYTYPEID]
			LEFT JOIN CUSTOMFIELDLAYOUT CUSTOMFIELDLAYOUT_DELETED WITH (NOLOCK) ON [deleted].[CUSTOMFIELDID] = [CUSTOMFIELDLAYOUT_DELETED].[GCUSTOMFIELDLAYOUTS]
			LEFT JOIN CUSTOMFIELDLAYOUT CUSTOMFIELDLAYOUT_INSERTED WITH (NOLOCK) ON [inserted].[CUSTOMFIELDID] = [CUSTOMFIELDLAYOUT_INSERTED].[GCUSTOMFIELDLAYOUTS]
	WHERE	ISNULL([deleted].[CUSTOMFIELDID], '') <> ISNULL([inserted].[CUSTOMFIELDID], '')
END
GO

CREATE TRIGGER [TG_PMPERMITACTIVITYTYPE_INSERT] ON [dbo].[PMPERMITACTIVITYTYPE]
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
        [inserted].[PMPERMITACTIVITYTYPEID],
        [inserted].[ROWVERSION],
        GETUTCDATE(),
        [inserted].[LASTCHANGEDBY],
        'Permit Activity Type Added',
        '',
        '',
        'Permit Activity Type (' + [inserted].[NAME] + ')',
		'82473E28-FD59-48C5-8F4B-51A3DBBEF3EF',
		1,
		1,
		[inserted].[NAME]
    FROM [inserted]
END
GO

CREATE TRIGGER [TG_PMPERMITACTIVITYTYPE_DELETE] ON [dbo].[PMPERMITACTIVITYTYPE]
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
        [deleted].[PMPERMITACTIVITYTYPEID],
        [deleted].[ROWVERSION],
        GETUTCDATE(),
        (SELECT dbo.UFN_GET_USERID_FROM_CONTEXT_INFO()),
        'Permit Activity Type Deleted',
        '',
        '',
        'Permit Activity Type (' + [deleted].[NAME] + ')',
		'82473E28-FD59-48C5-8F4B-51A3DBBEF3EF',
		3,
		1,
		[deleted].[NAME]
    FROM [deleted]
END