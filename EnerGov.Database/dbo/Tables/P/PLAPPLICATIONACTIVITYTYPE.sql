CREATE TABLE [dbo].[PLAPPLICATIONACTIVITYTYPE] (
    [PLAPPLICATIONACTIVITYTYPEID] CHAR (36)      NOT NULL,
    [NAME]                        NVARCHAR (50)  NOT NULL,
    [DESCRIPTION]                 NVARCHAR (MAX) NULL,
    [CANEDIT]                     BIT            NOT NULL,
    [CREATEID]                    BIT            NOT NULL,
    [PREFIXID]                    NVARCHAR (20)  NULL,
    [ALLOWDUPLICATE]              BIT            NOT NULL,
    [CUSTOMFIELDID]               CHAR (36)      NULL,
    [LASTCHANGEDBY]               CHAR (36)      NULL,
    [LASTCHANGEDON]               DATETIME       CONSTRAINT [DF_PLApplicationActivityType_LastChangedOn] DEFAULT (getutcdate()) NOT NULL,
    [ROWVERSION]                  INT            CONSTRAINT [DF_PLApplicationActivityType_RowVersion] DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_PLApplicationActivityType] PRIMARY KEY CLUSTERED ([PLAPPLICATIONACTIVITYTYPEID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_PLApplicationActivityType_CustomFieldLayout] FOREIGN KEY ([CUSTOMFIELDID]) REFERENCES [dbo].[CUSTOMFIELDLAYOUT] ([GCUSTOMFIELDLAYOUTS]),
    CONSTRAINT [FK_PLAPPLICATIONACTIVITYTYPE_USERS] FOREIGN KEY ([LASTCHANGEDBY]) REFERENCES [dbo].[USERS] ([SUSERGUID])
);


GO
CREATE NONCLUSTERED INDEX [PLApplicationActivityType_IX_QUERY]
    ON [dbo].[PLAPPLICATIONACTIVITYTYPE]([PLAPPLICATIONACTIVITYTYPEID] ASC, [NAME] ASC);


GO

CREATE TRIGGER [TG_PLAPPLICATIONACTIVITYTYPE_DELETE] ON PLAPPLICATIONACTIVITYTYPE
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
        [deleted].[PLAPPLICATIONACTIVITYTYPEID],
        [deleted].[ROWVERSION],
        GETUTCDATE(),
        (SELECT dbo.UFN_GET_USERID_FROM_CONTEXT_INFO()),
        'Application Activity Type Deleted',
        '',
        '',
        'Application Activity Type (' + [deleted].[NAME] + ')',
		'DA56E28D-DF19-4DEC-A63D-C8AEE4B016F7',
		3,
		1,
		[deleted].[NAME]
    FROM [deleted]
END
GO
 
 
CREATE TRIGGER [TG_PLAPPLICATIONACTIVITYTYPE_UPDATE] ON PLAPPLICATIONACTIVITYTYPE
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
			[inserted].[PLAPPLICATIONACTIVITYTYPEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Name',
			[deleted].[NAME],
			[inserted].[NAME],
			'Application Activity Type (' + [inserted].[NAME] + ')',
			'DA56E28D-DF19-4DEC-A63D-C8AEE4B016F7',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[PLAPPLICATIONACTIVITYTYPEID] = [inserted].[PLAPPLICATIONACTIVITYTYPEID]
	WHERE	[deleted].[NAME] <> [inserted].[NAME]
	UNION ALL
	SELECT
			[inserted].[PLAPPLICATIONACTIVITYTYPEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Description',
			ISNULL([deleted].[DESCRIPTION],'[none]'),
			ISNULL([inserted].[DESCRIPTION],'[none]'),
			'Application Activity Type (' + [inserted].[NAME] + ')',
			'DA56E28D-DF19-4DEC-A63D-C8AEE4B016F7',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[PLAPPLICATIONACTIVITYTYPEID] = [inserted].[PLAPPLICATIONACTIVITYTYPEID]
	WHERE	ISNULL([deleted].[DESCRIPTION], '') <> ISNULL([inserted].[DESCRIPTION], '')
	UNION ALL
	SELECT
			[inserted].[PLAPPLICATIONACTIVITYTYPEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Can Edit Flag',
			CASE WHEN [deleted].[CANEDIT] = 1 THEN 'Yes' ELSE 'No' END,
			CASE WHEN [inserted].[CANEDIT] = 1 THEN 'Yes' ELSE 'No' END,
			'Application Activity Type (' + [inserted].[NAME] + ')',
			'DA56E28D-DF19-4DEC-A63D-C8AEE4B016F7',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[PLAPPLICATIONACTIVITYTYPEID] = [inserted].[PLAPPLICATIONACTIVITYTYPEID]
	WHERE	[deleted].[CANEDIT] <> [inserted].[CANEDIT]
	UNION ALL
	SELECT
			[inserted].[PLAPPLICATIONACTIVITYTYPEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Create Id Flag',
			CASE WHEN [deleted].[CREATEID] = 1 THEN 'Yes' ELSE 'No' END,
			CASE WHEN [inserted].[CREATEID] = 1 THEN 'Yes' ELSE 'No' END,
			'Application Activity Type (' + [inserted].[NAME] + ')',
			'DA56E28D-DF19-4DEC-A63D-C8AEE4B016F7',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[PLAPPLICATIONACTIVITYTYPEID] = [inserted].[PLAPPLICATIONACTIVITYTYPEID]
	WHERE	[deleted].[CREATEID] <> [inserted].[CREATEID]
	UNION ALL
	SELECT
			[inserted].[PLAPPLICATIONACTIVITYTYPEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Prefix Id',
			ISNULL([deleted].[PREFIXID],'[none]'),
			ISNULL([inserted].[PREFIXID],'[none]'),			
			'Application Activity Type (' + [inserted].[NAME] + ')',
			'DA56E28D-DF19-4DEC-A63D-C8AEE4B016F7',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[PLAPPLICATIONACTIVITYTYPEID] = [inserted].[PLAPPLICATIONACTIVITYTYPEID]
	WHERE	ISNULL([deleted].[PREFIXID], '') <> ISNULL([inserted].[PREFIXID], '')
	UNION ALL
	SELECT
			[inserted].[PLAPPLICATIONACTIVITYTYPEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Allow Duplicate Flag',
			CASE WHEN [deleted].[ALLOWDUPLICATE] = 1 THEN 'Yes' ELSE 'No' END,
			CASE WHEN [inserted].[ALLOWDUPLICATE] = 1 THEN 'Yes' ELSE 'No' END,
			'Application Activity Type (' + [inserted].[NAME] + ')',
			'DA56E28D-DF19-4DEC-A63D-C8AEE4B016F7',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[PLAPPLICATIONACTIVITYTYPEID] = [inserted].[PLAPPLICATIONACTIVITYTYPEID]
	WHERE	[deleted].[ALLOWDUPLICATE] <> [inserted].[ALLOWDUPLICATE]
	UNION ALL
	SELECT
			[inserted].[PLAPPLICATIONACTIVITYTYPEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Custom Field',
			ISNULL([CUSTOMFIELDLAYOUT_DELETED].[SNAME], '[none]'),
			ISNULL([CUSTOMFIELDLAYOUT_INSERTED].[SNAME], '[none]'),
			'Application Activity Type (' + [inserted].[NAME] + ')',
			'DA56E28D-DF19-4DEC-A63D-C8AEE4B016F7',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[PLAPPLICATIONACTIVITYTYPEID] = [inserted].[PLAPPLICATIONACTIVITYTYPEID]
			LEFT JOIN CUSTOMFIELDLAYOUT CUSTOMFIELDLAYOUT_DELETED WITH (NOLOCK) ON [deleted].[CUSTOMFIELDID] = [CUSTOMFIELDLAYOUT_DELETED].[GCUSTOMFIELDLAYOUTS]
			LEFT JOIN CUSTOMFIELDLAYOUT CUSTOMFIELDLAYOUT_INSERTED WITH (NOLOCK) ON [inserted].[CUSTOMFIELDID] = [CUSTOMFIELDLAYOUT_INSERTED].[GCUSTOMFIELDLAYOUTS]
	WHERE	ISNULL([deleted].[CUSTOMFIELDID], '') <> ISNULL([inserted].[CUSTOMFIELDID], '')
END
GO

CREATE TRIGGER [TG_PLAPPLICATIONACTIVITYTYPE_INSERT] ON PLAPPLICATIONACTIVITYTYPE
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
        [inserted].[PLAPPLICATIONACTIVITYTYPEID],
        [inserted].[ROWVERSION],
        GETUTCDATE(),
        [inserted].[LASTCHANGEDBY],
        'Application Activity Type Added',
        '',
        '',
        'Application Activity Type (' + [inserted].[NAME] + ')',
		'DA56E28D-DF19-4DEC-A63D-C8AEE4B016F7',
        1,
		1,
		[inserted].[NAME]
    FROM [inserted]
END