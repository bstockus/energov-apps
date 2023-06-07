﻿


CREATE PROCEDURE [dbo].[RPT_PL_PLAN_EXPIRED_REPORTS]
@STARTDATE AS DATETIME,
@ENDDATE AS DATETIME
AS
SET @ENDDATE = DATEADD(S,-1,DATEADD(D,1,@ENDDATE))
SELECT PLPLAN.PLPLANID, PLPLAN.PLANNUMBER, PLPLAN.EXPIREDATE, DISTRICT.NAME AS DISTRICT, PLPLANWORKCLASS.NAME AS [WORK CLASS], PLPLANSTATUS.NAME AS STATUS, 
       PLPLANTYPE.PLANNAME AS [PLAN TYPE], PRPROJECT.NAME AS PROJECT
FROM PLPLAN 
INNER JOIN PLPLANTYPE ON PLPLAN.PLPLANTYPEID = PLPLANTYPE.PLPLANTYPEID 
INNER JOIN PLPLANWORKCLASS ON PLPLAN.PLPLANWORKCLASSID = PLPLANWORKCLASS.PLPLANWORKCLASSID 
INNER JOIN PLPLANSTATUS ON PLPLAN.PLPLANSTATUSID = PLPLANSTATUS.PLPLANSTATUSID 
INNER JOIN DISTRICT ON PLPLAN.DISTRICTID = DISTRICT.DISTRICTID
LEFT OUTER JOIN PRPROJECTPLAN ON PRPROJECTPLAN.PLPLANID = PLPLAN.PLPLANID
LEFT OUTER JOIN PRPROJECT ON PRPROJECT.PRPROJECTID = PRPROJECTPLAN.PRPROJECTID 
WHERE PLPLAN.EXPIREDATE BETWEEN @STARTDATE AND @ENDDATE

