﻿CREATE PROCEDURE [codemanagementsetup].[USP_CMCODECATEGORY_GETALL]
AS
BEGIN
SET NOCOUNT ON;
SELECT 
	[dbo].[CMCODECATEGORY].[CMCODECATEGORYID],
	[dbo].[CMCODECATEGORY].[NAME],
	[dbo].[CMCODECATEGORY].[DESCRIPTION],
	[dbo].[CMCODECATEGORY].[REPORTNAME],
	[dbo].[CMCODECATEGORY].[CMCODESYSTEMTYPEID],
	[dbo].[CMCODECATEGORY].[LASTCHANGEDBY],
	[dbo].[CMCODECATEGORY].[LASTCHANGEDON],
	[dbo].[CMCODECATEGORY].[ROWVERSION]
FROM [dbo].[CMCODECATEGORY] ORDER BY [dbo].[CMCODECATEGORY].[NAME]
END