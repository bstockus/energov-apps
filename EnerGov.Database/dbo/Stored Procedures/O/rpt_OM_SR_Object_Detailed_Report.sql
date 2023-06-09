﻿
CREATE PROCEDURE rpt_OM_SR_Object_Detailed_Report
@OMOBJECTID VARCHAR(36)
AS
SELECT	OMOBJECT.OMOBJECTID, OMOBJECT.OBJECTNUMBER, OMOBJECT.CREATEDATE, 
		OMOBJECT.OPERATIONSTARTDATE, OMOBJECT.INSTALLDATE, 
		OMOBJECT.OPERATIONENDDATE, OMOBJECT.DESCRIPTION, 
		OMOBJECTSTATUS.NAME AS OBJECTSTATUS, 
		OMOBJECTTYPE.NAME AS OBJECTTYPE,
		DISTRICT.NAME AS DISTRICT, 
		OMOBJECTCLASSIFICATION.NAME AS OBJECTCLASSIFICATION, 
		PRPROJECT.NAME AS PROJECT,
		PARENTOBJECT.OBJECTNUMBER AS PARENTOBJECT,
		(SELECT R.[IMAGE] FROM RPTIMAGELIB R
			WHERE R.IMAGENAME = 'Municipality_Logo') LOGO,
		(SELECT CASE WHEN R.[IMAGE] IS NULL THEN 'N' ELSE 'Y' END FROM RPTIMAGELIB R
			WHERE R.IMAGENAME = 'Municipality_Logo') SHOWLOGO,
		(SELECT R.REPORTTEXT FROM RPTTEXTLIB R
			WHERE R.TEXTNAME = 'Municipality_Name') Municipality_Name,	   
		(SELECT R.REPORTTEXT FROM RPTTEXTLIB R
			WHERE R.TEXTNAME = 'Municipality_Page_Footer') Municipality_Page_Footer
		
FROM	OMOBJECT 
		INNER JOIN OMOBJECTTYPE ON OMOBJECT.OMOBJECTTYPEID = OMOBJECTTYPE.OMOBJECTTYPEID 
		INNER JOIN OMOBJECTSTATUS ON OMOBJECT.OMOBJECTSTATUSID = OMOBJECTSTATUS.OMOBJECTSTATUSID 
		INNER JOIN OMOBJECTCLASSIFICATION ON OMOBJECT.OMOBJECTCLASSIFICATIONID = OMOBJECTCLASSIFICATION.OMOBJECTCLASSIFICATIONID 
		LEFT OUTER JOIN DISTRICT ON OMOBJECT.DISTRICTID = DISTRICT.DISTRICTID
		LEFT OUTER JOIN PRPROJECTOBJECT ON PRPROJECTOBJECT.OMOBJECTID = OMOBJECT.OMOBJECTID 
		LEFT OUTER JOIN PRPROJECT ON PRPROJECT.PRPROJECTID = PRPROJECTOBJECT.PRPROJECTID
		LEFT OUTER JOIN OMOBJECT PARENTOBJECT ON OMOBJECT.OMOBJECTPARENTID = PARENTOBJECT.OMOBJECTID
WHERE	OMOBJECT.OMOBJECTID = @OMOBJECTID

