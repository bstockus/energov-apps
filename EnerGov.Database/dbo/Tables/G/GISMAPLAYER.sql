CREATE TABLE [dbo].[GISMAPLAYER] (
    [GISMAPLAYERID]    CHAR (36)      NOT NULL,
    [LAYERURL]         VARCHAR (500)  NOT NULL,
    [DESCRIPTION]      VARCHAR (MAX)  NULL,
    [NAME]             NVARCHAR (100) NULL,
    [LEGENDURL]        VARCHAR (500)  NULL,
    [IS_KOOP_ENDPOINT] BIT            CONSTRAINT [DF_GISMAPLAYER_IS_KOOP_ENDPOINT] DEFAULT ((0)) NOT NULL,
    [LASTCHANGEDBY]    CHAR (36)      NULL,
    [LASTCHANGEDON]    DATETIME       CONSTRAINT [DF_GISMAPLAYER_LastChangedOn] DEFAULT (getutcdate()) NOT NULL,
    [ROWVERSION]       INT            CONSTRAINT [DF_GISMAPLAYER_RowVersion] DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_GISMapLayers] PRIMARY KEY CLUSTERED ([GISMAPLAYERID] ASC) WITH (FILLFACTOR = 90)
);


GO
CREATE NONCLUSTERED INDEX [GISMAPLAYER_IX_QUERY]
    ON [dbo].[GISMAPLAYER]([GISMAPLAYERID] ASC, [NAME] ASC);


GO

CREATE TRIGGER [dbo].[TG_GISMAPLAYER_INSERT] ON [dbo].[GISMAPLAYER]
	AFTER INSERT
AS
BEGIN
	SET NOCOUNT ON;

	-- Check if LASTCHANGEDBY contains VALID User Id and it Exists in USERS table, this is in replacement to foreign key reference of GISMAPLAYER table with USERS table.
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
			[inserted].[GISMAPLAYERID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'GIS Map Layer Added',
			'',
			'',
			'GIS Map Layer (' + ISNULL([inserted].[NAME], '[none]') + ')',
			'719EF3B6-99B4-4BF5-94CF-CC5AD082B96C',
			1,
			1,
			ISNULL([inserted].[NAME], '[none]')
	FROM	[inserted]
END
GO

CREATE TRIGGER [dbo].[TG_GISMAPLAYER_UPDATE] ON [dbo].[GISMAPLAYER]
	AFTER UPDATE
AS
BEGIN
	SET NOCOUNT ON;

	-- Check if LASTCHANGEDBY contains VALID User Id and it Exists in USERS table, this is in replacement to foreign key reference of GISMAPLAYER table with USERS table.
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
			[inserted].[GISMAPLAYERID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Layer URL',
			[deleted].[LAYERURL],
			[inserted].[LAYERURL],
			'GIS Map Layer (' + ISNULL([inserted].[NAME], '[none]') + ')',
			'719EF3B6-99B4-4BF5-94CF-CC5AD082B96C',
			2,
			1,
			ISNULL([inserted].[NAME], '[none]')
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[GISMAPLAYERID] = [inserted].[GISMAPLAYERID]			
	WHERE	[deleted].[LAYERURL] <> [inserted].[LAYERURL]
	UNION ALL

	SELECT
			[inserted].[GISMAPLAYERID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Name',
			ISNULL([deleted].[NAME], '[none]'),
			ISNULL([inserted].[NAME], '[none]'),
			'GIS Map Layer (' + ISNULL([inserted].[NAME], '[none]') + ')',
			'719EF3B6-99B4-4BF5-94CF-CC5AD082B96C',
			2,
			1,
			ISNULL([inserted].[NAME], '[none]')
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[GISMAPLAYERID] = [inserted].[GISMAPLAYERID]			
	WHERE	ISNULL([deleted].[NAME], '') <> ISNULL([inserted].[NAME], '')
	UNION ALL

	SELECT
			[inserted].[GISMAPLAYERID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Description',
			ISNULL([deleted].[DESCRIPTION], '[none]'),
			ISNULL([inserted].[DESCRIPTION], '[none]'),
			'GIS Map Layer (' + ISNULL([inserted].[NAME], '[none]') + ')',
			'719EF3B6-99B4-4BF5-94CF-CC5AD082B96C',
			2,
			1,
			ISNULL([inserted].[NAME], '[none]')
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[GISMAPLAYERID] = [inserted].[GISMAPLAYERID]			
	WHERE	ISNULL([deleted].[DESCRIPTION], '') <> ISNULL([inserted].[DESCRIPTION], '')
	UNION ALL

	SELECT
			[inserted].[GISMAPLAYERID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Legend URL',
			ISNULL([deleted].[LEGENDURL], '[none]'),
			ISNULL([inserted].[LEGENDURL], '[none]'),
			'GIS Map Layer (' + ISNULL([inserted].[NAME], '[none]') + ')',
			'719EF3B6-99B4-4BF5-94CF-CC5AD082B96C',
			2,
			1,
			ISNULL([inserted].[NAME], '[none]')
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[GISMAPLAYERID] = [inserted].[GISMAPLAYERID]			
	WHERE	ISNULL([deleted].[LEGENDURL], '') <> ISNULL([inserted].[LEGENDURL], '')
	UNION ALL

	SELECT
			[inserted].[GISMAPLAYERID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Is Koop Endpoint Flag',
			CASE [deleted].[IS_KOOP_ENDPOINT] WHEN 1 THEN 'Yes' ELSE 'No' END,
			CASE [inserted].[IS_KOOP_ENDPOINT] WHEN 1 THEN 'Yes' ELSE 'No' END,
			'GIS Map Layer (' + ISNULL([inserted].[NAME], '[none]') + ')',
			'719EF3B6-99B4-4BF5-94CF-CC5AD082B96C',
			2,
			1,
			ISNULL([inserted].[NAME], '[none]')
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[GISMAPLAYERID] = [inserted].[GISMAPLAYERID]			
	WHERE	[deleted].[IS_KOOP_ENDPOINT] <> [inserted].[IS_KOOP_ENDPOINT]

END
GO

CREATE TRIGGER [dbo].[TG_GISMAPLAYER_DELTE] ON [dbo].[GISMAPLAYER]
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
			[deleted].[GISMAPLAYERID],
			[deleted].[ROWVERSION],
			GETUTCDATE(),
			(SELECT dbo.UFN_GET_USERID_FROM_CONTEXT_INFO()),
			'GIS Map Layer Deleted',
			'',
			'',
			'GIS Map Layer (' + ISNULL([deleted].[NAME], '[none]') + ')',
			'719EF3B6-99B4-4BF5-94CF-CC5AD082B96C',
			3,
			1,
			ISNULL([deleted].[NAME], '[none]')
	FROM	[deleted]
END