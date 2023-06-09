﻿CREATE PROCEDURE [gissetupapp].[USP_GISMAP_GETBYID]
(
	@GMAPID CHAR(36)
)
AS
BEGIN
SET NOCOUNT ON;
SELECT 
	[dbo].[GISMAP].[GMAPID],
	[dbo].[GISMAP].[IMAPNUMBER],
	[dbo].[GISMAP].[SMAPNAME],
	[dbo].[GISMAP].[SMAPURL],
	[dbo].[GISMAP].[SPARCELLAYER],
	[dbo].[GISMAP].[SPINFIELD],
	[dbo].[GISMAP].[SGEOMETRYSERVER],
	[dbo].[GISMAP].[SROUTESERVICE],
	[dbo].[GISMAP].[SMAPUNITS],
	[dbo].[GISMAP].[SGISIDENTIFYTASK],
	[dbo].[GISMAP].[SGISSTARTX],
	[dbo].[GISMAP].[SGISENDX],
	[dbo].[GISMAP].[SGISSTARTY],
	[dbo].[GISMAP].[SGISENDY],
	[dbo].[GISMAP].[SGISNAPROJECTION],
	[dbo].[GISMAP].[SGISLEGENDURL],
	[dbo].[GISMAP].[SGISMEASUREPROJECTIONVALUE],
	[dbo].[GISMAP].[SGISMEASUREUNIT],
	[dbo].[GISMAP].[SGISFEATUREMAPURL],
	[dbo].[GISMAP].[SINTERSECTIONLOCATORURL],
	[dbo].[GISMAP].[SEXTENT],
	[dbo].[GISMAP].[IDEFAULTLAYERNUMBER],
	[dbo].[GISMAP].[SCACHEPATH],
	[dbo].[GISMAP].[SPARCELOWNER],
	[dbo].[GISMAP].[USEADDRESSLOCATORFORADDRESSSRC],
	[dbo].[GISMAP].[SADDRESSSEARCHURL],
	[dbo].[GISMAP].[SADDRESSSEARCHFIELD],
	[dbo].[GISMAP].[SWEATHERZIPCODE],
	[dbo].[GISMAP].[BUSESPATIALCOLLECTIONS],
	[dbo].[GISMAP].[SSPATIALCOLLECTIONPOINTLAYERUR],
	[dbo].[GISMAP].[SSPATIALCOLLECTIONLINELAYERURL],
	[dbo].[GISMAP].[SSPATIALCOLLECTIONPOLYGONLAYER],
	[dbo].[GISMAP].[SPARCELLAYERNAME],
	[dbo].[GISMAP].[SADDRESSIDFIELD],
	[dbo].[GISMAP].[SQUERYLIMIT],
	[dbo].[GISMAP].[SFEATURESERVICELIST],
	[dbo].[GISMAP].[SGISFEATURESERVICEURL],
	[dbo].[GISMAP].[SGEOCODESERVICEURL],
	[dbo].[GISMAP].[LASTCHANGEDBY],
	[dbo].[GISMAP].[LASTCHANGEDON],
	[dbo].[GISMAP].[ROWVERSION]
FROM [dbo].[GISMAP]
WHERE
	[dbo].[GISMAP].[GMAPID] = @GMAPID  

	EXEC [gissetupapp].[USP_GISMAPFEATUREXREF_GETBYPARENTID] @GMAPID
END