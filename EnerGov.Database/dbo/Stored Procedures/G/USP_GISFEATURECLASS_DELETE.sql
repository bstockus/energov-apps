﻿CREATE PROCEDURE [dbo].[USP_GISFEATURECLASS_DELETE]
(
	@GISFEATURECLASSID CHAR(36),
	@ROWVERSION INT
)
AS

SET NOCOUNT ON;

EXEC [dbo].[USP_GISFEATURECLASSSEARCHFIELD_DELETE_BYPARENTID] @GISFEATURECLASSID

SET NOCOUNT OFF;

DELETE FROM [dbo].[GISFEATURECLASS]
WHERE
	[GISFEATURECLASSID] = @GISFEATURECLASSID AND 
	[ROWVERSION]= @ROWVERSION