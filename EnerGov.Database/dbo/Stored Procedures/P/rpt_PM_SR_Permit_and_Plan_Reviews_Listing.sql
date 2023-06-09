﻿
CREATE PROCEDURE [dbo].[rpt_PM_SR_Permit_and_Plan_Reviews_Listing] 
@STARTDATE AS DATETIME,
@ENDDATE AS DATETIME

AS

SET @STARTDATE = DATEADD(dd, DATEDIFF(dd, 0, @startdate), 0)
SET @ENDDATE = DATEADD(S,-1,DATEADD(D,1,@ENDDATE)) 

BEGIN

;WITH ADDRESS_CTE
AS
(SELECT DISTINCT
	 PA.PMPERMITID
	,MA.ADDRESSLINE1
	,MA.ADDRESSLINE2
	,MA.ADDRESSLINE3
	,MA.PREDIRECTION
	,MA.POSTDIRECTION
	,MA.STREETTYPE
	,MA.UNITORSUITE
	,MA.CITY
	,MA.STATE
	,MA.POSTALCODE
	,MA.PARCELNUMBER
 FROM PMPERMITADDRESS PA
	INNER JOIN MAILINGADDRESS MA ON MA.MAILINGADDRESSID = PA.MAILINGADDRESSID
 WHERE PA.MAIN = 1
)
SELECT 'PM' AS PMorPL,
		P.PERMITNUMBER AS PermitNumber, 
		ST.TYPENAME AS SubmittalType, 
		IT.NAME AS ReviewType, 
        D.NAME AS Department, 
		I.COMMENTS AS ReviewComments, 
		IRS.NAME AS ReviewStatus, 
        I.ASSIGNEDDATE AS AssignedDate, 
		I.DUEDATE AS DueDate, 
		I.COMPLETEDATE,
		PLWFAS.VERSIONNUMBER PRIORITYORDER,
		I.COMPLETED,
		CASE I.NOTREQUIRED WHEN NULL THEN 1 WHEN 1 THEN 0 ELSE 1 END NOTREQUIRED,
		U.FNAME + ' ' + U.LNAME AS AssignedUser,
		A.ADDRESSLINE1 AS AddressLine1,
		A.ADDRESSLINE2 AS AddressLine2,
		A.ADDRESSLINE3 AS AddressLine3,
		A.PREDIRECTION AS PreDirection,
		A.POSTDIRECTION AS PostDirection,
		A.STREETTYPE AS StreetType,
		A.UNITORSUITE AS UnitOrSuite,
		A.CITY AS City,
		A.STATE AS State,
		A.POSTALCODE AS PostalCode,
		A.PARCELNUMBER,
		CASE WHEN PLWFAS.VERSIONNUMBER > 1 THEN 'Yes' ELSE 'No' END AS RESUBMITTAL,
		--(SELECT R.[IMAGE] FROM RPTIMAGELIB R
		--WHERE R.IMAGENAME = 'Municipality_Logo') LOGO,
	   (SELECT CASE WHEN R.[IMAGE] IS NULL THEN 'N' ELSE 'Y' END FROM RPTIMAGELIB R
		WHERE R.IMAGENAME = 'Municipality_Logo') SHOWLOGO,
	   (SELECT R.REPORTTEXT FROM RPTTEXTLIB R
		WHERE R.TEXTNAME = 'Municipality_Name') Municipality_Name,	   
	   (SELECT R.REPORTTEXT FROM RPTTEXTLIB R
		WHERE R.TEXTNAME = 'Municipality_Page_Footer') Municipality_Page_Footer
		
FROM PMPERMIT P
	INNER JOIN PLSUBMITTAL S ON S.PMPERMITID = P.PMPERMITID 
	INNER JOIN PLITEMREVIEW I ON S.PLSUBMITTALID = I.PLSUBMITTALID 
	INNER JOIN PLITEMREVIEWTYPE IT ON I.PLITEMREVIEWTYPEID = IT.PLITEMREVIEWTYPEID 
	INNER JOIN DEPARTMENT D ON IT.DEPARTMENTID = D.DEPARTMENTID 
	INNER JOIN USERS U ON I.ASSIGNEDUSERID = U.SUSERGUID 
	INNER JOIN PLSUBMITTALTYPE ST ON S.PLSUBMITTALTYPEID = ST.PLSUBMITTALTYPEID 
	INNER JOIN PLITEMREVIEWSTATUS IRS ON I.PLITEMREVIEWSTATUSID = IRS.PLITEMREVIEWSTATUSID
	LEFT OUTER JOIN ADDRESS_CTE A ON A.PMPERMITID = P.PMPERMITID
	LEFT JOIN PMPERMITWFACTIONSTEP PLWFAS ON S.PMPERMITWFACTIONSTEPID = PLWFAS.PMPERMITWFACTIONSTEPID
WHERE I.DUEDATE BETWEEN @STARTDATE AND @ENDDATE

UNION

SELECT 'PL',
	PL.PLANNUMBER AS PlanNumber, 
	PLSUBMITTALTYPE.TYPENAME AS SubmittalType, 
	PLITEMREVIEWTYPE.NAME AS ReviewType,
	DEPARTMENT.NAME AS Department, 
	PLITEMREVIEW.COMMENTS AS ReviewComments, 
	PLITEMREVIEWSTATUS.NAME AS ReviewStatus, 
	PLITEMREVIEW.ASSIGNEDDATE AS AssignedDate, 
	PLITEMREVIEW.DUEDATE AS DueDate,
	PLITEMREVIEW.COMPLETEDATE,
	PLPLANWFACTIONSTEP.VERSIONNUMBER, 	 
	PLITEMREVIEW.COMPLETED,
	CASE PLITEMREVIEW.NOTREQUIRED WHEN NULL THEN 1 WHEN 1 THEN 0 ELSE 1 END NOTREQUIRED,
	--CASE PLITEMREVIEW.NOTREQUIRED WHEN 1 THEN 'No' WHEN 2 THEN 'Yes' ELSE 'Yes' END AS NOTREQUIRED,
	USERS.FNAME + ' ' + USERS.LNAME AS AssignedUser,
	TB_ADDR.ADDRESSLINE1, 
	TB_ADDR.ADDRESSLINE2, 
	TB_ADDR.ADDRESSLINE3, 
	TB_ADDR.PREDIRECTION, 
	TB_ADDR.POSTDIRECTION, 
	TB_ADDR.STREETTYPE, 
	TB_ADDR.UNITORSUITE,
	TB_ADDR.CITY, 
	TB_ADDR.STATE, 
	TB_ADDR.POSTALCODE,
	TB_ADDR.PARCELNUMBER, 
	CASE WHEN PLPLANWFACTIONSTEP.VERSIONNUMBER > 1 THEN 'Yes' ELSE 'No' END AS RESUBMITTAL,
	--(SELECT R.[IMAGE] FROM RPTIMAGELIB R	WHERE R.IMAGENAME = 'Municipality_Logo') LOGO,
	(SELECT CASE WHEN R.[IMAGE] IS NULL THEN 'N' ELSE 'Y' END FROM RPTIMAGELIB R	WHERE R.IMAGENAME = 'Municipality_Logo') SHOWLOGO,
	(SELECT R.REPORTTEXT FROM RPTTEXTLIB R WHERE R.TEXTNAME = 'Municipality_Name') Municipality_Name,	   
	(SELECT R.REPORTTEXT FROM RPTTEXTLIB R WHERE R.TEXTNAME = 'Municipality_Page_Footer') Municipality_Page_Footer
FROM PLPLAN AS PL 
INNER JOIN PLPLANWFSTEP ON PL.PLPLANID = PLPLANWFSTEP.PLPLANID 
INNER JOIN PLPLANWFACTIONSTEP ON PLPLANWFSTEP.PLPLANWFSTEPID = PLPLANWFACTIONSTEP.PLPLANWFSTEPID 
INNER JOIN PLSUBMITTAL ON PLPLANWFACTIONSTEP.PLPLANWFACTIONSTEPID = PLSUBMITTAL.PLPLANWFACTIONSTEPID 
INNER JOIN PLITEMREVIEW ON PLSUBMITTAL.PLSUBMITTALID = PLITEMREVIEW.PLSUBMITTALID 
INNER JOIN PLITEMREVIEWTYPE ON PLITEMREVIEW.PLITEMREVIEWTYPEID = PLITEMREVIEWTYPE.PLITEMREVIEWTYPEID 
INNER JOIN DEPARTMENT ON PLITEMREVIEWTYPE.DEPARTMENTID = DEPARTMENT.DEPARTMENTID 
INNER JOIN USERS ON PLITEMREVIEW.ASSIGNEDUSERID = USERS.SUSERGUID 
INNER JOIN PLSUBMITTALTYPE ON PLSUBMITTAL.PLSUBMITTALTYPEID = PLSUBMITTALTYPE.PLSUBMITTALTYPEID 
INNER JOIN PLITEMREVIEWSTATUS ON PLITEMREVIEW.PLITEMREVIEWSTATUSID = PLITEMREVIEWSTATUS.PLITEMREVIEWSTATUSID
LEFT OUTER JOIN ( SELECT PLPLANADDRESS.PLPLANID, MAILINGADDRESS.MAILINGADDRESSID, MAILINGADDRESS.PARCELNUMBER,
                         MAILINGADDRESS.ADDRESSLINE1, MAILINGADDRESS.ADDRESSLINE2, MAILINGADDRESS.ADDRESSLINE3, MAILINGADDRESS.CITY, MAILINGADDRESS.STATE, MAILINGADDRESS.POSTALCODE,
                         MAILINGADDRESS.PREDIRECTION, MAILINGADDRESS.POSTDIRECTION, MAILINGADDRESS.STREETTYPE, MAILINGADDRESS.UNITORSUITE
                  FROM PLPLANADDRESS 
                  INNER JOIN MAILINGADDRESS ON PLPLANADDRESS.MAILINGADDRESSID = MAILINGADDRESS.MAILINGADDRESSID
                  WHERE PLPLANADDRESS.MAIN = 1
                ) AS TB_ADDR ON PL.PLPLANID = TB_ADDR.PLPLANID
WHERE PLITEMREVIEW.DUEDATE BETWEEN @STARTDATE AND @ENDDATE

END

