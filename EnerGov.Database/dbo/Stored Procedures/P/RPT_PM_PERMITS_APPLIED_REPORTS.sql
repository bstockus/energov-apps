﻿

CREATE PROCEDURE [dbo].[RPT_PM_PERMITS_APPLIED_REPORTS]
@STARTDATE AS DATETIME,
@ENDDATE AS DATETIME
AS
SET @ENDDATE = DATEADD(S,-1,DATEADD(D,1,@ENDDATE))
SELECT PMPERMIT.APPLYDATE, PMPERMIT.PERMITNUMBER, PMPERMITTYPE.NAME AS PERMITTYPE, PMPERMITSTATUS.NAME AS STATUS, PRPROJECT.NAME AS PROJECT, 
       PMPERMITWORKCLASS.NAME AS WORKCLASS, DISTRICT.NAME AS DISTRICT, PMPERMIT.PMPERMITID
FROM PMPERMIT 
INNER JOIN PMPERMITTYPE ON PMPERMIT.PMPERMITTYPEID = PMPERMITTYPE.PMPERMITTYPEID 
INNER JOIN PMPERMITWORKCLASS ON PMPERMIT.PMPERMITWORKCLASSID = PMPERMITWORKCLASS.PMPERMITWORKCLASSID 
INNER JOIN PMPERMITSTATUS ON PMPERMIT.PMPERMITSTATUSID = PMPERMITSTATUS.PMPERMITSTATUSID 
LEFT OUTER JOIN DISTRICT ON PMPERMIT.DISTRICTID = DISTRICT.DISTRICTID
LEFT OUTER JOIN PRPROJECTPERMIT ON PRPROJECTPERMIT.PMPERMITID = PMPERMIT.PMPERMITID 
LEFT OUTER JOIN PRPROJECT ON PRPROJECT.PRPROJECTID = PRPROJECTPERMIT.PRPROJECTID 
WHERE (PMPERMIT.APPLYDATE BETWEEN @STARTDATE AND @ENDDATE)



