﻿
CREATE PROCEDURE rpt_PM_Standard_Trade_Permit_C
@PMPERMITID AS VARCHAR(36),
@REPORTID VARCHAR(36)
AS
DECLARE @CUSTOMFIELDS NVARCHAR(MAX) = '';
EXEC [dbo].[GetCustomReportText] @REPORTID, @PMPERMITID, @CUSTOMFIELDS OUTPUT; 

--DECLARE @PMPERMITID VARCHAR(36) = '000ef68a-9a23-4240-b2b4-a5ff504ce355'

SELECT PMC.PMPERMITID, GE.FIRSTNAME, GE.LASTNAME, GE.GLOBALENTITYID, GE.GLOBALENTITYNAME COMPANYNAME,
	CASE WHEN ISNULL(GE.ISCOMPANY,0) = 1 AND ISNULL(GE.ISCONTACT,0) = 1 THEN GE.GLOBALENTITYNAME + ', ' + GE.FIRSTNAME + ' ' + GE.LASTNAME 
		WHEN GE.ISCOMPANY = 1 THEN GE.GLOBALENTITYNAME ELSE GE.FIRSTNAME + ' ' + GE.LASTNAME END AS CONTACT_NAME,
	LMCT.NAME CONTACTTYPE, PMC.ISBILLING,
	ROW_NUMBER() OVER (PARTITION BY PMC.PMPERMITID, CASE WHEN LMCT.NAME LIKE '%OWNER%' THEN 1 WHEN LMCT.NAME LIKE '%CONTRACTOR%' THEN 2 ELSE 3 END ORDER BY PMC.ISBILLING DESC, GE.GLOBALENTITYID) AS ROWNBR,
	CASE	WHEN LEN(LTRIM(GE.BUSINESSPHONE)) > 0 THEN GE.BUSINESSPHONE 
		WHEN LEN(LTRIM(GE.MOBILEPHONE)) > 0 THEN GE.MOBILEPHONE 
		WHEN LEN(LTRIM(GE.HOMEPHONE)) > 0 THEN GE.HOMEPHONE 
		WHEN LEN(LTRIM(GE.OTHERPHONE)) > 0 THEN GE.OTHERPHONE 
		ELSE '' END AS PHONE,
	CASE GE.PREFCOMM 
	WHEN 0 THEN ''
	WHEN 1 THEN GE.BUSINESSPHONE
	WHEN 2 THEN GE.HOMEPHONE
	WHEN 3 THEN GE.MOBILEPHONE
	WHEN 4 THEN GE.OTHERPHONE
	WHEN 5 THEN GE.FAX
	WHEN 6 THEN GE.EMAIL
	WHEN 7 THEN 'Address' END AS PREFERRED_CONTACT
INTO #CONTACTS
FROM PMPERMITCONTACT PMC
INNER JOIN GLOBALENTITY GE ON PMC.GLOBALENTITYID = GE.GLOBALENTITYID
INNER JOIN LANDMANAGEMENTCONTACTTYPE LMCT ON PMC.LANDMANAGEMENTCONTACTTYPEID = LMCT.LANDMANAGEMENTCONTACTTYPEID
WHERE PMC.PMPERMITID = @PMPERMITID


SELECT GEMA.GLOBALENTITYID, MA.ADDRESSTYPE, RTRIM(MA.ADDRESSLINE1 + ' ' +	LTRIM(MA.PREDIRECTION + ' ') + LTRIM(MA.ADDRESSLINE2 + ' ') + 
	LTRIM(MA.STREETTYPE + ' ') + LTRIM(MA.POSTDIRECTION + ' ') + LTRIM(MA.UNITORSUITE + ' ')  + LTRIM(MA.ADDRESSLINE3)) ADDRESS_LINE1,
	RTRIM(CASE WHEN RTRIM(LTRIM(MA.CITY)) = '' THEN '' ELSE LTRIM(MA.CITY + ', ' ) END + LTRIM(MA.STATE + ' ') + 
	(CASE WHEN LEN(REPLACE(ISNULL(MA.POSTALCODE,''),'-','')) > 5 
		THEN SUBSTRING(REPLACE(ISNULL(MA.POSTALCODE,''),'-',''),1,5) + '-' + SUBSTRING(REPLACE(ISNULL(MA.POSTALCODE,''),'-',''),6,4)
		ELSE REPLACE(ISNULL(MA.POSTALCODE,''),'-','') END)) ADDRESS_LINE2,
	ROW_NUMBER() OVER (PARTITION BY GEMA.GLOBALENTITYID ORDER BY CASE WHEN MA.ADDRESSTYPE LIKE 'Mailing%' THEN 1 WHEN MA.ADDRESSTYPE LIKE 'Billing%' THEN 2 WHEN MA.ADDRESSTYPE LIKE 'Location%' THEN 3 ELSE 4 END ) AS ROWNBR
INTO #CONTACTADDRESS
FROM GLOBALENTITYMAILINGADDRESS GEMA 
INNER JOIN MAILINGADDRESS MA ON GEMA.MAILINGADDRESSID = MA.MAILINGADDRESSID

SELECT PA.PMPERMITID, PA.MAIN, MA.ADDRESSTYPE, RTRIM(MA.ADDRESSLINE1 + ' ' +	LTRIM(MA.PREDIRECTION + ' ') + LTRIM(MA.ADDRESSLINE2 + ' ') + 
	LTRIM(MA.STREETTYPE + ' ') + LTRIM(MA.POSTDIRECTION + ' ') + LTRIM(MA.UNITORSUITE + ' ')  + LTRIM(MA.ADDRESSLINE3)) ADDRESS_LINE1,
	RTRIM(CASE WHEN RTRIM(LTRIM(MA.CITY)) = '' THEN '' ELSE LTRIM(MA.CITY + ', ' ) END + LTRIM(MA.STATE + ' ') + 
	(CASE WHEN LEN(REPLACE(ISNULL(MA.POSTALCODE,''),'-','')) > 5 
		THEN SUBSTRING(REPLACE(ISNULL(MA.POSTALCODE,''),'-',''),1,5) + '-' + SUBSTRING(REPLACE(ISNULL(MA.POSTALCODE,''),'-',''),6,4)
		ELSE REPLACE(ISNULL(MA.POSTALCODE,''),'-','') END)) ADDRESS_LINE2
INTO #MADDRESS
FROM PMPERMITADDRESS PA
INNER JOIN MAILINGADDRESS MA ON PA.MAILINGADDRESSID = MA.MAILINGADDRESSID
WHERE PA.PMPERMITID = @PMPERMITID

SELECT PWFS.PMPERMITID MAINPERMITID, PM.PERMITNUMBER MAINPERMITNUMBER, P.PERMITNUMBER SUBPERMITNUMBER, P.PMPERMITID
INTO #PARENT
FROM PMPERMITWFSTEP PWFS
INNER JOIN PMPERMITWFACTIONSTEP PWFAS ON PWFS.PMPERMITWFSTEPID = PWFAS.PMPERMITWFSTEPID
INNER JOIN PMPERMITACTIONREF PAR ON PWFAS.PMPERMITWFACTIONSTEPID = PAR.OBJECTID
INNER JOIN PMPERMIT P ON PAR.PMPERMITID = P.PMPERMITID
INNER JOIN PMPERMIT PM ON PM.PMPERMITID = PWFS.PMPERMITID
WHERE P.PMPERMITID = @PMPERMITID

CREATE INDEX TEMP1 ON #CONTACTS (PMPERMITID);
CREATE INDEX TEMP1 ON #CONTACTADDRESS (GLOBALENTITYID);
CREATE INDEX TEMP2 ON #CONTACTADDRESS (ROWNBR);
CREATE INDEX TEMP1 ON #MADDRESS (PMPERMITID);


SELECT P.PMPERMITID, P.PERMITNUMBER, P.ISSUEDATE, P.EXPIREDATE, P.SQUAREFEET, P.[VALUE], P.DESCRIPTION,
	PT.NAME PERMIT_TYPE, 
	PWC.NAME WORK_CLASS, 
	PS.NAME PERMIT_STATUS,
	OWN.CONTACT_NAME OWNER_NAME,
	OWN_ADD.ADDRESS_LINE1 OWNER_ADDRESSLINE1, 
	OWN_ADD.ADDRESS_LINE2 OWNER_ADDRESSLINE2,
	CON.CONTACT_NAME CONTRACTOR_NAME,
	CON.PHONE CONTRACTOR_PHONE,
	CON.PREFERRED_CONTACT CONTRACTOR_PREFERRED_CONTACT,
	CON_ADD.ADDRESS_LINE1 CONTRACTOR_ADDRESSLINE1, CON_ADD.ADDRESS_LINE2 CONTRACTOR_ADDRESSLINE2,
	MA.ADDRESS_LINE1 MAIN_ADDRESS_LINE1, MA.ADDRESS_LINE2 MAIN_ADDRESS_LINE2,
	PR.PROJECTNUMBER, PR.NAME PROJECTNAME,
	PAR.MAINPERMITNUMBER,	
	PA.PARCELNUMBER,
	@CUSTOMFIELDS CUSTOMFIELDS,
	CASE WHEN (SELECT ISNULL(R.REPORTTEXT,'') FROM RPTTEXTLIB R
		WHERE R.TEXTNAME = 'Permit_Municipality_Name') = '' 
		THEN (SELECT R.REPORTTEXT FROM RPTTEXTLIB R
		WHERE R.TEXTNAME = 'Municipality_Name')
		ELSE (SELECT R.REPORTTEXT FROM RPTTEXTLIB R
		WHERE R.TEXTNAME = 'Permit_Municipality_Name') END Municipality_Name,
	CASE WHEN (SELECT ISNULL(R.REPORTTEXT,'') FROM RPTTEXTLIB R
		WHERE R.TEXTNAME = 'Permit_Municipality_Address') = '' 
		THEN (SELECT R.REPORTTEXT FROM RPTTEXTLIB R
		WHERE R.TEXTNAME = 'Municipality_Address')
		ELSE (SELECT R.REPORTTEXT FROM RPTTEXTLIB R
		WHERE R.TEXTNAME = 'Permit_Municipality_Address') END Municipality_Address,
	(SELECT REPLACE(R.REPORTTEXT,CHAR(10),'<BR>')  FROM RPTTEXTLIB R
		WHERE R.TEXTNAME = 'Trade_Permit_C_Text_1') Trade_Permit_C_Text_1,
	(SELECT REPLACE(R.REPORTTEXT,CHAR(10),'<BR>')  FROM RPTTEXTLIB R
		WHERE R.TEXTNAME = 'Trade_Permit_C_Text_2') Trade_Permit_C_Text_2,
	(SELECT R.[IMAGE] FROM RPTIMAGELIB R
		WHERE R.IMAGENAME = 'Permit_Logo') LOGO,
	(SELECT R.REPORTTEXT FROM RPTTEXTLIB R
		WHERE R.TEXTNAME = 'Permit_Page_Footer') Permit_Page_Footer,
	(SELECT CASE WHEN R.[IMAGE] IS NULL  THEN 'N' ELSE 'Y' END FROM RPTIMAGELIB R
		WHERE R.IMAGENAME = 'Permit_Logo') SHOWLOGO
FROM PMPERMIT P
INNER JOIN PMPERMITTYPE PT ON P.PMPERMITTYPEID = PT.PMPERMITTYPEID
INNER JOIN PMPERMITWORKCLASS PWC ON P.PMPERMITWORKCLASSID = PWC.PMPERMITWORKCLASSID
INNER JOIN PMPERMITSTATUS PS ON P.PMPERMITSTATUSID = PS.PMPERMITSTATUSID
LEFT JOIN #CONTACTS OWN ON P.PMPERMITID = OWN.PMPERMITID AND OWN.CONTACTTYPE LIKE '%OWNER%' AND OWN.ROWNBR = 1
LEFT JOIN #CONTACTADDRESS OWN_ADD ON OWN.GLOBALENTITYID = OWN_ADD.GLOBALENTITYID AND OWN_ADD.ROWNBR = 1
LEFT JOIN #CONTACTS CON ON P.PMPERMITID = CON.PMPERMITID AND CON.CONTACTTYPE LIKE '%CONTRACTOR%' AND CON.ROWNBR = 1
LEFT JOIN #CONTACTADDRESS CON_ADD ON CON.GLOBALENTITYID = CON_ADD.GLOBALENTITYID AND CON_ADD.ROWNBR = 1
LEFT JOIN #MADDRESS MA ON P.PMPERMITID = MA.PMPERMITID AND MA.MAIN = 1
LEFT JOIN PRPROJECTPERMIT PRP ON P.PMPERMITID = PRP.PMPERMITID
LEFT JOIN PRPROJECT PR ON PRP.PRPROJECTID = PR.PRPROJECTID
LEFT JOIN PMPERMITPARCEL PP ON P.PMPERMITID = PP.PMPERMITID AND PP.MAIN = 1
LEFT JOIN PARCEL PA ON PP.PARCELID = PA.PARCELID
LEFT JOIN #PARENT PAR ON P.PMPERMITID = PAR.PMPERMITID
WHERE P.PMPERMITID = @PMPERMITID

DROP TABLE #CONTACTS;
DROP TABLE #CONTACTADDRESS;
DROP TABLE #MADDRESS;
DROP TABLE #PARENT;
