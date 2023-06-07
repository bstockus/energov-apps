﻿CREATE PROCEDURE [globalsetup].[USP_ZONE_GETALL]
AS
BEGIN
SET NOCOUNT ON;
SELECT 
	[dbo].[ZONE].[ZONEID],
	[dbo].[ZONE].[NAME],
	[dbo].[ZONE].[DESCRIPTION],
	[dbo].[ZONE].[ZONECODE],
	[dbo].[ZONE].[LASTCHANGEDBY],
	[dbo].[ZONE].[LASTCHANGEDON],
	[dbo].[ZONE].[ROWVERSION]
FROM [dbo].[ZONE]
 ORDER BY [dbo].[ZONE].[NAME] ASC
END