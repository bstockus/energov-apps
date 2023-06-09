﻿




CREATE PROCEDURE [dbo].[rpt_PL_Plan_Detail_Report_Hearing]
@PLANID AS VARCHAR(36)
AS
SELECT PLPLAN.PLPLANID, PLPLANWFSTEP.PLPLANWFSTEPID, PLPLANWFSTEP.NAME AS WFSTEP, PLPLANWFSTEP.PRIORITYORDER AS STEPPRIORITY, 
       PLPLANWFSTEP.VERSIONNUMBER AS STEPVERSIONNUMBER, 
       PLPLANWFACTIONSTEP.PLPLANWFACTIONSTEPID, PLPLANWFACTIONSTEP.NAME AS WFACTION, 
       PLPLANWFACTIONSTEP.PRIORITYORDER AS ACTIONPRIORITY, PLPLANWFACTIONSTEP.VERSIONNUMBER AS ACTIONVERSIONNUMBER,
       PLPLANWFACTIONSTEP.PASSDESCRIPTION, PLPLANWFACTIONSTEP.FAILDESCRIPTION,
       HEARINGTYPE.NAME AS HEARINGTYPE, HEARING.LOCATION, HEARING.STARTDATE, HEARING.COMMENTS
FROM PLPLAN 
INNER JOIN PLPLANWFSTEP ON PLPLAN.PLPLANID = PLPLANWFSTEP.PLPLANID 
INNER JOIN PLPLANWFACTIONSTEP ON PLPLANWFSTEP.PLPLANWFSTEPID = PLPLANWFACTIONSTEP.PLPLANWFSTEPID 
LEFT OUTER JOIN HEARINGXREF ON HEARINGXREF.OBJECTID = PLPLANWFACTIONSTEP.PLPLANWFACTIONSTEPID
LEFT OUTER JOIN HEARING ON HEARINGXREF.HEARINGID = HEARING.HEARINGID
LEFT OUTER JOIN HEARINGTYPE ON HEARING.HEARINGTYPEID = HEARINGTYPE.HEARINGTYPEID 
WHERE PLPLANWFSTEP.WORKFLOWSTATUSID <> 3
AND PLPLANWFACTIONSTEP.WORKFLOWSTATUSID <> 3 
AND PLPLANWFACTIONSTEP.WFACTIONTYPEID = 3                      
AND PLPLAN.PLPLANID = @PLANID
					  
SELECT * FROM HEARINGXREF


