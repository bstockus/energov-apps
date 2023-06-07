﻿CREATE PROCEDURE [businessmanagementsetup].[USP_ILLICENSECLASSTYPE_GETALL]
AS
BEGIN
SET NOCOUNT ON;
SELECT 
	[dbo].[ILLICENSECLASSTYPE].[ILLICENSECLASSTYPEID],
	[dbo].[ILLICENSECLASSTYPE].[NAME],
	[dbo].[ILLICENSECLASSTYPE].[DESCRIPTION],
	[dbo].[ILLICENSECLASSTYPE].[ILLICENSECLASSTYPECATEGORYID],
	[dbo].[ILLICENSECLASSTYPE].[LASTCHANGEDBY],
	[dbo].[ILLICENSECLASSTYPE].[LASTCHANGEDON],
	[dbo].[ILLICENSECLASSTYPE].[ROWVERSION]
FROM [dbo].[ILLICENSECLASSTYPE]
	ORDER BY [dbo].[ILLICENSECLASSTYPE].[NAME]
END