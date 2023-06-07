CREATE TABLE [dbo].[GEORULE] (
    [GEORULEID]                     CHAR (36)      NOT NULL,
    [RULENAME]                      NVARCHAR (150) NOT NULL,
    [GEORULEENTITYID]               CHAR (36)      NOT NULL,
    [DESCRIPTION]                   NVARCHAR (MAX) NOT NULL,
    [GEOQUERYID]                    CHAR (36)      NOT NULL,
    [ENTITYPROPERTY]                NVARCHAR (MAX) CONSTRAINT [DF_GeoRule_EntityProperty] DEFAULT ('') NOT NULL,
    [ISCUSTOMFIELD]                 BIT            CONSTRAINT [DF_GeoRule_IsCustomField] DEFAULT ((0)) NOT NULL,
    [PROPERTYFRIENDLYNAME]          NVARCHAR (MAX) CONSTRAINT [DF_GeoRule_PropertyFriendlyName] DEFAULT ('') NOT NULL,
    [ISASSETCOLLECTIONBASED]        BIT            CONSTRAINT [DF_GeoRule_IsCustomField1] DEFAULT ((0)) NOT NULL,
    [ASSETCOLLECTIONIDPROPERTYNAME] NVARCHAR (MAX) CONSTRAINT [DF_GeoRule_AssetCollectionIDPropertyName] DEFAULT ('') NOT NULL,
    [ISGISFEATURESBASED]            BIT            CONSTRAINT [DF_IsGISFeaturesBased] DEFAULT ((0)) NOT NULL,
    [GISFEATURESPROPERTYNAME]       NVARCHAR (MAX) CONSTRAINT [DF_GISFeaturesPropertyName] DEFAULT ('') NOT NULL,
    [LASTCHANGEDBY]                 CHAR (36)      NULL,
    [LASTCHANGEDON]                 DATETIME       CONSTRAINT [DF_GEORULE_LastChangedOn] DEFAULT (getutcdate()) NOT NULL,
    [ROWVERSION]                    INT            CONSTRAINT [DF_GEORULE_RowVersion] DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_PLGeoRule] PRIMARY KEY CLUSTERED ([GEORULEID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Rule_GeoQuery] FOREIGN KEY ([GEOQUERYID]) REFERENCES [dbo].[GEOQUERY] ([GEOQUERYID]),
    CONSTRAINT [FK_Rule_GeoRuleEntity] FOREIGN KEY ([GEORULEENTITYID]) REFERENCES [dbo].[GEORULEENTITY] ([GEORULEENTITYID])
);


GO
CREATE NONCLUSTERED INDEX [GEORULE_IX_QUERY]
    ON [dbo].[GEORULE]([GEORULEID] ASC, [RULENAME] ASC);


GO

CREATE TRIGGER [dbo].[TG_GEORULE_UPDATE] ON [dbo].[GEORULE]
	AFTER UPDATE
AS
BEGIN
	SET NOCOUNT ON;

	-- Check if LASTCHANGEDBY contains VALID User Id and it Exists in USERS table, this is in replacement to foreign key reference of GEORULE table with USERS table.
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
			[inserted].[GEORULEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Geo Rule Name',
			[deleted].[RULENAME],
			[inserted].[RULENAME],
			'Geo Rule (' + [inserted].[RULENAME] + ')',
			'92E08D84-E807-4CC4-936A-04DCD65AF43A',
			2,
			1,
			[inserted].[RULENAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[GEORULEID] = [inserted].[GEORULEID]			
	WHERE	[deleted].[RULENAME] <> [inserted].[RULENAME]

	UNION ALL
	SELECT
			[inserted].[GEORULEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Geo Rule Entity',
			[GEORULEENTITY_DELETED].[GEORYLEENTITYFRIENDLYNAME],
			[GEORULEENTITY_INSERTED].[GEORYLEENTITYFRIENDLYNAME],
			'Geo Rule (' + [inserted].[RULENAME] + ')',
			'92E08D84-E807-4CC4-936A-04DCD65AF43A',
			2,
			1,
			[inserted].[RULENAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[GEORULEID] = [inserted].[GEORULEID]
			JOIN [GEORULEENTITY] [GEORULEENTITY_DELETED] WITH (NOLOCK) ON [deleted].[GEORULEENTITYID] = [GEORULEENTITY_DELETED].[GEORULEENTITYID]
			JOIN [GEORULEENTITY] [GEORULEENTITY_INSERTED] WITH (NOLOCK) ON [inserted].[GEORULEENTITYID] = [GEORULEENTITY_INSERTED].[GEORULEENTITYID]
	WHERE	[deleted].[GEORULEENTITYID] <> [inserted].[GEORULEENTITYID]

	UNION ALL
	SELECT
			[inserted].[GEORULEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Description',
			[deleted].[DESCRIPTION],
			[inserted].[DESCRIPTION],
			'Geo Rule (' + [inserted].[RULENAME] + ')',
			'92E08D84-E807-4CC4-936A-04DCD65AF43A',
			2,
			1,
			[inserted].[RULENAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[GEORULEID] = [inserted].[GEORULEID]	
	WHERE	[deleted].[DESCRIPTION] <> [inserted].[DESCRIPTION]

	UNION ALL
	SELECT
			[inserted].[GEORULEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Geo Query',
			[GEOQUERY_DELETED].[QUERYNAME],
			[GEOQUERY_INSERTED].[QUERYNAME],
			'Geo Rule (' + [inserted].[RULENAME] + ')',
			'92E08D84-E807-4CC4-936A-04DCD65AF43A',
			2,
			1,
			[inserted].[RULENAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[GEORULEID] = [inserted].[GEORULEID]
			JOIN [GEOQUERY] [GEOQUERY_DELETED] WITH (NOLOCK) ON [deleted].[GEOQUERYID] = [GEOQUERY_DELETED].[GEOQUERYID]
			JOIN [GEOQUERY] [GEOQUERY_INSERTED] WITH (NOLOCK) ON [inserted].[GEOQUERYID] = [GEOQUERY_INSERTED].[GEOQUERYID]
	WHERE	[deleted].[GEOQUERYID] <> [inserted].[GEOQUERYID]

	UNION ALL
	SELECT
			[inserted].[GEORULEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Query Type',
			[GEOQUERYTYPE_DELETED].[QUERYTYPENAME],
			[GEOQUERYTYPE_INSERTED].[QUERYTYPENAME],
			'Geo Rule (' + [inserted].[RULENAME] + ')',
			'92E08D84-E807-4CC4-936A-04DCD65AF43A',
			2,
			1,
			[inserted].[RULENAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[GEORULEID] = [inserted].[GEORULEID]
			JOIN [GEOQUERY] [GEOQUERY_DELETED] WITH (NOLOCK) ON [deleted].[GEOQUERYID] = [GEOQUERY_DELETED].[GEOQUERYID]
			JOIN [GEOQUERY] [GEOQUERY_INSERTED] WITH (NOLOCK) ON [inserted].[GEOQUERYID] = [GEOQUERY_INSERTED].[GEOQUERYID]
			JOIN [GEOQUERYTYPE] [GEOQUERYTYPE_DELETED] WITH (NOLOCK) ON [GEOQUERY_DELETED].[GEOQUERYTYPEID] = [GEOQUERYTYPE_DELETED].[GEOQUERYTYPEID]
			JOIN [GEOQUERYTYPE] [GEOQUERYTYPE_INSERTED] WITH (NOLOCK) ON [GEOQUERY_INSERTED].[GEOQUERYTYPEID] = [GEOQUERYTYPE_INSERTED].[GEOQUERYTYPEID]
	WHERE	[deleted].[GEOQUERYID] <> [inserted].[GEOQUERYID]

	UNION ALL
	SELECT
			[inserted].[GEORULEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Feature Class Name',
			[GEOQUERY_DELETED].[FEATURECLASSNAME],
			[GEOQUERY_INSERTED].[FEATURECLASSNAME],
			'Geo Rule (' + [inserted].[RULENAME] + ')',
			'92E08D84-E807-4CC4-936A-04DCD65AF43A',
			2,
			1,
			[inserted].[RULENAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[GEORULEID] = [inserted].[GEORULEID]
			JOIN [GEOQUERY] [GEOQUERY_DELETED] WITH (NOLOCK) ON [deleted].[GEOQUERYID] = [GEOQUERY_DELETED].[GEOQUERYID]
			JOIN [GEOQUERY] [GEOQUERY_INSERTED] WITH (NOLOCK) ON [inserted].[GEOQUERYID] = [GEOQUERY_INSERTED].[GEOQUERYID]
	WHERE	[deleted].[GEOQUERYID] <> [inserted].[GEOQUERYID]

	UNION ALL
	SELECT
			[inserted].[GEORULEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Field Name',
			[GEOQUERY_DELETED].[FIELDNAME],
			[GEOQUERY_INSERTED].[FIELDNAME],
			'Geo Rule (' + [inserted].[RULENAME] + ')',
			'92E08D84-E807-4CC4-936A-04DCD65AF43A',
			2,
			1,
			[inserted].[RULENAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[GEORULEID] = [inserted].[GEORULEID]
			JOIN [GEOQUERY] [GEOQUERY_DELETED] WITH (NOLOCK) ON [deleted].[GEOQUERYID] = [GEOQUERY_DELETED].[GEOQUERYID]
			JOIN [GEOQUERY] [GEOQUERY_INSERTED] WITH (NOLOCK) ON [inserted].[GEOQUERYID] = [GEOQUERY_INSERTED].[GEOQUERYID]
	WHERE	[deleted].[GEOQUERYID] <> [inserted].[GEOQUERYID]

	UNION ALL
	SELECT
			[inserted].[GEORULEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'ESRI Type',
			[GEOQUERY_DELETED].[RETURNTYPE],
			[GEOQUERY_INSERTED].[RETURNTYPE],
			'Geo Rule (' + [inserted].[RULENAME] + ')',
			'92E08D84-E807-4CC4-936A-04DCD65AF43A',
			2,
			1,
			[inserted].[RULENAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[GEORULEID] = [inserted].[GEORULEID]
			JOIN [GEOQUERY] [GEOQUERY_DELETED] WITH (NOLOCK) ON [deleted].[GEOQUERYID] = [GEOQUERY_DELETED].[GEOQUERYID]
			JOIN [GEOQUERY] [GEOQUERY_INSERTED] WITH (NOLOCK) ON [inserted].[GEOQUERYID] = [GEOQUERY_INSERTED].[GEOQUERYID]
	WHERE	[deleted].[GEOQUERYID] <> [inserted].[GEOQUERYID]

	UNION ALL
	SELECT
			[inserted].[GEORULEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Returned Feature Class Name',
			[GEOQUERY_DELETED].[RETURNEDFEATURECLASS],
			[GEOQUERY_INSERTED].[RETURNEDFEATURECLASS],
			'Geo Rule (' + [inserted].[RULENAME] + ')',
			'92E08D84-E807-4CC4-936A-04DCD65AF43A',
			2,
			1,
			[inserted].[RULENAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[GEORULEID] = [inserted].[GEORULEID]
			JOIN [GEOQUERY] [GEOQUERY_DELETED] WITH (NOLOCK) ON [deleted].[GEOQUERYID] = [GEOQUERY_DELETED].[GEOQUERYID]
			JOIN [GEOQUERY] [GEOQUERY_INSERTED] WITH (NOLOCK) ON [inserted].[GEOQUERYID] = [GEOQUERY_INSERTED].[GEOQUERYID]
	WHERE	[deleted].[GEOQUERYID] <> [inserted].[GEOQUERYID]

	UNION ALL
	SELECT
			[inserted].[GEORULEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Is Custom Field Flag',
			CASE [deleted].[ISCUSTOMFIELD] WHEN 1 THEN 'Yes' ELSE 'No' END,
			CASE [inserted].[ISCUSTOMFIELD] WHEN 1 THEN 'Yes' ELSE 'No' END,
			'Geo Rule (' + [inserted].[RULENAME] + ')',
			'92E08D84-E807-4CC4-936A-04DCD65AF43A',
			2,
			1,
			[inserted].[RULENAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[GEORULEID] = [inserted].[GEORULEID]			
	WHERE	[deleted].[ISCUSTOMFIELD] <> [inserted].[ISCUSTOMFIELD]

	UNION ALL
	SELECT
			[inserted].[GEORULEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Entity Field',
			[deleted].[PROPERTYFRIENDLYNAME],
			[inserted].[PROPERTYFRIENDLYNAME],
			'Geo Rule (' + [inserted].[RULENAME] + ')',
			'92E08D84-E807-4CC4-936A-04DCD65AF43A',
			2,
			1,
			[inserted].[RULENAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[GEORULEID] = [inserted].[GEORULEID]			
	WHERE	[deleted].[PROPERTYFRIENDLYNAME] <> [inserted].[PROPERTYFRIENDLYNAME]

	UNION ALL
	SELECT
			[inserted].[GEORULEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Based on Spatial Collection Flag',
			CASE [deleted].[ISASSETCOLLECTIONBASED] WHEN 1 THEN 'Yes' ELSE 'No' END,
			CASE [inserted].[ISASSETCOLLECTIONBASED] WHEN 1 THEN 'Yes' ELSE 'No' END,
			'Geo Rule (' + [inserted].[RULENAME] + ')',
			'92E08D84-E807-4CC4-936A-04DCD65AF43A',
			2,
			1,
			[inserted].[RULENAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[GEORULEID] = [inserted].[GEORULEID]			
	WHERE	[deleted].[ISASSETCOLLECTIONBASED] <> [inserted].[ISASSETCOLLECTIONBASED]

	UNION ALL
	SELECT
			[inserted].[GEORULEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Asset Collection ID Property Name',
			[deleted].[ASSETCOLLECTIONIDPROPERTYNAME],
			[inserted].[ASSETCOLLECTIONIDPROPERTYNAME],
			'Geo Rule (' + [inserted].[RULENAME] + ')',
			'92E08D84-E807-4CC4-936A-04DCD65AF43A',
			2,
			1,
			[inserted].[RULENAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[GEORULEID] = [inserted].[GEORULEID]			
	WHERE	[deleted].[ASSETCOLLECTIONIDPROPERTYNAME] <> [inserted].[ASSETCOLLECTIONIDPROPERTYNAME]

	UNION ALL
	SELECT
			[inserted].[GEORULEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'GIS Features Based Flag',
			CASE [deleted].[ISGISFEATURESBASED] WHEN 1 THEN 'Yes' ELSE 'No' END,
			CASE [inserted].[ISGISFEATURESBASED] WHEN 1 THEN 'Yes' ELSE 'No' END,
			'Geo Rule (' + [inserted].[RULENAME] + ')',
			'92E08D84-E807-4CC4-936A-04DCD65AF43A',
			2,
			1,
			[inserted].[RULENAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[GEORULEID] = [inserted].[GEORULEID]			
	WHERE	[deleted].[ISGISFEATURESBASED] <> [inserted].[ISGISFEATURESBASED]

	UNION ALL
	SELECT
			[inserted].[GEORULEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'GIS Features Property Name',
			[deleted].[GISFEATURESPROPERTYNAME],
			[inserted].[GISFEATURESPROPERTYNAME],
			'Geo Rule (' + [inserted].[RULENAME] + ')',
			'92E08D84-E807-4CC4-936A-04DCD65AF43A',
			2,
			1,
			[inserted].[RULENAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[GEORULEID] = [inserted].[GEORULEID]			
	WHERE	[deleted].[GISFEATURESPROPERTYNAME] <> [inserted].[GISFEATURESPROPERTYNAME]
END
GO

CREATE TRIGGER [dbo].[TG_GEORULE_DELTE] ON [dbo].[GEORULE]
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
			[deleted].[GEORULEID],
			[deleted].[ROWVERSION],
			GETUTCDATE(),
			(SELECT dbo.UFN_GET_USERID_FROM_CONTEXT_INFO()),
			'Geo Rule Deleted',
			'',
			'',
			'Geo Rule (' + [deleted].[RULENAME] + ')',
			'92E08D84-E807-4CC4-936A-04DCD65AF43A',
			3,
			1,
			[deleted].[RULENAME]
	FROM	[deleted]
END
GO

CREATE TRIGGER [dbo].[TG_GEORULE_INSERT] ON [dbo].[GEORULE]
	AFTER INSERT
AS
BEGIN
	SET NOCOUNT ON;

	-- Check if LASTCHANGEDBY contains VALID User Id and it Exists in USERS table, this is in replacement to foreign key reference of GEORULE table with USERS table.
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
			[inserted].[GEORULEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Geo Rule Added',
			'',
			'',
			'Geo Rule (' + [inserted].[RULENAME] + ')',
			'92E08D84-E807-4CC4-936A-04DCD65AF43A',
			1,
			1,
			[inserted].[RULENAME]
	FROM	[inserted]
END