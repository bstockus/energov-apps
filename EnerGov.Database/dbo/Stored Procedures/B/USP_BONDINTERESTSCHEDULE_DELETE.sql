﻿CREATE PROCEDURE [dbo].[USP_BONDINTERESTSCHEDULE_DELETE]
(
	@BONDINTERESTSCHEDULEID CHAR(36),
	@ROWVERSION INT
)
AS

SET NOCOUNT ON;

EXEC [dbo].[USP_BONDGLACCOUNTXREF_DELETE_BYPARENTID] @BONDINTERESTSCHEDULEID

EXEC [dbo].[USP_BONDINTERESTRATE_DELETE_BYPARENTID] @BONDINTERESTSCHEDULEID

SET NOCOUNT OFF;

DELETE FROM [dbo].[BONDINTERESTSCHEDULE]
WHERE
	[BONDINTERESTSCHEDULEID] = @BONDINTERESTSCHEDULEID AND 
	[ROWVERSION]= @ROWVERSION