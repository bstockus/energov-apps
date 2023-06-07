﻿CREATE PROCEDURE [dbo].[USP_CMCODE_DELETE]
(
	@CMCODEID CHAR(36),
	@ROWVERSION INT
)
AS

SET NOCOUNT ON;

EXEC [dbo].[USP_CMCODEREVISION_DELETE_BYPARENTID] @CMCODEID
EXEC [dbo].[USP_WFACTION_CMCODE_DELETE_BYPARENTID] @CMCODEID

SET NOCOUNT OFF;

DELETE FROM [dbo].[CMCODE]
WHERE
	[CMCODEID] = @CMCODEID AND 
	[ROWVERSION]= @ROWVERSION