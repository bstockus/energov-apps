﻿CREATE PROCEDURE [dbo].[USP_GEOFIELDMAPPING_DELETE]
(
	@GEOFIELDMAPPINGID CHAR(36)
)
AS

EXEC [dbo].[USP_GEOFIELDMAPPINGTRANSLATE_DELETE_BYGEOFIELDMAPPINGID] @GEOFIELDMAPPINGID

DELETE FROM [dbo].[GEOFIELDMAPPING]
WHERE
	[GEOFIELDMAPPINGID] = @GEOFIELDMAPPINGID