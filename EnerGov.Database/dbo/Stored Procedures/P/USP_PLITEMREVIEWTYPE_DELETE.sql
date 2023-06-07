﻿CREATE PROCEDURE [dbo].[USP_PLITEMREVIEWTYPE_DELETE]
(
@PLITEMREVIEWTYPEID CHAR(36),
@ROWVERSION INT
)
AS
BEGIN

SET NOCOUNT ON;

EXEC [USP_PLITEMREVIEWTYPEUSERALLOW_DELETE_BYPARENTID] @PLITEMREVIEWTYPEID

SET NOCOUNT OFF;

DELETE FROM [dbo].[PLITEMREVIEWTYPE]
WHERE
	[PLITEMREVIEWTYPEID] = @PLITEMREVIEWTYPEID AND 
	[ROWVERSION]= @ROWVERSION

END