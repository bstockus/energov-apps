﻿CREATE PROCEDURE [dbo].[USP_EXAMTYPERULE_DELETE_BYPARENTID]
(
	@PARENTID CHAR(36)
)
AS
DELETE FROM [dbo].[EXAMTYPERULE]
WHERE
	[EXAMTYPEID] = @PARENTID