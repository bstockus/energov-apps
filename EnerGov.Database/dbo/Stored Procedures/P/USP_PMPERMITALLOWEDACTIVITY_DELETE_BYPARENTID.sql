﻿CREATE PROCEDURE [dbo].[USP_PMPERMITALLOWEDACTIVITY_DELETE_BYPARENTID]
(
	@PARENTID CHAR(36)
)
AS
DELETE FROM [dbo].[PMPERMITALLOWEDACTIVITY]
WHERE
	[PMPERMITTYPEID] = @PARENTID