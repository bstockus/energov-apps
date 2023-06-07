﻿CREATE PROCEDURE [communitydevelopmentsetup].[USP_IPCONDITIONCATEGORY_GETALL]
AS
BEGIN
SET NOCOUNT ON;
SELECT 
	[dbo].[IPCONDITIONCATEGORY].[IPCONDITIONCATEGORYID],
	[dbo].[IPCONDITIONCATEGORY].[NAME],
	[dbo].[IPCONDITIONCATEGORY].[DESCRIPTION],
	[dbo].[IPCONDITIONCATEGORY].[PREFIX],
	[dbo].[IPCONDITIONCATEGORY].[LASTCHANGEDBY],
	[dbo].[IPCONDITIONCATEGORY].[LASTCHANGEDON],
	[dbo].[IPCONDITIONCATEGORY].[ROWVERSION]
FROM [dbo].[IPCONDITIONCATEGORY] ORDER BY [dbo].[IPCONDITIONCATEGORY].[NAME]

END