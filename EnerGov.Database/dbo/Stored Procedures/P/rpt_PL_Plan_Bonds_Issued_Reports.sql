﻿


CREATE PROCEDURE [dbo].[rpt_PL_Plan_Bonds_Issued_Reports]
@STARTDATE AS DATETIME,
@ENDDATE AS DATETIME
AS
SET @ENDDATE = DATEADD(S,-1,DATEADD(D,1,@ENDDATE))
SELECT BOND.BONDNUMBER, BONDTYPE.NAME AS BONDTYPE, BOND.AMOUNT, BOND.BONDDATE AS ISSUEDATE, BOND.BONDEXPIRATIONDATE AS EXPIRATIONDATE, 
       BOND.BONDRELEASEDATE AS RELEASEDATE, BONDSTATUS.NAME AS STATUS, BOND.PRINCIPALID, BOND.SURETYID, BOND.OBLIGEEID, BOND.BONDID, 
       PLPLAN.PLANNUMBER
FROM BONDTYPE 
INNER JOIN BOND ON BONDTYPE.BONDTYPEID = BOND.BONDTYPEID 
INNER JOIN BONDSTATUS ON BOND.BONDSTATUSID = BONDSTATUS.BONDSTATUSID 
INNER JOIN PLPLANBOND ON BOND.BONDID = PLPLANBOND.BONDID 
INNER JOIN PLPLAN ON PLPLANBOND.PLPLANID = PLPLAN.PLPLANID
WHERE (Bond.BondDate BETWEEN @STARTDATE AND @ENDDATE)


