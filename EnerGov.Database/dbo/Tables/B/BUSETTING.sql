CREATE TABLE [dbo].[BUSETTING] (
    [BUSETTINGID]   CHAR (36) NOT NULL,
    [ENTITY]        INT       NOT NULL,
    [STARTTIME]     DATETIME  NOT NULL,
    [ENDTIME]       DATETIME  NOT NULL,
    [NUMOFRECORD]   INT       NOT NULL,
    [ACTIVE]        BIT       NOT NULL,
    [LASTCHANGEDBY] CHAR (36) NULL,
    [LASTCHANGEDON] DATETIME  CONSTRAINT [DF_BUSETTING_LastChangedOn] DEFAULT (getutcdate()) NOT NULL,
    [ROWVERSION]    INT       CONSTRAINT [DF_BUSETTING_RowVersion] DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_BUSETTING] PRIMARY KEY CLUSTERED ([BUSETTINGID] ASC) WITH (FILLFACTOR = 90)
);


GO

CREATE TRIGGER [TG_BUSETTING_UPDATE] ON [dbo].[BUSETTING]
   AFTER UPDATE
AS 
BEGIN
	SET NOCOUNT ON;

	-- Check if LASTCHANGEDBY contains VALID User Id and it Exists in USERS table, this is in replacement to foreign key reference of BUSETTING table with USERS table.
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
			[inserted].[BUSETTINGID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Start time',
			CONVERT(NVARCHAR(MAX),FORMAT([deleted].[STARTTIME],'hh:mm tt')),
			CONVERT(NVARCHAR(MAX),FORMAT([inserted].[STARTTIME],'hh:mm tt')),
			'Start time for batch updates',
			'09A43BA0-3A36-4D2B-95AE-A2C13B97185A',
			2,
			0,
			'Start time for batch updates'
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[BUSETTINGID] = [inserted].[BUSETTINGID]
	WHERE	[deleted].[STARTTIME] <> [inserted].[STARTTIME]
	UNION ALL

	SELECT
			[inserted].[BUSETTINGID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'End time',
			CONVERT(NVARCHAR(MAX),FORMAT([deleted].[ENDTIME],'hh:mm tt')),
			CONVERT(NVARCHAR(MAX),FORMAT([inserted].[ENDTIME],'hh:mm tt')),
			'End time for batch updates',
			'09A43BA0-3A36-4D2B-95AE-A2C13B97185A',
			2,
			0,
			'End time for batch updates'
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[BUSETTINGID] = [inserted].[BUSETTINGID]
	WHERE	[deleted].[ENDTIME] <> [inserted].[ENDTIME]
	UNION ALL

	SELECT
			[inserted].[BUSETTINGID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Entity',
			CONVERT(NVARCHAR(MAX),[deleted].[ENTITY]),
			CONVERT(NVARCHAR(MAX),[inserted].[ENTITY]),
			'Entity for batch updates',
			'09A43BA0-3A36-4D2B-95AE-A2C13B97185A',
			2,
			0,
			'Entity for batch updates'
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[BUSETTINGID] = [inserted].[BUSETTINGID]
	WHERE	[deleted].[ENTITY] <> [inserted].[ENTITY]
	UNION ALL

	SELECT
			[inserted].[BUSETTINGID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Number of records per batch',
			CONVERT(NVARCHAR(MAX),[deleted].[NUMOFRECORD]),
			CONVERT(NVARCHAR(MAX),[inserted].[NUMOFRECORD]),
			'Number of records per batch for batch updates',
			'09A43BA0-3A36-4D2B-95AE-A2C13B97185A',
			2,
			0,
			'Number of records per batch for batch updates'
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[BUSETTINGID] = [inserted].[BUSETTINGID]
	WHERE	[deleted].[NUMOFRECORD] <> [inserted].[NUMOFRECORD]
	UNION ALL

	SELECT
			[inserted].[BUSETTINGID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Active Flag',
			CASE [deleted].[ACTIVE] WHEN 1 THEN 'Yes' ELSE 'No' END,
			CASE [inserted].[ACTIVE] WHEN 1 THEN 'Yes' ELSE 'No' END,
			'Active flag for batch updates',
			'09A43BA0-3A36-4D2B-95AE-A2C13B97185A',
			2,
			0,
			'Active flag for batch updates'
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[BUSETTINGID] = [inserted].[BUSETTINGID]
	WHERE	[deleted].[ACTIVE] <> [inserted].[ACTIVE]
END