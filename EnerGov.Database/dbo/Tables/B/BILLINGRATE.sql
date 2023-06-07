CREATE TABLE [dbo].[BILLINGRATE] (
    [BILLINGRATEID] CHAR (36)      NOT NULL,
    [NAME]          NVARCHAR (150) NOT NULL,
    [DESCRIPTION]   NVARCHAR (MAX) NULL,
    [AMOUNT]        MONEY          NOT NULL,
    [ACTIVE]        BIT            NOT NULL,
    [LASTCHANGEDBY] CHAR (36)      NULL,
    [LASTCHANGEDON] DATETIME       CONSTRAINT [DF_BILLINGRATE_LastChangedOn] DEFAULT (getutcdate()) NOT NULL,
    [ROWVERSION]    INT            CONSTRAINT [DF_BILLINGRATE_RowVersion] DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_BillingRate] PRIMARY KEY CLUSTERED ([BILLINGRATEID] ASC) WITH (FILLFACTOR = 90)
);


GO
CREATE NONCLUSTERED INDEX [BILLINGRATE_IX_QUERY]
    ON [dbo].[BILLINGRATE]([BILLINGRATEID] ASC, [NAME] ASC);


GO

CREATE TRIGGER [dbo].[TG_BILLINGRATE_DELETE] ON [dbo].[BILLINGRATE]
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
			[deleted].[BILLINGRATEID],
			[deleted].[ROWVERSION],
			GETUTCDATE(),
			(SELECT dbo.UFN_GET_USERID_FROM_CONTEXT_INFO()),
			'Billable Rate Type Deleted',
			'',
			'',
			'Billable Rate Type (' + [deleted].[NAME] + ')',
			'49AE6599-C9A5-407F-A595-00527BD3B7A6',
			3,
			1,
			[deleted].[NAME]
	FROM	[deleted]
END
GO

CREATE TRIGGER [dbo].[TG_BILLINGRATE_INSERT] ON [dbo].[BILLINGRATE]
   FOR INSERT
AS 
BEGIN
	SET NOCOUNT ON;
	-- Check if LASTCHANGEDBY contains VALID User Id and it Exists in USERS table, this is in replacement to foreign key reference of BILLINGRATE table with USERS table.
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
			[inserted].[BILLINGRATEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Billable Rate Type Added',
			'',
			'',
			'Billable Rate Type (' + [inserted].[NAME] + ')',
			'49AE6599-C9A5-407F-A595-00527BD3B7A6',
			1,
			1,
			[inserted].[NAME]
	FROM	[inserted]	
END
GO

CREATE TRIGGER [dbo].[TG_BILLINGRATE_UPDATE] ON [dbo].[BILLINGRATE] 
	AFTER UPDATE
AS 
BEGIN
	SET NOCOUNT ON;
		
	-- Check if LASTCHANGEDBY contains VALID User Id and it Exists in USERS table, this is in replacement to foreign key reference of BILLINGRATE table with USERS table.
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
			[inserted].[BILLINGRATEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Name',
			[deleted].[NAME],
			[inserted].[NAME],
			'Billable Rate Type (' + [inserted].[NAME] + ')',
			'49AE6599-C9A5-407F-A595-00527BD3B7A6',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[BILLINGRATEID] = [inserted].[BILLINGRATEID]
	WHERE	[deleted].[NAME] <> [inserted].[NAME]

	UNION ALL
	SELECT
			[inserted].[BILLINGRATEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Description',
			ISNULL([deleted].[DESCRIPTION],'[none]'),
			ISNULL([inserted].[DESCRIPTION],'[none]'),
			'Billable Rate Type (' + [inserted].[NAME] + ')',
			'49AE6599-C9A5-407F-A595-00527BD3B7A6',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[BILLINGRATEID] = [inserted].[BILLINGRATEID]
	WHERE	ISNULL([deleted].[DESCRIPTION], '') <> ISNULL([inserted].[DESCRIPTION], '')

	UNION ALL
	SELECT
			[inserted].[BILLINGRATEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Billable Rate (per hour)',
			CAST(FORMAT([deleted].[AMOUNT], 'C4') AS NVARCHAR(MAX)),
            CAST(FORMAT([inserted].[AMOUNT], 'C4') AS NVARCHAR(MAX)),
			'Billable Rate Type (' + [inserted].[NAME] + ')',
			'49AE6599-C9A5-407F-A595-00527BD3B7A6',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[BILLINGRATEID] = [inserted].[BILLINGRATEID]
	WHERE	[deleted].[AMOUNT] <> [inserted].[AMOUNT]

	UNION ALL
	SELECT
			[inserted].[BILLINGRATEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Active Flag',
			CASE WHEN [deleted].[ACTIVE] = 1 THEN 'Yes' ELSE 'No' END,
			CASE WHEN [inserted].[ACTIVE] = 1 THEN 'Yes' ELSE 'No' END,
			'Billable Rate Type (' + [inserted].[NAME] + ')',
			'49AE6599-C9A5-407F-A595-00527BD3B7A6',
			2,
			1,
			[inserted].[NAME] 
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[BILLINGRATEID] = [inserted].[BILLINGRATEID]
	WHERE	[deleted].[ACTIVE] <> [inserted].[ACTIVE]
END