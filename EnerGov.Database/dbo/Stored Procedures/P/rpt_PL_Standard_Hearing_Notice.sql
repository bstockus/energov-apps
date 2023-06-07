﻿
CREATE PROCEDURE rpt_PL_Standard_Hearing_Notice
@PLPLANID VARCHAR(36),
@REPORTID VARCHAR(36)
AS

DECLARE @CUSTOMFIELDS NVARCHAR(MAX) = '';
EXEC [dbo].[GetCustomReportText] @REPORTID, @PLPLANID, @CUSTOMFIELDS OUTPUT; 

SELECT TOP 1 PL.PLPLANID,
	H.[SUBJECT] HEARING_SUBJECT,
	H.STARTDATE HEARING_STARTDATE,
	H.[COMMENTS] HEARING_COMMENTS,
	H.[LOCATION] HEARING_LOCATION,
	H2.NAME HEARING_TYPE
INTO #HEARING
FROM PLPLAN PL
INNER JOIN PLPLANWFSTEP PLWFS ON PLWFS.PLPLANID = PL.PLPLANID
INNER JOIN PLPLANWFACTIONSTEP PLWFAS ON PLWFAS.PLPLANWFSTEPID = PLWFS.PLPLANWFSTEPID
INNER JOIN HEARINGXREF HXR ON PLWFAS.PLPLANWFACTIONSTEPID = HXR.OBJECTID
INNER JOIN HEARING H ON H.HEARINGID = HXR.HEARINGID
INNER JOIN HEARINGTYPE H2 ON H2.HEARINGTYPEID = H.HEARINGTYPEID
WHERE PL.PLPLANID = @PLPLANID
ORDER BY H.STARTDATE DESC

SELECT PLC.PLPLANID, GE.FIRSTNAME, GE.LASTNAME, GE.GLOBALENTITYID, GE.GLOBALENTITYNAME COMPANYNAME,
	LMCT.NAME CONTACTTYPE, PLC.ISBILLING,
	CASE WHEN GE.ISCONTACT = 1 THEN GE.FIRSTNAME + (CASE WHEN ISNULL(GE.MIDDLENAME,'') = '' THEN '' ELSE ' ' + LEFT(GE.MIDDLENAME,1)  END )+ ' ' + GE.LASTNAME ELSE GE.GLOBALENTITYNAME END CONTACT_NAME,
	ROW_NUMBER() OVER (PARTITION BY PLC.PLPLANID ORDER BY CASE WHEN LMCT.NAME LIKE '%APPLICANT%' THEN 1 WHEN LMCT.NAME LIKE '%PLANNER%' THEN 2 ELSE 3 END, PLC.ISBILLING DESC, GE.GLOBALENTITYID) AS ROWNBR,
	CASE	WHEN LEN(LTRIM(GE.BUSINESSPHONE)) > 0 THEN GE.BUSINESSPHONE 
		WHEN LEN(LTRIM(GE.MOBILEPHONE)) > 0 THEN GE.MOBILEPHONE 
		WHEN LEN(LTRIM(GE.HOMEPHONE)) > 0 THEN GE.HOMEPHONE 
		WHEN LEN(LTRIM(GE.OTHERPHONE)) > 0 THEN GE.OTHERPHONE 
		ELSE '' END AS PHONE
INTO #CONTACTS
FROM PLPLANCONTACT PLC
INNER JOIN GLOBALENTITY GE ON PLC.GLOBALENTITYID = GE.GLOBALENTITYID
INNER JOIN LANDMANAGEMENTCONTACTTYPE LMCT ON PLC.LANDMANAGEMENTCONTACTTYPEID = LMCT.LANDMANAGEMENTCONTACTTYPEID
WHERE PLC.PLPLANID = @PLPLANID

SELECT PA.PLPLANID, PA.MAIN, MA.ADDRESSTYPE, RTRIM(MA.ADDRESSLINE1 + ' ' +	LTRIM(MA.PREDIRECTION + ' ') + LTRIM(MA.ADDRESSLINE2 + ' ') + 
	LTRIM(MA.STREETTYPE + ' ') + LTRIM(MA.POSTDIRECTION + ' ') + LTRIM(MA.UNITORSUITE + ' ')  + LTRIM(MA.ADDRESSLINE3)) ADDRESS_LINE1,
	RTRIM(CASE WHEN RTRIM(LTRIM(MA.CITY)) = '' THEN '' ELSE LTRIM(MA.CITY + ', ' ) END + LTRIM(MA.STATE + ' ') + 
	(CASE WHEN LEN(REPLACE(ISNULL(MA.POSTALCODE,''),'-','')) > 5 
		THEN SUBSTRING(REPLACE(ISNULL(MA.POSTALCODE,''),'-',''),1,5) + '-' + SUBSTRING(REPLACE(ISNULL(MA.POSTALCODE,''),'-',''),6,4)
		ELSE REPLACE(ISNULL(MA.POSTALCODE,''),'-','') END)) ADDRESS_LINE2
INTO #MADDRESS
FROM PLPLANADDRESS PA
INNER JOIN MAILINGADDRESS MA ON PA.MAILINGADDRESSID = MA.MAILINGADDRESSID
WHERE PA.PLPLANID = @PLPLANID AND PA.MAIN = 1

SELECT PL.PLPLANID,
	PL.PLANNUMBER,
	PL.[DESCRIPTION],
	H.HEARING_SUBJECT ,
    H.HEARING_STARTDATE ,
    H.HEARING_COMMENTS ,
	H.HEARING_LOCATION,
    H.HEARING_TYPE,
	C.CONTACT_NAME,
	C.CONTACTTYPE,
	MA.ADDRESS_LINE1,
	MA.ADDRESS_LINE2,
	(SELECT REPLACE(R.REPORTTEXT,CHAR(10),'<BR>') FROM RPTTEXTLIB R
		WHERE R.TEXTNAME = 'Municipality_Name') Municipality_Name,
	(SELECT REPLACE(R.REPORTTEXT,CHAR(10),'<BR>') FROM RPTTEXTLIB R
		WHERE R.TEXTNAME = 'Municipality_Address') Municipality_Address,
	(SELECT REPLACE(R.REPORTTEXT,CHAR(10),'<BR>') FROM RPTTEXTLIB R
		WHERE R.TEXTNAME = 'Plan_Hearing_Text_1') Plan_Hearing_Text_1,
	(SELECT REPLACE(R.REPORTTEXT,CHAR(10),'<BR>') FROM RPTTEXTLIB R
		WHERE R.TEXTNAME = 'Plan_Hearing_Text_2') Plan_Hearing_Text_2,
	(SELECT REPLACE(R.REPORTTEXT,CHAR(10),'<BR>') FROM RPTTEXTLIB R
		WHERE R.TEXTNAME = 'Plan_Hearing_Text_3') Plan_Hearing_Text_3,
	(SELECT REPLACE(R.REPORTTEXT,CHAR(10),'<BR>') FROM RPTTEXTLIB R
		WHERE R.TEXTNAME = 'Plan_Hearing_Standard_Time') Plan_Hearing_Standard_Time,
	(SELECT R.[IMAGE] FROM RPTIMAGELIB R
		WHERE R.IMAGENAME = 'Plan_Logo') LOGO,
	(SELECT CASE WHEN R.[IMAGE] IS NULL  THEN 'N' ELSE 'Y' END FROM RPTIMAGELIB R
		WHERE R.IMAGENAME = 'Plan_Logo') SHOWLOGO,
	@CUSTOMFIELDS CUSTOMFIELDS
FROM PLPLAN PL
LEFT JOIN  #HEARING H ON H.PLPLANID = PL.PLPLANID
LEFT JOIN #CONTACTS C ON C.PLPLANID = PL.PLPLANID AND C.ROWNBR = 1
LEFT JOIN #MADDRESS MA ON MA.PLPLANID = PL.PLPLANID 
WHERE PL.PLPLANID = @PLPLANID

DROP TABLE #HEARING;
DROP TABLE #CONTACTS;
DROP TABLE #MADDRESS