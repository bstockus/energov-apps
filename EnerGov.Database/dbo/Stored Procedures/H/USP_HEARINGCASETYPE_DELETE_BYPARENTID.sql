﻿CREATE PROCEDURE [dbo].[USP_HEARINGCASETYPE_DELETE_BYPARENTID]
(
	@PARENTID CHAR(36)
)
AS
DELETE FROM [dbo].[HEARINGCASETYPE]
WHERE
	[HEARINGTYPEID] = @PARENTID