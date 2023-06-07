﻿
CREATE PROCEDURE [dbo].[rpt_PM_SR_Permit_Reviews_Listing] 
@STARTDATE AS DATETIME,
@ENDDATE AS DATETIME


AS

SET @STARTDATE = DATEADD(dd, DATEDIFF(dd, 0, @startdate), 0)
SET @ENDDATE = DATEADD(S,-1,DATEADD(D,1,@ENDDATE)) 



Begin
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
 FROM PMPERMITADDRESS PA
	INNER JOIN MAILINGADDRESS MA ON MA.MAILINGADDRESSID = PA.MAILINGADDRESSID
 WHERE PA.MAIN = 1
)


SELECT     
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
		I.COMPLETED,
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
	END
