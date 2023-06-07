﻿CREATE PROCEDURE [systemsetup].[USP_MAILMERGETEMPLATE_GETBYIDS]
(
	@MAILMERGETEMPLATEIDLIST RecordIDs READONLY
)
AS
BEGIN
	SET NOCOUNT ON;
	SELECT
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
	WHERE [dbo].[MAILMERGETEMPLATE].[MAILMERGETEMPLATEID] IN (SELECT [RECORDID] FROM @MAILMERGETEMPLATEIDLIST)
END