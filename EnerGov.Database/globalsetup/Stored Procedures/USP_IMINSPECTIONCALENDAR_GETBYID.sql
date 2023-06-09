﻿CREATE PROCEDURE [globalsetup].[USP_IMINSPECTIONCALENDAR_GETBYID]
(
	@IMINSPECTIONCALENDARID CHAR(36)
)
AS
BEGIN
SET NOCOUNT ON;
SELECT 
	[dbo].[IMINSPECTIONCALENDAR].[IMINSPECTIONCALENDARID],
	[dbo].[IMINSPECTIONCALENDAR].[NAME],
	[dbo].[IMINSPECTIONCALENDAR].[USESYSTEMHOLIDAYS],
	[dbo].[IMINSPECTIONCALENDAR].[LASTCHANGEDBY],
	[dbo].[IMINSPECTIONCALENDAR].[LASTCHANGEDON],
	[dbo].[IMINSPECTIONCALENDAR].[ROWVERSION]
FROM [dbo].[IMINSPECTIONCALENDAR]
WHERE
	[IMINSPECTIONCALENDARID] = @IMINSPECTIONCALENDARID  

	EXEC [globalsetup].[USP_IMINSPECTIONCALENDAR_IMINSPECTIONCALWORKWEEK_GETBYPARENTID] @IMINSPECTIONCALENDARID
	EXEC [globalsetup].[USP_IMINSPECTIONCALENDAR_IMINSPECTIONCALAMPM_GETBYPARENTID] @IMINSPECTIONCALENDARID
	EXEC [globalsetup].[USP_IMINSPECTIONCALENDAR_IMINSPECTIONCALHOLIDAY_GETBYPARENTID] @IMINSPECTIONCALENDARID
END