﻿CREATE PROCEDURE [dbo].[USP_ROLESCUSTOMFIELDS_DELETE_BYPARENTID]
(
	@PARENTID CHAR(36)
)
AS
DELETE FROM [dbo].[ROLESCUSTOMFIELDS]
WHERE [ROLEID] = @PARENTID