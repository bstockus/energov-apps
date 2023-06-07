CREATE TABLE [dbo].[GEOQUERY] (
    [GEOQUERYID]             CHAR (36)      NOT NULL,
    [QUERYNAME]              NVARCHAR (150) NOT NULL,
    [FEATURECLASSNAME]       NVARCHAR (150) NOT NULL,
    [FEATURECLASSID]         INT            CONSTRAINT [DF_GeoQuery_FeatureClassID] DEFAULT ((0)) NOT NULL,
    [FIELDNAME]              NVARCHAR (150) NOT NULL,
    [RETURNTYPE]             NVARCHAR (50)  NOT NULL,
    [RETURNEDFEATURECLASS]   NVARCHAR (150) NOT NULL,
    [RETURNEDFEATURECLASSID] INT            CONSTRAINT [DF_GeoQuery_ReturnedFeatureID] DEFAULT ((0)) NOT NULL,
    [GEOQUERYTYPEID]         CHAR (36)      NOT NULL,
    [RETURNFIELDNAME]        NVARCHAR (150) CONSTRAINT [DF_GeoQuery_ReturnFieldName] DEFAULT ('') NULL,
    [RETURNFIELDTYPE]        NVARCHAR (50)  CONSTRAINT [DF_GeoQuery_ReturnFieldType] DEFAULT ('') NULL,
    [DISTANCE]               FLOAT (53)     CONSTRAINT [DF_GeoQuery_Distance] DEFAULT ((0)) NOT NULL,
    [GEOQUERYUNITTYPEID]     CHAR (36)      NULL,
    [USEBUFFERRING]          BIT            CONSTRAINT [DF_GeoQuery_UseBufferringQuery] DEFAULT ((0)) NOT NULL,
    [BUFFERFEATURECLASS]     NVARCHAR (150) CONSTRAINT [DF_GeoQuery_BufferFeatureClass] DEFAULT ('') NOT NULL,
    [BUFFERFEATURECLASSID]   INT            CONSTRAINT [DF_GeoQuery_ReturnedFeatureClassID1] DEFAULT ((0)) NOT NULL,
    [BUFFERGEOQUERYTYPEID]   CHAR (36)      NULL,
    [APPLYSHAPEBUFFERING]    BIT            DEFAULT ((0)) NOT NULL,
    [LASTCHANGEDBY]          CHAR (36)      NULL,
    [LASTCHANGEDON]          DATETIME       CONSTRAINT [DF_GEOQUERY_LastChangedOn] DEFAULT (getutcdate()) NOT NULL,
    [ROWVERSION]             INT            CONSTRAINT [DF_GEOQUERY_RowVersion] DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_GeoRuleQuery] PRIMARY KEY CLUSTERED ([GEOQUERYID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_GeoQuery_GeoQueryType] FOREIGN KEY ([BUFFERGEOQUERYTYPEID]) REFERENCES [dbo].[GEOQUERYTYPE] ([GEOQUERYTYPEID]),
    CONSTRAINT [FK_GeoQuery_GeoQueryUnitType] FOREIGN KEY ([GEOQUERYUNITTYPEID]) REFERENCES [dbo].[GEOQUERYUNITTYPE] ([GEOQUERYUNITTYPEID]),
    CONSTRAINT [FK_GeoQuery_QueryType] FOREIGN KEY ([GEOQUERYTYPEID]) REFERENCES [dbo].[GEOQUERYTYPE] ([GEOQUERYTYPEID])
);


GO
CREATE NONCLUSTERED INDEX [GEOQUERY_IX_QUERY]
    ON [dbo].[GEOQUERY]([GEOQUERYID] ASC, [QUERYNAME] ASC);


GO

CREATE TRIGGER [dbo].[TG_GEOQUERY_INSERT] ON [dbo].[GEOQUERY]
	AFTER INSERT
AS
BEGIN
	SET NOCOUNT ON;

	-- Check if LASTCHANGEDBY contains VALID User Id and it Exists in USERS table, this is in replacement to foreign key reference of GEOQUERY table with USERS table.
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
			[inserted].[GEOQUERYID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Geo Query Added',
			'',
			'',
			'Geo Query (' + [inserted].[QUERYNAME] + ')',
			'1844C8FA-8D5A-4E01-A24B-604AD067AC1D',
			1,
			1,
			[inserted].[QUERYNAME]
	FROM	[inserted]
END
GO

CREATE TRIGGER [dbo].[TG_GEOQUERY_UPDATE] ON [dbo].[GEOQUERY]
	AFTER UPDATE
AS
BEGIN
	SET NOCOUNT ON;

	-- Check if LASTCHANGEDBY contains VALID User Id and it Exists in USERS table, this is in replacement to foreign key reference of GEOQUERY table with USERS table.
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
			[inserted].[GEOQUERYID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Query Name',
			[deleted].[QUERYNAME],
			[inserted].[QUERYNAME],
			'Geo Query (' + [inserted].[QUERYNAME] + ')',
			'1844C8FA-8D5A-4E01-A24B-604AD067AC1D',
			2,
			1,
			[inserted].[QUERYNAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[GEOQUERYID] = [inserted].[GEOQUERYID]			
	WHERE	[deleted].[QUERYNAME] <> [inserted].[QUERYNAME]

	UNION ALL
	SELECT
			[inserted].[GEOQUERYID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Feature Class Name',
			[deleted].[FEATURECLASSNAME],
			[inserted].[FEATURECLASSNAME],
			'Geo Query (' + [inserted].[QUERYNAME] + ')',
			'1844C8FA-8D5A-4E01-A24B-604AD067AC1D',
			2,
			1,
			[inserted].[QUERYNAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[GEOQUERYID] = [inserted].[GEOQUERYID]			
	WHERE	[deleted].[FEATURECLASSNAME] <> [inserted].[FEATURECLASSNAME]

	UNION ALL
	SELECT
			[inserted].[GEOQUERYID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Field Name',
			[deleted].[FIELDNAME],
			[inserted].[FIELDNAME],
			'Geo Query (' + [inserted].[QUERYNAME] + ')',
			'1844C8FA-8D5A-4E01-A24B-604AD067AC1D',
			2,
			1,
			[inserted].[QUERYNAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[GEOQUERYID] = [inserted].[GEOQUERYID]			
	WHERE	[deleted].[FIELDNAME] <> [inserted].[FIELDNAME]

	UNION ALL
	SELECT
			[inserted].[GEOQUERYID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'ESRI Type',
			[deleted].[RETURNTYPE],
			[inserted].[RETURNTYPE],
			'Geo Query (' + [inserted].[QUERYNAME] + ')',
			'1844C8FA-8D5A-4E01-A24B-604AD067AC1D',
			2,
			1,
			[inserted].[QUERYNAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[GEOQUERYID] = [inserted].[GEOQUERYID]			
	WHERE	[deleted].[RETURNTYPE] <> [inserted].[RETURNTYPE]

	UNION ALL
	SELECT
			[inserted].[GEOQUERYID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Returned Feature Class Name',
			[deleted].[RETURNEDFEATURECLASS],
			[inserted].[RETURNEDFEATURECLASS],
			'Geo Query (' + [inserted].[QUERYNAME] + ')',
			'1844C8FA-8D5A-4E01-A24B-604AD067AC1D',
			2,
			1,
			[inserted].[QUERYNAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[GEOQUERYID] = [inserted].[GEOQUERYID]			
	WHERE	[deleted].[RETURNEDFEATURECLASS] <> [inserted].[RETURNEDFEATURECLASS]

	UNION ALL
	SELECT
			[inserted].[GEOQUERYID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Query Type',
			[GEOQUERYTYPE_DELETED].[QUERYTYPENAME],
			[GEOQUERYTYPE_INSERTED].[QUERYTYPENAME],
			'Geo Query (' + [inserted].[QUERYNAME] + ')',
			'1844C8FA-8D5A-4E01-A24B-604AD067AC1D',
			2,
			1,
			[inserted].[QUERYNAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[GEOQUERYID] = [inserted].[GEOQUERYID]
			JOIN [GEOQUERYTYPE] [GEOQUERYTYPE_DELETED] WITH (NOLOCK) ON [deleted].[GEOQUERYTYPEID] = [GEOQUERYTYPE_DELETED].[GEOQUERYTYPEID]
			JOIN [GEOQUERYTYPE] [GEOQUERYTYPE_INSERTED] WITH (NOLOCK) ON [inserted].[GEOQUERYTYPEID] = [GEOQUERYTYPE_INSERTED].[GEOQUERYTYPEID]		
	WHERE	[deleted].[GEOQUERYTYPEID] <> [inserted].[GEOQUERYTYPEID]

	UNION ALL
	SELECT
			[inserted].[GEOQUERYID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Return Field Name',
			ISNULL([deleted].[RETURNFIELDNAME], '[none]'),
			ISNULL([inserted].[RETURNFIELDNAME], '[none]'),
			'Geo Query (' + [inserted].[QUERYNAME] + ')',
			'1844C8FA-8D5A-4E01-A24B-604AD067AC1D',
			2,
			1,
			[inserted].[QUERYNAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[GEOQUERYID] = [inserted].[GEOQUERYID]			
	WHERE	ISNULL([deleted].[RETURNFIELDNAME], '') <> ISNULL([inserted].[RETURNFIELDNAME], '')

	UNION ALL
	SELECT
			[inserted].[GEOQUERYID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Return Field Type',
			ISNULL([deleted].[RETURNFIELDTYPE], '[none]'),
			ISNULL([inserted].[RETURNFIELDTYPE], '[none]'),
			'Geo Query (' + [inserted].[QUERYNAME] + ')',
			'1844C8FA-8D5A-4E01-A24B-604AD067AC1D',
			2,
			1,
			[inserted].[QUERYNAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[GEOQUERYID] = [inserted].[GEOQUERYID]			
	WHERE	ISNULL([deleted].[RETURNFIELDTYPE], '') <> ISNULL([inserted].[RETURNFIELDTYPE], '')

	UNION ALL
	SELECT
			[inserted].[GEOQUERYID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Buffer Distance',
			CAST([deleted].[DISTANCE] AS NVARCHAR(MAX)),
			CAST([inserted].[DISTANCE] AS NVARCHAR(MAX)),
			'Geo Query (' + [inserted].[QUERYNAME] + ')',
			'1844C8FA-8D5A-4E01-A24B-604AD067AC1D',
			2,
			1,
			[inserted].[QUERYNAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[GEOQUERYID] = [inserted].[GEOQUERYID]			
	WHERE	[deleted].[DISTANCE] <> [inserted].[DISTANCE]

	UNION ALL
	SELECT
			[inserted].[GEOQUERYID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Buffer Unit',
			ISNULL([GEOQUERYUNITTYPE_DELETED].[QUERYUNITTYPENAME], '[none]'),
			ISNULL([GEOQUERYUNITTYPE_INSERTED].[QUERYUNITTYPENAME], '[none]'),
			'Geo Query (' + [inserted].[QUERYNAME] + ')',
			'1844C8FA-8D5A-4E01-A24B-604AD067AC1D',
			2,
			1,
			[inserted].[QUERYNAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[GEOQUERYID] = [inserted].[GEOQUERYID]
			LEFT JOIN [GEOQUERYUNITTYPE] [GEOQUERYUNITTYPE_DELETED] WITH (NOLOCK) ON [deleted].[GEOQUERYUNITTYPEID] = [GEOQUERYUNITTYPE_DELETED].[GEOQUERYUNITTYPEID]
			LEFT JOIN [GEOQUERYUNITTYPE] [GEOQUERYUNITTYPE_INSERTED] WITH (NOLOCK) ON [inserted].[GEOQUERYUNITTYPEID] = [GEOQUERYUNITTYPE_INSERTED].[GEOQUERYUNITTYPEID]					
	WHERE	ISNULL([deleted].[GEOQUERYUNITTYPEID], '') <> ISNULL([inserted].[GEOQUERYUNITTYPEID], '')
	
	UNION ALL
	SELECT
			[inserted].[GEOQUERYID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Use Buffering Flag',
			CASE [deleted].[USEBUFFERRING] WHEN 1 THEN 'Yes' ELSE 'No' END,
			CASE [inserted].[USEBUFFERRING] WHEN 1 THEN 'Yes' ELSE 'No' END,
			'Geo Query (' + [inserted].[QUERYNAME] + ')',
			'1844C8FA-8D5A-4E01-A24B-604AD067AC1D',
			2,
			1,
			[inserted].[QUERYNAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[GEOQUERYID] = [inserted].[GEOQUERYID]			
	WHERE	[deleted].[USEBUFFERRING] <> [inserted].[USEBUFFERRING]

	UNION ALL
	SELECT
			[inserted].[GEOQUERYID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Buffer Feature Class',
			CASE WHEN [deleted].[BUFFERFEATURECLASS] = '' THEN '[none]' ELSE [deleted].[BUFFERFEATURECLASS] END,
			CASE WHEN [inserted].[BUFFERFEATURECLASS] = '' THEN '[none]' ELSE [inserted].[BUFFERFEATURECLASS] END,
			'Geo Query (' + [inserted].[QUERYNAME] + ')',
			'1844C8FA-8D5A-4E01-A24B-604AD067AC1D',
			2,
			1,
			[inserted].[QUERYNAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[GEOQUERYID] = [inserted].[GEOQUERYID]			
	WHERE	[deleted].[BUFFERFEATURECLASS] <> [inserted].[BUFFERFEATURECLASS]

	UNION ALL
	SELECT
			[inserted].[GEOQUERYID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Buffer Query Type',
			ISNULL([GEOQUERYTYPE_DELETED].[QUERYTYPENAME], '[none]'),
			ISNULL([GEOQUERYTYPE_INSERTED].[QUERYTYPENAME], '[none]'),
			'Geo Query (' + [inserted].[QUERYNAME] + ')',
			'1844C8FA-8D5A-4E01-A24B-604AD067AC1D',
			2,
			1,
			[inserted].[QUERYNAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[GEOQUERYID] = [inserted].[GEOQUERYID]
			LEFT JOIN [GEOQUERYTYPE] [GEOQUERYTYPE_DELETED] WITH (NOLOCK) ON [deleted].[BUFFERGEOQUERYTYPEID] = [GEOQUERYTYPE_DELETED].[GEOQUERYTYPEID]
			LEFT JOIN [GEOQUERYTYPE] [GEOQUERYTYPE_INSERTED] WITH (NOLOCK) ON [inserted].[BUFFERGEOQUERYTYPEID] = [GEOQUERYTYPE_INSERTED].[GEOQUERYTYPEID]
	WHERE	ISNULL([deleted].[BUFFERGEOQUERYTYPEID], '') <> ISNULL([inserted].[BUFFERGEOQUERYTYPEID], '')

	UNION ALL
	SELECT
			[inserted].[GEOQUERYID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Apply Shape Buffering Flag',
			CASE [deleted].[APPLYSHAPEBUFFERING] WHEN 1 THEN 'Yes' ELSE 'No' END,
			CASE [inserted].[APPLYSHAPEBUFFERING] WHEN 1 THEN 'Yes' ELSE 'No' END,
			'Geo Query (' + [inserted].[QUERYNAME] + ')',
			'1844C8FA-8D5A-4E01-A24B-604AD067AC1D',
			2,
			1,
			[inserted].[QUERYNAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[GEOQUERYID] = [inserted].[GEOQUERYID]			
	WHERE	[deleted].[APPLYSHAPEBUFFERING] <> [inserted].[APPLYSHAPEBUFFERING]
END
GO

CREATE TRIGGER [dbo].[TG_GEOQUERY_DELTE] ON [dbo].[GEOQUERY]
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
			[deleted].[GEOQUERYID],
			[deleted].[ROWVERSION],
			GETUTCDATE(),
			(SELECT dbo.UFN_GET_USERID_FROM_CONTEXT_INFO()),
			'Geo Query Deleted',
			'',
			'',
			'Geo Query (' + [deleted].[QUERYNAME] + ')',
			'1844C8FA-8D5A-4E01-A24B-604AD067AC1D',
			3,
			1,
			[deleted].[QUERYNAME]
	FROM	[deleted]
END