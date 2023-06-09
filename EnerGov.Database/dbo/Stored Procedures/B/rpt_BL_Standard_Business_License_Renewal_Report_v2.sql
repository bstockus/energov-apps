﻿
-- exec rpt_BL_Standard_Business_License_Renewal_Report_v2 '20171031','20181031','issued date',''

CREATE PROCEDURE rpt_BL_Standard_Business_License_Renewal_Report_v2
	@STARTDATE AS DATETIME,
	@ENDDATE AS DATETIME,
	@FILTER VARCHAR(150),
	@REPORTID VARCHAR(36)
AS

SET @STARTDATE = DATEADD(DAY, DATEDIFF(DAY, 0, @STARTDATE), 0)
SET @ENDDATE = DATEADD(SECOND,-1,DATEDIFF(DAY,0,@ENDDATE) + 1)

 DECLARE @idTab AS IdTableType;
    
      INSERT    INTO @idTab
                ([Id])
      SELECT BL.BLLICENSEID
	  FROM BLLICENSE BL
	  INNER JOIN BLLICENSESTATUS LS ON BL.BLLICENSESTATUSID = LS.BLLICENSESTATUSID
	  WHERE (CASE @FILTER
			 WHEN 'ISSUED DATE' THEN BL.ISSUEDDATE
			 WHEN 'EXPIRATION DATE' THEN BL.EXPIRATIONDATE
			 WHEN 'APPLIED DATE' THEN BL.APPLIEDDATE
			 WHEN 'LAST RENEWAL DATE' THEN BL.LASTRENEWALDATE END) BETWEEN @STARTDATE AND @ENDDATE
		AND	 LS.BLLICENSESTATUSSYSTEMID <> 3 --REVOKED;

      DECLARE @customFields TABLE
              ([Id] CHAR(36)
              ,[Text] NVARCHAR(MAX));

      INSERT    INTO @customFields
                EXEC [dbo].[GetAllCustomReportText] @ReportId, @idTab;

/*CREATE A INDEXED FILTER*/
SELECT Id BLLICENSEID
INTO #FILTER
FROM @idTab
;CREATE INDEX TEMP1 ON #FILTER(BLLICENSEID);


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
FROM #FILTER F
INNER JOIN BLLICENSECONTACT BLC ON F.BLLICENSEID = BLC.BLLICENSEID
INNER JOIN GLOBALENTITY GE ON BLC.GLOBALENTITYID = GE.GLOBALENTITYID
INNER JOIN BLCONTACTTYPE BLCT ON BLC.BLCONTACTTYPEID = BLCT.BLCONTACTTYPEID 
WHERE BLCT.NAME LIKE '%OWNER%'

/*LOCATION ADDRESS*/
SELECT BLA.MAIN, BLA.BLLICENSEID, MA.ADDRESSTYPE, RTRIM(MA.ADDRESSLINE1 + ' ' +	LTRIM(MA.PREDIRECTION + ' ') + LTRIM(MA.ADDRESSLINE2 + ' ') + 
	LTRIM(MA.STREETTYPE + ' ') + LTRIM(MA.POSTDIRECTION + ' ') + LTRIM(MA.UNITORSUITE + ' ')  + LTRIM(MA.ADDRESSLINE3)) ADDRESS_LINE1,
	RTRIM(CASE WHEN RTRIM(LTRIM(MA.CITY)) = '' THEN '' ELSE LTRIM(MA.CITY + ', ' ) END + LTRIM(MA.STATE + ' ') + MA.POSTALCODE) ADDRESS_LINE2,
	ROW_NUMBER() OVER (PARTITION BY BLA.BLLICENSEID ORDER BY CASE WHEN MA.ADDRESSTYPE LIKE '%LOCATION%' THEN 1 ELSE 2 END ) AS ROWNBR
INTO #LOCADDRESS
FROM #FILTER F
INNER JOIN BLLICENSEADDRESS BLA ON F.BLLICENSEID = BLA.BLLICENSEID
INNER JOIN MAILINGADDRESS MA ON BLA.MAILINGADDRESSID = MA.MAILINGADDRESSID

/*MAILING ADDRESS*/
SELECT BLGEEA.MAIN, BLGEEA.BLGLOBALENTITYEXTENSIONID, MA.ADDRESSTYPE, RTRIM(MA.ADDRESSLINE1 + ' ' +	LTRIM(MA.PREDIRECTION + ' ') + LTRIM(MA.ADDRESSLINE2 + ' ') + 
	LTRIM(MA.STREETTYPE + ' ') + LTRIM(MA.POSTDIRECTION + ' ') + LTRIM(MA.UNITORSUITE + ' ')  + LTRIM(MA.ADDRESSLINE3)) ADDRESS_LINE1,
	RTRIM(CASE WHEN RTRIM(LTRIM(MA.CITY)) = '' THEN '' ELSE LTRIM(MA.CITY + ', ' ) END + LTRIM(MA.STATE + ' ') + MA.POSTALCODE) ADDRESS_LINE2,
	ROW_NUMBER() OVER (PARTITION BY BLGEEA.BLGLOBALENTITYEXTENSIONID ORDER BY CASE WHEN MA.ADDRESSTYPE LIKE '%MAILING%' THEN 1 ELSE 2 END ) AS ROWNBR
INTO #BUSADDRESS
FROM #FILTER F
INNER JOIN BLLICENSE L ON F.BLLICENSEID = L.BLLICENSEID
INNER JOIN BLGLOBALENTITYEXTENSIONADDRESS BLGEEA ON L.BLGLOBALENTITYEXTENSIONID = BLGEEA.BLGLOBALENTITYEXTENSIONID
INNER JOIN MAILINGADDRESS MA ON BLGEEA.MAILINGADDRESSID = MA.MAILINGADDRESSID

/*ALL LICENSE FEES*/
SELECT BLF.BLLICENSEID, C.COMPUTEDAMOUNT FEEAMOUNT, C.FEENAME
INTO #FEES
FROM #FILTER F
INNER JOIN BLLICENSEFEE BLF ON F.BLLICENSEID = BLF.BLLICENSEID
INNER JOIN CACOMPUTEDFEE C ON C.CACOMPUTEDFEEID = BLF.CACOMPUTEDFEEID
WHERE  	C.CASTATUSID NOT IN (5,9,10) AND C.FEENAME NOT LIKE '%PENALTY%'AND
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
SELECT BL.BLLICENSEID, BL.LICENSENUMBER, CASE WHEN BL.EXPIRATIONDATE = '1/1/2999' THEN NULL ELSE BL.EXPIRATIONDATE END AS EXPIRATIONDATE, BL.TAXYEAR, BL.ISSUEDDATE
	 , BLGEE.DBA, BLGEE.EINNUMBER AS TIN, BLGEE.STATETAXNUMBER AS TAXID
	 , BUS.GLOBALENTITYNAME BUSINESSNAME
	 , CASE WHEN OWN.ISCOMPANY = 1 THEN OWN.GLOBALENTITYNAME ELSE OWN.FIRSTNAME + ' ' + OWN.LASTNAME  END OWNERNAME
	 , MA.ADDRESS_LINE1 MADDRESS_LINE1, MA.ADDRESS_LINE2 MADDRESS_LINE2
	 , LOC.ADDRESS_LINE1, LOC.ADDRESS_LINE2
	 , BLT.NAME LICENSETYPE
	 , BLC.NAME LICENSECLASS
	 , F.FEEAMOUNT, F.FEENAME
	 , STUFF((select  ', '+(BLEBT.CODENUMBER + '   ' + BLEBT.NAME) 
			 from BLLICENSE BLL
			 LEFT OUTER JOIN BLLICENSEEXTBUSINESSTYPE BLGEEBT ON BLL.BLLICENSEID = BLGEEBT.BLLICENSEID
			 LEFT OUTER JOIN BLEXTBUSINESSTYPE BLEBT ON BLGEEBT.BLEXTBUSINESSTYPEID = BLEBT.BLEXTBUSINESSTYPEID
			 WHERE BLL.BLLICENSEID = BL.BLLICENSEID
			 for xml path(''), root('MyString'), type
		     ).value('/MyString[1]','varchar(max)'),1,2,'') AS 'BUSINESSTYPE'
	 , CASE WHEN (SELECT ISNULL(R.REPORTTEXT,'') FROM RPTTEXTLIB R WHERE R.TEXTNAME = 'Business_License_Renewal_v2_Municipality_Name') = '' 
		    THEN (SELECT R.REPORTTEXT FROM RPTTEXTLIB R WHERE R.TEXTNAME = 'Municipality_Name')
		    ELSE (SELECT R.REPORTTEXT FROM RPTTEXTLIB R	WHERE R.TEXTNAME = 'Business_License_Renewal_v2_Municipality_Name') END Municipality_Name
	 , CASE WHEN (SELECT ISNULL(R.REPORTTEXT,'') FROM RPTTEXTLIB R WHERE R.TEXTNAME = 'Business_License_Renewal_v2_Municipality_Address') = '' 
		    THEN (SELECT R.REPORTTEXT FROM RPTTEXTLIB R WHERE R.TEXTNAME = 'Municipality_Address')
		    ELSE (SELECT R.REPORTTEXT FROM RPTTEXTLIB R WHERE R.TEXTNAME = 'Business_License_Renewal_v2_Municipality_Address') END Municipality_Address
	 , CASE WHEN (SELECT ISNULL(R.REPORTTEXT,'') FROM RPTTEXTLIB R WHERE R.TEXTNAME = 'Business_License_Renewal_v2_Municipality_Phone_Number') = '' 
	    	THEN (SELECT R.REPORTTEXT FROM RPTTEXTLIB R WHERE R.TEXTNAME = 'Municipality_Phone_Number')
		    ELSE (SELECT R.REPORTTEXT FROM RPTTEXTLIB R WHERE R.TEXTNAME = 'Business_License_Renewal_v2_Municipality_Phone') END Municipality_Phone_Number
     , (SELECT R.REPORTTEXT FROM RPTTEXTLIB R WHERE r.TEXTNAME = 'Business_License_Renewal_v2_Report_Title') Business_License_Renewal_v2_Report_Title
	 , (SELECT R.REPORTTEXT FROM RPTTEXTLIB R WHERE r.TEXTNAME = 'Renewal_License_or_Permit_Number_Label') Renewal_License_or_Permit_Number_Label
	 , (SELECT REPLACE(R.REPORTTEXT,CHAR(10),'<BR>') FROM RPTTEXTLIB R WHERE R.TEXTNAME = 'Business_License_Renewal_v2_Text1') Business_License_Renewal_v2_Text1
	 , (SELECT REPLACE(R.REPORTTEXT,CHAR(10),'<BR>') FROM RPTTEXTLIB R WHERE R.TEXTNAME = 'Business_License_Renewal_v2_Text2') Business_License_Renewal_v2_Text2
	 , (SELECT REPLACE(R.REPORTTEXT,CHAR(10),'<BR>') FROM RPTTEXTLIB R WHERE R.TEXTNAME = 'Business_License_Renewal_v2_Text3') Business_License_Renewal_v2_Text3
	 , (SELECT R.[IMAGE] FROM RPTIMAGELIB R WHERE R.IMAGENAME = 'Business_License_Logo') LOGO
	 , (SELECT CASE WHEN R.[IMAGE] IS NULL  THEN 'N' ELSE 'Y' END FROM RPTIMAGELIB R WHERE R.IMAGENAME = 'Business_License_Logo') SHOWLOGO
	 , CF.Text CUSTOMFIELDS

FROM BLLICENSE BL
INNER JOIN BLGLOBALENTITYEXTENSION BLGEE ON BL.BLGLOBALENTITYEXTENSIONID = BLGEE.BLGLOBALENTITYEXTENSIONID
INNER JOIN GLOBALENTITY BUS ON BLGEE.GLOBALENTITYID = BUS.GLOBALENTITYID
INNER JOIN BLLICENSETYPE BLT ON BL.BLLICENSETYPEID = BLT.BLLICENSETYPEID
INNER JOIN BLLICENSECLASS BLC ON BL.BLLICENSECLASSID = BLC.BLLICENSECLASSID
INNER JOIN @idTab ID ON BL.BLLICENSEID = ID.[Id]
LEFT JOIN #CONTACT OWN ON BL.BLLICENSEID = OWN.BLLICENSEID AND OWN.ROWNBR = 1
LEFT JOIN #LOCADDRESS LOC ON BL.BLLICENSEID = LOC.BLLICENSEID AND LOC.ROWNBR = 1
LEFT JOIN #BUSADDRESS MA ON BLGEE.BLGLOBALENTITYEXTENSIONID = MA.BLGLOBALENTITYEXTENSIONID AND MA.ROWNBR = 1
LEFT JOIN #FEES F ON BL.BLLICENSEID = F.BLLICENSEID
LEFT JOIN @customFields CF ON CF.ID = BL.BLLICENSEID


DROP TABLE #CONTACT;
DROP TABLE #LOCADDRESS;
DROP TABLE #BUSADDRESS;
DROP TABLE #FEES;