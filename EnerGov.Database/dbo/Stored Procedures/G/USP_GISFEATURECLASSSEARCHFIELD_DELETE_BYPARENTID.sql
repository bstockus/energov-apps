﻿CREATE PROCEDURE [dbo].[USP_GISFEATURECLASSSEARCHFIELD_DELETE_BYPARENTID]
(
	@PARENTID CHAR(36)
)
AS
DELETE FROM [dbo].[GISFEATURECLASSSEARCHFIELD]
WHERE [dbo].[GISFEATURECLASSSEARCHFIELD].[GISFEATURECLASSID] = @PARENTID