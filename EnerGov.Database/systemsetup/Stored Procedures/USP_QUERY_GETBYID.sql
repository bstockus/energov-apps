﻿CREATE PROCEDURE [systemsetup].[USP_QUERY_GETBYID]
(
 @QUERYID CHAR(36)
)
AS
BEGIN
SET NOCOUNT ON;
SELECT	
		[dbo].[QUERY].[QUERYID],
		[dbo].[QUERY].[NAME],
		[dbo].[QUERY].[DESCRIPTION],
		[dbo].[QUERY].[MODULEID],
		[dbo].[QUERY].[PRIORITY],
		[dbo].[QUERY].[ISENABLED],
		[dbo].[QUERY].[LASTCHANGEDON],
		[dbo].[QUERY].[LASTCHANGEDBY],
		[dbo].[QUERY].[ROWVERSION],
		[dbo].[QUERY].[QUERYBUILDERID],
		[dbo].[QUERYBUILDER].[ROOTCLASSNAME],
		[dbo].[QUERYBUILDER].[NAME]
FROM	[dbo].[QUERY]
INNER JOIN [dbo].[QUERYBUILDER]
ON		[dbo].[QUERY].[QUERYBUILDERID] = [dbo].[QUERYBUILDER].[QUERYBUILDERID]
WHERE	[dbo].[QUERY].[QUERYID] = @QUERYID

	EXEC [systemsetup].[USP_QUERYACTION_GETBYID] @QUERYID -- Query Actions
	EXEC [systemsetup].[USP_QUERYACTIONPARAMETER_GETBYPARENTID] @QUERYID -- Action Type Compute Fees
	EXEC [systemsetup].[USP_QUERYACTIONHOLDTYPE_GETBYPARENTID] @QUERYID -- Action Type Apply Hold	
	EXEC [systemsetup].[USP_QUERYACTION_MAILMERGETEMPLATE_GETBYPARENTID] @QUERYID -- Query Email Actions
	EXEC [systemsetup].[USP_QUERYACTION_MAILMERGETEMPLATEUSER_GETBYPARENTID] @QUERYID -- Query Email Action Users
	EXEC [systemsetup].[USP_QUERYACTIONATTACHDOC_GETBYPARENTID] @QUERYID -- Action Type Attachment Document
	EXEC [systemsetup].[USP_QUERYACTIONSETVALUE_GETBYPARENTID] @QUERYID -- Action Type Set Value
	EXEC [systemsetup].[USP_QUERYACTIONFTP_GETBYPARENTID] @QUERYID -- Action Type FTP
	EXEC [systemsetup].[USP_QUERYACTIONTASK_GETBYPARENTID] @QUERYID -- Action Type TASK
	EXEC [systemsetup].[USP_QUERYACTIONTASKUSER_GETBYPARENTID] @QUERYID -- TASK USER

END