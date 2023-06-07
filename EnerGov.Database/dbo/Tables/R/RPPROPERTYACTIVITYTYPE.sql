CREATE TABLE [dbo].[RPPROPERTYACTIVITYTYPE] (
    [RPPROPERTYACTIVITYTYPEID] CHAR (36)      NOT NULL,
    [NAME]                     NVARCHAR (50)  NOT NULL,
    [DESCRIPTION]              NVARCHAR (MAX) NULL,
    [CANEDIT]                  BIT            NOT NULL,
    [CREATEID]                 BIT            NOT NULL,
    [PREFIXID]                 NVARCHAR (20)  NULL,
    [ALLOWDUPLICATE]           BIT            NOT NULL,
    [CUSTOMFIELDLAYOUTID]      CHAR (36)      NULL,
    [LASTCHANGEDBY]            CHAR (36)      NULL,
    [LASTCHANGEDON]            DATETIME       CONSTRAINT [DF_RPPROPERTYACTIVITYTYPE_LastChangedOn] DEFAULT (getutcdate()) NOT NULL,
    [ROWVERSION]               INT            CONSTRAINT [DF_RPPROPERTYACTIVITYTYPE_RowVersion] DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_RPPROPERTYACTIVITYTYPE] PRIMARY KEY NONCLUSTERED ([RPPROPERTYACTIVITYTYPEID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_RPPROPACTTYPE_CUSTOM] FOREIGN KEY ([CUSTOMFIELDLAYOUTID]) REFERENCES [dbo].[CUSTOMFIELDLAYOUT] ([GCUSTOMFIELDLAYOUTS])
);


GO
CREATE NONCLUSTERED INDEX [RPPROPERTYACTIVITYTYPE_IX_QUERY]
    ON [dbo].[RPPROPERTYACTIVITYTYPE]([RPPROPERTYACTIVITYTYPEID] ASC, [NAME] ASC);


GO

CREATE TRIGGER [dbo].[TG_RPPROPERTYACTIVITYTYPE_DELETE]
   ON  [dbo].[RPPROPERTYACTIVITYTYPE]
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
		[ADDITIONALINFO]
    )
	SELECT
			[deleted].[RPPROPERTYACTIVITYTYPEID],
			[deleted].[ROWVERSION],
			GETUTCDATE(),
			(SELECT dbo.UFN_GET_USERID_FROM_CONTEXT_INFO()),
			'Property Activity Type Deleted',
			'',
			'',
			'Property Activity Type (' + [deleted].[NAME] + ')'
	FROM [deleted]
END
GO

CREATE TRIGGER [dbo].[TG_RPPROPERTYACTIVITYTYPE_UPDATE] 
   ON  [dbo].[RPPROPERTYACTIVITYTYPE]
   AFTER UPDATE
AS 
BEGIN	
	SET NOCOUNT ON;

	-- Check if LASTCHANGEDBY contains VALID User Id and it Exists in USERS table, this is in replacement to foreign key reference of RPPROPERTYACTIVITYTYPE table with USERS table.
	IF EXISTS (SELECT * FROM inserted 
		LEFT OUTER JOIN USERS WITH (NOLOCK) ON USERS.SUSERGUID = inserted.LASTCHANGEDBY
		WHERE inserted.LASTCHANGEDBY IS NOT NULL AND USERS.SUSERGUID IS NULL)
	BEGIN		
		RAISERROR ('The INSERT or UPDATE statement conflicted with the FOREIGN KEY to table USERS', 16, 0);
		ROLLBACK;
		RETURN;
	END

	INSERT INTO [HISTORYSYSTEMSETUP]
    (	[ID],
		[ROWVERSION],
		[CHANGEDON],
		[CHANGEDBY],
		[FIELDNAME],
		[OLDVALUE],
		[NEWVALUE],
		[ADDITIONALINFO]
    )
	SELECT 
			[inserted].[RPPROPERTYACTIVITYTYPEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Property Activity Type Name',
			[deleted].[NAME],
			[inserted].[NAME],
			'Property Activity Type (' + [inserted].[NAME] + ')'
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[RPPROPERTYACTIVITYTYPEID] = [inserted].[RPPROPERTYACTIVITYTYPEID]
	WHERE	[deleted].[NAME] <> [inserted].[NAME]
	UNION ALL
	SELECT
			[inserted].[RPPROPERTYACTIVITYTYPEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Property Activity Type Description',
			ISNULL([deleted].[DESCRIPTION],'[none]'),
			ISNULL([inserted].[DESCRIPTION],'[none]'),
			'Property Activity Type (' + [inserted].[NAME] + ')'
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[RPPROPERTYACTIVITYTYPEID] = [inserted].[RPPROPERTYACTIVITYTYPEID]
	WHERE	ISNULL([deleted].[DESCRIPTION], '') <> ISNULL([inserted].[DESCRIPTION], '')
	UNION ALL
	SELECT
			[inserted].[RPPROPERTYACTIVITYTYPEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Property Activity Type Can Edit Flag',
			CASE [deleted].[CANEDIT] WHEN 1 THEN 'Yes' ELSE 'No' END,
			CASE [inserted].[CANEDIT] WHEN 1 THEN 'Yes'ELSE 'No' END,
			'Property Activity Type (' + [inserted].[NAME] + ')'
	FROM	[deleted]
	JOIN	[inserted] ON [deleted].[RPPROPERTYACTIVITYTYPEID] = [inserted].[RPPROPERTYACTIVITYTYPEID]
	WHERE	([deleted].[CANEDIT] <> [inserted].[CANEDIT])
	UNION ALL
	SELECT
			[inserted].[RPPROPERTYACTIVITYTYPEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Property Activity Type Create Id Flag',
			CASE [deleted].[CREATEID] WHEN 1 THEN 'Yes' ELSE 'No' END,
			CASE [inserted].[CREATEID] WHEN 1 THEN 'Yes' ELSE 'No' END,
			'Property Activity Type (' + [inserted].[NAME] + ')'
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[RPPROPERTYACTIVITYTYPEID] = [inserted].[RPPROPERTYACTIVITYTYPEID]
	WHERE	([deleted].[CREATEID] <> [inserted].[CREATEID])
	UNION ALL
	SELECT
			[inserted].[RPPROPERTYACTIVITYTYPEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Property Activity Type Prefix Id',
			ISNULL([deleted].[PREFIXID],'[none]'),
			ISNULL([inserted].[PREFIXID],'[none]'),			
			'Property Activity Type (' + [inserted].[NAME] + ')'
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[RPPROPERTYACTIVITYTYPEID] = [inserted].[RPPROPERTYACTIVITYTYPEID]
	WHERE	ISNULL([deleted].[PREFIXID], '') <> ISNULL([inserted].[PREFIXID], '')
	UNION ALL
	SELECT
			[inserted].[RPPROPERTYACTIVITYTYPEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Property Activity Type Allow Duplicate Flag',
			CASE [deleted].[ALLOWDUPLICATE] WHEN 1 THEN 'Yes'ELSE 'No' END,
			CASE [inserted].[ALLOWDUPLICATE] WHEN 1 THEN 'Yes' ELSE 'No' END,
			'Property Activity Type (' + [inserted].[NAME] + ')'
	FROM	[deleted]
	JOIN	[inserted] ON [deleted].[RPPROPERTYACTIVITYTYPEID] = [inserted].[RPPROPERTYACTIVITYTYPEID]
	WHERE	([deleted].[ALLOWDUPLICATE] <> [inserted].[ALLOWDUPLICATE])
	UNION ALL
	SELECT
			[inserted].[RPPROPERTYACTIVITYTYPEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Property Activity Type Custom Field',
			ISNULL([CUSTOMFIELDLAYOUT_DELETED].[SNAME], '[none]'),
			ISNULL([CUSTOMFIELDLAYOUT_INSERTED].[SNAME], '[none]'),
			'Property Activity Type (' + [inserted].[NAME] + ')'
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[RPPROPERTYACTIVITYTYPEID] = [inserted].[RPPROPERTYACTIVITYTYPEID]
			LEFT JOIN CUSTOMFIELDLAYOUT CUSTOMFIELDLAYOUT_DELETED WITH (NOLOCK) ON [deleted].[CUSTOMFIELDLAYOUTID] = [CUSTOMFIELDLAYOUT_DELETED].[GCUSTOMFIELDLAYOUTS]
			LEFT JOIN CUSTOMFIELDLAYOUT CUSTOMFIELDLAYOUT_INSERTED WITH (NOLOCK) ON [inserted].[CUSTOMFIELDLAYOUTID] = [CUSTOMFIELDLAYOUT_INSERTED].[GCUSTOMFIELDLAYOUTS]
	WHERE	ISNULL([deleted].[CUSTOMFIELDLAYOUTID], '') <> ISNULL([inserted].[CUSTOMFIELDLAYOUTID], '')

END
GO

CREATE TRIGGER [dbo].[TG_RPPROPERTYACTIVITYTYPE_INSERT] ON [dbo].[RPPROPERTYACTIVITYTYPE]
   AFTER INSERT
AS 
BEGIN
	SET NOCOUNT ON;

	-- Check if LASTCHANGEDBY contains VALID User Id and it Exists in USERS table, this is in replacement to foreign key reference of RPPROPERTYACTIVITYTYPE table with USERS table.
	IF EXISTS (SELECT * FROM inserted 
		LEFT OUTER JOIN USERS WITH (NOLOCK) ON USERS.SUSERGUID = inserted.LASTCHANGEDBY
		WHERE inserted.LASTCHANGEDBY IS NOT NULL AND USERS.SUSERGUID IS NULL)
	BEGIN		
		RAISERROR ('The INSERT or UPDATE statement conflicted with the FOREIGN KEY to table USERS', 16, 0);
		ROLLBACK;
		RETURN;
	END

	INSERT INTO [HISTORYSYSTEMSETUP]
    (
        [ID],
        [ROWVERSION],
        [CHANGEDON],
        [CHANGEDBY],
        [FIELDNAME],
        [OLDVALUE],
        [NEWVALUE],
        [ADDITIONALINFO]
    )
	SELECT 
        [inserted].[RPPROPERTYACTIVITYTYPEID], 
        [inserted].[ROWVERSION],
        GETUTCDATE(),
        [inserted].[LASTCHANGEDBY],
        'Property Activity Type Added',
        '',
        '',
        'Property Activity Type (' + [inserted].[NAME] + ')'
    FROM [inserted] 
END