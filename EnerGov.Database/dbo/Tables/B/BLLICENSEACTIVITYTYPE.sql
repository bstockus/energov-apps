CREATE TABLE [dbo].[BLLICENSEACTIVITYTYPE] (
    [BLLICENSEACTIVITYTYPEID] CHAR (36)      NOT NULL,
    [NAME]                    NVARCHAR (50)  NOT NULL,
    [DESCRIPTION]             NVARCHAR (MAX) NULL,
    [CANEDIT]                 BIT            NULL,
    [CREATEID]                BIT            NULL,
    [PREFIXID]                NVARCHAR (20)  NULL,
    [ALLOWDUPLICATE]          BIT            NULL,
    [CUSTOMFIELDLAYOUTID]     CHAR (36)      NULL,
    [LASTCHANGEDBY]           CHAR (36)      NULL,
    [LASTCHANGEDON]           DATETIME       CONSTRAINT [DF_BLLICENSEACTIVITYTYPE_LastChangedOn] DEFAULT (getutcdate()) NOT NULL,
    [ROWVERSION]              INT            CONSTRAINT [DF_BLLICENSEACTIVITYTYPE_RowVersion] DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_BLLicenseActivityType] PRIMARY KEY CLUSTERED ([BLLICENSEACTIVITYTYPEID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_BLLicAcType_Custom] FOREIGN KEY ([CUSTOMFIELDLAYOUTID]) REFERENCES [dbo].[CUSTOMFIELDLAYOUT] ([GCUSTOMFIELDLAYOUTS])
);


GO
CREATE NONCLUSTERED INDEX [BLLICENSEACTIVITYTYPE_IX_QUERY]
    ON [dbo].[BLLICENSEACTIVITYTYPE]([BLLICENSEACTIVITYTYPEID] ASC, [NAME] ASC);


GO

CREATE TRIGGER [dbo].[TG_BLLICENSEACTIVITYTYPE_DELETE] ON [dbo].[BLLICENSEACTIVITYTYPE]
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
			[deleted].[BLLICENSEACTIVITYTYPEID],
			[deleted].[ROWVERSION],
			GETUTCDATE(),
			(SELECT dbo.UFN_GET_USERID_FROM_CONTEXT_INFO()),
			'License Activity Type Deleted',
			'',
			'',
			'License Activity Type (' + [deleted].[NAME] + ')',
			'E5556B72-305E-4292-A8C6-758768DEC09E',
			3,
			1,
			[deleted].[NAME]
	FROM	[deleted]
END
GO

CREATE TRIGGER [dbo].[TG_BLLICENSEACTIVITYTYPE_INSERT] ON [dbo].[BLLICENSEACTIVITYTYPE]
   FOR INSERT
AS 
BEGIN
	SET NOCOUNT ON;
	-- Check if LASTCHANGEDBY contains VALID User Id and it Exists in USERS table, this is in replacement to foreign key reference of BLLICENSEACTIVITYTYPE table with USERS table.
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
		[ADDITIONALINFO],
		[FORMID],
		[ACTION],
		[ISROOT],
		[RECORDNAME]
    )
	SELECT
			[inserted].[BLLICENSEACTIVITYTYPEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'License Activity Type Added',
			'',
			'',
			'License Activity Type (' + [inserted].[NAME] + ')',
			'E5556B72-305E-4292-A8C6-758768DEC09E',
			1,
			1,
			[inserted].[NAME]
	FROM	[inserted]	
END
GO

CREATE TRIGGER [dbo].[TG_BLLICENSEACTIVITYTYPE_UPDATE] ON [dbo].[BLLICENSEACTIVITYTYPE] 
	AFTER UPDATE
AS 
BEGIN
	SET NOCOUNT ON;
		
	-- Check if LASTCHANGEDBY contains VALID User Id and it Exists in USERS table, this is in replacement to foreign key reference of BLLICENSEACTIVITYTYPE table with USERS table.
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
		[ADDITIONALINFO],
		[FORMID],
		[ACTION],
		[ISROOT],
		[RECORDNAME]
    )
	SELECT
			[inserted].[BLLICENSEACTIVITYTYPEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Name',
			[deleted].[NAME],
			[inserted].[NAME],
			'License Activity Type (' + [inserted].[NAME] + ')',
			'E5556B72-305E-4292-A8C6-758768DEC09E',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[BLLICENSEACTIVITYTYPEID] = [inserted].[BLLICENSEACTIVITYTYPEID]
	WHERE	[deleted].[NAME] <> [inserted].[NAME]

	UNION ALL
	SELECT
			[inserted].[BLLICENSEACTIVITYTYPEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Description',
			ISNULL([deleted].[DESCRIPTION],'[none]'),
			ISNULL([inserted].[DESCRIPTION],'[none]'),
			'License Activity Type (' + [inserted].[NAME] + ')',
			'E5556B72-305E-4292-A8C6-758768DEC09E',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[BLLICENSEACTIVITYTYPEID] = [inserted].[BLLICENSEACTIVITYTYPEID]
	WHERE	ISNULL([deleted].[DESCRIPTION], '') <> ISNULL([inserted].[DESCRIPTION], '')

	UNION ALL
	SELECT
			[inserted].[BLLICENSEACTIVITYTYPEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Can Edit Flag',
			CASE [deleted].[CANEDIT] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No'  ELSE '[none]' END,
			CASE [inserted].[CANEDIT] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No'  ELSE '[none]' END,
			'License Activity Type (' + [inserted].[NAME] + ')',
			'E5556B72-305E-4292-A8C6-758768DEC09E',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[BLLICENSEACTIVITYTYPEID] = [inserted].[BLLICENSEACTIVITYTYPEID]
	WHERE	([deleted].[CANEDIT] <> [inserted].[CANEDIT]) OR ([deleted].[CANEDIT] IS NULL AND [inserted].[CANEDIT] IS NOT NULL)
			OR ([deleted].[CANEDIT] IS NOT NULL AND [inserted].[CANEDIT] IS NULL)

	UNION ALL
	SELECT
			[inserted].[BLLICENSEACTIVITYTYPEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Create ID Flag',
			CASE [deleted].[CREATEID] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No'  ELSE '[none]' END,
			CASE [inserted].[CREATEID] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No'  ELSE '[none]' END,
			'License Activity Type (' + [inserted].[NAME] + ')',
			'E5556B72-305E-4292-A8C6-758768DEC09E',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[BLLICENSEACTIVITYTYPEID] = [inserted].[BLLICENSEACTIVITYTYPEID]
	WHERE	([deleted].[CREATEID] <> [inserted].[CREATEID]) OR ([deleted].[CREATEID] IS NULL AND [inserted].[CREATEID] IS NOT NULL)
			OR ([deleted].[CREATEID] IS NOT NULL AND [inserted].[CREATEID] IS NULL)

	UNION ALL
	SELECT
			[inserted].[BLLICENSEACTIVITYTYPEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Prefix ID',
			ISNULL([deleted].[PREFIXID],'[none]'),
			ISNULL([inserted].[PREFIXID],'[none]'),
			'License Activity Type (' + [inserted].[NAME] + ')',
			'E5556B72-305E-4292-A8C6-758768DEC09E',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[BLLICENSEACTIVITYTYPEID] = [inserted].[BLLICENSEACTIVITYTYPEID]
	WHERE	ISNULL([deleted].[PREFIXID], '') <> ISNULL([inserted].[PREFIXID], '')

	UNION ALL
	SELECT
			[inserted].[BLLICENSEACTIVITYTYPEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Allow Duplicate Flag',
			CASE [deleted].[ALLOWDUPLICATE] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No'  ELSE '[none]' END,
			CASE [inserted].[ALLOWDUPLICATE] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No'  ELSE '[none]' END,
			'License Activity Type (' + [inserted].[NAME] + ')',
			'E5556B72-305E-4292-A8C6-758768DEC09E',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[BLLICENSEACTIVITYTYPEID] = [inserted].[BLLICENSEACTIVITYTYPEID]
	WHERE	([deleted].[ALLOWDUPLICATE] <> [inserted].[ALLOWDUPLICATE]) OR ([deleted].[ALLOWDUPLICATE] IS NULL AND [inserted].[ALLOWDUPLICATE] IS NOT NULL)
			OR ([deleted].[ALLOWDUPLICATE] IS NOT NULL AND [inserted].[ALLOWDUPLICATE] IS NULL)
	
	UNION ALL
	SELECT
			[inserted].[BLLICENSEACTIVITYTYPEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Custom Field Layout',
			ISNULL([CUSTOMFIELDLAYOUT_DELETED].[SNAME],'[none]'),
			ISNULL([CUSTOMFIELDLAYOUT_INSERTED].[SNAME],'[none]'),
			'License Activity Type (' + [inserted].[NAME] + ')',
			'E5556B72-305E-4292-A8C6-758768DEC09E',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[BLLICENSEACTIVITYTYPEID] = [inserted].[BLLICENSEACTIVITYTYPEID]
			LEFT JOIN CUSTOMFIELDLAYOUT CUSTOMFIELDLAYOUT_DELETED WITH (NOLOCK) ON [deleted].[CUSTOMFIELDLAYOUTID] = [CUSTOMFIELDLAYOUT_DELETED].[GCUSTOMFIELDLAYOUTS]
			LEFT JOIN CUSTOMFIELDLAYOUT CUSTOMFIELDLAYOUT_INSERTED WITH (NOLOCK) ON [inserted].[CUSTOMFIELDLAYOUTID] = [CUSTOMFIELDLAYOUT_INSERTED].[GCUSTOMFIELDLAYOUTS]
	WHERE	ISNULL([deleted].[CUSTOMFIELDLAYOUTID], '') <> ISNULL([inserted].[CUSTOMFIELDLAYOUTID], '')
END