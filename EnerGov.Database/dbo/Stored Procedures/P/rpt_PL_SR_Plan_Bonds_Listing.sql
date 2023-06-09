﻿

CREATE PROCEDURE [dbo].[rpt_PL_SR_Plan_Bonds_Listing]
@STARTDATE AS DATETIME,
@ENDDATE AS DATETIME,
@FILTER AS VARCHAR(150)
AS

SET @STARTDATE = DATEADD(dd, DATEDIFF(dd, 0, @startdate), 0)
SET @ENDDATE = DATEADD(S,-1,DATEADD(D,1,@ENDDATE)) 

SELECT PLPLAN.PLANNUMBER, BOND.BONDNUMBER, BONDTYPE.NAME AS BONDTYPE, BOND.AMOUNT,BOND.BONDDATE AS ISSUEDATE, 
       BOND.BONDEXPIRATIONDATE AS EXPIRATIONDATE, BOND.BONDRELEASEDATE AS RELEASEDATE, BONDSTATUS.NAME AS STATUS,
       BOND.PRINCIPALID, BOND.SURETYID, BOND.OBLIGEEID, BOND.BONDID
	   ,CASE WHEN COALESCE(GE1.FIRSTNAME+GE1.LASTNAME,'')='' THEN LTRIM(RTRIM(GE1.GLOBALENTITYNAME)) ELSE + LTRIM(RTRIM(GE1.FIRSTNAME))+' ' + LTRIM(RTRIM(GE1.LASTNAME)) + ', ' +  LTRIM(RTRIM(GE1.GLOBALENTITYNAME)) END AS BOND_PRINCIPAL
	   ,CASE WHEN COALESCE(GE2.FIRSTNAME+GE2.LASTNAME,'')='' THEN LTRIM(RTRIM(GE2.GLOBALENTITYNAME)) ELSE + LTRIM(RTRIM(GE2.FIRSTNAME))+' ' + LTRIM(RTRIM(GE2.LASTNAME)) + ', ' +  LTRIM(RTRIM(GE2.GLOBALENTITYNAME)) END AS BOND_OBLIGEE
	   ,CASE WHEN COALESCE(GE3.FIRSTNAME+GE3.LASTNAME,'')='' THEN LTRIM(RTRIM(GE3.GLOBALENTITYNAME)) ELSE + LTRIM(RTRIM(GE3.FIRSTNAME))+' ' + LTRIM(RTRIM(GE3.LASTNAME)) + ', ' +  LTRIM(RTRIM(GE3.GLOBALENTITYNAME)) END AS BOND_SURETY,
--	   (SELECT R.[IMAGE] FROM RPTIMAGELIB R
--		WHERE R.IMAGENAME = 'Municipality_Logo') LOGO,
	   (SELECT CASE WHEN R.[IMAGE] IS NULL THEN 'N' ELSE 'Y' END FROM RPTIMAGELIB R
		WHERE R.IMAGENAME = 'Municipality_Logo') SHOWLOGO,
	   (SELECT R.REPORTTEXT FROM RPTTEXTLIB R
		WHERE R.TEXTNAME = 'Municipality_Name') Municipality_Name,	   
	   (SELECT R.REPORTTEXT FROM RPTTEXTLIB R
		WHERE R.TEXTNAME = 'Municipality_Page_Footer') Municipality_Page_Footer
      
FROM PLPLAN 
INNER JOIN PLPLANBOND ON PLPLANBOND.PLPLANID = PLPLAN.PLPLANID
INNER JOIN BOND ON PLPLANBOND.BONDID = BOND.BONDID 
INNER JOIN BONDTYPE ON BOND.BONDTYPEID = BONDTYPE.BONDTYPEID 
INNER JOIN BONDSTATUS ON BOND.BONDSTATUSID = BONDSTATUS.BONDSTATUSID
INNER JOIN GLOBALENTITY GE1 ON GE1.GLOBALENTITYID = BOND.PRINCIPALID
INNER JOIN GLOBALENTITY GE2 ON GE2.GLOBALENTITYID = BOND.OBLIGEEID
INNER JOIN GLOBALENTITY GE3 ON GE3.GLOBALENTITYID = BOND.SURETYID

WHERE (CASE @FILTER 
	WHEN 'EXPIRATION DATE' THEN BOND.BONDEXPIRATIONDATE
	WHEN 'ISSUE DATE' THEN BOND.BONDDATE
	WHEN 'RELEASE DATE' THEN BOND.BONDRELEASEDATE END) BETWEEN @STARTDATE AND @ENDDATE

