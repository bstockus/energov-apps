﻿CREATE PROCEDURE [dbo].[USP_PRPROJECTTYPE_DELETE]
(
	@PRPROJECTTYPEID CHAR(36),
	@ROWVERSION INT
)
AS
BEGIN

SET NOCOUNT ON;

EXEC [dbo].[USP_PRPROJECTTYPEPERMITLIMIT_DELETE_BYPARENTID] @PRPROJECTTYPEID
EXEC [dbo].[USP_PRPROJECTTYPEPLANORDER_DELETE_BYPARENTID] @PRPROJECTTYPEID

SET NOCOUNT OFF;

DELETE FROM [dbo].[PRPROJECTTYPE]
WHERE
	[PRPROJECTTYPEID] = @PRPROJECTTYPEID AND 
	[ROWVERSION]= @ROWVERSION

END