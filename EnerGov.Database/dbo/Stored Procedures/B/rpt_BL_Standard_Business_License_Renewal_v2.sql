﻿-- exec rpt_BL_Standard_Business_License_Renewal '0ef9a8ed-c48b-435b-a94c-4a1e5bac9430',''

CREATE PROCEDURE rpt_BL_Standard_Business_License_Renewal_v2
@BLLICENSEID VARCHAR(36),
	@REPORTID VARCHAR(36)
AS

DECLARE @CUSTOMFIELDS NVARCHAR(MAX) = '';
EXEC [dbo].[GetCustomReportText] @REPORTID, @BLLICENSEID, @CUSTOMFIELDS OUTPUT; 

/*BUILD OWNER INFO*/
SELECT BLC.BLLICENSEID, GE.FIRSTNAME, GE.LASTNAME, GE.GLOBALENTITYID, BLCT.NAME CONTACTTYPE, GE.GLOBALENTITYNAME COMPANYNAME, 
	BLC.ISBILLING, GE.GLOBALENTITYNAME, GE.[IMAGE], GE.ISCOMPANY, GE.ISCONTACT, GE.MIDDLENAME,
	ROW_NUMBER() OVER (PARTITION BY BLC.BLLICENSEID ORDER BY  GE.GLOBALENTITYID) AS ROWNBR,
	CASE	WHEN LEN(LTRIM(GE.BUSINESSPHONE)) > 0 THEN GE.BUSINESSPHONE 
		WHEN LEN(LTRIM(GE.MOBILEPHONE)) > 0 THEN GE.MOBILEPHONE 
		WHEN LEN(LTRIM(GE.HOMEPHONE)) > 0 THEN GE.HOMEPHONE 
		WHEN LEN(LTRIM(GE.OTHERPHONE)) > 0 THEN GE.OTHERPHONE 
		ELSE '' END AS PHONE
INTO #CONTACT
FROM BLLICENSECONTACT BLC
INNER JOIN GLOBALENTITY GE ON BLC.GLOBALENTITYID = GE.GLOBALENTITYID
INNER JOIN BLCONTACTTYPE BLCT ON BLC.BLCONTACTTYPEID = BLCT.BLCONTACTTYPEID 
WHERE BLC.BLLICENSEID = @BLLICENSEID AND BLCT.NAME LIKE '%OWNER%'

/*LOCATION ADDRESS*/
SELECT BLA.MAIN, BLA.BLLICENSEID, MA.ADDRESSTYPE, RTRIM(MA.ADDRESSLINE1 + ' ' +	LTRIM(MA.PREDIRECTION + ' ') + LTRIM(MA.ADDRESSLINE2 + ' ') + 
	LTRIM(MA.STREETTYPE + ' ') + LTRIM(MA.POSTDIRECTION + ' ') + LTRIM(MA.UNITORSUITE + ' ')  + LTRIM(MA.ADDRESSLINE3)) ADDRESS_LINE1,
	RTRIM(CASE WHEN RTRIM(LTRIM(MA.CITY)) = '' THEN '' ELSE LTRIM(MA.CITY + ', ' ) END + LTRIM(MA.STATE + ' ') + 
	(CASE WHEN LEN(REPLACE(ISNULL(MA.POSTALCODE,''),'-','')) > 5 
		THEN SUBSTRING(REPLACE(ISNULL(MA.POSTALCODE,''),'-',''),1,5) + '-' + SUBSTRING(REPLACE(ISNULL(MA.POSTALCODE,''),'-',''),6,4)
		ELSE REPLACE(ISNULL(MA.POSTALCODE,''),'-','') END)) ADDRESS_LINE2,
	ROW_NUMBER() OVER (PARTITION BY BLA.BLLICENSEID ORDER BY CASE WHEN MA.ADDRESSTYPE LIKE '%LOCATION%' THEN 1 ELSE 2 END ) AS ROWNBR
INTO #LOCADDRESS
FROM BLLICENSEADDRESS BLA
INNER JOIN MAILINGADDRESS MA ON BLA.MAILINGADDRESSID = MA.MAILINGADDRESSID
WHERE BLA.BLLICENSEID = @BLLICENSEID

/*MAILING ADDRESS*/
SELECT BLGEEA.MAIN, BLGEEA.BLGLOBALENTITYEXTENSIONID, MA.ADDRESSTYPE, RTRIM(MA.ADDRESSLINE1 + ' ' +	LTRIM(MA.PREDIRECTION + ' ') + LTRIM(MA.ADDRESSLINE2 + ' ') + 
	LTRIM(MA.STREETTYPE + ' ') + LTRIM(MA.POSTDIRECTION + ' ') + LTRIM(MA.UNITORSUITE + ' ')  + LTRIM(MA.ADDRESSLINE3)) ADDRESS_LINE1,
	RTRIM(CASE WHEN RTRIM(LTRIM(MA.CITY)) = '' THEN '' ELSE LTRIM(MA.CITY + ', ' ) END + LTRIM(MA.STATE + ' ') + 
	(CASE WHEN LEN(REPLACE(ISNULL(MA.POSTALCODE,''),'-','')) > 5 
		THEN SUBSTRING(REPLACE(ISNULL(MA.POSTALCODE,''),'-',''),1,5) + '-' + SUBSTRING(REPLACE(ISNULL(MA.POSTALCODE,''),'-',''),6,4)
		ELSE REPLACE(ISNULL(MA.POSTALCODE,''),'-','') END)) ADDRESS_LINE2,
	ROW_NUMBER() OVER (PARTITION BY BLGEEA.BLGLOBALENTITYEXTENSIONID ORDER BY CASE WHEN MA.ADDRESSTYPE LIKE '%MAILING%' THEN 1 ELSE 2 END ) AS ROWNBR
INTO #BUSADDRESS
FROM BLGLOBALENTITYEXTENSIONADDRESS BLGEEA
INNER JOIN MAILINGADDRESS MA ON BLGEEA.MAILINGADDRESSID = MA.MAILINGADDRESSID

/*ALL LICENSE FEES*/
SELECT BLF.BLLICENSEID, C.COMPUTEDAMOUNT FEEAMOUNT, C.FEENAME
INTO #FEES
FROM BLLICENSEFEE BLF
INNER JOIN CACOMPUTEDFEE C ON C.CACOMPUTEDFEEID = BLF.CACOMPUTEDFEEID
WHERE BLF.BLLICENSEID = @BLLICENSEID AND
	C.CASTATUSID NOT IN (5,9,10) AND 
	C.FEENAME NOT LIKE '%PENALTY%' AND
	(C.FEENAME NOT LIKE '% late %'
	AND C.FEENAME NOT LIKE 'late %'
	AND C.FEENAME NOT LIKE '% late')


CREATE INDEX TEMP1 ON #CONTACT (BLLICENSEID);
CREATE INDEX TEMP1 ON #LOCADDRESS (BLLICENSEID);
CREATE INDEX TEMP2 ON #LOCADDRESS (ROWNBR);
CREATE INDEX TEMP1 ON #BUSADDRESS (BLGLOBALENTITYEXTENSIONID);
CREATE INDEX TEMP2 ON #BUSADDRESS (ROWNBR);
CREATE INDEX TEMP1 ON #FEES (BLLICENSEID);


/*BEGIN MAIN QUERY*/
SELECT BL.BLLICENSEID, BL.LICENSENUMBER, CASE WHEN BL.EXPIRATIONDATE = '1/1/2999' THEN NULL ELSE BL.EXPIRATIONDATE END AS EXPIRATIONDATE, 
	BL.TAXYEAR, BL.ISSUEDDATE,
	BLGEE.DBA, BLGEE.EINNUMBER AS TIN, BLGEE.STATETAXNUMBER AS TAXID,
	BUS.GLOBALENTITYNAME BUSINESSNAME,
	CASE WHEN OWN.ISCOMPANY = 1 THEN OWN.GLOBALENTITYNAME ELSE OWN.FIRSTNAME + ' ' + OWN.LASTNAME  END OWNERNAME,
	MA.ADDRESS_LINE1 MADDRESS_LINE1, MA.ADDRESS_LINE2 MADDRESS_LINE2,
	LOC.ADDRESS_LINE1, LOC.ADDRESS_LINE2,
	BLT.NAME LICENSETYPE,
	BLC.NAME LICENSECLASS,
	F.FEEAMOUNT, F.FEENAME,
	STUFF((select  ', '+(BLEBT.CODENUMBER + '   ' + BLEBT.NAME) 
			from BLLICENSE BLL
			LEFT OUTER JOIN BLLICENSEEXTBUSINESSTYPE BLGEEBT ON BLL.BLLICENSEID = BLGEEBT.BLLICENSEID
			LEFT OUTER JOIN BLEXTBUSINESSTYPE BLEBT ON BLGEEBT.BLEXTBUSINESSTYPEID = BLEBT.BLEXTBUSINESSTYPEID
			WHERE BLL.BLLICENSEID = @BLLICENSEID
			for xml path(''), root('MyString'), type
		).value('/MyString[1]','varchar(max)'),1,2,'') AS 'BUSINESSTYPE',
	CASE WHEN (SELECT ISNULL(R.REPORTTEXT,'') FROM RPTTEXTLIB R
		WHERE R.TEXTNAME = 'Business_License_Renewal_v2_Municipality_Name') = '' 
		THEN (SELECT R.REPORTTEXT FROM RPTTEXTLIB R
		WHERE R.TEXTNAME = 'Municipality_Name')
		ELSE (SELECT R.REPORTTEXT FROM RPTTEXTLIB R
		WHERE R.TEXTNAME = 'Business_License_Renewal_v2_Municipality_Name') END Municipality_Name,
	CASE WHEN (SELECT ISNULL(R.REPORTTEXT,'') FROM RPTTEXTLIB R
		WHERE R.TEXTNAME = 'Business_License_Renewal_v2_Municipality_Address') = '' 
		THEN (SELECT R.REPORTTEXT FROM RPTTEXTLIB R
		WHERE R.TEXTNAME = 'Municipality_Address')
		ELSE (SELECT R.REPORTTEXT FROM RPTTEXTLIB R
		WHERE R.TEXTNAME = 'Business_License_Renewal_v2_Municipality_Address') END Municipality_Address,
	CASE WHEN (SELECT ISNULL(R.REPORTTEXT,'') FROM RPTTEXTLIB R
		WHERE R.TEXTNAME = 'Business_License_Renewal_v2_Municipality_Phone') = '' 
		THEN (SELECT R.REPORTTEXT FROM RPTTEXTLIB R
		WHERE R.TEXTNAME = 'Municipality_Phone_Number')
		ELSE (SELECT R.REPORTTEXT FROM RPTTEXTLIB R
		WHERE R.TEXTNAME = 'Business_License_Renewal_v2_Municipality_Phone') END Municipality_Phone_Number,
    (SELECT R.REPORTTEXT FROM RPTTEXTLIB R WHERE r.TEXTNAME = 'Business_License_Renewal_v2_Report_Title') Business_License_Renewal_v2_Report_Title,
	(SELECT R.REPORTTEXT FROM RPTTEXTLIB R WHERE r.TEXTNAME = 'Renewal_License_or_Permit_Number_Label') Renewal_License_or_Permit_Number_Label,
	(SELECT REPLACE(R.REPORTTEXT,CHAR(10),'<BR>') FROM RPTTEXTLIB R
		WHERE R.TEXTNAME = 'Business_License_Renewal_v2_Text1') Business_License_Renewal_v2_Text1,
	(SELECT REPLACE(R.REPORTTEXT,CHAR(10),'<BR>') FROM RPTTEXTLIB R
		WHERE R.TEXTNAME = 'Business_License_Renewal_v2_Text2') Business_License_Renewal_v2_Text2,
	(SELECT REPLACE(R.REPORTTEXT,CHAR(10),'<BR>') FROM RPTTEXTLIB R
		WHERE R.TEXTNAME = 'Business_License_Renewal_v2_Text3') Business_License_Renewal_v2_Text3,
	(SELECT R.[IMAGE] FROM RPTIMAGELIB R
		WHERE R.IMAGENAME = 'Business_License_Logo') LOGO,
	(SELECT CASE WHEN R.[IMAGE] IS NULL  THEN 'N' ELSE 'Y' END FROM RPTIMAGELIB R
		WHERE R.IMAGENAME = 'Business_License_Logo') SHOWLOGO,
	@CUSTOMFIELDS CUSTOMFIELDS
FROM BLLICENSE BL
INNER JOIN BLGLOBALENTITYEXTENSION BLGEE ON BL.BLGLOBALENTITYEXTENSIONID = BLGEE.BLGLOBALENTITYEXTENSIONID
INNER JOIN GLOBALENTITY BUS ON BLGEE.GLOBALENTITYID = BUS.GLOBALENTITYID
INNER JOIN BLLICENSETYPE BLT ON BL.BLLICENSETYPEID = BLT.BLLICENSETYPEID
INNER JOIN BLLICENSECLASS BLC ON BL.BLLICENSECLASSID = BLC.BLLICENSECLASSID
LEFT JOIN #CONTACT OWN ON BL.BLLICENSEID = OWN.BLLICENSEID AND OWN.ROWNBR = 1
LEFT JOIN #LOCADDRESS LOC ON BL.BLLICENSEID = LOC.BLLICENSEID AND LOC.ROWNBR = 1
LEFT JOIN #BUSADDRESS MA ON BLGEE.BLGLOBALENTITYEXTENSIONID = MA.BLGLOBALENTITYEXTENSIONID AND MA.ROWNBR = 1
LEFT JOIN #FEES F ON BL.BLLICENSEID = F.BLLICENSEID
WHERE BL.BLLICENSEID = @BLLICENSEID


DROP TABLE #CONTACT;
DROP TABLE #LOCADDRESS;
DROP TABLE #BUSADDRESS;
DROP TABLE #FEES;