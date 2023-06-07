CREATE TABLE [dbo].[GISLLDATASOURCE] (
    [GISLLDATASOURCEID]   CHAR (36)       NOT NULL,
    [GISLLDATASOURCETYPE] CHAR (36)       NOT NULL,
    [ARCGISENDPOINT]      NVARCHAR (1000) NULL,
    [SQLSERVERSOURCE]     NVARCHAR (250)  NULL,
    [SQLSERVERUSERNAME]   NVARCHAR (250)  NULL,
    [SQLSERVERPASSWORD]   NVARCHAR (250)  NULL,
    [SQLSERVERCATALOG]    NVARCHAR (250)  NULL,
    [SQLQUERY]            NVARCHAR (MAX)  NULL,
    [DATASET]             NVARCHAR (3)    NULL,
    [ARCGISLAYER]         VARCHAR (250)   NULL,
    [SQLQUERYISPROCEDURE] BIT             DEFAULT ((0)) NOT NULL,
    [USELIKEFORGIS]       BIT             DEFAULT ((0)) NOT NULL,
    [ISPARCELLAYER]       BIT             DEFAULT ((0)) NULL,
    [ISADDRESSLAYER]      BIT             DEFAULT ((0)) NULL,
    [LASTCHANGEDBY]       CHAR (36)       NULL,
    [LASTCHANGEDON]       DATETIME        CONSTRAINT [DF_GISLLDATASOURCE_LastChangedOn] DEFAULT (getutcdate()) NOT NULL,
    [ROWVERSION]          INT             CONSTRAINT [DF_GISLLDATASOURCE_RowVersion] DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_GISLLDataSource] PRIMARY KEY CLUSTERED ([GISLLDATASOURCEID] ASC) WITH (FILLFACTOR = 80),
    CONSTRAINT [FK_LLDataSource_DataSourceType] FOREIGN KEY ([GISLLDATASOURCETYPE]) REFERENCES [dbo].[GISLLDATASOURCETYPE] ([GISLLDATASOURCETYPEID])
);


GO

CREATE TRIGGER [dbo].[TG_GISLLDATASOURCE_INSERT] ON [dbo].[GISLLDATASOURCE]
	AFTER INSERT
AS
BEGIN
	SET NOCOUNT ON;

	-- Check if LASTCHANGEDBY contains VALID User Id and it Exists in USERS table, this is in replacement to foreign key reference of GISZONEREVIEWITEMMAPPING table with USERS table.
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
			[inserted].[GISLLDATASOURCEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Live Link Added',
			'',
			'',
			'Live Link (' + ISNULL([inserted].[ARCGISLAYER],'[none]') + ')',
			'9B9CF7DC-8C6A-444A-B5B7-F50664942297',
			1,
			1,
			ISNULL([inserted].[ARCGISLAYER],'[none]')
	FROM	[inserted]
END
GO

CREATE TRIGGER [dbo].[TG_GISLLDATASOURCE_UPDATE] ON [dbo].[GISLLDATASOURCE]
	AFTER UPDATE
AS
BEGIN
	SET NOCOUNT ON;

	-- Check if LASTCHANGEDBY contains VALID User Id and it Exists in USERS table, this is in replacement to foreign key reference of GISZONEREVIEWITEMMAPPING table with USERS table.
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
			[inserted].[GISLLDATASOURCEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Data Source Type',
			[GISLLDATASOURCETYPE_DELETED].[NAME],
			[GISLLDATASOURCETYPE_INSERTED].[NAME],
			'Live Link (' + ISNULL([inserted].[ARCGISLAYER],'[none]') + ')',
			'9B9CF7DC-8C6A-444A-B5B7-F50664942297',
			2,
			1,
			ISNULL([inserted].[ARCGISLAYER],'[none]')
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[GISLLDATASOURCEID] = [inserted].[GISLLDATASOURCEID]	
			JOIN [GISLLDATASOURCETYPE] GISLLDATASOURCETYPE_INSERTED WITH (NOLOCK) ON [GISLLDATASOURCETYPE_INSERTED].[GISLLDATASOURCETYPEID] = [inserted].[GISLLDATASOURCETYPE]
			JOIN [GISLLDATASOURCETYPE] GISLLDATASOURCETYPE_DELETED WITH (NOLOCK) ON [GISLLDATASOURCETYPE_DELETED].[GISLLDATASOURCETYPEID] = [deleted].[GISLLDATASOURCETYPE]	
	WHERE	[deleted].[GISLLDATASOURCETYPE] <> [inserted].[GISLLDATASOURCETYPE]
	UNION ALL

	SELECT			
			[inserted].[GISLLDATASOURCEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'ARC GIS End Point',
			ISNULL([deleted].[ARCGISENDPOINT],'[none]'),
			ISNULL([inserted].[ARCGISENDPOINT],'[none]'),
			'Live Link (' + ISNULL([inserted].[ARCGISLAYER],'[none]') + ')',
			'9B9CF7DC-8C6A-444A-B5B7-F50664942297',
			2,
			1,
			ISNULL([inserted].[ARCGISLAYER],'[none]')
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[GISLLDATASOURCEID] = [inserted].[GISLLDATASOURCEID]			
	WHERE	ISNULL([deleted].[ARCGISENDPOINT],'') <> ISNULL([inserted].[ARCGISENDPOINT],'')
	UNION ALL

	SELECT			
			[inserted].[GISLLDATASOURCEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'ARC GIS Layer',
			ISNULL([deleted].[ARCGISLAYER],'[none]'),
			ISNULL([inserted].[ARCGISLAYER],'[none]'),
			'Live Link (' + ISNULL([inserted].[ARCGISLAYER],'[none]') + ')',
			'9B9CF7DC-8C6A-444A-B5B7-F50664942297',
			2,
			1,
			ISNULL([inserted].[ARCGISLAYER],'[none]')
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[GISLLDATASOURCEID] = [inserted].[GISLLDATASOURCEID]			
	WHERE	ISNULL([deleted].[ARCGISLAYER],'') <> ISNULL([inserted].[ARCGISLAYER],'')
	UNION ALL

	SELECT			
			[inserted].[GISLLDATASOURCEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Use LIKE Operator',
			CASE [deleted].[USELIKEFORGIS] WHEN 1 THEN 'Yes' ELSE 'No' END,
			CASE [inserted].[USELIKEFORGIS] WHEN 1 THEN 'Yes' ELSE 'No' END,
			'Live Link (' + ISNULL([inserted].[ARCGISLAYER],'[none]') + ')',
			'9B9CF7DC-8C6A-444A-B5B7-F50664942297',
			2,
			1,
			ISNULL([inserted].[ARCGISLAYER],'[none]')
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[GISLLDATASOURCEID] = [inserted].[GISLLDATASOURCEID]			
	WHERE	[deleted].[USELIKEFORGIS] <> [inserted].[USELIKEFORGIS]
	UNION ALL

	SELECT			
			[inserted].[GISLLDATASOURCEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Is Parcel Layer Flag',
			CASE [deleted].[ISPARCELLAYER] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' ELSE '[none]' END,
			CASE [inserted].[ISPARCELLAYER] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' ELSE '[none]' END,
			'Live Link (' + ISNULL([inserted].[ARCGISLAYER],'[none]') + ')',
			'9B9CF7DC-8C6A-444A-B5B7-F50664942297',
			2,
			1,
			ISNULL([inserted].[ARCGISLAYER],'[none]')
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[GISLLDATASOURCEID] = [inserted].[GISLLDATASOURCEID]			
	WHERE	[deleted].[ISPARCELLAYER] <> [inserted].[ISPARCELLAYER]
			OR ([deleted].[ISPARCELLAYER] IS NULL AND [inserted].[ISPARCELLAYER] IS NOT NULL)
			OR ([deleted].[ISPARCELLAYER] IS NOT NULL AND [inserted].[ISPARCELLAYER] IS NULL)
	UNION ALL

	SELECT			
			[inserted].[GISLLDATASOURCEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Is Address Layer Flag',
			CASE [deleted].[ISADDRESSLAYER] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' ELSE '[none]' END,
			CASE [inserted].[ISADDRESSLAYER] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' ELSE '[none]' END,
			'Live Link (' + ISNULL([inserted].[ARCGISLAYER],'[none]') + ')',
			'9B9CF7DC-8C6A-444A-B5B7-F50664942297',
			2,
			1,
			ISNULL([inserted].[ARCGISLAYER],'[none]')
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[GISLLDATASOURCEID] = [inserted].[GISLLDATASOURCEID]			
	WHERE	[deleted].[ISADDRESSLAYER] <> [inserted].[ISADDRESSLAYER]
			OR ([deleted].[ISADDRESSLAYER] IS NULL AND [inserted].[ISADDRESSLAYER] IS NOT NULL)
			OR ([deleted].[ISADDRESSLAYER] IS NOT NULL AND [inserted].[ISADDRESSLAYER] IS NULL)
	UNION ALL

	SELECT			
			[inserted].[GISLLDATASOURCEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'SQL Server Source',
			ISNULL([deleted].[SQLSERVERSOURCE],'[none]'),
			ISNULL([inserted].[SQLSERVERSOURCE],'[none]'),
			'Live Link (' + ISNULL([inserted].[ARCGISLAYER],'[none]') + ')',
			'9B9CF7DC-8C6A-444A-B5B7-F50664942297',
			2,
			1,
			ISNULL([inserted].[ARCGISLAYER],'[none]')
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[GISLLDATASOURCEID] = [inserted].[GISLLDATASOURCEID]			
	WHERE	ISNULL([deleted].[SQLSERVERSOURCE],'') <> ISNULL([inserted].[SQLSERVERSOURCE],'')
	UNION ALL

	SELECT			
			[inserted].[GISLLDATASOURCEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Catalog',
			ISNULL([deleted].[SQLSERVERCATALOG],'[none]'),
			ISNULL([inserted].[SQLSERVERCATALOG],'[none]'),
			'Live Link (' + ISNULL([inserted].[ARCGISLAYER],'[none]') + ')',
			'9B9CF7DC-8C6A-444A-B5B7-F50664942297',
			2,
			1,
			ISNULL([inserted].[ARCGISLAYER],'[none]')
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[GISLLDATASOURCEID] = [inserted].[GISLLDATASOURCEID]			
	WHERE	ISNULL([deleted].[SQLSERVERCATALOG],'') <> ISNULL([inserted].[SQLSERVERCATALOG],'')
	UNION ALL

	SELECT			
			[inserted].[GISLLDATASOURCEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'User Name',
			ISNULL([deleted].[SQLSERVERUSERNAME],'[none]'),
			ISNULL([inserted].[SQLSERVERUSERNAME],'[none]'),
			'Live Link (' + ISNULL([inserted].[ARCGISLAYER],'[none]') + ')',
			'9B9CF7DC-8C6A-444A-B5B7-F50664942297',
			2,
			1,
			ISNULL([inserted].[ARCGISLAYER],'[none]')
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[GISLLDATASOURCEID] = [inserted].[GISLLDATASOURCEID]			
	WHERE	ISNULL([deleted].[SQLSERVERUSERNAME],'') <> ISNULL([inserted].[SQLSERVERUSERNAME],'')
	UNION ALL

	SELECT			
			[inserted].[GISLLDATASOURCEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Password',			
			CASE WHEN [deleted].[SQLSERVERPASSWORD] IS NULL THEN '[none]' ELSE '******' END,
			CASE WHEN [inserted].[SQLSERVERPASSWORD] IS NULL THEN '[none]' ELSE '******' END,
			'Live Link (' + ISNULL([inserted].[ARCGISLAYER],'[none]') + ')',
			'9B9CF7DC-8C6A-444A-B5B7-F50664942297',
			2,
			1,
			ISNULL([inserted].[ARCGISLAYER],'[none]')
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[GISLLDATASOURCEID] = [inserted].[GISLLDATASOURCEID]			
	WHERE	ISNULL([deleted].[SQLSERVERPASSWORD],'') <> ISNULL([inserted].[SQLSERVERPASSWORD],'')
	UNION ALL

	SELECT			
			[inserted].[GISLLDATASOURCEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Set',
			ISNULL([deleted].[DATASET],'[none]'),
			ISNULL([inserted].[DATASET],'[none]'),
			'Live Link (' + ISNULL([inserted].[ARCGISLAYER],'[none]') + ')',
			'9B9CF7DC-8C6A-444A-B5B7-F50664942297',
			2,
			1,
			ISNULL([inserted].[ARCGISLAYER],'[none]')
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[GISLLDATASOURCEID] = [inserted].[GISLLDATASOURCEID]			
	WHERE	ISNULL([deleted].[DATASET],'') <> ISNULL([inserted].[DATASET],'')
	UNION ALL

	SELECT			
			[inserted].[GISLLDATASOURCEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'SQL Query',
			ISNULL([deleted].[SQLQUERY],'[none]'),
			ISNULL([inserted].[SQLQUERY],'[none]'),
			'Live Link (' + ISNULL([inserted].[ARCGISLAYER],'[none]') + ')',
			'9B9CF7DC-8C6A-444A-B5B7-F50664942297',
			2,
			1,
			ISNULL([inserted].[ARCGISLAYER],'[none]')
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[GISLLDATASOURCEID] = [inserted].[GISLLDATASOURCEID]			
	WHERE	ISNULL([deleted].[SQLQUERY],'') <> ISNULL([inserted].[SQLQUERY],'')
	UNION ALL

	SELECT			
			[inserted].[GISLLDATASOURCEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'SQL Query Is Procedure Flag',
			CASE [deleted].[SQLQUERYISPROCEDURE] WHEN 1 THEN 'Yes' ELSE 'No' END,
			CASE [inserted].[SQLQUERYISPROCEDURE] WHEN 1 THEN 'Yes' ELSE 'No' END,
			'Live Link (' + ISNULL([inserted].[ARCGISLAYER],'[none]') + ')',
			'9B9CF7DC-8C6A-444A-B5B7-F50664942297',
			2,
			1,
			ISNULL([inserted].[ARCGISLAYER],'[none]')
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[GISLLDATASOURCEID] = [inserted].[GISLLDATASOURCEID]			
	WHERE	[deleted].[SQLQUERYISPROCEDURE] <> [inserted].[SQLQUERYISPROCEDURE]
END
GO

CREATE TRIGGER [dbo].[TG_GISLLDATASOURCE_DELTE] ON [dbo].[GISLLDATASOURCE]
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
			[deleted].[GISLLDATASOURCEID],
			[deleted].[ROWVERSION],
			GETUTCDATE(),
			(SELECT dbo.UFN_GET_USERID_FROM_CONTEXT_INFO()),
			'Live Link Deleted',
			'',
			'',
			'Live Link (' + ISNULL([deleted].[ARCGISLAYER],'[none]') + ')',
			'9B9CF7DC-8C6A-444A-B5B7-F50664942297',
			3,
			1,
			ISNULL([deleted].[ARCGISLAYER],'[none]')
			FROM	[deleted]
END