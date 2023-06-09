﻿CREATE PROCEDURE [dbo].[USP_PLSUBMITTALTYPE_DELETE]
(
 @PLSUBMITTALTYPEID CHAR(36),
 @ROWVERSION INT	
)
AS
BEGIN
SET NOCOUNT ON;

EXEC [dbo].[USP_PLSUBMITTALTYPEITEMREVIEWTYPEX_DELETE_BYPARENTID] @PLSUBMITTALTYPEID
EXEC [dbo].[USP_SYSTEMTASKTYPESUBMITTALTYPE_DELETE_BYPARENTID] @PLSUBMITTALTYPEID
EXEC [dbo].[USP_WFACTION_DELETE_BY_SUBMITTALTYPEID] @PLSUBMITTALTYPEID

SET NOCOUNT OFF;

DELETE FROM [dbo].[PLSUBMITTALTYPE]
WHERE [dbo].[PLSUBMITTALTYPE].[PLSUBMITTALTYPEID] = @PLSUBMITTALTYPEID
AND [dbo].[PLSUBMITTALTYPE].[ROWVERSION] = @ROWVERSION
END