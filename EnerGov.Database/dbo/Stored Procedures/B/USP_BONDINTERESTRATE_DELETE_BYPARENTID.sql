﻿CREATE PROCEDURE [dbo].[USP_BONDINTERESTRATE_DELETE_BYPARENTID]
(
@PARENTID CHAR(36)
)
AS
DELETE FROM [dbo].[BONDINTERESTRATE]
WHERE
	[BONDINTERESTSCHEDULEID] = @PARENTID