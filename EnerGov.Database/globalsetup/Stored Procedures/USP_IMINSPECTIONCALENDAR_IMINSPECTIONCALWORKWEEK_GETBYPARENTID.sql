﻿CREATE PROCEDURE [globalsetup].[USP_IMINSPECTIONCALENDAR_IMINSPECTIONCALWORKWEEK_GETBYPARENTID]
(
	@PARENTID CHAR(36)
)
AS
BEGIN
SET NOCOUNT ON;
SELECT 
	[dbo].[IMINSPECTIONCALWORKWEEK].[IMINSPECTIONCALWORKWEEKID],
	[dbo].[IMINSPECTIONCALWORKWEEK].[IMINSPECTIONCALENDARID],
	[dbo].[IMINSPECTIONCALWORKWEEK].[DAYOFWEEK],
	[dbo].[IMINSPECTIONCALWORKWEEK].[STARTTIME],
	[dbo].[IMINSPECTIONCALWORKWEEK].[ENDTIME],
	[dbo].[IMINSPECTIONCALWORKWEEK].[ISWORKINGDAY]
FROM [dbo].[IMINSPECTIONCALWORKWEEK]
WHERE
	[dbo].[IMINSPECTIONCALWORKWEEK].[IMINSPECTIONCALENDARID] = @PARENTID  
ORDER BY
	[dbo].[IMINSPECTIONCALWORKWEEK].[DAYOFWEEK]
END