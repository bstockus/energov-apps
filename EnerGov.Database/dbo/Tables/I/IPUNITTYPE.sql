CREATE TABLE [dbo].[IPUNITTYPE] (
    [IPUNITTYPEID]           CHAR (36)      NOT NULL,
    [NAME]                   NVARCHAR (100) NOT NULL,
    [DESCRIPTION]            NVARCHAR (MAX) NULL,
    [ACTIVE]                 BIT            NOT NULL,
    [IGNOREONIMPACTEDRECORD] BIT            DEFAULT ((0)) NOT NULL,
    [LASTCHANGEDBY]          CHAR (36)      NULL,
    [LASTCHANGEDON]          DATETIME       CONSTRAINT [DF_IPUNITTYPE_LastChangedOn] DEFAULT (getutcdate()) NOT NULL,
    [ROWVERSION]             INT            CONSTRAINT [DF_IPUNITTYPE_RowVersion] DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_IPUNITTYPE] PRIMARY KEY CLUSTERED ([IPUNITTYPEID] ASC) WITH (FILLFACTOR = 90)
);


GO
CREATE NONCLUSTERED INDEX [IPUNITTYPE_IX_QUERY]
    ON [dbo].[IPUNITTYPE]([IPUNITTYPEID] ASC, [NAME] ASC);


GO

CREATE TRIGGER [TG_IPUNITTYPE_DELETE] ON IPUNITTYPE
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
			[deleted].[IPUNITTYPEID],
			[deleted].[ROWVERSION],
			GETUTCDATE(),
			(SELECT dbo.UFN_GET_USERID_FROM_CONTEXT_INFO()),
			'Impact Unit Type Deleted',
			'',
			'',
			'Impact Unit Type (' + [deleted].[NAME] + ')',
			'950CE21F-B02B-41A0-A65A-FA40B3177F7E',
			3,
			1,
			[deleted].[NAME]
	FROM	[deleted]
END
GO

CREATE TRIGGER [TG_IPUNITTYPE_INSERT] ON IPUNITTYPE
   FOR INSERT
AS 
BEGIN
	SET NOCOUNT ON;

	-- Check if LASTCHANGEDBY contains VALID User Id and it Exists in USERS table, this is in replacement to foreign key reference of IPUNITTYPE table with USERS table.
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
			[inserted].[IPUNITTYPEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Impact Unit Type Added',
			'',
			'',
			'Impact Unit Type (' + [inserted].[NAME] + ')',
			'950CE21F-B02B-41A0-A65A-FA40B3177F7E',
			1,
			1,
			[inserted].[NAME]
	FROM	[inserted]	
END
GO

CREATE TRIGGER [TG_IPUNITTYPE_UPDATE] ON IPUNITTYPE
   AFTER UPDATE
AS 
BEGIN
	SET NOCOUNT ON;

	-- Check if LASTCHANGEDBY contains VALID User Id and it Exists in USERS table, this is in replacement to foreign key reference of IPUNITTYPE table with USERS table.
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
			[inserted].[IPUNITTYPEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Name',
			[deleted].[NAME],
			[inserted].[NAME],
			'Impact Unit Type (' + [inserted].[NAME] + ')',
			'950CE21F-B02B-41A0-A65A-FA40B3177F7E',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].IPUNITTYPEID = [inserted].IPUNITTYPEID
	WHERE	[deleted].[NAME] <> [inserted].[NAME]
	
	UNION ALL
	SELECT
			[inserted].[IPUNITTYPEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Description',
			ISNULL([deleted].[DESCRIPTION],'[none]'),
			ISNULL([inserted].[DESCRIPTION],'[none]'),
			'Impact Unit Type (' + [inserted].[NAME] + ')',
			'950CE21F-B02B-41A0-A65A-FA40B3177F7E',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].IPUNITTYPEID = [inserted].IPUNITTYPEID
	WHERE	ISNULL([deleted].[DESCRIPTION], '') <> ISNULL([inserted].[DESCRIPTION], '')
	
	UNION ALL
	SELECT
			[inserted].[IPUNITTYPEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Active Flag',
			CASE [deleted].[ACTIVE] WHEN 1 THEN 'Yes' ELSE 'No' END,
			CASE [inserted].[ACTIVE] WHEN 1 THEN 'Yes' ELSE 'No' END,
			'Impact Unit Type (' + [inserted].[NAME] + ')',
			'950CE21F-B02B-41A0-A65A-FA40B3177F7E',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[IPUNITTYPEID] = [inserted].[IPUNITTYPEID]
	WHERE	[deleted].[ACTIVE] <> [inserted].[ACTIVE]

	UNION ALL
	SELECT
			[inserted].[IPUNITTYPEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Ignore On Impacted Record Flag',
			CASE [deleted].[IGNOREONIMPACTEDRECORD] WHEN 1 THEN 'Yes' ELSE 'No' END,
			CASE [inserted].[IGNOREONIMPACTEDRECORD] WHEN 1 THEN 'Yes' ELSE 'No' END,
			'Impact Unit Type (' + [inserted].[NAME] + ')',
			'950CE21F-B02B-41A0-A65A-FA40B3177F7E',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[IPUNITTYPEID] = [inserted].[IPUNITTYPEID]
	WHERE	[deleted].[IGNOREONIMPACTEDRECORD] <> [inserted].[IGNOREONIMPACTEDRECORD]
END