CREATE TABLE [dbo].[IPTARGETEDFUNDTYPE] (
    [IPTARGETEDFUNDTYPEID] CHAR (36)      NOT NULL,
    [NAME]                 NVARCHAR (100) NOT NULL,
    [DESCRIPTION]          NVARCHAR (MAX) NULL,
    [ACTIVE]               BIT            NOT NULL,
    [LASTCHANGEDBY]        CHAR (36)      NULL,
    [LASTCHANGEDON]        DATETIME       CONSTRAINT [DF_IPTARGETEDFUNDTYPE_LastChangedOn] DEFAULT (getutcdate()) NOT NULL,
    [ROWVERSION]           INT            CONSTRAINT [DF_IPTARGETEDFUNDTYPE_RowVersion] DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_IPTARGETEDFUNDTYPE] PRIMARY KEY CLUSTERED ([IPTARGETEDFUNDTYPEID] ASC) WITH (FILLFACTOR = 90)
);


GO
CREATE NONCLUSTERED INDEX [IPTARGETEDFUNDTYPE_IX_QUERY]
    ON [dbo].[IPTARGETEDFUNDTYPE]([IPTARGETEDFUNDTYPEID] ASC, [NAME] ASC);


GO

CREATE TRIGGER [TG_IPTARGETEDFUNDTYPE_DELETE] ON IPTARGETEDFUNDTYPE
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
			[deleted].[IPTARGETEDFUNDTYPEID],
			[deleted].[ROWVERSION],
			GETUTCDATE(),
			(SELECT dbo.UFN_GET_USERID_FROM_CONTEXT_INFO()),
			'Targeted Fund Type Deleted',
			'',
			'',
			'Targeted Fund Type (' + [deleted].[NAME] + ')',
			'5A6F402F-EC1F-4AC2-AED8-C1E33FF53CA0',
			3,
			1,
			[deleted].[NAME]
	FROM	[deleted]
END
GO

CREATE TRIGGER [TG_IPTARGETEDFUNDTYPE_INSERT] ON IPTARGETEDFUNDTYPE
   FOR INSERT
AS 
BEGIN
	SET NOCOUNT ON;

	-- Check if LASTCHANGEDBY contains VALID User Id and it Exists in USERS table, this is in replacement to foreign key reference of IPTARGETEDFUNDTYPE table with USERS table.
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
			[inserted].[IPTARGETEDFUNDTYPEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Targeted Fund Type Added',
			'',
			'',
			'Targeted Fund Type (' + [inserted].[NAME] + ')',
			'5A6F402F-EC1F-4AC2-AED8-C1E33FF53CA0',
			1,
			1,
			[inserted].[NAME]
	FROM	[inserted]	
END
GO

CREATE TRIGGER [TG_IPTARGETEDFUNDTYPE_UPDATE] ON IPTARGETEDFUNDTYPE
   AFTER UPDATE
AS 
BEGIN
	SET NOCOUNT ON;

	-- Check if LASTCHANGEDBY contains VALID User Id and it Exists in USERS table, this is in replacement to foreign key reference of IPTARGETEDFUNDTYPE table with USERS table.
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
			[inserted].[IPTARGETEDFUNDTYPEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Name',
			[deleted].[NAME],
			[inserted].[NAME],
			'Targeted Fund Type (' + [inserted].[NAME] + ')',
			'5A6F402F-EC1F-4AC2-AED8-C1E33FF53CA0',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].IPTARGETEDFUNDTYPEID = [inserted].IPTARGETEDFUNDTYPEID
	WHERE	[deleted].[NAME] <> [inserted].[NAME]
	UNION ALL
	SELECT
			[inserted].[IPTARGETEDFUNDTYPEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Description',
			ISNULL([deleted].[DESCRIPTION],'[none]'),
			ISNULL([inserted].[DESCRIPTION],'[none]'),
			'Targeted Fund Type (' + [inserted].[NAME] + ')',
			'5A6F402F-EC1F-4AC2-AED8-C1E33FF53CA0',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].IPTARGETEDFUNDTYPEID = [inserted].IPTARGETEDFUNDTYPEID
	WHERE	ISNULL([deleted].[DESCRIPTION], '') <> ISNULL([inserted].[DESCRIPTION], '')
	UNION ALL
	SELECT
			[inserted].[IPTARGETEDFUNDTYPEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Active Flag',
			CASE [deleted].[ACTIVE] WHEN 1 THEN 'Yes' ELSE 'No' END,
			CASE [inserted].[ACTIVE] WHEN 1 THEN 'Yes' ELSE 'No' END,
			'Targeted Fund Type (' + [inserted].[NAME] + ')',
			'5A6F402F-EC1F-4AC2-AED8-C1E33FF53CA0',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[IPTARGETEDFUNDTYPEID] = [inserted].[IPTARGETEDFUNDTYPEID]
	WHERE	[deleted].[ACTIVE] <> [inserted].[ACTIVE]
END