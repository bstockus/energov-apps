﻿CREATE PROCEDURE [businessmanagementsetup].[USP_ILLICENSESTATUS_GETALL]
AS
BEGIN
SET NOCOUNT ON;
SELECT 
	[dbo].[ILLICENSESTATUS].[ILLICENSESTATUSID],
	[dbo].[ILLICENSESTATUS].[NAME],
	[dbo].[ILLICENSESTATUS].[DESCRIPTION],
	[dbo].[ILLICENSESTATUS].[ILLICENSESTATUSSYSTEMID],
	[dbo].[ILLICENSESTATUS].[LASTCHANGEDBY],
	[dbo].[ILLICENSESTATUS].[LASTCHANGEDON],
	[dbo].[ILLICENSESTATUS].[ROWVERSION]
FROM [dbo].[ILLICENSESTATUS]
ORDER BY [dbo].[ILLICENSESTATUS].[NAME] ASC

END