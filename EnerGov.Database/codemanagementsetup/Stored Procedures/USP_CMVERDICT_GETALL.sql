﻿CREATE PROCEDURE [codemanagementsetup].[USP_CMVERDICT_GETALL]
AS
BEGIN
SET NOCOUNT ON;
SELECT 
	[dbo].[CMVERDICT].[CMVERDICTID],
	[dbo].[CMVERDICT].[NAME],
	[dbo].[CMVERDICT].[DESCRIPTION],
	[dbo].[CMVERDICT].[LASTCHANGEDBY],
	[dbo].[CMVERDICT].[LASTCHANGEDON],
	[dbo].[CMVERDICT].[ROWVERSION]
FROM [dbo].[CMVERDICT] 
ORDER BY [dbo].[CMVERDICT].[NAME] ASC

END