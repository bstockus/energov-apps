﻿CREATE PROCEDURE [dbo].[USP_QUERYACTION_DELETE]
	(
	@QUERYACTIONID CHAR(36)
)
AS


DECLARE @QUERYID CHAR(36)
SELECT @QUERYID = [QUERYID] from  [dbo].[QUERYACTION] 
WHERE [QUERYACTIONID] = @QUERYACTIONID

EXEC [dbo].[USP_MAILMERGETEMPLATEUSER_DELETE_BYPARENTID] @QUERYACTIONID, NULL -- delete mail merge users
EXEC [dbo].[USP_QUERYACTIONMAILMERGETMPL_DELETE_BYPARENTID] @QUERYACTIONID, NULL -- delete mail merge templates
EXEC [dbo].[USP_QUERYACTIONATTACHDOC_DELETE_BYPARENTID] @QUERYID, @QUERYACTIONID -- delete attach documents
EXEC [dbo].[USP_QUERYACTIONFTP_DELETE_BYPARENTID] @QUERYID, @QUERYACTIONID -- delete ftp
EXEC [dbo].[USP_QUERYACTIONPARAMETER_DELETE_BYPARENTID] @QUERYID, @QUERYACTIONID --delete fees
EXEC [dbo].[USP_QUERYACTIONHOLDTYPE_DELETE_BYPARENTID] @QUERYID,@QUERYACTIONID
EXEC [dbo].[USP_QUERYACTIONTASKUSER_DELETE_BYPARENTID] @QUERYACTIONID, NULL, NULL
EXEC [dbo].[USP_QUERYACTIONTASK_DELETE_BYPARENTID] @QUERYID, @QUERYACTIONID
EXEC [dbo].[USP_QUERYACTIONSETVALUE_DELETE_BYPARENTID]  @QUERYID, @QUERYACTIONID

DELETE FROM [dbo].[QUERYACTION]
WHERE [QUERYACTIONID] = @QUERYACTIONID