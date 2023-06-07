CREATE TABLE [dbo].[GISMAP] (
    [GMAPID]                         CHAR (36)        CONSTRAINT [DF_GISMaps_gMapID] DEFAULT (newid()) NOT NULL,
    [IMAPNUMBER]                     INT              IDENTITY (1, 1) NOT NULL,
    [SMAPNAME]                       VARCHAR (100)    NOT NULL,
    [SMAPURL]                        NVARCHAR (MAX)   NULL,
    [SPARCELLAYER]                   NVARCHAR (MAX)   NULL,
    [SPINFIELD]                      VARCHAR (100)    NOT NULL,
    [SGEOMETRYSERVER]                NVARCHAR (MAX)   NULL,
    [SROUTESERVICE]                  VARCHAR (100)    NOT NULL,
    [SMAPUNITS]                      VARCHAR (100)    NULL,
    [SGISIDENTIFYTASK]               VARCHAR (MAX)    NULL,
    [SGISSTARTX]                     DECIMAL (38, 12) NULL,
    [SGISENDX]                       DECIMAL (38, 12) NULL,
    [SGISSTARTY]                     DECIMAL (38, 12) NULL,
    [SGISENDY]                       DECIMAL (38, 12) NULL,
    [SGISNAPROJECTION]               VARCHAR (100)    NULL,
    [SGISLEGENDURL]                  NVARCHAR (MAX)   NULL,
    [SGISMEASUREPROJECTIONVALUE]     VARCHAR (100)    NULL,
    [SGISMEASUREUNIT]                VARCHAR (50)     NULL,
    [SGISFEATUREMAPURL]              NVARCHAR (MAX)   NULL,
    [SINTERSECTIONLOCATORURL]        VARCHAR (500)    NULL,
    [SEXTENT]                        VARCHAR (150)    NULL,
    [IDEFAULTLAYERNUMBER]            INT              NULL,
    [SCACHEPATH]                     VARCHAR (150)    NULL,
    [SPARCELOWNER]                   VARCHAR (150)    NULL,
    [USEADDRESSLOCATORFORADDRESSSRC] BIT              NULL,
    [SADDRESSSEARCHURL]              VARCHAR (MAX)    NULL,
    [SADDRESSSEARCHFIELD]            VARCHAR (150)    NULL,
    [SWEATHERZIPCODE]                VARCHAR (150)    NULL,
    [BUSESPATIALCOLLECTIONS]         BIT              NULL,
    [SSPATIALCOLLECTIONPOINTLAYERUR] VARCHAR (150)    NULL,
    [SSPATIALCOLLECTIONLINELAYERURL] VARCHAR (150)    NULL,
    [SSPATIALCOLLECTIONPOLYGONLAYER] VARCHAR (150)    NULL,
    [SPARCELLAYERNAME]               VARCHAR (150)    NULL,
    [SADDRESSIDFIELD]                VARCHAR (150)    NULL,
    [SQUERYLIMIT]                    INT              DEFAULT ((0)) NOT NULL,
    [SFEATURESERVICELIST]            VARCHAR (MAX)    NULL,
    [SGISFEATURESERVICEURL]          VARCHAR (250)    NULL,
    [SGEOCODESERVICEURL]             VARCHAR (250)    NULL,
    [LASTCHANGEDBY]                  CHAR (36)        NULL,
    [LASTCHANGEDON]                  DATETIME         CONSTRAINT [DF_GISMAP_LastChangedOn] DEFAULT (getutcdate()) NOT NULL,
    [ROWVERSION]                     INT              CONSTRAINT [DF_GISMAP_RowVersion] DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_GISMaps] PRIMARY KEY CLUSTERED ([GMAPID] ASC) WITH (FILLFACTOR = 80)
);


GO
CREATE NONCLUSTERED INDEX [GISMAP_IX_QUERY]
    ON [dbo].[GISMAP]([GMAPID] ASC, [SMAPNAME] ASC);


GO

CREATE TRIGGER [dbo].[TG_GISMAP_UPDATE] ON [dbo].[GISMAP] 
	AFTER UPDATE
AS 
BEGIN
	SET NOCOUNT ON;
		
	-- Check if LASTCHANGEDBY contains VALID User Id and it Exists in USERS table, this is in replacement to foreign key reference of GISMAP table with USERS table.
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
			[inserted].[GMAPID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Map Name',
			CAST([deleted].[SMAPNAME] AS NVARCHAR(255)),
			CAST([inserted].[SMAPNAME] AS NVARCHAR(255)),
			'GIS Map (' + [inserted].[SMAPNAME] + ')',
			'D85FB7D7-45FE-4FE0-88BE-FBD958E41153',
			2,
			1,
			[inserted].[SMAPNAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[GMAPID] = [inserted].[GMAPID]
	WHERE	[deleted].[SMAPNAME] <> [inserted].[SMAPNAME]
	
	UNION ALL
	SELECT
			[inserted].[GMAPID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Map URL',
			ISNULL([deleted].[SMAPURL], '[none]'),
			ISNULL([inserted].[SMAPURL], '[none]'),
			'GIS Map (' + [inserted].[SMAPNAME] + ')',
			'D85FB7D7-45FE-4FE0-88BE-FBD958E41153',
			2,
			1,
			[inserted].[SMAPNAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[GMAPID] = [inserted].[GMAPID]
	WHERE	ISNULL([deleted].[SMAPURL], '') <> ISNULL([inserted].[SMAPURL], '')
	
	UNION ALL
	SELECT
			[inserted].[GMAPID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Parcel Layer URL',
			ISNULL([deleted].[SPARCELLAYER], '[none]'),
			ISNULL([inserted].[SPARCELLAYER], '[none]'),
			'GIS Map (' + [inserted].[SMAPNAME] + ')',
			'D85FB7D7-45FE-4FE0-88BE-FBD958E41153',
			2,
			1,
			[inserted].[SMAPNAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[GMAPID] = [inserted].[GMAPID]
	WHERE	ISNULL([deleted].[SPARCELLAYER], '') <> ISNULL([inserted].[SPARCELLAYER], '')
	
	UNION ALL
	SELECT
			[inserted].[GMAPID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Pin Field',
			CAST([deleted].[SPINFIELD] AS NVARCHAR(255)),
			CAST([inserted].[SPINFIELD] AS NVARCHAR(255)),
			'GIS Map (' + [inserted].[SMAPNAME] + ')',
			'D85FB7D7-45FE-4FE0-88BE-FBD958E41153',
			2,
			1,
			[inserted].[SMAPNAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[GMAPID] = [inserted].[GMAPID]
	WHERE	[deleted].[SPINFIELD] <> [inserted].[SPINFIELD]
	
	UNION ALL
	SELECT
			[inserted].[GMAPID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Geometry Service URL',
			ISNULL([deleted].[SGEOMETRYSERVER], '[none]'),
			ISNULL([inserted].[SGEOMETRYSERVER], '[none]'),
			'GIS Map (' + [inserted].[SMAPNAME] + ')',
			'D85FB7D7-45FE-4FE0-88BE-FBD958E41153',
			2,
			1,
			[inserted].[SMAPNAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[GMAPID] = [inserted].[GMAPID]
	WHERE	ISNULL([deleted].[SGEOMETRYSERVER], '') <> ISNULL([inserted].[SGEOMETRYSERVER], '')
	
	UNION ALL
	SELECT
			[inserted].[GMAPID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Route Service URL',
			CAST([deleted].[SROUTESERVICE] AS NVARCHAR(255)),
			CAST([inserted].[SROUTESERVICE] AS NVARCHAR(255)),
			'GIS Map (' + [inserted].[SMAPNAME] + ')',
			'D85FB7D7-45FE-4FE0-88BE-FBD958E41153',
			2,
			1,
			[inserted].[SMAPNAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[GMAPID] = [inserted].[GMAPID]
	WHERE	[deleted].[SROUTESERVICE] <> [inserted].[SROUTESERVICE]
	
	UNION ALL
	SELECT
			[inserted].[GMAPID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Map Unit',
			ISNULL(CAST([deleted].[SMAPUNITS] AS NVARCHAR(255)), '[none]'),
			ISNULL(CAST([inserted].[SMAPUNITS] AS NVARCHAR(255)), '[none]'),
			'GIS Map (' + [inserted].[SMAPNAME] + ')',
			'D85FB7D7-45FE-4FE0-88BE-FBD958E41153',
			2,
			1,
			[inserted].[SMAPNAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[GMAPID] = [inserted].[GMAPID]
	WHERE	ISNULL([deleted].[SMAPUNITS], '') <> ISNULL([inserted].[SMAPUNITS], '')
	
	UNION ALL
	SELECT
			[inserted].[GMAPID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Identify Task URL',
			ISNULL(CAST([deleted].[SGISIDENTIFYTASK] AS NVARCHAR(255)), '[none]'),
			ISNULL(CAST([inserted].[SGISIDENTIFYTASK] AS NVARCHAR(255)), '[none]'),
			'GIS Map (' + [inserted].[SMAPNAME] + ')',
			'D85FB7D7-45FE-4FE0-88BE-FBD958E41153',
			2,
			1,
			[inserted].[SMAPNAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[GMAPID] = [inserted].[GMAPID]
	WHERE	ISNULL([deleted].[SGISIDENTIFYTASK], '') <> ISNULL([inserted].[SGISIDENTIFYTASK], '')
	
	UNION ALL
	SELECT
			[inserted].[GMAPID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Route Start X',
			ISNULL(CAST([deleted].[SGISSTARTX] AS NVARCHAR(255)), '[none]'),
			ISNULL(CAST([inserted].[SGISSTARTX] AS NVARCHAR(255)), '[none]'),
			'GIS Map (' + [inserted].[SMAPNAME] + ')',
			'D85FB7D7-45FE-4FE0-88BE-FBD958E41153',
			2,
			1,
			[inserted].[SMAPNAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[GMAPID] = [inserted].[GMAPID]
	WHERE	COALESCE([deleted].[SGISSTARTX], '') <> COALESCE([inserted].[SGISSTARTX], '')
	
	UNION ALL
	SELECT
			[inserted].[GMAPID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Route End X',
			ISNULL(CAST([deleted].[SGISENDX] AS NVARCHAR(255)), '[none]'),
			ISNULL(CAST([inserted].[SGISENDX] AS NVARCHAR(255)), '[none]'),
			'GIS Map (' + [inserted].[SMAPNAME] + ')',
			'D85FB7D7-45FE-4FE0-88BE-FBD958E41153',
			2,
			1,
			[inserted].[SMAPNAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[GMAPID] = [inserted].[GMAPID]
	WHERE	COALESCE([deleted].[SGISENDX], '') <> COALESCE([inserted].[SGISENDX], '')
	
	UNION ALL
	SELECT
			[inserted].[GMAPID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Route Start Y',
			ISNULL(CAST([deleted].[SGISSTARTY] AS NVARCHAR(255)), '[none]'),
			ISNULL(CAST([inserted].[SGISSTARTY] AS NVARCHAR(255)), '[none]'),
			'GIS Map (' + [inserted].[SMAPNAME] + ')',
			'D85FB7D7-45FE-4FE0-88BE-FBD958E41153',
			2,
			1,
			[inserted].[SMAPNAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[GMAPID] = [inserted].[GMAPID]
	WHERE	COALESCE([deleted].[SGISSTARTY], '') <> COALESCE([inserted].[SGISSTARTY], '')
	
	UNION ALL
	SELECT
			[inserted].[GMAPID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Route End Y',
			ISNULL(CAST([deleted].[SGISENDY] AS NVARCHAR(255)), '[none]'),
			ISNULL(CAST([inserted].[SGISENDY] AS NVARCHAR(255)), '[none]'),
			'GIS Map (' + [inserted].[SMAPNAME] + ')',
			'D85FB7D7-45FE-4FE0-88BE-FBD958E41153',
			2,
			1,
			[inserted].[SMAPNAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[GMAPID] = [inserted].[GMAPID]
	WHERE	COALESCE([deleted].[SGISENDY], '') <> COALESCE([inserted].[SGISENDY], '')
	
	UNION ALL
	SELECT
			[inserted].[GMAPID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Network Analysis Projection',
			ISNULL(CAST([deleted].[SGISNAPROJECTION] AS NVARCHAR(255)), '[none]'),
			ISNULL(CAST([inserted].[SGISNAPROJECTION] AS NVARCHAR(255)), '[none]'),
			'GIS Map (' + [inserted].[SMAPNAME] + ')',
			'D85FB7D7-45FE-4FE0-88BE-FBD958E41153',
			2,
			1,
			[inserted].[SMAPNAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[GMAPID] = [inserted].[GMAPID]
	WHERE	ISNULL([deleted].[SGISNAPROJECTION], '') <> ISNULL([inserted].[SGISNAPROJECTION], '')
	
	UNION ALL
	SELECT
			[inserted].[GMAPID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Legend URL',
			ISNULL([deleted].[SGISLEGENDURL], '[none]'),
			ISNULL([inserted].[SGISLEGENDURL], '[none]'),
			'GIS Map (' + [inserted].[SMAPNAME] + ')',
			'D85FB7D7-45FE-4FE0-88BE-FBD958E41153',
			2,
			1,
			[inserted].[SMAPNAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[GMAPID] = [inserted].[GMAPID]
	WHERE	ISNULL([deleted].[SGISLEGENDURL], '') <> ISNULL([inserted].[SGISLEGENDURL], '')
	
	UNION ALL
	SELECT
			[inserted].[GMAPID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Measurement Projection',
			ISNULL(CAST([deleted].[SGISMEASUREPROJECTIONVALUE] AS NVARCHAR(255)), '[none]'),
			ISNULL(CAST([inserted].[SGISMEASUREPROJECTIONVALUE] AS NVARCHAR(255)), '[none]'),
			'GIS Map (' + [inserted].[SMAPNAME] + ')',
			'D85FB7D7-45FE-4FE0-88BE-FBD958E41153',
			2,
			1,
			[inserted].[SMAPNAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[GMAPID] = [inserted].[GMAPID]
	WHERE	ISNULL([deleted].[SGISMEASUREPROJECTIONVALUE], '') <> ISNULL([inserted].[SGISMEASUREPROJECTIONVALUE], '')
	
	UNION ALL
	SELECT
			[inserted].[GMAPID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Measurement Unit',
			ISNULL(CAST([deleted].[SGISMEASUREUNIT] AS NVARCHAR(255)), '[none]'),
			ISNULL(CAST([inserted].[SGISMEASUREUNIT] AS NVARCHAR(255)), '[none]'),
			'GIS Map (' + [inserted].[SMAPNAME] + ')',
			'D85FB7D7-45FE-4FE0-88BE-FBD958E41153',
			2,
			1,
			[inserted].[SMAPNAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[GMAPID] = [inserted].[GMAPID]
	WHERE	ISNULL([deleted].[SGISMEASUREUNIT], '') <> ISNULL([inserted].[SGISMEASUREUNIT], '')
	
	UNION ALL
	SELECT
			[inserted].[GMAPID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Feature Map URL',
			ISNULL([deleted].[SGISFEATUREMAPURL], '[none]'),
			ISNULL([inserted].[SGISFEATUREMAPURL], '[none]'),
			'GIS Map (' + [inserted].[SMAPNAME] + ')',
			'D85FB7D7-45FE-4FE0-88BE-FBD958E41153',
			2,
			1,
			[inserted].[SMAPNAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[GMAPID] = [inserted].[GMAPID]
	WHERE	ISNULL([deleted].[SGISFEATUREMAPURL], '') <> ISNULL([inserted].[SGISFEATUREMAPURL], '')
	
	UNION ALL
	SELECT
			[inserted].[GMAPID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Intersection URL',
			ISNULL(CAST([deleted].[SINTERSECTIONLOCATORURL] AS NVARCHAR(255)), '[none]'),
			ISNULL(CAST([inserted].[SINTERSECTIONLOCATORURL] AS NVARCHAR(255)), '[none]'),
			'GIS Map (' + [inserted].[SMAPNAME] + ')',
			'D85FB7D7-45FE-4FE0-88BE-FBD958E41153',
			2,
			1,
			[inserted].[SMAPNAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[GMAPID] = [inserted].[GMAPID]
	WHERE	ISNULL([deleted].[SINTERSECTIONLOCATORURL], '') <> ISNULL([inserted].[SINTERSECTIONLOCATORURL], '')
	
	UNION ALL
	SELECT
			[inserted].[GMAPID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Initial Extent',
			ISNULL(CAST([deleted].[SEXTENT] AS NVARCHAR(255)), '[none]'),
			ISNULL(CAST([inserted].[SEXTENT] AS NVARCHAR(255)), '[none]'),
			'GIS Map (' + [inserted].[SMAPNAME] + ')',
			'D85FB7D7-45FE-4FE0-88BE-FBD958E41153',
			2,
			1,
			[inserted].[SMAPNAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[GMAPID] = [inserted].[GMAPID]
	WHERE	ISNULL([deleted].[SEXTENT], '') <> ISNULL([inserted].[SEXTENT], '')
	
	UNION ALL
	SELECT
			[inserted].[GMAPID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Default Layer',
			ISNULL(CAST([deleted].[IDEFAULTLAYERNUMBER] AS NVARCHAR(255)), '[none]'),
			ISNULL(CAST([inserted].[IDEFAULTLAYERNUMBER] AS NVARCHAR(255)), '[none]'),
			'GIS Map (' + [inserted].[SMAPNAME] + ')',
			'D85FB7D7-45FE-4FE0-88BE-FBD958E41153',
			2,
			1,
			[inserted].[SMAPNAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[GMAPID] = [inserted].[GMAPID]
	WHERE	COALESCE([deleted].[IDEFAULTLAYERNUMBER], '') <> COALESCE([inserted].[IDEFAULTLAYERNUMBER], '')
	
	UNION ALL
	SELECT
			[inserted].[GMAPID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Cache Path',
			ISNULL(CAST([deleted].[SCACHEPATH] AS NVARCHAR(255)), '[none]'),
			ISNULL(CAST([inserted].[SCACHEPATH] AS NVARCHAR(255)), '[none]'),
			'GIS Map (' + [inserted].[SMAPNAME] + ')',
			'D85FB7D7-45FE-4FE0-88BE-FBD958E41153',
			2,
			1,
			[inserted].[SMAPNAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[GMAPID] = [inserted].[GMAPID]
	WHERE	ISNULL([deleted].[SCACHEPATH], '') <> ISNULL([inserted].[SCACHEPATH], '')
	
	UNION ALL
	SELECT
			[inserted].[GMAPID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Parcel Owner Field',
			ISNULL(CAST([deleted].[SPARCELOWNER] AS NVARCHAR(255)), '[none]'),
			ISNULL(CAST([inserted].[SPARCELOWNER] AS NVARCHAR(255)), '[none]'),
			'GIS Map (' + [inserted].[SMAPNAME] + ')',
			'D85FB7D7-45FE-4FE0-88BE-FBD958E41153',
			2,
			1,
			[inserted].[SMAPNAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[GMAPID] = [inserted].[GMAPID]
	WHERE	ISNULL([deleted].[SPARCELOWNER], '') <> ISNULL([inserted].[SPARCELOWNER], '')
	
	UNION ALL
	SELECT
			[inserted].[GMAPID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Use Address Locator For Address Search',
			CASE [deleted].[USEADDRESSLOCATORFORADDRESSSRC] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No'  ELSE '[none]' END,
			CASE [inserted].[USEADDRESSLOCATORFORADDRESSSRC] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No'  ELSE '[none]' END,
			'GIS Map (' + [inserted].[SMAPNAME] + ')',
			'D85FB7D7-45FE-4FE0-88BE-FBD958E41153',
			2,
			1,
			[inserted].[SMAPNAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[GMAPID] = [inserted].[GMAPID]
	WHERE	([deleted].[USEADDRESSLOCATORFORADDRESSSRC] <> [inserted].[USEADDRESSLOCATORFORADDRESSSRC]) 
			OR ([deleted].[USEADDRESSLOCATORFORADDRESSSRC] IS NULL AND [inserted].[USEADDRESSLOCATORFORADDRESSSRC] IS NOT NULL)
			OR ([deleted].[USEADDRESSLOCATORFORADDRESSSRC] IS NOT NULL AND [inserted].[USEADDRESSLOCATORFORADDRESSSRC] IS NULL)
	
	UNION ALL
	SELECT
			[inserted].[GMAPID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Address Search URL',
			ISNULL(CAST([deleted].[SADDRESSSEARCHURL] AS NVARCHAR(255)), '[none]'),
			ISNULL(CAST([inserted].[SADDRESSSEARCHURL] AS NVARCHAR(255)), '[none]'),
			'GIS Map (' + [inserted].[SMAPNAME] + ')',
			'D85FB7D7-45FE-4FE0-88BE-FBD958E41153',
			2,
			1,
			[inserted].[SMAPNAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[GMAPID] = [inserted].[GMAPID]
	WHERE	ISNULL([deleted].[SADDRESSSEARCHURL], '') <> ISNULL([inserted].[SADDRESSSEARCHURL], '')
	
	UNION ALL
	SELECT
			[inserted].[GMAPID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Address Search Field',
			ISNULL(CAST([deleted].[SADDRESSSEARCHFIELD] AS NVARCHAR(255)), '[none]'),
			ISNULL(CAST([inserted].[SADDRESSSEARCHFIELD] AS NVARCHAR(255)), '[none]'),
			'GIS Map (' + [inserted].[SMAPNAME] + ')',
			'D85FB7D7-45FE-4FE0-88BE-FBD958E41153',
			2,
			1,
			[inserted].[SMAPNAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[GMAPID] = [inserted].[GMAPID]
	WHERE	ISNULL([deleted].[SADDRESSSEARCHFIELD], '') <> ISNULL([inserted].[SADDRESSSEARCHFIELD], '')
	
	UNION ALL
	SELECT
			[inserted].[GMAPID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Weather Zip Code',
			ISNULL(CAST([deleted].[SWEATHERZIPCODE] AS NVARCHAR(255)), '[none]'),
			ISNULL(CAST([inserted].[SWEATHERZIPCODE] AS NVARCHAR(255)), '[none]'),
			'GIS Map (' + [inserted].[SMAPNAME] + ')',
			'D85FB7D7-45FE-4FE0-88BE-FBD958E41153',
			2,
			1,
			[inserted].[SMAPNAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[GMAPID] = [inserted].[GMAPID]
	WHERE	ISNULL([deleted].[SWEATHERZIPCODE], '') <> ISNULL([inserted].[SWEATHERZIPCODE], '')
	
	UNION ALL
	SELECT
			[inserted].[GMAPID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Use Spatial Collections',
			CASE [deleted].[BUSESPATIALCOLLECTIONS] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No'  ELSE '[none]' END,
			CASE [inserted].[BUSESPATIALCOLLECTIONS] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No'  ELSE '[none]' END,
			'GIS Map (' + [inserted].[SMAPNAME] + ')',
			'D85FB7D7-45FE-4FE0-88BE-FBD958E41153',
			2,
			1,
			[inserted].[SMAPNAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[GMAPID] = [inserted].[GMAPID]
	WHERE	([deleted].[BUSESPATIALCOLLECTIONS] <> [inserted].[BUSESPATIALCOLLECTIONS]) 
			OR ([deleted].[BUSESPATIALCOLLECTIONS] IS NULL AND [inserted].[BUSESPATIALCOLLECTIONS] IS NOT NULL)
			OR ([deleted].[BUSESPATIALCOLLECTIONS] IS NOT NULL AND [inserted].[BUSESPATIALCOLLECTIONS] IS NULL)
	
	UNION ALL
	SELECT
			[inserted].[GMAPID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Spatial Collection Point Layer URL',
			ISNULL(CAST([deleted].[SSPATIALCOLLECTIONPOINTLAYERUR] AS NVARCHAR(255)), '[none]'),
			ISNULL(CAST([inserted].[SSPATIALCOLLECTIONPOINTLAYERUR] AS NVARCHAR(255)), '[none]'),
			'GIS Map (' + [inserted].[SMAPNAME] + ')',
			'D85FB7D7-45FE-4FE0-88BE-FBD958E41153',
			2,
			1,
			[inserted].[SMAPNAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[GMAPID] = [inserted].[GMAPID]
	WHERE	ISNULL([deleted].[SSPATIALCOLLECTIONPOINTLAYERUR], '') <> ISNULL([inserted].[SSPATIALCOLLECTIONPOINTLAYERUR], '')
	
	UNION ALL
	SELECT
			[inserted].[GMAPID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Spatial Collection Line Layer URL',
			ISNULL(CAST([deleted].[SSPATIALCOLLECTIONLINELAYERURL] AS NVARCHAR(255)), '[none]'),
			ISNULL(CAST([inserted].[SSPATIALCOLLECTIONLINELAYERURL] AS NVARCHAR(255)), '[none]'),
			'GIS Map (' + [inserted].[SMAPNAME] + ')',
			'D85FB7D7-45FE-4FE0-88BE-FBD958E41153',
			2,
			1,
			[inserted].[SMAPNAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[GMAPID] = [inserted].[GMAPID]
	WHERE	ISNULL([deleted].[SSPATIALCOLLECTIONLINELAYERURL], '') <> ISNULL([inserted].[SSPATIALCOLLECTIONLINELAYERURL], '')
	
	UNION ALL
	SELECT
			[inserted].[GMAPID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Spatial Collection Polygon Layer',
			ISNULL(CAST([deleted].[SSPATIALCOLLECTIONPOLYGONLAYER] AS NVARCHAR(255)), '[none]'),
			ISNULL(CAST([inserted].[SSPATIALCOLLECTIONPOLYGONLAYER] AS NVARCHAR(255)), '[none]'),
			'GIS Map (' + [inserted].[SMAPNAME] + ')',
			'D85FB7D7-45FE-4FE0-88BE-FBD958E41153',
			2,
			1,
			[inserted].[SMAPNAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[GMAPID] = [inserted].[GMAPID]
	WHERE	ISNULL([deleted].[SSPATIALCOLLECTIONPOLYGONLAYER], '') <> ISNULL([inserted].[SSPATIALCOLLECTIONPOLYGONLAYER], '')
	
	UNION ALL
	SELECT
			[inserted].[GMAPID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Parcel Layer Name',
			ISNULL(CAST([deleted].[SPARCELLAYERNAME] AS NVARCHAR(255)), '[none]'),
			ISNULL(CAST([inserted].[SPARCELLAYERNAME] AS NVARCHAR(255)), '[none]'),
			'GIS Map (' + [inserted].[SMAPNAME] + ')',
			'D85FB7D7-45FE-4FE0-88BE-FBD958E41153',
			2,
			1,
			[inserted].[SMAPNAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[GMAPID] = [inserted].[GMAPID]
	WHERE	ISNULL([deleted].[SPARCELLAYERNAME], '') <> ISNULL([inserted].[SPARCELLAYERNAME], '')
	
	UNION ALL
	SELECT
			[inserted].[GMAPID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Address ID',
			ISNULL(CAST([deleted].[SADDRESSIDFIELD] AS NVARCHAR(255)), '[none]'),
			ISNULL(CAST([inserted].[SADDRESSIDFIELD] AS NVARCHAR(255)), '[none]'),
			'GIS Map (' + [inserted].[SMAPNAME] + ')',
			'D85FB7D7-45FE-4FE0-88BE-FBD958E41153',
			2,
			1,
			[inserted].[SMAPNAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[GMAPID] = [inserted].[GMAPID]
	WHERE	ISNULL([deleted].[SADDRESSIDFIELD], '') <> ISNULL([inserted].[SADDRESSIDFIELD], '')
	
	UNION ALL
	SELECT
			[inserted].[GMAPID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Query Limit',
			CAST([deleted].[SQUERYLIMIT] AS NVARCHAR(255)),
			CAST([inserted].[SQUERYLIMIT] AS NVARCHAR(255)),
			'GIS Map (' + [inserted].[SMAPNAME] + ')',
			'D85FB7D7-45FE-4FE0-88BE-FBD958E41153',
			2,
			1,
			[inserted].[SMAPNAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[GMAPID] = [inserted].[GMAPID]
	WHERE	[deleted].[SQUERYLIMIT] <> [inserted].[SQUERYLIMIT]
	
	UNION ALL
	SELECT
			[inserted].[GMAPID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Feature Service Layer',
			ISNULL(CAST([deleted].[SFEATURESERVICELIST] AS NVARCHAR(255)), '[none]'),
			ISNULL(CAST([inserted].[SFEATURESERVICELIST] AS NVARCHAR(255)), '[none]'),
			'GIS Map (' + [inserted].[SMAPNAME] + ')',
			'D85FB7D7-45FE-4FE0-88BE-FBD958E41153',
			2,
			1,
			[inserted].[SMAPNAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[GMAPID] = [inserted].[GMAPID]
	WHERE	ISNULL([deleted].[SFEATURESERVICELIST], '') <> ISNULL([inserted].[SFEATURESERVICELIST], '')
	
	UNION ALL
	SELECT
			[inserted].[GMAPID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Feature Service URL',
			ISNULL(CAST([deleted].[SGISFEATURESERVICEURL] AS NVARCHAR(255)), '[none]'),
			ISNULL(CAST([inserted].[SGISFEATURESERVICEURL] AS NVARCHAR(255)), '[none]'),
			'GIS Map (' + [inserted].[SMAPNAME] + ')',
			'D85FB7D7-45FE-4FE0-88BE-FBD958E41153',
			2,
			1,
			[inserted].[SMAPNAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[GMAPID] = [inserted].[GMAPID]
	WHERE	ISNULL([deleted].[SGISFEATURESERVICEURL], '') <> ISNULL([inserted].[SGISFEATURESERVICEURL], '')
	
	UNION ALL
	SELECT
			[inserted].[GMAPID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'GeoCode Service URL',
			ISNULL(CAST([deleted].[SGEOCODESERVICEURL] AS NVARCHAR(255)), '[none]'),
			ISNULL(CAST([inserted].[SGEOCODESERVICEURL] AS NVARCHAR(255)), '[none]'),
			'GIS Map (' + [inserted].[SMAPNAME] + ')',
			'D85FB7D7-45FE-4FE0-88BE-FBD958E41153',
			2,
			1,
			[inserted].[SMAPNAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[GMAPID] = [inserted].[GMAPID]
	WHERE	ISNULL([deleted].[SGEOCODESERVICEURL], '') <> ISNULL([inserted].[SGEOCODESERVICEURL], '')
END
GO

CREATE TRIGGER [dbo].[TG_GISMAP_INSERT] ON [dbo].[GISMAP]
   FOR INSERT
AS 
BEGIN
	SET NOCOUNT ON;
	-- Check if LASTCHANGEDBY contains VALID User Id and it Exists in USERS table, this is in replacement to foreign key reference of GISMAP table with USERS table.
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
			[inserted].[GMAPID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'GIS Map Added',
			'',
			'',
			'GIS Map (' + [inserted].[SMAPNAME] + ')',
			'D85FB7D7-45FE-4FE0-88BE-FBD958E41153',
			1,
			1,
			[inserted].[SMAPNAME]
	FROM	[inserted]	
END
GO

CREATE TRIGGER [dbo].[TG_GISMAP_DELETE] ON [dbo].[GISMAP]
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
			[deleted].[GMAPID],
			[deleted].[ROWVERSION],
			GETUTCDATE(),
			(SELECT dbo.UFN_GET_USERID_FROM_CONTEXT_INFO()),
			'GIS Map Deleted',
			'',
			'',
			'GIS Map (' + [deleted].[SMAPNAME] + ')',
			'D85FB7D7-45FE-4FE0-88BE-FBD958E41153',
			3,
			1,
			[deleted].[SMAPNAME]
	FROM	[deleted]
END