CREATE TABLE [dbo].[CADISCOUNT] (
    [CADISCOUNTID]        CHAR (36)      NOT NULL,
    [CACOMPUTATIONTYPEID] INT            NOT NULL,
    [NAME]                NVARCHAR (50)  NOT NULL,
    [DESCRIPTION]         NVARCHAR (MAX) NOT NULL,
    [ACTIVE]              BIT            CONSTRAINT [DF_CADiscount_Active] DEFAULT ((1)) NOT NULL,
    [ROWVERSION]          INT            CONSTRAINT [DF_CADiscount_Version] DEFAULT ((1)) NOT NULL,
    [LASTCHANGEDBY]       CHAR (36)      NOT NULL,
    [LASTCHANGEDON]       DATETIME       CONSTRAINT [DF_CADiscount_ChangedOn] DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [PK_CADiscount] PRIMARY KEY CLUSTERED ([CADISCOUNTID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_CADiscount_ChangedBy] FOREIGN KEY ([LASTCHANGEDBY]) REFERENCES [dbo].[USERS] ([SUSERGUID]),
    CONSTRAINT [FK_CADiscount_Type] FOREIGN KEY ([CACOMPUTATIONTYPEID]) REFERENCES [dbo].[CACOMPUTATIONTYPE] ([CACOMPUTATIONTYPEID])
);


GO
CREATE NONCLUSTERED INDEX [CADISCOUNT_IX_QUERY]
    ON [dbo].[CADISCOUNT]([CADISCOUNTID] ASC, [NAME] ASC);


GO


CREATE TRIGGER [dbo].[TG_CADISCOUNT_DELETE] ON [dbo].[CADISCOUNT]
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
			[deleted].[CADISCOUNTID],
			[deleted].[ROWVERSION],
			GETUTCDATE(),
			(SELECT dbo.UFN_GET_USERID_FROM_CONTEXT_INFO()),
			'Discount Deleted',
			'',
			'',
			'Discount (' + [deleted].[NAME] + ')',
			'6E95A0E5-C492-4C95-B532-DE1630CE3F7C',
			3,
			1,
			[deleted].[NAME]
	FROM	[deleted]
END
GO


CREATE TRIGGER [dbo].[TG_CADISCOUNT_INSERT] ON [dbo].[CADISCOUNT]
   AFTER INSERT
AS 
BEGIN
	SET NOCOUNT ON;

	-- Check if LASTCHANGEDBY contains VALID User Id and it Exists in USERS table, this is in replacement to foreign key reference of CADISCOUNT table with USERS table.
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
        [ADDITIONALINFO],
		[FORMID],
		[ACTION],
		[ISROOT],
		[RECORDNAME]
    )
	SELECT 
        [inserted].[CADISCOUNTID], 
        [inserted].[ROWVERSION],
        GETUTCDATE(),
        [inserted].[LASTCHANGEDBY],
        'Discount Added',
        '',
        '',
        'Discount (' + [inserted].[NAME] + ')',
		'6E95A0E5-C492-4C95-B532-DE1630CE3F7C',
		1,
		1,
		[inserted].[NAME]
    FROM [inserted] 
END
GO


CREATE TRIGGER [dbo].[TG_CADISCOUNT_UPDATE] ON [dbo].[CADISCOUNT]
   AFTER UPDATE
AS 
BEGIN	
	SET NOCOUNT ON;

	-- Check if LASTCHANGEDBY contains VALID User Id and it Exists in USERS table, this is in replacement to foreign key reference of CADISCOUNT table with USERS table.
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
			[inserted].[CADISCOUNTID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Discount Type',
			[CACOMPUTATIONTYPE_DELETED].[NAME],
			[CACOMPUTATIONTYPE_INSERTED].[NAME],
			'Discount (' + [inserted].[NAME] + ')',
			'6E95A0E5-C492-4C95-B532-DE1630CE3F7C',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted] JOIN [inserted] ON [deleted].[CADISCOUNTID] = [inserted].[CADISCOUNTID]
	INNER JOIN [CACOMPUTATIONTYPE] CACOMPUTATIONTYPE_DELETED WITH (NOLOCK) ON [deleted].[CACOMPUTATIONTYPEID] = [CACOMPUTATIONTYPE_DELETED].[CACOMPUTATIONTYPEID]
	INNER JOIN [CACOMPUTATIONTYPE] CACOMPUTATIONTYPE_INSERTED WITH (NOLOCK) ON [inserted].[CACOMPUTATIONTYPEID] = [CACOMPUTATIONTYPE_INSERTED].[CACOMPUTATIONTYPEID]
	WHERE	[deleted].[CACOMPUTATIONTYPEID] <> [inserted].[CACOMPUTATIONTYPEID]
	UNION ALL
	SELECT
			[inserted].[CADISCOUNTID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Name',
			[deleted].[NAME],
			[inserted].[NAME],
			'Discount (' + [inserted].[NAME] + ')',
			'6E95A0E5-C492-4C95-B532-DE1630CE3F7C',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[CADISCOUNTID] = [inserted].[CADISCOUNTID]
	WHERE	[deleted].[NAME] <> [inserted].[NAME]
	UNION ALL
	SELECT
			[inserted].[CADISCOUNTID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Description',
			[deleted].[DESCRIPTION],
			[inserted].[DESCRIPTION],
			'Discount (' + [inserted].[NAME] + ')',
			'6E95A0E5-C492-4C95-B532-DE1630CE3F7C',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[CADISCOUNTID] = [inserted].[CADISCOUNTID]
	WHERE	[deleted].[DESCRIPTION] <> [inserted].[DESCRIPTION]
	UNION ALL
	SELECT
			[inserted].[CADISCOUNTID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Active Flag',
			CASE WHEN [deleted].[ACTIVE] = 1 THEN 'Yes' ELSE 'No' END,
			CASE WHEN [inserted].[ACTIVE] = 1 THEN 'Yes' ELSE 'No' END,
			'Discount (' + [inserted].[NAME] + ')',
			'6E95A0E5-C492-4C95-B532-DE1630CE3F7C',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[CADISCOUNTID] = [inserted].[CADISCOUNTID]
	WHERE	[deleted].[ACTIVE] <> [inserted].[ACTIVE]
END