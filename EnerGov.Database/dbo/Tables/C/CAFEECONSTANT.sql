CREATE TABLE [dbo].[CAFEECONSTANT] (
    [CAFEECONSTANTID] CHAR (36)      NOT NULL,
    [NAME]            NVARCHAR (50)  NOT NULL,
    [DESCRIPTION]     NVARCHAR (MAX) NOT NULL,
    [VALUETYPEID]     INT            CONSTRAINT [DF_CAFeeConstant_ValueType] DEFAULT ((0)) NOT NULL,
    [LASTCHANGEDBY]   CHAR (36)      NULL,
    [LASTCHANGEDON]   DATETIME       CONSTRAINT [DF_CAFEECONSTANT_LastChangedOn] DEFAULT (getutcdate()) NOT NULL,
    [ROWVERSION]      INT            CONSTRAINT [DF_CAFEECONSTANT_RowVersion] DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_CAFeeConstant] PRIMARY KEY CLUSTERED ([CAFEECONSTANTID] ASC) WITH (FILLFACTOR = 90)
);


GO
CREATE NONCLUSTERED INDEX [CAFEECONSTANT_IX_QUERY]
    ON [dbo].[CAFEECONSTANT]([CAFEECONSTANTID] ASC, [NAME] ASC);


GO

CREATE TRIGGER [dbo].[TG_CAFEECONSTANT_INSERT] ON [dbo].[CAFEECONSTANT]
   FOR INSERT
AS 
BEGIN
	SET NOCOUNT ON;
	-- Check if LASTCHANGEDBY contains VALID User Id and it Exists in USERS table, this is in replacement to foreign key reference of CAFEECONSTANT table with USERS table.
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
			[inserted].[CAFEECONSTANTID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Fee Constant Added',
			'',
			'',
			'Fee Constant (' + [inserted].[NAME] + ')',
			'B19A0B8D-ED51-4A4E-8075-E8EE0DEDE22C',
			1,
			1,
			[inserted].[NAME]
	FROM	[inserted]	
END
GO

CREATE TRIGGER [dbo].[TG_CAFEECONSTANT_UPDATE] ON [dbo].[CAFEECONSTANT] 
	AFTER UPDATE
AS 
BEGIN
	SET NOCOUNT ON;
		
	-- Check if LASTCHANGEDBY contains VALID User Id and it Exists in USERS table, this is in replacement to foreign key reference of CAFEECONSTANT table with USERS table.
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
			[inserted].[CAFEECONSTANTID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Name',
			[deleted].[NAME],
			[inserted].[NAME],
			'Fee Constant (' + [inserted].[NAME] + ')',
			'B19A0B8D-ED51-4A4E-8075-E8EE0DEDE22C',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[CAFEECONSTANTID] = [inserted].[CAFEECONSTANTID]
	WHERE	[deleted].[NAME] <> [inserted].[NAME]
	
	UNION ALL
	SELECT
			[inserted].[CAFEECONSTANTID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Description',
			[deleted].[DESCRIPTION],
			[inserted].[DESCRIPTION],
			'Fee Constant (' + [inserted].[NAME] + ')',
			'B19A0B8D-ED51-4A4E-8075-E8EE0DEDE22C',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[CAFEECONSTANTID] = [inserted].[CAFEECONSTANTID]
	WHERE	[deleted].[DESCRIPTION] <> [inserted].[DESCRIPTION]			
	
	UNION ALL
	SELECT
			[inserted].[CAFEECONSTANTID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Value Type (Data Type)',
			CASE [deleted].[VALUETYPEID] WHEN 1 THEN 'String' 
										 WHEN 2 THEN 'Date'
										 WHEN 3 THEN 'Boolean'
										 WHEN 4 THEN 'Integer'
										 WHEN 5 THEN 'Number'
										 WHEN 6 THEN 'Currency'
										 WHEN 7 THEN 'None'
										 ELSE '[none]' END,
			CASE [inserted].[VALUETYPEID] WHEN 1 THEN 'String' 
										 WHEN 2 THEN 'Date'
										 WHEN 3 THEN 'Boolean'
										 WHEN 4 THEN 'Integer'
										 WHEN 5 THEN 'Number'
										 WHEN 6 THEN 'Currency'
										 WHEN 7 THEN 'None'
										 ELSE '[none]' END,
			'Fee Constant (' + [inserted].[NAME] + ')',
			'B19A0B8D-ED51-4A4E-8075-E8EE0DEDE22C',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[CAFEECONSTANTID] = [inserted].[CAFEECONSTANTID]
	WHERE	[deleted].[VALUETYPEID] <> [inserted].[VALUETYPEID]
	
END
GO

CREATE TRIGGER [dbo].[TG_CAFEECONSTANT_DELETE] ON [dbo].[CAFEECONSTANT]
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
			[deleted].[CAFEECONSTANTID],
			[deleted].[ROWVERSION],
			GETUTCDATE(),
			(SELECT dbo.UFN_GET_USERID_FROM_CONTEXT_INFO()),
			'Fee Constant Deleted',
			'',
			'',
			'Fee Constant (' + [deleted].[NAME] + ')',
			'B19A0B8D-ED51-4A4E-8075-E8EE0DEDE22C',
			3,
			1,
			[deleted].[NAME]
	FROM	[deleted]
END