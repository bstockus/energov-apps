﻿CREATE PROCEDURE [dbo].[USP_ILLICENSEALLOWEDACTIVITY_DELETE_BYPARENTID]
(
@PARENTID CHAR(36)
)
AS
DELETE FROM [dbo].[ILLICENSEALLOWEDACTIVITY]
WHERE
	[ILLICENSETYPEID] = @PARENTID