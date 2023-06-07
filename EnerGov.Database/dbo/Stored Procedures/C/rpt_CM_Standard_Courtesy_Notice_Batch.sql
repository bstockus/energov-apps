﻿
/*
exec rpt_CM_Standard_Courtesy_Notice_Batch '20180101', '20190801', ''

*/

CREATE PROCEDURE rpt_CM_Standard_Courtesy_Notice_Batch
@STARTDATE DATETIME,
@ENDDATE DATETIME,
@REPORTID VARCHAR(36)
AS

SET @STARTDATE = DATEADD(DAY, DATEDIFF(DAY, 0, @STARTDATE), 0)
SET @ENDDATE = DATEADD(SECOND,-1,DATEDIFF(DAY,0,@ENDDATE) + 1)

--DECLARE @CUSTOMFIELDS NVARCHAR(MAX) = '';
--EXEC [dbo].[GetCustomReportText] @REPORTID, @CMCODECASEID, @CUSTOMFIELDS OUTPUT; 

DECLARE @idTab AS IdTableType;
    
      INSERT    INTO @idTab
                ([Id])
      SELECT DISTINCT CWFS.CMCODECASEID
		FROM CMCODEWFSTEP CWFS
		INNER JOIN CMVIOLATION CV ON CWFS.CMCODEWFSTEPID = CV.CMCODEWFSTEPID
		INNER JOIN CMCODE C ON CV.CMCODEID = C.CMCODEID 
		INNER JOIN CMCODEREVISION CR ON C.CMCODEID = CR.CMCODEID AND CR.CURRENTREVISION = 1
		WHERE CV.CITATIONISSUEDATE BETWEEN @STARTDATE AND @ENDDATE;

      DECLARE @customFields TABLE
              ([Id] CHAR(36)
              ,[Text] NVARCHAR(MAX));

      INSERT    INTO @customFields
                EXEC [dbo].[GetAllCustomReportText] @ReportId, @idTab;

/*BUILD VIOLATION LIST*/
SELECT CWFS.CMCODECASEID,CV.CITATIONISSUEDATE, CV.COMPLIANCEDATE, CV.CORRECTIVEACTION,
	C.CODENUMBER, C.DESCRIPTION, 
	CR.CODETEXT REVISIONCODETEXT
INTO #VIO
FROM CMCODEWFSTEP CWFS
INNER JOIN CMVIOLATION CV ON CWFS.CMCODEWFSTEPID = CV.CMCODEWFSTEPID
INNER JOIN CMVIOLATIONSTATUS VS ON CV.CMVIOLATIONSTATUSID = VS.CMVIOLATIONSTATUSID AND VS.SUCCESSFLAG <> 1
INNER JOIN CMCODE C ON CV.CMCODEID = C.CMCODEID 
INNER JOIN CMCODEREVISION CR ON C.CMCODEID = CR.CMCODEID AND CR.CURRENTREVISION = 1
--WHERE CWFS.CMCODECASEID = @CMCODECASEID

/*MINIMUM COMPLIANCE DATE*/
SELECT CWFS.CMCODECASEID, MIN(CV.COMPLIANCEDATE) AS MINCOMPLIANCEDATE
INTO #MINVIO
FROM CMCODEWFSTEP CWFS
INNER JOIN CMVIOLATION CV ON CWFS.CMCODEWFSTEPID = CV.CMCODEWFSTEPID
INNER JOIN CMVIOLATIONSTATUS VS ON CV.CMVIOLATIONSTATUSID = VS.CMVIOLATIONSTATUSID AND VS.SUCCESSFLAG <> 1
--WHERE CWFS.CMCODECASEID = @CMCODECASEID
GROUP BY CWFS.CMCODECASEID

/*BUILD CONTACT LIST*/
SELECT CCC.CMCODECASEID, GE.FIRSTNAME, GE.LASTNAME, GE.GLOBALENTITYID, CCCT.NAME CONTACTTYPE, GE.GLOBALENTITYNAME COMPANYNAME, 
	CCC.ISBILLING, GE.GLOBALENTITYNAME, GE.[IMAGE], GE.ISCOMPANY, GE.ISCONTACT, GE.MIDDLENAME,
	CASE	WHEN LEN(LTRIM(GE.BUSINESSPHONE)) > 0 THEN GE.BUSINESSPHONE 
		WHEN LEN(LTRIM(GE.MOBILEPHONE)) > 0 THEN GE.MOBILEPHONE 
		WHEN LEN(LTRIM(GE.HOMEPHONE)) > 0 THEN GE.HOMEPHONE 
		WHEN LEN(LTRIM(GE.OTHERPHONE)) > 0 THEN GE.OTHERPHONE 
		ELSE '' END AS PHONE
INTO #CONTACT
FROM CMCODECASECONTACT CCC
INNER JOIN GLOBALENTITY GE ON CCC.GLOBALENTITYID = GE.GLOBALENTITYID
INNER JOIN CMCODECASECONTACTTYPE CCCT ON CCC.CMCODECASECONTACTTYPEID = CCCT.CMCODECASECONTACTTYPEID
--WHERE CCC.CMCODECASEID = @CMCODECASEID

/*BUILD LIST OF ADDRESSES FOR CONTACTS*/
SELECT GEMA.GLOBALENTITYID, MA.ADDRESSTYPE, RTRIM(MA.ADDRESSLINE1 + ' ' +	LTRIM(MA.PREDIRECTION + ' ') + LTRIM(MA.ADDRESSLINE2 + ' ') + 
	LTRIM(MA.STREETTYPE + ' ') + LTRIM(MA.POSTDIRECTION + ' ') + LTRIM(MA.UNITORSUITE + ' ')  + LTRIM(MA.ADDRESSLINE3)) ADDRESS_LINE1,
	RTRIM(CASE WHEN RTRIM(LTRIM(MA.CITY)) = '' THEN '' ELSE LTRIM(MA.CITY + ', ' ) END + LTRIM(MA.STATE + ' ') + 
	(CASE WHEN LEN(REPLACE(ISNULL(MA.POSTALCODE,''),'-','')) > 5 
		THEN SUBSTRING(REPLACE(ISNULL(MA.POSTALCODE,''),'-',''),1,5) + '-' + SUBSTRING(REPLACE(ISNULL(MA.POSTALCODE,''),'-',''),6,4)
		ELSE REPLACE(ISNULL(MA.POSTALCODE,''),'-','') END)) ADDRESS_LINE2,
	ROW_NUMBER() OVER (PARTITION BY GEMA.GLOBALENTITYID ORDER BY CASE WHEN MA.ADDRESSTYPE LIKE 'Mailing%' THEN 1 WHEN MA.ADDRESSTYPE LIKE 'Billing%' THEN 2 WHEN MA.ADDRESSTYPE LIKE 'Location%' THEN 3 ELSE 4 END, MA.MAILINGADDRESSID) AS ROWNBR
INTO #CONTACTADDRESS
FROM GLOBALENTITYMAILINGADDRESS GEMA 
INNER JOIN MAILINGADDRESS MA ON GEMA.MAILINGADDRESSID = MA.MAILINGADDRESSID

/*MAIN CASE ADDRESS*/
SELECT CCA.MAIN, CCA.CMCODECASEID, MA.ADDRESSTYPE, RTRIM(MA.ADDRESSLINE1 + ' ' +	LTRIM(MA.PREDIRECTION + ' ') + LTRIM(MA.ADDRESSLINE2 + ' ') + 
	LTRIM(MA.STREETTYPE + ' ') + LTRIM(MA.POSTDIRECTION + ' ') + LTRIM(MA.UNITORSUITE + ' ')  + LTRIM(MA.ADDRESSLINE3)) ADDRESS_LINE1,
	RTRIM(CASE WHEN RTRIM(LTRIM(MA.CITY)) = '' THEN '' ELSE LTRIM(MA.CITY + ', ' ) END + LTRIM(MA.STATE + ' ') + 
	(CASE WHEN LEN(REPLACE(ISNULL(MA.POSTALCODE,''),'-','')) > 5 
		THEN SUBSTRING(REPLACE(ISNULL(MA.POSTALCODE,''),'-',''),1,5) + '-' + SUBSTRING(REPLACE(ISNULL(MA.POSTALCODE,''),'-',''),6,4)
		ELSE REPLACE(ISNULL(MA.POSTALCODE,''),'-','') END)) ADDRESS_LINE2
INTO #MADDRESS
FROM CMCODECASEADDRESS CCA
INNER JOIN MAILINGADDRESS MA ON CCA.MAILINGADDRESSID = MA.MAILINGADDRESSID
WHERE CCA.MAIN = 1

SELECT DISTINCT CC.CMCODECASEID
INTO #INSPECTION
FROM CMCODECASE CC
INNER JOIN IMINSPECTION IM ON CC.CMCODECASEID = IM.LINKID
WHERE IM.ACTUALSTARTDATE BETWEEN @STARTDATE AND @ENDDATE

CREATE INDEX TEMP1 ON #VIO (CMCODECASEID);
CREATE INDEX TEMP1 ON #MINVIO (CMCODECASEID);
CREATE INDEX TEMP1 ON #CONTACT (CMCODECASEID);
CREATE INDEX TEMP1 ON #CONTACTADDRESS (GLOBALENTITYID);
CREATE INDEX TEMP2 ON #CONTACTADDRESS (ROWNBR);
CREATE INDEX TEMP1 ON #MADDRESS (CMCODECASEID);
CREATE INDEX TEMP1 ON #INSPECTION (CMCODECASEID);

/*BEGIN MAIN QUERY*/
SELECT CM.CMCODECASEID, CM.CASENUMBER, CM.OPENEDDATE
	 , CT.NAME CASETYPE
	 , P.PARCELNUMBER
	 , MVIO.MINCOMPLIANCEDATE
	 , VIO.CITATIONISSUEDATE, VIO.COMPLIANCEDATE, VIO.CODENUMBER, VIO.DESCRIPTION, VIO.REVISIONCODETEXT, VIO.CORRECTIVEACTION
	 , CASE WHEN CON.ISCONTACT = 1 THEN CON.FIRSTNAME + ' ' + CON.LASTNAME ELSE CON.GLOBALENTITYNAME END CONTACTNAME, CON.CONTACTTYPE
	 , CONADD.ADDRESS_LINE1, CONADD.ADDRESS_LINE2, CON.GLOBALENTITYID
	 , MA.ADDRESS_LINE1 MADDRESS_LINE1, MA.ADDRESS_LINE2 MADDRESS_LINE2
	 , U.FNAME + ' ' + U.LNAME ASSIGNEDTO, U.TITLE
	 , CASE WHEN (SELECT ISNULL(R.REPORTTEXT,'') FROM RPTTEXTLIB R WHERE R.TEXTNAME = 'Courtesy_Notice_Municipality_Name') = '' 
		    THEN (SELECT R.REPORTTEXT FROM RPTTEXTLIB R WHERE R.TEXTNAME = 'Municipality_Name')
		    ELSE (SELECT R.REPORTTEXT FROM RPTTEXTLIB R WHERE R.TEXTNAME = 'Courtesy_Notice_Municipality_Name') END Municipality_Name
	 , CASE WHEN (SELECT ISNULL(R.REPORTTEXT,'') FROM RPTTEXTLIB R	WHERE R.TEXTNAME = 'Courtesy_Notice_Municipality_Address') = '' 
		    THEN (SELECT R.REPORTTEXT FROM RPTTEXTLIB R WHERE R.TEXTNAME = 'Municipality_Address')
		    ELSE (SELECT R.REPORTTEXT FROM RPTTEXTLIB R WHERE R.TEXTNAME = 'Courtesy_Notice_Municipality_Address') END Municipality_Address
	 , (SELECT REPLACE(R.REPORTTEXT,CHAR(10),'<BR>') FROM RPTTEXTLIB R WHERE R.TEXTNAME = 'Courtesy_Notice_Text') Courtesy_Notice_Text
	 , (SELECT REPLACE(R.REPORTTEXT,CHAR(10),'<BR>') FROM RPTTEXTLIB R WHERE R.TEXTNAME = 'Courtesy_Notice_Text1') Courtesy_Notice_Text1
	 , (SELECT REPLACE(R.REPORTTEXT,CHAR(10),'<BR>') FROM RPTTEXTLIB R WHERE R.TEXTNAME = 'Courtesy_Notice_Text2') Courtesy_Notice_Text2
	 , (SELECT R.REPORTTEXT FROM RPTTEXTLIB R WHERE R.TEXTNAME = 'Courtesy_Notice_Title') Courtesy_Notice_Title
	 , (SELECT CASE WHEN R.[IMAGE] IS NULL THEN 'N' ELSE 'Y' END FROM RPTIMAGELIB R WHERE R.IMAGENAME = 'Code_Case_Logo') SHOWLOGO
	 , CF.Text AS CUSTOMFIELDS

FROM CMCODECASE CM
INNER JOIN CMCASETYPE CT ON CM.CMCASETYPEID = CT.CMCASETYPEID
INNER JOIN @idTab ID ON CM.CMCODECASEID = ID.[Id]
LEFT JOIN @customFields CF ON CF.ID = CM.CMCODECASEID
LEFT JOIN CMCODECASEPARCEL CP ON CM.CMCODECASEID = CP.CMCODECASEID AND CP.[PRIMARY] = 1
LEFT JOIN PARCEL P ON CP.PARCELID = P.PARCELID 
LEFT JOIN #VIO VIO ON CM.CMCODECASEID = VIO.CMCODECASEID
LEFT JOIN #MINVIO MVIO ON CM.CMCODECASEID = MVIO.CMCODECASEID
LEFT JOIN #CONTACT CON ON CM.CMCODECASEID = CON.CMCODECASEID AND CON.CONTACTTYPE IN ('VIOLATOR','OWNER','TENANT')
LEFT JOIN #CONTACTADDRESS CONADD ON CON.GLOBALENTITYID = CONADD.GLOBALENTITYID AND CONADD.ROWNBR = 1
LEFT JOIN #MADDRESS MA ON CM.CMCODECASEID = MA.CMCODECASEID
LEFT JOIN USERS U ON CM.ASSIGNEDTO = U.SUSERGUID

DROP TABLE #VIO;
DROP TABLE #MINVIO;
DROP TABLE #CONTACT;
DROP TABLE #CONTACTADDRESS;
DROP TABLE #MADDRESS;
DROP TABLE #INSPECTION

