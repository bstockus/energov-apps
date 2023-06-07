﻿CREATE PROCEDURE [communitydevelopmentsetup].[USP_PLPLANWORKCLASS_GETALL]
AS
BEGIN
SET NOCOUNT ON;
SELECT 
	[dbo].[PLPLANWORKCLASS].[PLPLANWORKCLASSID],
	[dbo].[PLPLANWORKCLASS].[NAME],
	[dbo].[PLPLANWORKCLASS].[DESCRIPTION],
	[dbo].[PLPLANWORKCLASS].[LASTCHANGEDBY],
	[dbo].[PLPLANWORKCLASS].[LASTCHANGEDON],
	[dbo].[PLPLANWORKCLASS].[ROWVERSION]
FROM [dbo].[PLPLANWORKCLASS] ORDER BY [dbo].[PLPLANWORKCLASS].[NAME] ASC
END