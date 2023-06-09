﻿
CREATE PROCEDURE [dbo].[rpt_IL_SR_Professional_License_Listing]
@STARTDATE AS DATETIME,
@ENDDATE AS DATETIME,
@FILTER AS VARCHAR(150),
@CASEORIGIN AS VARCHAR(50)
AS
SET @STARTDATE=dateadd(dd,datediff(dd,0,@STARTDATE),0)
SET @ENDDATE = DATEADD(S,-1,DATEADD(D,1,@ENDDATE))

SELECT ILF.ILLICENSEID, SUM(CACF.COMPUTEDAMOUNT) FEETOTAL
INTO #FEES
FROM ILLICENSEFEE ILF
INNER JOIN CACOMPUTEDFEE CACF ON ILF.CACOMPUTEDFEEID = CACF.CACOMPUTEDFEEID 
WHERE CACF.CASTATUSID NOT IN (5,10) --VOID, DELETED
GROUP BY ILF.ILLICENSEID


SELECT ILA.ILLICENSEID, MA.ADDRESSTYPE, RTRIM(MA.ADDRESSLINE1 + ' ' +	LTRIM(MA.PREDIRECTION + ' ') + LTRIM(MA.ADDRESSLINE2 + ' ') + 
	LTRIM(MA.STREETTYPE + ' ') + LTRIM(MA.POSTDIRECTION + ' ') + LTRIM(MA.UNITORSUITE + ' ')  + LTRIM(MA.ADDRESSLINE3)) ADDRESS_LINE1,
	RTRIM(CASE WHEN RTRIM(LTRIM(MA.CITY)) = '' THEN '' ELSE LTRIM(MA.CITY + ', ' ) END + LTRIM(MA.STATE + ' ') + MA.POSTALCODE) ADDRESS_LINE2
INTO #ADDRESS
FROM ILLICENSEADDRESS ILA
INNER JOIN MAILINGADDRESS MA ON ILA.MAILINGADDRESSID = MA.MAILINGADDRESSID
WHERE ILA.MAIN = 1

CREATE INDEX TEMP1 ON #FEES (ILLICENSEID)
CREATE INDEX TEMP1 ON #ADDRESS (ILLICENSEID)

SELECT GLOBALENTITY.GLOBALENTITYNAME AS CompanyName, GLOBALENTITY.FIRSTNAME + ' ' + GLOBALENTITY.LASTNAME AS LicHolder,
       ILLICENSE.LICENSENUMBER, ILLICENSE.APPLIEDDATE, ILLICENSE.ISSUEDATE, ILLICENSE.EXPIRATIONDATE, ILLICENSE.LASTRENEWALDATE, ILLICENSE.DESCRIPTION,
       ILLICENSECLASSIFICATION.NAME AS CLASSIFICATION, ILLICENSESTATUS.NAME AS STATUS, ILLICENSETYPE.NAME AS LICENSETYPE, ILLICENSE.LICENSEYEAR, 
	   CASE WHEN ILLICENSE.ISAPPLIEDONLINE = 1 THEN 'Yes' ELSE 'No' END APPLIEDONLINE,
	   PARCEL.PARCELNUMBER,
	   GLOBALENTITYACCOUNT.ACCOUNTNUMBER, GLOBALENTITYACCOUNT.BALANCE,
	   COALESCE(NULLIF(DISTRICT.NAME,''),'Not Assigned') AS District, 
	   COALESCE(NULLIF(USERS.FNAME + ' ' + USERS.LNAME,''),'Not Assigned') IssuedBy, 
	   A.ADDRESS_LINE1, A.ADDRESS_LINE2,
	   F.FEETOTAL, 
	   --(SELECT R.[IMAGE] FROM RPTIMAGELIB R
	   -- WHERE R.IMAGENAME = 'Municipality_Logo') LOGO,
	   (SELECT CASE WHEN R.[IMAGE] IS NULL THEN 'N' ELSE 'Y' END FROM RPTIMAGELIB R
	    WHERE R.IMAGENAME = 'Municipality_Logo') SHOWLOGO,
	   (SELECT R.REPORTTEXT FROM RPTTEXTLIB R
	    WHERE R.TEXTNAME = 'Municipality_Name') Municipality_Name,	   
	   (SELECT R.REPORTTEXT FROM RPTTEXTLIB R
	    WHERE R.TEXTNAME = 'Municipality_Page_Footer') Municipality_Page_Footer

FROM ILLICENSE 
INNER JOIN ILLICENSETYPE ON ILLICENSE.ILLICENSETYPEID = ILLICENSETYPE.ILLICENSETYPEID
INNER JOIN ILLICENSECLASSIFICATION ON ILLICENSE.ILLICENSECLASSIFICATIONID = ILLICENSECLASSIFICATION.ILLICENSECLASSIFICATIONID 
INNER JOIN ILLICENSESTATUS ON ILLICENSE.ILLICENSESTATUSID = ILLICENSESTATUS.ILLICENSESTATUSID
INNER JOIN GLOBALENTITY ON ILLICENSE.GLOBALENTITYID = GLOBALENTITY.GLOBALENTITYID
LEFT OUTER JOIN GLOBALENTITYACCOUNT ON ILLICENSE.GLOBALENTITYACCOUNTID = GLOBALENTITYACCOUNT.GLOBALENTITYACCOUNTID 
LEFT OUTER JOIN ILLICENSEPARCEL ON ILLICENSE.ILLICENSEID = ILLICENSEPARCEL.ILLICENSEID AND ILLICENSEPARCEL.MAIN = 1
LEFT OUTER JOIN PARCEL ON ILLICENSEPARCEL.PARCELID = PARCEL.PARCELID  
INNER JOIN DISTRICT ON ILLICENSE.DISTRICTID = DISTRICT.DISTRICTID 
LEFT OUTER JOIN USERS ON ILLICENSE.ISSUEDBY = USERS.SUSERGUID
LEFT JOIN #FEES F ON ILLICENSE.ILLICENSEID = F.ILLICENSEID
LEFT JOIN #ADDRESS A ON A.ILLICENSEID = ILLICENSE.ILLICENSEID
WHERE (CASE @FILTER
       WHEN 'APPLIED DATE' THEN ILLICENSE.APPLIEDDATE
	   WHEN 'EXPIRED DATE' THEN ILLICENSE.EXPIRATIONDATE
	   WHEN 'ISSUED DATE' THEN ILLICENSE.ISSUEDATE
	   WHEN 'RENEWED DATE' THEN ILLICENSE.LASTRENEWALDATE END)
	   BETWEEN @STARTDATE AND @ENDDATE
	AND CASE @CASEORIGIN
			WHEN 'Online Only' THEN 1
			WHEN 'Back Office Only' THEN 0
			ELSE ILLICENSE.ISAPPLIEDONLINE
	    END = ILLICENSE.ISAPPLIEDONLINE

DROP TABLE #ADDRESS
