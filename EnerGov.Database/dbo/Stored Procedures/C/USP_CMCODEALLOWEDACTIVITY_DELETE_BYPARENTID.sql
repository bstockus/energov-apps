﻿CREATE PROCEDURE [dbo].[USP_CMCODEALLOWEDACTIVITY_DELETE_BYPARENTID]
(
@PARENTID CHAR(36)
)
AS
DELETE FROM [dbo].[CMCODEALLOWEDACTIVITY]
WHERE
	[CMCASETYPEID] = @PARENTID