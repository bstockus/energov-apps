﻿CREATE PROCEDURE [dbo].[USP_EXAMSITTINGDATE_DELETE_BYPARENTID]
(
	@PARENTID CHAR(36)
)
AS
DELETE FROM [dbo].[EXAMSITTINGDATE]
WHERE
	[EXAMOBJECTID] = @PARENTID