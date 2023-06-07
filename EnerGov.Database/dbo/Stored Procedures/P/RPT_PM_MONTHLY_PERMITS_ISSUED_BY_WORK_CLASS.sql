﻿

CREATE PROCEDURE [dbo].[RPT_PM_MONTHLY_PERMITS_ISSUED_BY_WORK_CLASS]
@STARTDATE AS DATETIME,
@ENDDATE AS DATETIME
AS
SET @ENDDATE = DATEADD(S,-1,DATEADD(D,1,@ENDDATE))

SELECT PMPERMIT.PMPERMITID, PMPERMIT.ISSUEDATE, PMPERMITTYPE.NAME AS PermitType, PMPERMITWORKCLASS.NAME AS PermitWorkClass
FROM PMPERMIT 
INNER JOIN PMPERMITTYPE ON PMPERMIT.PMPERMITTYPEID = PMPERMITTYPE.PMPERMITTYPEID
INNER JOIN PMPERMITWORKCLASS ON PMPERMIT.PMPERMITWORKCLASSID = PMPERMITWORKCLASS.PMPERMITWORKCLASSID
WHERE PMPERMIT.ISSUEDATE BETWEEN @STARTDATE AND @ENDDATE


