﻿
CREATE PROCEDURE [dbo].[rpt_PM_SR_Permit_Inspection_History_Report2]
@PMPERMITID AS VARCHAR(36)
AS

BEGIN

;WITH OWN_CTE
AS
(SELECT DISTINCT
	 PC.PMPERMITID
	,NULLIF(GE.GLOBALENTITYNAME,'') AS COMPANY_NAME
	,(ISNULL(GE.FIRSTNAME,'') + ' ' + ISNULL(GE.LASTNAME,'')) AS FULL_NAME
 FROM PMPERMITCONTACT PC
	INNER JOIN LANDMANAGEMENTCONTACTTYPE CT ON CT.LANDMANAGEMENTCONTACTTYPEID = PC.LANDMANAGEMENTCONTACTTYPEID
	INNER JOIN GLOBALENTITY GE ON GE.GLOBALENTITYID = PC.GLOBALENTITYID
 WHERE PC.PMPERMITID = @PMPERMITID
	AND CT.NAME LIKE '%OWNER%'
), 

ADDRESS_CTE AS
(SELECT PA.PMPERMITID, PA.MAIN, MA.ADDRESSTYPE, RTRIM(MA.ADDRESSLINE1 + ' ' +	LTRIM(MA.PREDIRECTION + ' ') + LTRIM(MA.ADDRESSLINE2 + ' ') + 
	LTRIM(MA.STREETTYPE + ' ') + LTRIM(MA.POSTDIRECTION + ' ') + LTRIM(MA.UNITORSUITE + ' ')  + LTRIM(MA.ADDRESSLINE3)) ADDRESS_LINE1,
	RTRIM(CASE WHEN RTRIM(LTRIM(MA.CITY)) = '' THEN '' ELSE LTRIM(MA.CITY + ', ' ) END + LTRIM(MA.STATE + ' ') + MA.POSTALCODE) ADDRESS_LINE2
FROM PMPERMITADDRESS PA
INNER JOIN MAILINGADDRESS MA ON PA.MAILINGADDRESSID = MA.MAILINGADDRESSID
WHERE PA.PMPERMITID = @PMPERMITID
	AND PA.MAIN = 1)

SELECT DISTINCT
	PMPERMIT.PERMITNUMBER, 
	IMINSPECTION.INSPECTIONNUMBER, 
	IMINSPECTIONTYPE.NAME AS INSPTYPE, 
    IMINSPECTIONSTATUS.STATUSNAME AS INSPECTIONSTATUS, 
	PMPERMITSTATUS.NAME AS PERMITSTATUS, 
	PMPERMITWORKCLASS.NAME AS WORKCLASS, 
    PMPERMITTYPE.NAME AS PERMITTYPE, 
	PMPERMIT.APPLYDATE, 
	PMPERMIT.EXPIREDATE, 
	PMPERMIT.ISSUEDATE, 
	PMPERMIT.PMPERMITID, 
	PMPERMIT.IVRNUMBER, -- MB ADDED TO STANDARD REPORT PER COMMON REQUEST BY CLIENTS
    IMINSPECTION.SCHEDULEDSTARTDATE,
	IMINSPECTION.ACTUALSTARTDATE, -- MB ADDED TO STANDARD REPORT PER COMMON REQUEST BY CLIENTS
	IMINSPECTION.COMPLETE, 
	IMINSPECTION.ISREINSPECTION, 
	IMINSPECTION.IMINSPECTIONID, 
	IMINSPECTION.PARENTINSPECTIONNUMBER,
	IMINSPECTION.COMMENTS,
	USERS.FNAME, 
    USERS.LNAME, 
	WORKFLOWSTATUS.NAME AS WORKFLOWSTATUS,
	O.NAME AS OWNER_NAME, -- MB ADDED TO STANDARD REPORT PER COMMON REQUEST BY CLIENTS
	p.SUBDIVISION, P.PARCELNUMBER,
	(SELECT R.[IMAGE] FROM RPTIMAGELIB R
		WHERE R.IMAGENAME = 'Municipality_Logo') LOGO,
	(SELECT CASE WHEN R.[IMAGE] IS NULL THEN 'N' ELSE 'Y' END FROM RPTIMAGELIB R
		WHERE R.IMAGENAME = 'Municipality_Logo') SHOWLOGO,
	(SELECT R.REPORTTEXT FROM RPTTEXTLIB R
		WHERE R.TEXTNAME = 'Municipality_Name') Municipality_Name,	   
	(SELECT R.REPORTTEXT FROM RPTTEXTLIB R
		WHERE R.TEXTNAME = 'Municipality_Page_Footer') Municipality_Page_Footer,
	MA.ADDRESS_LINE1, MA.ADDRESS_LINE2
FROM IMINSPECTION 
	INNER JOIN IMINSPECTIONACTREF ON IMINSPECTION.IMINSPECTIONID = IMINSPECTIONACTREF.IMINSPECTIONID 
	INNER JOIN IMINSPECTIONTYPE ON IMINSPECTION.IMINSPECTIONTYPEID = IMINSPECTIONTYPE.IMINSPECTIONTYPEID 
	INNER JOIN IMINSPECTIONSTATUS ON IMINSPECTION.IMINSPECTIONSTATUSID = IMINSPECTIONSTATUS.IMINSPECTIONSTATUSID 
	INNER JOIN PMPERMITWFACTIONSTEP ON IMINSPECTIONACTREF.OBJECTID = PMPERMITWFACTIONSTEP.PMPERMITWFACTIONSTEPID 
	INNER JOIN PMPERMITWFSTEP ON PMPERMITWFACTIONSTEP.PMPERMITWFSTEPID = PMPERMITWFSTEP.PMPERMITWFSTEPID 
	INNER JOIN PMPERMIT ON PMPERMITWFSTEP.PMPERMITID = PMPERMIT.PMPERMITID
	INNER JOIN PMPERMITTYPE ON PMPERMIT.PMPERMITTYPEID = PMPERMITTYPE.PMPERMITTYPEID 
	INNER JOIN PMPERMITWORKCLASS ON PMPERMIT.PMPERMITWORKCLASSID = PMPERMITWORKCLASS.PMPERMITWORKCLASSID 
	INNER JOIN PMPERMITSTATUS ON PMPERMIT.PMPERMITSTATUSID = PMPERMITSTATUS.PMPERMITSTATUSID 
	LEFT JOIN IMINSPECTORREF ON IMINSPECTION.IMINSPECTIONID = IMINSPECTORREF.INSPECTIONID AND IMINSPECTORREF.BPRIMARY = 1
	LEFT JOIN USERS ON IMINSPECTORREF.USERID = USERS.SUSERGUID 
	LEFT JOIN WORKFLOWSTATUS ON PMPERMITWFACTIONSTEP.WORKFLOWSTATUSID = WORKFLOWSTATUS.WORKFLOWSTATUSID
	LEFT OUTER JOIN (SELECT DISTINCT N.PMPERMITID,
						STUFF((SELECT ', ' + (ISNULL(N1.COMPANY_NAME, N1.FULL_NAME)) AS OWN_NAME
							   FROM OWN_CTE N1
							   WHERE N1.PMPERMITID = N.PMPERMITID
							   ORDER BY OWN_NAME
							   FOR XML PATH(''), root('MyString'), type).value('/MyString[1]','varchar(max)'),1,2,'') AS NAME
					 FROM OWN_CTE N
					 )O ON O.PMPERMITID = PMPERMIT.PMPERMITID
	LEFT OUTER JOIN PMPERMITPARCEL PC ON PC.PMPERMITID = PMPERMIT.PMPERMITID
	LEFT OUTER JOIN PARCEL P ON PC.PARCELID = P.PARCELID
	LEFT JOIN ADDRESS_CTE MA ON PMPERMIT.PMPERMITID = MA.PMPERMITID
WHERE PMPERMIT.PMPERMITID = @PMPERMITID 

END
