﻿-- exec rpt_PM_Standard_Permit_License_Batch '20180301','20180401','applied date',''
-- select * from pmpermit
CREATE PROCEDURE rpt_PM_Standard_Permit_License_Batch
@STARTDATE AS DATETIME,
@ENDDATE AS DATETIME,
@FILTER AS VARCHAR(150),
@REPORTID VARCHAR(36)

AS

SET @STARTDATE = DATEADD(DAY, DATEDIFF(DAY, 0, @STARTDATE), 0)
SET @ENDDATE = DATEADD(SECOND,-1,DATEDIFF(DAY,0,@ENDDATE) + 1)


DECLARE @idTab AS IdTableType;
    
      INSERT    INTO @idTab
                ([Id])
      SELECT P.PMPERMITID
	  FROM PMPERMIT P
	  WHERE (CASE @FILTER
			 WHEN 'EXPIRATION DATE' THEN P.[EXPIREDATE]
			 WHEN 'APPLIED DATE' THEN P.APPLYDATE
			 WHEN 'ISSUED DATE' THEN P.ISSUEDATE END) BETWEEN @STARTDATE AND @ENDDATE;

      DECLARE @customFields TABLE
              ([Id] CHAR(36)
              ,[Text] NVARCHAR(MAX));

      INSERT    INTO @customFields
                EXEC [dbo].[GetAllCustomReportText] @ReportId, @idTab;


/*BUILD OWNER INFO*/
SELECT PC.PMPERMITID, PC.ISBILLING, LMCT.[NAME] CONTACTTYPE
	 , CASE WHEN GE.FIRSTNAME IS NULL OR GE.FIRSTNAME = '' THEN GE.GLOBALENTITYNAME ELSE LTRIM(RTRIM((GE.FIRSTNAME + CASE WHEN GE.MIDDLENAME IS NULL OR GE.MIDDLENAME = '' THEN ' ' ELSE ' ' + LEFT(GE.MIDDLENAME,1) + ' ' END + GE.LASTNAME))) END AS O_NAME
	 , GE.GLOBALENTITYNAME COMPANYNAME
	 , RTRIM(MA.ADDRESSLINE1 + ' ' +	LTRIM(MA.PREDIRECTION + ' ') + LTRIM(MA.ADDRESSLINE2 + ' ') + 
	   LTRIM(MA.STREETTYPE + ' ') + LTRIM(MA.POSTDIRECTION + ' ') + LTRIM(MA.UNITORSUITE + ' ')  + LTRIM(MA.ADDRESSLINE3)) O_ADDRESS_LINE1
	 , RTRIM(CASE WHEN RTRIM(LTRIM(MA.CITY)) = '' THEN '' ELSE LTRIM(MA.CITY + ', ' ) END + LTRIM(MA.STATE + ' ') +  MA.POSTALCODE) O_ADDRESS_LINE2
     , ROW_NUMBER() OVER (PARTITION BY PC.PMPERMITID ORDER BY CASE WHEN LMCT.NAME LIKE 'OWNER%' THEN 1 ELSE 3 END, GE.GLOBALENTITYID, CASE MA.ADDRESSTYPE WHEN 'MAILING' THEN 1 ELSE 4 END, MA.MAILINGADDRESSID) 'RowNBR'

INTO #CONTACT
FROM PMPERMITCONTACT PC
INNER JOIN LANDMANAGEMENTCONTACTTYPE LMCT ON PC.LANDMANAGEMENTCONTACTTYPEID = LMCT.LANDMANAGEMENTCONTACTTYPEID AND LMCT.NAME LIKE 'OWNER%'
INNER JOIN GLOBALENTITY GE ON PC.GLOBALENTITYID = GE.GLOBALENTITYID
LEFT OUTER JOIN GLOBALENTITYMAILINGADDRESS GEMA ON GE.GLOBALENTITYID = GEMA.GLOBALENTITYID
LEFT OUTER JOIN MAILINGADDRESS MA ON MA.MAILINGADDRESSID = GEMA.MAILINGADDRESSID AND MA.ADDRESSTYPE = 'MAILING'

CREATE INDEX TEMP1 ON #CONTACT (PMPERMITID);

/*LOCATION ADDRESS*/
SELECT PA.MAIN, PA.PMPERMITID
     , MA.ADDRESSTYPE, RTRIM(MA.ADDRESSLINE1 + ' ' +	LTRIM(MA.PREDIRECTION + ' ') + LTRIM(MA.ADDRESSLINE2 + ' ') + 
	   LTRIM(MA.STREETTYPE + ' ') + LTRIM(MA.POSTDIRECTION + ' ') + LTRIM(MA.UNITORSUITE + ' ')  + LTRIM(MA.ADDRESSLINE3)) ADDRESS_LINE1
	 , RTRIM(CASE WHEN RTRIM(LTRIM(MA.CITY)) = '' THEN '' ELSE LTRIM(MA.CITY + ', ' ) END + LTRIM(MA.STATE + ' ') + 
	        (CASE WHEN LEN(REPLACE(ISNULL(MA.POSTALCODE,''),'-','')) > 5 
		          THEN SUBSTRING(REPLACE(ISNULL(MA.POSTALCODE,''),'-',''),1,5) + '-' + SUBSTRING(REPLACE(ISNULL(MA.POSTALCODE,''),'-',''),6,4)
		          ELSE REPLACE(ISNULL(MA.POSTALCODE,''),'-','') END)) ADDRESS_LINE2
	 , ROW_NUMBER() OVER (PARTITION BY PA.PMPERMITID ORDER BY CASE WHEN MA.ADDRESSTYPE LIKE '%LOCATION%' THEN 1 ELSE 2 END ) AS ROWNBR

INTO #LOCADDRESS
FROM PMPERMITADDRESS PA
INNER JOIN MAILINGADDRESS MA ON PA.MAILINGADDRESSID = MA.MAILINGADDRESSID

CREATE INDEX TEMP1 ON #LOCADDRESS (PMPERMITID);

/*ALL LICENSE FEES*/
SELECT PF.PMPERMITID, SUM(C.COMPUTEDAMOUNT) FEEAMOUNT
INTO #FEES
FROM PMPERMITFEE PF
INNER JOIN CACOMPUTEDFEE C ON C.CACOMPUTEDFEEID = PF.CACOMPUTEDFEEID
WHERE C.CASTATUSID NOT IN (5,9,10) 
GROUP BY PF.PMPERMITID

CREATE INDEX TEMP1 ON #FEES (PMPERMITID);

/*BEGIN MAIN QUERY*/
SELECT P.PMPERMITID, P.PERMITNUMBER, CASE WHEN P.EXPIREDATE = '1/1/2999' THEN NULL ELSE P.EXPIREDATE END AS EXPIRATIONDATE, P.ISSUEDATE
	 , PT.[NAME] PERMITTYPE
	 , PWC.[NAME] WORKCLASS
	 , OWN.O_NAME, OWN.COMPANYNAME, OWN.O_ADDRESS_LINE1, OWN.O_ADDRESS_LINE2
	 , MA.ADDRESS_LINE1 MADDRESS_LINE1, MA.ADDRESS_LINE2 MADDRESS_LINE2
	 , F.FEEAMOUNT
	 , CASE WHEN (SELECT ISNULL(R.REPORTTEXT,'') FROM RPTTEXTLIB R WHERE R.TEXTNAME = 'Permit_License_Municipality_Name') = '' 
		   THEN (SELECT R.REPORTTEXT FROM RPTTEXTLIB R WHERE R.TEXTNAME = 'Municipality_Name')
		   ELSE (SELECT R.REPORTTEXT FROM RPTTEXTLIB R WHERE R.TEXTNAME = 'Permit_License_Municipality_Name') END Municipality_Name
	, CASE WHEN (SELECT ISNULL(R.REPORTTEXT,'') FROM RPTTEXTLIB R WHERE R.TEXTNAME = 'Permit_License_Municipality_Address') = '' 
		   THEN (SELECT R.REPORTTEXT FROM RPTTEXTLIB R	WHERE R.TEXTNAME = 'Municipality_Address')
		   ELSE (SELECT R.REPORTTEXT FROM RPTTEXTLIB R WHERE R.TEXTNAME = 'Permit_License_Municipality_Address') END Municipality_Address
	, CASE WHEN (SELECT ISNULL(R.REPORTTEXT,'') FROM RPTTEXTLIB R WHERE R.TEXTNAME = 'Permit_License_Municipality_Phone_Number') = '' 
		   THEN (SELECT R.REPORTTEXT FROM RPTTEXTLIB R WHERE R.TEXTNAME = 'Municipality_Phone_Number')
		   ELSE (SELECT R.REPORTTEXT FROM RPTTEXTLIB R WHERE R.TEXTNAME = 'Permit_License_Municipality_Phone_Number') END Municipality_Phone_Number
	, (SELECT REPLACE(R.REPORTTEXT,CHAR(10),'<BR>') FROM RPTTEXTLIB R	WHERE R.TEXTNAME = 'Permit_License_Text1') Permit_License_Text1
	, (SELECT REPLACE(R.REPORTTEXT,CHAR(10),'<BR>') FROM RPTTEXTLIB R	WHERE R.TEXTNAME = 'Permit_License_Text2') Permit_License_Text2
    , (SELECT R.REPORTTEXT FROM RPTTEXTLIB R WHERE r.TEXTNAME = 'Permit_License_Report_Title') Permit_License_Report_Title
	, (SELECT R.REPORTTEXT FROM RPTTEXTLIB R WHERE r.TEXTNAME = 'License_or_Permit_Number_Label') License_or_Permit_Number_Label
	, (SELECT R.REPORTTEXT FROM RPTTEXTLIB R WHERE R.TEXTNAME = 'Permit_License_Signature_Line') Permit_License_Signature_Line
	, (SELECT R.[IMAGE] FROM RPTIMAGELIB R WHERE R.IMAGENAME = 'BL_Logo(CAN be used with signature image)') LOGO
	, (SELECT CASE WHEN R.[IMAGE] IS NULL  THEN 'N' ELSE 'Y' END FROM RPTIMAGELIB R WHERE R.IMAGENAME = 'BL_Logo(CAN be used with signature image)') SHOWLOGO
	, (SELECT R.[IMAGE] FROM RPTIMAGELIB R WHERE R.IMAGENAME = 'BL_Watermark(CANNOT be used with signature image)') WATERMARK
	, (SELECT R.DIMENSIONS FROM RPTIMAGELIB R WHERE R.IMAGENAME = 'BL_Watermark(CANNOT be used with signature image)') Watermark_Dimensions
	, (SELECT CASE WHEN R.[IMAGE] IS NULL  THEN 'N' ELSE 'Y' END FROM RPTIMAGELIB R	WHERE R.IMAGENAME = 'BL_Watermark(CANNOT be used with signature image)') SHOWWATERMARK
	, (SELECT R.[IMAGE] FROM RPTIMAGELIB R WHERE R.IMAGENAME = 'Permit_License_Signature_Image') SIGIMAGE
	, (SELECT CASE WHEN R.[IMAGE] IS NULL  THEN 'N' ELSE 'Y' END FROM RPTIMAGELIB R	WHERE R.IMAGENAME = 'Permit_License_Signature_Image') SHOWSIGIMAGE
	, CF.Text CUSTOMFIELDS

FROM PMPERMIT P
INNER JOIN PMPERMITTYPE PT ON P.PMPERMITTYPEID = PT.PMPERMITTYPEID 
INNER JOIN PMPERMITWORKCLASS PWC ON P.PMPERMITWORKCLASSID = PWC.PMPERMITWORKCLASSID
INNER JOIN @idTab ID ON P.PMPERMITID = ID.[Id]
LEFT JOIN #CONTACT OWN ON P.PMPERMITID = OWN.PMPERMITID AND OWN.ROWNBR = 1
LEFT JOIN #LOCADDRESS MA ON P.PMPERMITID = MA.PMPERMITID AND MA.ROWNBR = 1
LEFT JOIN #FEES F ON P.PMPERMITID = F.PMPERMITID
LEFT JOIN @customFields CF ON CF.ID = P.PMPERMITID


DROP TABLE #CONTACT;
DROP TABLE #LOCADDRESS;
DROP TABLE #FEES;

