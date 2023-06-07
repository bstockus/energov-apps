CREATE TABLE [dbo].[PLITEMREVIEWZONE] (
    [PLITEMREVIEWZONEID] CHAR (36)       NOT NULL,
    [NAME]               NVARCHAR (50)   NOT NULL,
    [DESCRIPTION]        NVARCHAR (MAX)  NULL,
    [DEFAULTTRAVELTIME]  DECIMAL (18, 4) NULL,
    [LASTCHANGEDBY]      CHAR (36)       NULL,
    [LASTCHANGEDON]      DATETIME        CONSTRAINT [DF_PLITEMREVIEWZONE_LastChangedOn] DEFAULT (getutcdate()) NOT NULL,
    [ROWVERSION]         INT             CONSTRAINT [DF_PLITEMREVIEWZONE_RowVersion] DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_PLITEMREVIEWZONE] PRIMARY KEY CLUSTERED ([PLITEMREVIEWZONEID] ASC) WITH (FILLFACTOR = 90)
);


GO
CREATE NONCLUSTERED INDEX [PLITEMREVIEWZON_IX_QUERY]
    ON [dbo].[PLITEMREVIEWZONE]([PLITEMREVIEWZONEID] ASC, [NAME] ASC);


GO

CREATE TRIGGER [dbo].[TG_PLITEMREVIEWZONE_DELTE] ON [dbo].[PLITEMREVIEWZONE]
	AFTER DELETE
AS
BEGIN
	INSERT INTO [HISTORYSYSTEMSETUP]
			([ID],
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
			[RECORDNAME])
	SELECT
			[deleted].[PLITEMREVIEWZONEID],
			[deleted].[ROWVERSION],
			GETUTCDATE(),
			(SELECT dbo.UFN_GET_USERID_FROM_CONTEXT_INFO()),
			'Review Item Zone Deleted',
			'',
			'',
			'Review Item Zone (' + [deleted].[NAME] + ')',
			'D7057299-2BE0-4284-AC0A-2282E488254A',
			3,
			1,
			[deleted].[NAME]
	FROM	[deleted]
END
GO

CREATE TRIGGER [dbo].[TG_PLITEMREVIEWZONE_UPDATE] ON [dbo].[PLITEMREVIEWZONE]
	AFTER UPDATE
AS
BEGIN
	SET NOCOUNT ON;

	-- Check if LASTCHANGEDBY contains VALID User Id and it Exists in USERS table, this is in replacement to foreign key reference of PLITEMREVIEWZONE table with USERS table.
	IF EXISTS (SELECT * FROM inserted 
		LEFT OUTER JOIN USERS WITH (NOLOCK) ON USERS.SUSERGUID = inserted.LASTCHANGEDBY
		WHERE inserted.LASTCHANGEDBY IS NOT NULL AND USERS.SUSERGUID IS NULL)
	BEGIN		
		RAISERROR ('The INSERT or UPDATE statement conflicted with the FOREIGN KEY to table USERS', 16, 0);
		ROLLBACK;
		RETURN;
	END

	INSERT INTO [HISTORYSYSTEMSETUP]
			([ID],
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
			[RECORDNAME])
	SELECT
			[inserted].[PLITEMREVIEWZONEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Name',
			[deleted].[NAME],
			[inserted].[NAME],
			'Review Item Zone (' + [inserted].[NAME] + ')',
			'D7057299-2BE0-4284-AC0A-2282E488254A',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[PLITEMREVIEWZONEID] = [inserted].[PLITEMREVIEWZONEID]			
	WHERE	[deleted].[NAME] <> [inserted].[NAME]
	UNION ALL

	SELECT
			[inserted].[PLITEMREVIEWZONEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Description',
			ISNULL([deleted].[DESCRIPTION], '[none]'),
			ISNULL([inserted].[DESCRIPTION], '[none]'),
			'Review Item Zone (' + [inserted].[NAME] + ')',
			'D7057299-2BE0-4284-AC0A-2282E488254A',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[PLITEMREVIEWZONEID] = [inserted].[PLITEMREVIEWZONEID]			
	WHERE	ISNULL([deleted].[DESCRIPTION], '') <> ISNULL([inserted].[DESCRIPTION], '')
	UNION ALL

	SELECT
			[inserted].[PLITEMREVIEWZONEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Default Travel Time',
			ISNULL(CAST([deleted].[DEFAULTTRAVELTIME] AS NVARCHAR(MAX)),'[none]'),
			ISNULL(CAST([inserted].[DEFAULTTRAVELTIME] AS NVARCHAR(MAX)),'[none]'),
			'Review Item Zone (' + [inserted].[NAME] + ')',
			'D7057299-2BE0-4284-AC0A-2282E488254A',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[PLITEMREVIEWZONEID] = [inserted].[PLITEMREVIEWZONEID]			
	WHERE	[deleted].[DEFAULTTRAVELTIME] IS NULL AND [inserted].[DEFAULTTRAVELTIME] IS NOT NULL
			OR [deleted].[DEFAULTTRAVELTIME] IS NOT NULL AND [inserted].[DEFAULTTRAVELTIME] IS NULL
			OR [deleted].[DEFAULTTRAVELTIME] <> [inserted].[DEFAULTTRAVELTIME]

END
GO

CREATE TRIGGER [dbo].[TG_PLITEMREVIEWZONE_INSERT] ON [dbo].[PLITEMREVIEWZONE]
	AFTER INSERT
AS
BEGIN
	SET NOCOUNT ON;

	-- Check if LASTCHANGEDBY contains VALID User Id and it Exists in USERS table, this is in replacement to foreign key reference of PLITEMREVIEWZONE table with USERS table.
	IF EXISTS (SELECT * FROM inserted 
		LEFT OUTER JOIN USERS WITH (NOLOCK) ON USERS.SUSERGUID = inserted.LASTCHANGEDBY
		WHERE inserted.LASTCHANGEDBY IS NOT NULL AND USERS.SUSERGUID IS NULL)
	BEGIN		
		RAISERROR ('The INSERT or UPDATE statement conflicted with the FOREIGN KEY to table USERS', 16, 0);
		ROLLBACK;
		RETURN;
	END

	INSERT INTO [HISTORYSYSTEMSETUP]
			([ID],
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
			[RECORDNAME])
	SELECT
			[inserted].[PLITEMREVIEWZONEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Review Item Zone Added',
			'',
			'',
			'Review Item Zone (' + [inserted].[NAME] + ')',
			'D7057299-2BE0-4284-AC0A-2282E488254A',
			1,
			1,
			[inserted].[NAME]
	FROM	[inserted]
END