﻿CREATE PROCEDURE [dbo].[USP_WORKFLOWACTION_DELETE_BYPARENTID]
(
	@PARENTID CHAR(36)
)
AS

EXEC [dbo].[USP_WORKFLOWACTIONPARAMETER_DELETE_BYPARENTID] @PARENTID,null
EXEC [dbo].[USP_WORKFLOWACTIONHOLDTYPE_DELETE_BYPARENTID] @PARENTID, null
EXEC [dbo].[USP_WORKFLOWACTIONSETCALENDARDUEDA_DELETE_BYPARENTID] @PARENTID, null
EXEC [dbo].[USP_WORKFLOWACTIONSETVALUE_DELETE_BYPARENTID] @PARENTID, null
EXEC [dbo].[USP_MAILMERGETEMPLATEUSER_DELETE_BYPARENTID] NULL, @PARENTID
EXEC [dbo].[USP_WORKFLOWACTIONMAILMERGETMPL_DELETE_BYPARENTID] NULL, @PARENTID
EXEC [dbo].[USP_WORKFLOWACTIONATTACHDOC_DELETE_BYPARENTID] @PARENTID, NULL
EXEC [dbo].[USP_WORKFLOWACTIONFTP_DELETE_BYPARENTID] @PARENTID, null
EXEC [dbo].[USP_WORKFLOWACTIONTASKUSER_DELETE_BYPARENTID] null, @PARENTID, null
EXEC [dbo].[USP_WORKFLOWACTIONTASK_DELETE_BYPARENTID] @PARENTID, null

DELETE FROM [dbo].[WORKFLOWACTION]
WHERE [WORKFLOWID] = @PARENTID