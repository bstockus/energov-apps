﻿CREATE PROCEDURE [dbo].[USP_GEOFIELDMAPPING_UPDATE]
(
	@GEOFIELDMAPPINGID CHAR(36),
	@GEORULEPROCESSID CHAR(36),
	@ENTITYPROPERTY NVARCHAR(MAX),
	@GISATTRIBUTENAME NVARCHAR(250),
	@PROPERTYFRIENDLYNAME NVARCHAR(MAX),
	@ISCUSTOMFIELD BIT,
	@CUSTOMFIELDID NVARCHAR(50)
)
AS

UPDATE [dbo].[GEOFIELDMAPPING] SET
	[GEORULEPROCESSID] = @GEORULEPROCESSID,
	[ENTITYPROPERTY] = @ENTITYPROPERTY,
	[GISATTRIBUTENAME] = @GISATTRIBUTENAME,
	[PROPERTYFRIENDLYNAME] = @PROPERTYFRIENDLYNAME,
	[ISCUSTOMFIELD] = @ISCUSTOMFIELD,
	[CUSTOMFIELDID] = @CUSTOMFIELDID

WHERE
	[GEOFIELDMAPPINGID] = @GEOFIELDMAPPINGID