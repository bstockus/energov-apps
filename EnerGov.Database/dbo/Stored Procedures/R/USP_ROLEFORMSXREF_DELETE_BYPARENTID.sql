﻿CREATE PROCEDURE [dbo].[USP_ROLEFORMSXREF_DELETE_BYPARENTID]
(
	@PARENTID CHAR(36)
)
AS
DELETE FROM [dbo].[ROLEFORMSXREF]
WHERE
	[FKROLEID] = @PARENTID