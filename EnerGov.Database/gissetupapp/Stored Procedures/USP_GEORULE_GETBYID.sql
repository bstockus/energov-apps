﻿CREATE PROCEDURE [gissetupapp].[USP_GEORULE_GETBYID]
(
	@GEORULEID CHAR(36)
)
AS
BEGIN
SET NOCOUNT ON;
SELECT 
	[dbo].[GEORULE].[GEORULEID],
	[dbo].[GEORULE].[RULENAME],
	[dbo].[GEORULE].[GEORULEENTITYID],
	[dbo].[GEORULE].[DESCRIPTION],
	[dbo].[GEORULE].[GEOQUERYID],
	[dbo].[GEORULE].[ENTITYPROPERTY],
	[dbo].[GEORULE].[ISCUSTOMFIELD],
	[dbo].[GEORULE].[PROPERTYFRIENDLYNAME],
	[dbo].[GEORULE].[ISASSETCOLLECTIONBASED],
	[dbo].[GEORULE].[ASSETCOLLECTIONIDPROPERTYNAME],
	[dbo].[GEORULE].[ISGISFEATURESBASED],
	[dbo].[GEORULE].[GISFEATURESPROPERTYNAME],
	[dbo].[GEORULE].[LASTCHANGEDBY],
	[dbo].[GEORULE].[LASTCHANGEDON],
	[dbo].[GEORULE].[ROWVERSION],
	[dbo].[GEOQUERY].[QUERYNAME],
	[dbo].[GEOQUERY].[FEATURECLASSNAME],
	[dbo].[GEOQUERY].[FIELDNAME],
	[dbo].[GEOQUERY].[RETURNTYPE],
	[dbo].[GEOQUERY].[RETURNEDFEATURECLASS],
	[dbo].[GEOQUERYTYPE].[QUERYTYPENAME],
	[dbo].[GEORULEENTITY].[GEORYLEENTITYFRIENDLYNAME],
	[dbo].[GEORULEENTITY].[GEORULEENTITYCLASS]
FROM [dbo].[GEORULE]
INNER JOIN [dbo].[GEOQUERY] ON [dbo].[GEOQUERY].[GEOQUERYID] = [dbo].[GEORULE].[GEOQUERYID]
INNER JOIN [dbo].[GEOQUERYTYPE] ON [dbo].[GEOQUERYTYPE].[GEOQUERYTYPEID] = [dbo].[GEOQUERY].[GEOQUERYTYPEID]
INNER JOIN [dbo].[GEORULEENTITY] ON [dbo].[GEORULEENTITY].[GEORULEENTITYID] = [dbo].[GEORULE].[GEORULEENTITYID]
WHERE
	[dbo].[GEORULE].[GEORULEID] = @GEORULEID  

	EXEC [gissetupapp].[USP_GEORULEPROCESS_GETBYPARENTID] @GEORULEID
	EXEC [gissetupapp].[USP_GEOADDITEMREVIEW_GETBYPARENTID] @GEORULEID
	EXEC [gissetupapp].[USP_GEOFIELDMAPPING_GETBYPARENTID] @GEORULEID
	EXEC [gissetupapp].[USP_GEOFIELDMAPPINGTRANSLATE_GETBYPARENTID] @GEORULEID
END