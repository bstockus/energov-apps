﻿CREATE PROCEDURE [dbo].[USP_GISMAP_UPDATE]
(
	@GMAPID CHAR(36),
	@SMAPNAME VARCHAR(100),
	@SMAPURL NVARCHAR(MAX),
	@SPARCELLAYER NVARCHAR(MAX),
	@SPINFIELD VARCHAR(100),
	@SGEOMETRYSERVER NVARCHAR(MAX),
	@SROUTESERVICE VARCHAR(100),
	@SMAPUNITS VARCHAR(100),
	@SGISIDENTIFYTASK VARCHAR(MAX),
	@SGISSTARTX DECIMAL(38,12),
	@SGISENDX DECIMAL(38,12),
	@SGISSTARTY DECIMAL(38,12),
	@SGISENDY DECIMAL(38,12),
	@SGISNAPROJECTION VARCHAR(100),
	@SGISLEGENDURL NVARCHAR(MAX),
	@SGISMEASUREPROJECTIONVALUE VARCHAR(100),
	@SGISMEASUREUNIT VARCHAR(50),
	@SGISFEATUREMAPURL NVARCHAR(MAX),
	@SINTERSECTIONLOCATORURL VARCHAR(500),
	@SEXTENT VARCHAR(150),
	@IDEFAULTLAYERNUMBER INT,
	@SCACHEPATH VARCHAR(150),
	@SPARCELOWNER VARCHAR(150),
	@USEADDRESSLOCATORFORADDRESSSRC BIT,
	@SADDRESSSEARCHURL VARCHAR(MAX),
	@SADDRESSSEARCHFIELD VARCHAR(150),
	@SWEATHERZIPCODE VARCHAR(150),
	@BUSESPATIALCOLLECTIONS BIT,
	@SSPATIALCOLLECTIONPOINTLAYERUR VARCHAR(150),
	@SSPATIALCOLLECTIONLINELAYERURL VARCHAR(150),
	@SSPATIALCOLLECTIONPOLYGONLAYER VARCHAR(150),
	@SPARCELLAYERNAME VARCHAR(150),
	@SADDRESSIDFIELD VARCHAR(150),
	@SQUERYLIMIT INT,
	@SFEATURESERVICELIST VARCHAR(MAX),
	@SGISFEATURESERVICEURL VARCHAR(250),
	@SGEOCODESERVICEURL VARCHAR(250),
	@LASTCHANGEDBY CHAR(36),
	@LASTCHANGEDON DATETIME,
	@ROWVERSION INT
)
AS
DECLARE @OUTPUTTABLE as TABLE([ROWVERSION] int)
UPDATE [dbo].[GISMAP] SET
	[SMAPNAME] = @SMAPNAME,
	[SMAPURL] = @SMAPURL,
	[SPARCELLAYER] = @SPARCELLAYER,
	[SPINFIELD] = @SPINFIELD,
	[SGEOMETRYSERVER] = @SGEOMETRYSERVER,
	[SROUTESERVICE] = @SROUTESERVICE,
	[SMAPUNITS] = @SMAPUNITS,
	[SGISIDENTIFYTASK] = @SGISIDENTIFYTASK,
	[SGISSTARTX] = @SGISSTARTX,
	[SGISENDX] = @SGISENDX,
	[SGISSTARTY] = @SGISSTARTY,
	[SGISENDY] = @SGISENDY,
	[SGISNAPROJECTION] = @SGISNAPROJECTION,
	[SGISLEGENDURL] = @SGISLEGENDURL,
	[SGISMEASUREPROJECTIONVALUE] = @SGISMEASUREPROJECTIONVALUE,
	[SGISMEASUREUNIT] = @SGISMEASUREUNIT,
	[SGISFEATUREMAPURL] = @SGISFEATUREMAPURL,
	[SINTERSECTIONLOCATORURL] = @SINTERSECTIONLOCATORURL,
	[SEXTENT] = @SEXTENT,
	[IDEFAULTLAYERNUMBER] = @IDEFAULTLAYERNUMBER,
	[SCACHEPATH] = @SCACHEPATH,
	[SPARCELOWNER] = @SPARCELOWNER,
	[USEADDRESSLOCATORFORADDRESSSRC] = @USEADDRESSLOCATORFORADDRESSSRC,
	[SADDRESSSEARCHURL] = @SADDRESSSEARCHURL,
	[SADDRESSSEARCHFIELD] = @SADDRESSSEARCHFIELD,
	[SWEATHERZIPCODE] = @SWEATHERZIPCODE,
	[BUSESPATIALCOLLECTIONS] = @BUSESPATIALCOLLECTIONS,
	[SSPATIALCOLLECTIONPOINTLAYERUR] = @SSPATIALCOLLECTIONPOINTLAYERUR,
	[SSPATIALCOLLECTIONLINELAYERURL] = @SSPATIALCOLLECTIONLINELAYERURL,
	[SSPATIALCOLLECTIONPOLYGONLAYER] = @SSPATIALCOLLECTIONPOLYGONLAYER,
	[SPARCELLAYERNAME] = @SPARCELLAYERNAME,
	[SADDRESSIDFIELD] = @SADDRESSIDFIELD,
	[SQUERYLIMIT] = @SQUERYLIMIT,
	[SFEATURESERVICELIST] = @SFEATURESERVICELIST,
	[SGISFEATURESERVICEURL] = @SGISFEATURESERVICEURL,
	[SGEOCODESERVICEURL] = @SGEOCODESERVICEURL,
	[LASTCHANGEDBY] = @LASTCHANGEDBY,
	[LASTCHANGEDON] = @LASTCHANGEDON,
	[ROWVERSION] = @ROWVERSION + 1
OUTPUT inserted.[ROWVERSION] INTO @OUTPUTTABLE
WHERE
	[GMAPID] = @GMAPID AND 
	[ROWVERSION]= @ROWVERSION

SELECT * FROM @OUTPUTTABLE