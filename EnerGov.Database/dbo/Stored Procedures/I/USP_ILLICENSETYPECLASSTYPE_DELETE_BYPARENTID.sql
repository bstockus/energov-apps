﻿CREATE PROCEDURE [dbo].[USP_ILLICENSETYPECLASSTYPE_DELETE_BYPARENTID]
(
@PARENTID CHAR(36)
)
AS
DELETE FROM [dbo].[ILLICENSETYPECLASSTYPE]
WHERE
	[ILLICENSETYPEID] = @PARENTID