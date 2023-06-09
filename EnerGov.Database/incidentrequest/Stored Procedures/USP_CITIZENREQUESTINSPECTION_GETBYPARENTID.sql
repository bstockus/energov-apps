﻿CREATE PROCEDURE [incidentrequest].[USP_CITIZENREQUESTINSPECTION_GETBYPARENTID]
(
	@PARENTID CHAR(36)
)
AS
BEGIN
SET NOCOUNT ON;
select 
	[IMINSPECTION].[INSPECTIONNUMBER],
	[IMINSPECTIONTYPE].[NAME],
	[IMINSPECTIONSTATUS].[STATUSNAME],
	[IMINSPECTIONSTATUS].[CANCELLEDFLAG],
	[IMINSPECTIONSTATUS].[EXTEND_EXPIRE_DATE],
	[IMINSPECTIONSTATUS].[INVIOLATIONFLAG],
	[IMINSPECTIONSTATUS].[OUTOFVIOLATIONFLAG],
	[IMINSPECTIONSTATUS].[PARTIALPASS],
	[IMINSPECTIONSTATUS].[REINSPECTIONFLAG],
	[IMINSPECTIONSTATUS].[SCHEDULEDFLAG],
	[IMINSPECTIONSTATUS].[INDICATESSUCCESS],
	[IMINSPECTIONSTATUS].[WAITFLAG],	
	[IMINSPECTION].[REQUESTEDDATE],
	[IMINSPECTION].[SCHEDULEDSTARTDATE],
	[IMINSPECTION].[SCHEDULEDENDDATE],
	[IMINSPECTION].[ACTUALSTARTDATE],
	[IMINSPECTION].[ACTUALENDDATE],
	[IMINSPECTION].[IMINSPECTIONID]
from [IMINSPECTION]
	LEFT JOIN [IMINSPECTIONTYPE] ON [IMINSPECTIONTYPE].[IMINSPECTIONTYPEID] = [IMINSPECTION].[IMINSPECTIONTYPEID]
	LEFT JOIN [IMINSPECTIONSTATUS] ON [IMINSPECTIONSTATUS].[IMINSPECTIONSTATUSID] = [IMINSPECTION].[IMINSPECTIONSTATUSID]
where 
	[IMINSPECTION].IMINSPECTIONLINKID = 4  
	AND 
	LINKID = @PARENTID

END