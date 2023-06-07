﻿
CREATE PROCEDURE [dbo].[rpt_PM_SR_Permit_Fee_Listing]
@STARTDATE AS DATETIME,
@ENDDATE AS DATETIME,
@FILTER AS VARCHAR(150)
AS
BEGIN
SET @STARTDATE = DATEADD(dd, DATEDIFF(dd, 0, @STARTDATE), 0)
SET @ENDDATE = DATEADD(S,-1,DATEADD(D,1,@ENDDATE))  

;WITH ADDRESS_CTE AS
(SELECT PA.PMPERMITID, PA.MAIN, MA.ADDRESSTYPE, RTRIM(MA.ADDRESSLINE1 + ' ' +	LTRIM(MA.PREDIRECTION + ' ') + LTRIM(MA.ADDRESSLINE2 + ' ') + 
	LTRIM(MA.STREETTYPE + ' ') + LTRIM(MA.POSTDIRECTION + ' ') + LTRIM(MA.UNITORSUITE + ' ')  + LTRIM(MA.ADDRESSLINE3)) ADDRESS_LINE1,
	RTRIM(CASE WHEN RTRIM(LTRIM(MA.CITY)) = '' THEN '' ELSE LTRIM(MA.CITY + ', ' ) END + LTRIM(MA.STATE + ' ') + MA.POSTALCODE) ADDRESS_LINE2
FROM PMPERMITADDRESS PA
INNER JOIN MAILINGADDRESS MA ON PA.MAILINGADDRESSID = MA.MAILINGADDRESSID
WHERE PA.MAIN  = 1),

CONTACT_CTE AS
(SELECT DISTINCT PMC1.PMPERMITID,
	STUFF((SELECT '||' + CASE WHEN GE.ISCONTACT = 1 THEN GE.FIRSTNAME + (CASE WHEN ISNULL(GE.MIDDLENAME,'') = '' THEN '' ELSE ' ' + LEFT(GE.MIDDLENAME,1)  END )+ ' ' + GE.LASTNAME ELSE GE.GLOBALENTITYNAME END BILLINGCONTACT
		FROM PMPERMITCONTACT PMC
		INNER JOIN GLOBALENTITY GE ON GE.GLOBALENTITYID = PMC.GLOBALENTITYID
		WHERE PMC.PMPERMITID = PMC1.PMPERMITID AND PMC.ISBILLING = 1
			FOR XML PATH(''), root('MyString'), type
		).value('/MyString[1]','varchar(max)') 
		,1,2,'') AS 'BILLINGCONTACT'
	FROM PMPERMITCONTACT PMC1)

SELECT DISTINCT PMPERMIT.PERMITNUMBER, PMPERMIT.APPLYDATE, PMPERMIT.EXPIREDATE, PMPERMIT.ISSUEDATE, PMPERMIT.FINALIZEDATE, PMPERMIT.VALUE, PMPERMIT.SQUAREFEET, 
				PMPERMITTYPE.NAME AS PERMITTYPE, PMPERMITWORKCLASS.NAME AS WORKCLASS, PMPERMITSTATUS.NAME AS STATUS, CACOMPUTEDFEE.FEENAME, PMPERMIT.PMPERMITID,
				CACOMPUTEDFEE.COMPUTEDAMOUNT AS FEEAMOUNT, CACOMPUTEDFEE.AMOUNTPAIDTODATE AS PAIDAMOUNT, CACOMPUTEDFEE.CACOMPUTEDFEEID, CACOMPUTEDFEE.CACOMPUTEDFEEID,
				BIL.BILLINGCONTACT,
				MA.ADDRESS_LINE1, MA.ADDRESS_LINE2,
				P.PARCELNUMBER,
				--(SELECT R.[IMAGE] FROM RPTIMAGELIB R
				-- WHERE R.IMAGENAME = 'Municipality_Logo') LOGO,
				(SELECT CASE WHEN R.[IMAGE] IS NULL THEN 'N' ELSE 'Y' END FROM RPTIMAGELIB R
				WHERE R.IMAGENAME = 'Municipality_Logo') SHOWLOGO,
				(SELECT R.REPORTTEXT FROM RPTTEXTLIB R
				WHERE R.TEXTNAME = 'Municipality_Name') Municipality_Name,	   
				(SELECT R.REPORTTEXT FROM RPTTEXTLIB R
				WHERE R.TEXTNAME = 'Municipality_Page_Footer') Municipality_Page_Footer

FROM PMPERMIT
INNER JOIN PMPERMITTYPE ON PMPERMIT.PMPERMITTYPEID = PMPERMITTYPE.PMPERMITTYPEID 
INNER JOIN PMPERMITWORKCLASS ON PMPERMIT.PMPERMITWORKCLASSID = PMPERMITWORKCLASS.PMPERMITWORKCLASSID 
INNER JOIN PMPERMITFEE ON PMPERMIT.PMPERMITID = PMPERMITFEE.PMPERMITID 
INNER JOIN CACOMPUTEDFEE ON PMPERMITFEE.CACOMPUTEDFEEID = CACOMPUTEDFEE.CACOMPUTEDFEEID 
INNER JOIN PMPERMITSTATUS ON PMPERMIT.PMPERMITSTATUSID = PMPERMITSTATUS.PMPERMITSTATUSID 
LEFT JOIN CONTACT_CTE AS BIL ON PMPERMIT.PMPERMITID = BIL.PMPERMITID
LEFT JOIN ADDRESS_CTE MA ON PMPERMIT.PMPERMITID = MA.PMPERMITID
LEFT JOIN PMPERMITPARCEL PMP ON PMPERMIT.PMPERMITID = PMP.PMPERMITID AND PMP.MAIN = 1
LEFT JOIN PARCEL P ON P.PARCELID = PMP.PARCELID
WHERE (CASE @FILTER 
	WHEN 'EXPIRATION DATE' THEN PMPERMIT.EXPIREDATE
	WHEN 'APPLIED DATE' THEN PMPERMIT.APPLYDATE
	WHEN 'FINALED DATE' THEN PMPERMIT.FINALIZEDATE
	WHEN 'ISSUED DATE' THEN PMPERMIT.ISSUEDATE END) BETWEEN @STARTDATE AND @ENDDATE
AND CACOMPUTEDFEE.CASTATUSID NOT IN (5,9,10) --VOID, DELETED
END
