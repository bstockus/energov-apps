﻿CREATE PROCEDURE [inspectiondashboard].[USP_STATUS_INFO_FOR_INSPECTION_SCHEDULED_STATUS]
	@ID CHAR(36)
AS

SET NOCOUNT ON;

SELECT 
	[dbo].[IMINSPECTIONSTATUS].[IMINSPECTIONSTATUSENTITYID],
	[dbo].[IMINSPECTIONSTATUS].[IMINSPECTIONSTATUSID],
	[dbo].[IMINSPECTIONSTATUS].[SCHEDULEDFLAG],
	[dbo].[IMINSPECTIONSTATUS].[STATUSNAME]
FROM [dbo].[IMINSPECTIONSTATUS]
WHERE [dbo].[IMINSPECTIONSTATUS].[IMINSPECTIONSTATUSENTITYID] = 
	(
		SELECT TOP 1 SECONDARY_STATUS.[IMINSPECTIONSTATUSENTITYID]
		FROM [dbo].[IMINSPECTIONSTATUS] SECONDARY_STATUS
		WHERE SECONDARY_STATUS.[IMINSPECTIONSTATUSID] = @ID
	) AND
	[dbo].[IMINSPECTIONSTATUS].[SCHEDULEDFLAG] = 1