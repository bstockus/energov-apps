﻿CREATE PROCEDURE [dbo].[USP_PLPLANALLOWEDACTIVITY_DELETE_BYPARENTID]
(
	@PARENTID CHAR(36)
)
AS
DELETE FROM [dbo].[PLPLANALLOWEDACTIVITY]
WHERE
	[PLPLANTYPEID] = @PARENTID