﻿CREATE PROCEDURE [energovnotifications].[USP_CALENDARHOLIDAY_GETALL]
              
AS
BEGIN
SET NOCOUNT ON;
	SELECT
	[dbo].[HOLIDAY].[HOLIDAYID],
	[dbo].[HOLIDAY].[NAME],
	[dbo].[HOLIDAY].[HOLIDAYDATE],
	[dbo].[HOLIDAY].[ROWVERSION]
	FROM [dbo].[HOLIDAY]		
END