﻿CREATE PROCEDURE [dbo].[USP_GEOFIELDMAPPING_INSERT]
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

INSERT INTO [dbo].[GEOFIELDMAPPING](
	[GEOFIELDMAPPINGID],
	[GEORULEPROCESSID],
	[ENTITYPROPERTY],
	[GISATTRIBUTENAME],
	[PROPERTYFRIENDLYNAME],
	[ISCUSTOMFIELD],
	[CUSTOMFIELDID]
)

VALUES
(
	@GEOFIELDMAPPINGID,
	@GEORULEPROCESSID,
	@ENTITYPROPERTY,
	@GISATTRIBUTENAME,
	@PROPERTYFRIENDLYNAME,
	@ISCUSTOMFIELD,
	@CUSTOMFIELDID
)