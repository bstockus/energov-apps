﻿CREATE PROCEDURE [systemsetup].[USP_QUERYBUILDER_GETBYID]
(
	@QUERYBUILDERID CHAR(36)
)
AS
BEGIN
SET NOCOUNT ON;
SELECT 
	[dbo].[QUERYBUILDER].[QUERYBUILDERID],
	[dbo].[QUERYBUILDER].[NAME],
	[dbo].[QUERYBUILDER].[DESCRIPTION],
	[dbo].[QUERYBUILDER].[QUERYMODULEID],
	[dbo].[QUERYBUILDER].[ROOTCLASSNAME],
	[dbo].[QUERYBUILDER].[QUERY],
	[dbo].[QUERYBUILDER].[SEARCHOBJECTID],
	[dbo].[QUERYBUILDER].[ISCUSTOM],
	[dbo].[QUERYBUILDER].[LASTCHANGEDON],
	[dbo].[QUERYBUILDER].[LASTCHANGEDBY],
	[dbo].[QUERYBUILDER].[ROWVERSION]	
FROM [dbo].[QUERYBUILDER]
WHERE
	[dbo].[QUERYBUILDER].[QUERYBUILDERID] = @QUERYBUILDERID

END