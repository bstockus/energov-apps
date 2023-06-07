﻿CREATE PROCEDURE [globalsetup].[USP_HOLIDAY_GETALL]
AS
BEGIN
SET NOCOUNT ON;
SELECT 
	[dbo].[HOLIDAY].[HOLIDAYID],
	[dbo].[HOLIDAY].[NAME],
	[dbo].[HOLIDAY].[HOLIDAYDATE],
	[dbo].[HOLIDAY].[LASTCHANGEDBY],
	[dbo].[HOLIDAY].[LASTCHANGEDON],
	[dbo].[HOLIDAY].[ROWVERSION]
FROM [dbo].[HOLIDAY]
 ORDER BY [dbo].[HOLIDAY].[NAME] ASC
END