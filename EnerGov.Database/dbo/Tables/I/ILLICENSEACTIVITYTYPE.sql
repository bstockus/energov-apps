CREATE TABLE [dbo].[ILLICENSEACTIVITYTYPE] (
    [ILLICENSEACTIVITYTYPEID] CHAR (36)      NOT NULL,
    [NAME]                    NVARCHAR (50)  NOT NULL,
    [DESCRIPTION]             NVARCHAR (MAX) NULL,
    [PREFIX]                  NVARCHAR (20)  NULL,
    [CUSTOMFIELDLAYOUTID]     CHAR (36)      NULL,
    [CANEDIT]                 BIT            NOT NULL,
    [CREATEID]                BIT            NOT NULL,
    [ALLOWDUPLICATE]          BIT            NOT NULL,
    [LASTCHANGEDBY]           CHAR (36)      NULL,
    [LASTCHANGEDON]           DATETIME       CONSTRAINT [DF_ILLICENSEACTIVITYTYPE_LastChangedOn] DEFAULT (getutcdate()) NOT NULL,
    [ROWVERSION]              INT            CONSTRAINT [DF_ILLICENSEACTIVITYTYPE_RowVersion] DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_ILLICENSEACTIVITYTYPE] PRIMARY KEY CLUSTERED ([ILLICENSEACTIVITYTYPEID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_ILLICACTTYPE_CUSTOMLAYOUT] FOREIGN KEY ([CUSTOMFIELDLAYOUTID]) REFERENCES [dbo].[CUSTOMFIELDLAYOUT] ([GCUSTOMFIELDLAYOUTS])
);


GO
CREATE NONCLUSTERED INDEX [ILLICENSEACTIVITYTYPE_IX_QUERY]
    ON [dbo].[ILLICENSEACTIVITYTYPE]([ILLICENSEACTIVITYTYPEID] ASC, [NAME] ASC);


GO

CREATE TRIGGER [dbo].[TG_ILLICENSEACTIVITYTYPE_DELETE] ON [dbo].[ILLICENSEACTIVITYTYPE]
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
			[deleted].[ILLICENSEACTIVITYTYPEID],
			[deleted].[ROWVERSION],
			GETUTCDATE(),
			(SELECT dbo.UFN_GET_USERID_FROM_CONTEXT_INFO()),
			'Professional License Activity Type Deleted',
			'',
			'',
			'Professional License Activity Type (' + [deleted].[NAME] + ')',
			'8EB3A2AD-70C5-4308-B1BC-812F6054BF9A',
			3,
			1,
			[deleted].[NAME]
	FROM	[deleted]
END
GO

CREATE TRIGGER [dbo].[TG_ILLICENSEACTIVITYTYPE_INSERT] ON [dbo].[ILLICENSEACTIVITYTYPE]
   FOR INSERT
AS 
BEGIN
	SET NOCOUNT ON;
	-- Check if LASTCHANGEDBY contains VALID User Id and it Exists in USERS table, this is in replacement to foreign key reference of ILLICENSEACTIVITYTYPE table with USERS table.
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
			[inserted].[ILLICENSEACTIVITYTYPEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Professional License Activity Type Added',
			'',
			'',
			'Professional License Activity Type (' + [inserted].[NAME] + ')',
			'8EB3A2AD-70C5-4308-B1BC-812F6054BF9A',
			1,
			1,
			[inserted].[NAME]
	FROM	[inserted]	
END
GO

CREATE TRIGGER [dbo].[TG_ILLICENSEACTIVITYTYPE_UPDATE] ON [dbo].[ILLICENSEACTIVITYTYPE] 
	AFTER UPDATE
AS 
BEGIN
	SET NOCOUNT ON;
		
	-- Check if LASTCHANGEDBY contains VALID User Id and it Exists in USERS table, this is in replacement to foreign key reference of ILLICENSEACTIVITYTYPE table with USERS table.
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
			[inserted].[ILLICENSEACTIVITYTYPEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Name',
			[deleted].[NAME],
			[inserted].[NAME],
			'Professional License Activity Type (' + [inserted].[NAME] + ')',
			'8EB3A2AD-70C5-4308-B1BC-812F6054BF9A',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[ILLICENSEACTIVITYTYPEID] = [inserted].[ILLICENSEACTIVITYTYPEID]
	WHERE	[deleted].[NAME] <> [inserted].[NAME]

	UNION ALL
	SELECT
			[inserted].[ILLICENSEACTIVITYTYPEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Description',
			ISNULL([deleted].[DESCRIPTION],'[none]'),
			ISNULL([inserted].[DESCRIPTION],'[none]'),
			'Professional License Activity Type (' + [inserted].[NAME] + ')',
			'8EB3A2AD-70C5-4308-B1BC-812F6054BF9A',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[ILLICENSEACTIVITYTYPEID] = [inserted].[ILLICENSEACTIVITYTYPEID]
	WHERE	ISNULL([deleted].[DESCRIPTION], '') <> ISNULL([inserted].[DESCRIPTION], '')

	UNION ALL
	SELECT
			[inserted].[ILLICENSEACTIVITYTYPEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Prefix ID',
			ISNULL([deleted].[PREFIX],'[none]'),
			ISNULL([inserted].[PREFIX],'[none]'),
			'Professional License Activity Type (' + [inserted].[NAME] + ')',
			'8EB3A2AD-70C5-4308-B1BC-812F6054BF9A',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[ILLICENSEACTIVITYTYPEID] = [inserted].[ILLICENSEACTIVITYTYPEID]
	WHERE	ISNULL([deleted].[PREFIX], '') <> ISNULL([inserted].[PREFIX], '')
	
	UNION ALL
	SELECT
			[inserted].[ILLICENSEACTIVITYTYPEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Custom Field Layout',
			ISNULL([CUSTOMFIELDLAYOUT_DELETED].[SNAME],'[none]'),
			ISNULL([CUSTOMFIELDLAYOUT_INSERTED].[SNAME],'[none]'),
			'Professional License Activity Type (' + [inserted].[NAME] + ')',
			'8EB3A2AD-70C5-4308-B1BC-812F6054BF9A',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[ILLICENSEACTIVITYTYPEID] = [inserted].[ILLICENSEACTIVITYTYPEID]
			LEFT JOIN CUSTOMFIELDLAYOUT CUSTOMFIELDLAYOUT_DELETED WITH (NOLOCK) ON [deleted].[CUSTOMFIELDLAYOUTID] = [CUSTOMFIELDLAYOUT_DELETED].[GCUSTOMFIELDLAYOUTS]
			LEFT JOIN CUSTOMFIELDLAYOUT CUSTOMFIELDLAYOUT_INSERTED WITH (NOLOCK) ON [inserted].[CUSTOMFIELDLAYOUTID] = [CUSTOMFIELDLAYOUT_INSERTED].[GCUSTOMFIELDLAYOUTS]
	WHERE	ISNULL([deleted].[CUSTOMFIELDLAYOUTID], '') <> ISNULL([inserted].[CUSTOMFIELDLAYOUTID], '')

	UNION ALL
	SELECT
			[inserted].[ILLICENSEACTIVITYTYPEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Can Edit Flag',
			CASE WHEN [deleted].[CANEDIT] = 1 THEN 'Yes' ELSE 'No' END,
			CASE WHEN [inserted].[CANEDIT] = 1 THEN 'Yes' ELSE 'No' END,
			'Professional License Activity Type (' + [inserted].[NAME] + ')',
			'8EB3A2AD-70C5-4308-B1BC-812F6054BF9A',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[ILLICENSEACTIVITYTYPEID] = [inserted].[ILLICENSEACTIVITYTYPEID]
	WHERE	[deleted].[CANEDIT] <> [inserted].[CANEDIT]

	UNION ALL
	SELECT
			[inserted].[ILLICENSEACTIVITYTYPEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Create ID Flag',
			CASE WHEN [deleted].[CREATEID] = 1 THEN 'Yes' ELSE 'No' END,
			CASE WHEN [inserted].[CREATEID] = 1 THEN 'Yes' ELSE 'No' END,
			'Professional License Activity Type (' + [inserted].[NAME] + ')',
			'8EB3A2AD-70C5-4308-B1BC-812F6054BF9A',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[ILLICENSEACTIVITYTYPEID] = [inserted].[ILLICENSEACTIVITYTYPEID]
	WHERE	[deleted].[CREATEID] <> [inserted].[CREATEID]

	UNION ALL
	SELECT
			[inserted].[ILLICENSEACTIVITYTYPEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Allow Duplicate Flag',
			CASE WHEN [deleted].[ALLOWDUPLICATE] = 1 THEN 'Yes' ELSE 'No' END,
			CASE WHEN [inserted].[ALLOWDUPLICATE] = 1 THEN 'Yes' ELSE 'No' END,
			'Professional License Activity Type (' + [inserted].[NAME] + ')',
			'8EB3A2AD-70C5-4308-B1BC-812F6054BF9A',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[ILLICENSEACTIVITYTYPEID] = [inserted].[ILLICENSEACTIVITYTYPEID]
	WHERE	[deleted].[ALLOWDUPLICATE] <> [inserted].[ALLOWDUPLICATE]
END