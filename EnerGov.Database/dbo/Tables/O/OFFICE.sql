CREATE TABLE [dbo].[OFFICE] (
    [OFFICEID]                 CHAR (36)      NOT NULL,
    [NAME]                     NVARCHAR (100) NOT NULL,
    [DESCRIPTION]              NVARCHAR (MAX) NULL,
    [DISTRICTID]               CHAR (36)      NULL,
    [PHONE]                    NVARCHAR (50)  NULL,
    [FAX]                      NVARCHAR (50)  NULL,
    [TYLERFINANCIALOFFICENAME] NVARCHAR (100) NULL,
    [LASTCHANGEDBY]            CHAR (36)      NULL,
    [LASTCHANGEDON]            DATETIME       CONSTRAINT [DF_OFFICE_LastChangedOn] DEFAULT (getutcdate()) NOT NULL,
    [ROWVERSION]               INT            CONSTRAINT [DF_OFFICE_RowVersion] DEFAULT ((1)) NOT NULL,
    [JURISDICTIONID]           CHAR (36)      NULL,
    CONSTRAINT [PK_OFFICE] PRIMARY KEY CLUSTERED ([OFFICEID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_JURISDICTION] FOREIGN KEY ([JURISDICTIONID]) REFERENCES [dbo].[JURISDICTION] ([JURISDICTIONID]),
    CONSTRAINT [FK_OFFICE_DISTRICT] FOREIGN KEY ([DISTRICTID]) REFERENCES [dbo].[DISTRICT] ([DISTRICTID])
);


GO

CREATE TRIGGER [TG_OFFICE_DELETE] ON OFFICE
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
			[deleted].[OFFICEID],
			[deleted].[ROWVERSION],
			GETUTCDATE(),
			(SELECT dbo.UFN_GET_USERID_FROM_CONTEXT_INFO()),
			'Office Deleted',
			'',
			'',
			'Office (' + [deleted].[NAME] + ')',
			'A4A2A7E4-FB08-47AA-80D9-51C0E68DEBC7',
			3,
			1,
			[deleted].[NAME]
	FROM	[deleted]
END
GO

CREATE TRIGGER [TG_OFFICE_INSERT] ON OFFICE
   FOR INSERT
AS 
BEGIN
	SET NOCOUNT ON;


	-- Check if LASTCHANGEDBY contains VALID User Id and it Exists in USERS table, this is in replacement to foreign key reference of OFFICE table with USERS table.
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
			[inserted].[OFFICEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Office Added',
			'',
			'',
			'Office (' + [inserted].[NAME] + ')',
			'A4A2A7E4-FB08-47AA-80D9-51C0E68DEBC7',
			1,
			1,
			[inserted].[NAME]
	FROM	[inserted]	
END
GO


CREATE TRIGGER [TG_OFFICE_UPDATE] ON OFFICE
   AFTER UPDATE
AS 
BEGIN
	SET NOCOUNT ON;
		
	-- Check if LASTCHANGEDBY contains VALID User Id and it Exists in USERS table, this is in replacement to foreign key reference of OFFICE table with USERS table.
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
			[inserted].[OFFICEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Office Name',
			[deleted].[NAME],
			[inserted].[NAME],
			'Office (' + [inserted].[NAME] + ')',
			'A4A2A7E4-FB08-47AA-80D9-51C0E68DEBC7',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[OFFICEID] = [inserted].[OFFICEID]
	WHERE	[deleted].[NAME] <> [inserted].[NAME]
	UNION ALL
	SELECT
			[inserted].[OFFICEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Description',
			ISNULL([deleted].[DESCRIPTION],'[none]'),
			ISNULL([inserted].[DESCRIPTION],'[none]'),
			'Office (' + [inserted].[NAME] + ')',
			'A4A2A7E4-FB08-47AA-80D9-51C0E68DEBC7',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[OFFICEID] = [inserted].[OFFICEID]
	WHERE	ISNULL([deleted].[DESCRIPTION], '') <> ISNULL([inserted].[DESCRIPTION], '')	
	UNION ALL
	SELECT
			[inserted].[OFFICEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'District',
			ISNULL([DISTRICT_DELETED].[NAME], '[none]'),
			ISNULL([DISTRICT_INSERTED].[NAME], '[none]'),
			'Office (' + [inserted].[NAME] + ')',
			'A4A2A7E4-FB08-47AA-80D9-51C0E68DEBC7',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[OFFICEID] = [inserted].[OFFICEID]
			LEFT JOIN DISTRICT DISTRICT_DELETED WITH (NOLOCK) ON [deleted].[DISTRICTID] = DISTRICT_DELETED.[DISTRICTID]
			LEFT JOIN DISTRICT DISTRICT_INSERTED WITH (NOLOCK) ON [inserted].[DISTRICTID] = DISTRICT_INSERTED.[DISTRICTID]
	WHERE	ISNULL([deleted].[DISTRICTID], '') <> ISNULL([inserted].[DISTRICTID], '')
	UNION ALL
	SELECT
			[inserted].[OFFICEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Office Phone',
			ISNULL([deleted].[PHONE],'[none]'),
			ISNULL([inserted].[PHONE],'[none]'),
			'Office (' + [inserted].[NAME] + ')',
			'A4A2A7E4-FB08-47AA-80D9-51C0E68DEBC7',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[OFFICEID] = [inserted].[OFFICEID]
	WHERE	ISNULL([deleted].[PHONE], '') <> ISNULL([inserted].[PHONE], '')
	UNION ALL
	SELECT
			[inserted].[OFFICEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Office Fax',
			ISNULL([deleted].[FAX],'[none]'),
			ISNULL([inserted].[FAX],'[none]'),
			'Office (' + [inserted].[NAME] + ')',
			'A4A2A7E4-FB08-47AA-80D9-51C0E68DEBC7',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[OFFICEID] = [inserted].[OFFICEID]
	WHERE	ISNULL([deleted].[FAX], '') <> ISNULL([inserted].[FAX], '')
	UNION ALL
	SELECT
			[inserted].[OFFICEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Tyler Financial Office Name',
			ISNULL([deleted].[TYLERFINANCIALOFFICENAME],'[none]'),
			ISNULL([inserted].[TYLERFINANCIALOFFICENAME],'[none]'),
			'Office (' + [inserted].[NAME] + ')',
			'A4A2A7E4-FB08-47AA-80D9-51C0E68DEBC7',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[OFFICEID] = [inserted].[OFFICEID]
	WHERE	ISNULL([deleted].[TYLERFINANCIALOFFICENAME], '') <> ISNULL([inserted].[TYLERFINANCIALOFFICENAME], '')
	UNION ALL
	SELECT
			[inserted].[OFFICEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Jurisdiction',
			ISNULL([JURISDICTION_DELETED].[NAME], '[none]'),
			ISNULL([JURISDICTION_INSERTED].[NAME], '[none]'),
			'Office (' + [inserted].[NAME] + ')',
			'A4A2A7E4-FB08-47AA-80D9-51C0E68DEBC7',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[OFFICEID] = [inserted].[OFFICEID]
			LEFT JOIN JURISDICTION JURISDICTION_DELETED WITH (NOLOCK) ON [deleted].[JURISDICTIONID] = JURISDICTION_DELETED.[JURISDICTIONID]
			LEFT JOIN JURISDICTION JURISDICTION_INSERTED WITH (NOLOCK) ON [inserted].[JURISDICTIONID] = JURISDICTION_INSERTED.[JURISDICTIONID]
	WHERE	ISNULL([deleted].[JURISDICTIONID], '') <> ISNULL([inserted].[JURISDICTIONID], '')
END