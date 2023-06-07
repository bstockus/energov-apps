﻿
/*
exec rpt_IM_SR_Inspection_Listing '20160101', '20180101', 'ACTUAL START DATE'
*/

CREATE PROCEDURE [dbo].[rpt_IM_SR_Inspection_Listing]
@STARTDATE AS DATETIME,
@ENDDATE AS DATETIME,
@FILTER AS VARCHAR(150)
AS

SET @STARTDATE=DATEADD(dd,DATEDIFF(dd,0,@STARTDATE),0)
SET @ENDDATE = DATEADD(S,-1,DATEADD(D,1,@ENDDATE))

SELECT IMINSPECTION.IMINSPECTIONID, SUM(CACOMPUTEDFEE.COMPUTEDAMOUNT) FEETOTAL
INTO #FEES
FROM IMINSPECTION 
INNER JOIN IMINSPECTIONFEE ON IMINSPECTION.IMINSPECTIONID = IMINSPECTIONFEE.IMINSPECTIONID
INNER JOIN CACOMPUTEDFEE ON CACOMPUTEDFEE.CACOMPUTEDFEEID = IMINSPECTIONFEE.CACOMPUTEDFEEID AND CACOMPUTEDFEE.CASTATUSID NOT IN (5,10) --VOID, DELETED
WHERE (CASE @FILTER 
	     WHEN 'ACTUAL START DATE' THEN IMINSPECTION.ACTUALSTARTDATE
	     WHEN 'ACTUAL END DATE' THEN IMINSPECTION.ACTUALENDDATE
		 WHEN 'SCHEDULED START DATE' THEN IMINSPECTION.SCHEDULEDSTARTDATE
		 WHEN 'SCHEDULED END DATE' THEN IMINSPECTION.SCHEDULEDENDDATE END)
         BETWEEN @STARTDATE AND @ENDDATE
GROUP BY IMINSPECTION.IMINSPECTIONID;

CREATE INDEX TEMP1 ON #FEES (IMINSPECTIONID);

SELECT COALESCE (BLLICENSE.LICENSENUMBER, CMCODECASE.CASENUMBER, PLPLAN.PLANNUMBER, PMPERMIT.PERMITNUMBER, CITIZENREQUEST.REQUESTNUMBER, 'N/A') AS CaseNumber, 
       COALESCE (BLLICENSETYPE.NAME, CMCASETYPE.NAME, PLPLANTYPE.PLANNAME, PMPERMITTYPE.NAME, CITIZENREQUESTTYPE.NAME, 'N/A') AS CaseType, 
                IMINSPECTION.IMINSPECTIONID, IMINSPECTION.INSPECTIONNUMBER, IMINSPECTION.COMPLETE AS Complete, IMINSPECTION.ACTUALSTARTDATE, IMINSPECTION.ACTUALENDDATE, IMINSPECTION.SCHEDULEDSTARTDATE, 
				IMINSPECTION.SCHEDULEDENDDATE, IMINSPECTION.IMINSPECTIONLINKID, IMINSPECTION.LINKNUMBER, IMINSPECTIONLINK.NAME AS ENTITY, IMINSPECTION.COMMENTS, IMINSPECTION.REQUESTEDDATE, IMINSPECTION.CREATEDATE,
				IMINSPECTION.ISREINSPECTION,
				PARCEL.PARCELNUMBER,
				IMINSPECTIONTYPE.NAME AS InspectionType, IMINSPECTIONSTATUS.STATUSNAME AS InspectionStatus,
               	USERS.FNAME + ' ' + USERS.LNAME AS InspectorName, 
                MAILINGADDRESS.ADDRESSLINE1, MAILINGADDRESS.ADDRESSLINE2, MAILINGADDRESS.ADDRESSLINE3, MAILINGADDRESS.CITY, MAILINGADDRESS.STATE, 
				MAILINGADDRESS.POSTALCODE, MAILINGADDRESS.POSTDIRECTION, MAILINGADDRESS.PREDIRECTION, MAILINGADDRESS.STREETTYPE, 
	            MAILINGADDRESS.UNITORSUITE,
				FEES.FEETOTAL,
				--(SELECT R.[IMAGE] FROM RPTIMAGELIB R
		  --       WHERE R.IMAGENAME = 'Municipality_Logo') LOGO,
	            (SELECT CASE WHEN R.[IMAGE] IS NULL THEN 'N' ELSE 'Y' END FROM RPTIMAGELIB R
		         WHERE R.IMAGENAME = 'Municipality_Logo') SHOWLOGO,
	            (SELECT R.REPORTTEXT FROM RPTTEXTLIB R
		         WHERE R.TEXTNAME = 'Municipality_Name') Municipality_Name,	   
	            (SELECT R.REPORTTEXT FROM RPTTEXTLIB R
		         WHERE R.TEXTNAME = 'Municipality_Page_Footer') Municipality_Page_Footer

FROM IMINSPECTION
INNER JOIN IMINSPECTIONTYPE ON IMINSPECTION.IMINSPECTIONTYPEID = IMINSPECTIONTYPE.IMINSPECTIONTYPEID
INNER JOIN IMINSPECTIONSTATUS ON IMINSPECTION.IMINSPECTIONSTATUSID = IMINSPECTIONSTATUS.IMINSPECTIONSTATUSID 
LEFT OUTER JOIN IMINSPECTIONADDRESS ON IMINSPECTION.IMINSPECTIONID = IMINSPECTIONADDRESS.IMINSPECTIONID AND IMINSPECTIONADDRESS.MAIN = 1
LEFT OUTER JOIN MAILINGADDRESS ON IMINSPECTIONADDRESS.MAILINGADDRESSID = MAILINGADDRESS.MAILINGADDRESSID
LEFT OUTER JOIN IMINSPECTIONPARCEL ON IMINSPECTION.IMINSPECTIONID = IMINSPECTIONPARCEL.IMINSPECTIONID AND IMINSPECTIONPARCEL.MAIN = 1
LEFT OUTER JOIN PARCEL ON IMINSPECTIONPARCEL.PARCELID = PARCEL.PARCELID 
LEFT OUTER JOIN IMINSPECTORREF ON IMINSPECTION.IMINSPECTIONID = IMINSPECTORREF.INSPECTIONID 
LEFT OUTER JOIN USERS ON IMINSPECTORREF.USERID = USERS.SUSERGUID 
LEFT OUTER JOIN IMINSPECTIONLINK ON IMINSPECTION.IMINSPECTIONLINKID = IMINSPECTIONLINK.IMINSPECTIONLINKID
LEFT OUTER JOIN CMCODECASE ON IMINSPECTION.LINKID = CMCODECASE.CMCODECASEID
LEFT OUTER JOIN CMCASETYPE ON CMCASETYPE.CMCASETYPEID = CMCODECASE.CMCASETYPEID              
LEFT OUTER JOIN PLPLAN ON IMINSPECTION.LINKID = PLPLAN.PLPLANID 
LEFT OUTER JOIN PLPLANTYPE ON PLPLANTYPE.PLPLANTYPEID = PLPLAN.PLPLANTYPEID 
LEFT OUTER JOIN BLLICENSE ON IMINSPECTION.LINKID = BLLICENSE.BLLICENSEID 
LEFT OUTER JOIN BLLICENSETYPE ON BLLICENSE.BLLICENSETYPEID = BLLICENSETYPE.BLLICENSETYPEID 
LEFT OUTER JOIN PMPERMIT ON IMINSPECTION.LINKID = PMPERMIT.PMPERMITID
LEFT OUTER JOIN PMPERMITTYPE ON PMPERMITTYPE.PMPERMITTYPEID = PMPERMIT.PMPERMITTYPEID
LEFT OUTER JOIN CITIZENREQUEST ON IMINSPECTION.LINKID = CITIZENREQUEST.CITIZENREQUESTID
LEFT OUTER JOIN CITIZENREQUESTTYPE ON CITIZENREQUESTTYPE.CITIZENREQUESTTYPEID = CITIZENREQUEST.CITIZENREQUESTTYPEID
LEFT JOIN #FEES FEES ON IMINSPECTION.IMINSPECTIONID = FEES.IMINSPECTIONID
WHERE (CASE @FILTER 
	     WHEN 'ACTUAL START DATE' THEN IMINSPECTION.ACTUALSTARTDATE
	     WHEN 'ACTUAL END DATE' THEN IMINSPECTION.ACTUALENDDATE
		 WHEN 'SCHEDULED START DATE' THEN IMINSPECTION.SCHEDULEDSTARTDATE
		 WHEN 'SCHEDULED END DATE' THEN IMINSPECTION.SCHEDULEDENDDATE END)
         BETWEEN @STARTDATE AND @ENDDATE

DROP TABLE #FEES