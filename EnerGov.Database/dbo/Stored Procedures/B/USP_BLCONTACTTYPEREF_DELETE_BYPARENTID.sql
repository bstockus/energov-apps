﻿CREATE PROCEDURE [dbo].[USP_BLCONTACTTYPEREF_DELETE_BYPARENTID]
(
@PARENTID CHAR(36)
)
AS
DELETE FROM [dbo].[BLCONTACTTYPEREF]
WHERE
	[OBJTYPEID] = @PARENTID