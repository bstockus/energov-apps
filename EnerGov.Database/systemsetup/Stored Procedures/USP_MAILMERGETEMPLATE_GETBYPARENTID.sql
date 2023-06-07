﻿CREATE PROCEDURE [systemsetup].[USP_MAILMERGETEMPLATE_GETBYPARENTID]
(
	@WORKFLOWID CHAR(36)
)
AS
BEGIN
	SET NOCOUNT ON;
	SELECT 
		[dbo].[WORKFLOWACTION].[WORKFLOWACTIONID],
		[dbo].[MAILMERGETEMPLATE].[MAILMERGETEMPLATEID],
		[dbo].[MAILMERGETEMPLATE].[SENDFROM],
		[dbo].[MAILMERGETEMPLATE].[SENDTO],		
		[dbo].[MAILMERGETEMPLATE].[CCTO],
		[dbo].[MAILMERGETEMPLATE].[BCCTO],
		[dbo].[MAILMERGETEMPLATE].[SUBJECT],
		[dbo].[MAILMERGETEMPLATE].[BODY],
		[dbo].[MAILMERGETEMPLATE].[ISHTML],
		[dbo].[MAILMERGETEMPLATE].[RPTREPORTID]
	FROM [dbo].[MAILMERGETEMPLATE]
	INNER JOIN [dbo].[WORKFLOWACTIONMAILMERGETMPL] on [dbo].[MAILMERGETEMPLATE].[MAILMERGETEMPLATEID] = [dbo].[WORKFLOWACTIONMAILMERGETMPL].[MAILMERGETEMPLATEID]	
	INNER JOIN [dbo].[WORKFLOWACTION] on [dbo].[WORKFLOWACTIONMAILMERGETMPL].[WORKFLOWACTIONID] =[dbo].[WORKFLOWACTION].[WORKFLOWACTIONID]
	WHERE [dbo].[WORKFLOWACTION].[WORKFLOWID] = @WORKFLOWID
	
END