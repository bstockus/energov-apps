﻿CREATE PROCEDURE [globalsetup].[USP_IMINSPECTIONSTATUS_GETALL]
AS
BEGIN
SET NOCOUNT ON;
SELECT 
	[dbo].[IMINSPECTIONSTATUS].[IMINSPECTIONSTATUSID],
	[dbo].[IMINSPECTIONSTATUS].[STATUSNAME],
	[dbo].[IMINSPECTIONSTATUS].[DESCRIPTION],
	[dbo].[IMINSPECTIONSTATUS].[INDICATESSUCCESS],
	[dbo].[IMINSPECTIONSTATUS].[IMINSPECTIONSTATUSENTITYID],
	[dbo].[IMINSPECTIONSTATUS].[REINSPECTIONFLAG],
	[dbo].[IMINSPECTIONSTATUS].[INVIOLATIONFLAG],
	[dbo].[IMINSPECTIONSTATUS].[OUTOFVIOLATIONFLAG],
	[dbo].[IMINSPECTIONSTATUS].[EXTEND_EXPIRE_DATE],
	[dbo].[IMINSPECTIONSTATUS].[SCHEDULEDFLAG],
	[dbo].[IMINSPECTIONSTATUS].[WAITFLAG],
	[dbo].[IMINSPECTIONSTATUS].[PARTIALPASS],
	[dbo].[IMINSPECTIONSTATUS].[CANCELLEDFLAG],
	[dbo].[IMINSPECTIONSTATUS].[DESCRIPTION_SPANISH],
	[dbo].[IMINSPECTIONSTATUS].[LASTCHANGEDBY],
	[dbo].[IMINSPECTIONSTATUS].[LASTCHANGEDON],
	[dbo].[IMINSPECTIONSTATUS].[ROWVERSION]
FROM [dbo].[IMINSPECTIONSTATUS]
ORDER BY [dbo].[IMINSPECTIONSTATUS].[STATUSNAME]
END