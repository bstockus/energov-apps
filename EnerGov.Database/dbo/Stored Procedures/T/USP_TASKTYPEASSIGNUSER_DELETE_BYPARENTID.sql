﻿CREATE PROCEDURE [dbo].[USP_TASKTYPEASSIGNUSER_DELETE_BYPARENTID]
(
	@PARENTID CHAR(36)
)
AS

DELETE FROM [dbo].[TASKTYPEASSIGNUSER]
WHERE
	[TASKTYPEID] = @PARENTID