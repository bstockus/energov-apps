﻿CREATE PROCEDURE [dbo].[USP_PMPERMITVALUATIONTYPEVALGROUPX_DELETE_BYPARENTID]
(
	@PARENTID CHAR(36)
)
AS
DELETE FROM [dbo].[PMPERMITVALUATIONTYPEVALGROUPX]
WHERE
	[PMPERMITVALTYPEVALGRPID] = @PARENTID