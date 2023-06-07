﻿CREATE PROCEDURE [dbo].[USP_GEORULE_DELETE]
(
	@GEORULEID CHAR(36),
	@ROWVERSION INT
)
AS

EXEC [dbo].[USP_GEOFIELDMAPPINGTRANSLATE_DELETE_BYPARENTID] @GEORULEID
EXEC [dbo].[USP_GEOFIELDMAPPING_DELETE_BYPARENTID] @GEORULEID
EXEC [dbo].[USP_GEOADDITEMREVIEW_DELETE_BYPARENTID] @GEORULEID
EXEC [dbo].[USP_GEORULEPROCESS_DELETE_BYPARENTID] @GEORULEID

DELETE FROM [dbo].[GEORULE]
WHERE
	[GEORULEID] = @GEORULEID AND 
	[ROWVERSION]= @ROWVERSION