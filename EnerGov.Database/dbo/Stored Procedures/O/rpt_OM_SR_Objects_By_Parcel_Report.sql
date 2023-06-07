﻿
CREATE PROCEDURE rpt_OM_SR_Objects_By_Parcel_Report
@OMOBJECTID VARCHAR(36)
AS

SELECT	MAINOMOBJECT.OMOBJECTID, MAINOMOBJECT.OBJECTNUMBER MAINOBJECTNUMBER,
		OMOBJECT.OBJECTNUMBER, OMOBJECT.INSTALLDATE, OMOBJECT.OPERATIONSTARTDATE, 
		OMOBJECTTYPE.NAME AS OBJECTTYPE, 
		OMOBJECTSTATUS.NAME AS OBJECTSTATUS, 
		OMOBJECTCLASSIFICATION.NAME AS OBJECTCLASSIFICATION, 
		PARCEL.PARCELNUMBER, PARCEL.ADDRESSLINE1, PARCEL.ADDRESSLINE2, PARCEL.ADDRESSLINE3, PARCEL.CITY, PARCEL.STATE, PARCEL.POSTALCODE,
		(SELECT R.[IMAGE] FROM RPTIMAGELIB R
			WHERE R.IMAGENAME = 'Municipality_Logo') LOGO,
		(SELECT CASE WHEN R.[IMAGE] IS NULL THEN 'N' ELSE 'Y' END FROM RPTIMAGELIB R
			WHERE R.IMAGENAME = 'Municipality_Logo') SHOWLOGO,
		(SELECT R.REPORTTEXT FROM RPTTEXTLIB R
			WHERE R.TEXTNAME = 'Municipality_Name') Municipality_Name,	   
		(SELECT R.REPORTTEXT FROM RPTTEXTLIB R
			WHERE R.TEXTNAME = 'Municipality_Page_Footer') Municipality_Page_Footer
				
FROM	OMOBJECT MAINOMOBJECT 
		INNER JOIN OMOBJECTPARCEL MAINOMOBJECTPARCEL ON MAINOMOBJECT.OMOBJECTID = MAINOMOBJECTPARCEL.OMOBJECTID
		INNER JOIN PARCEL ON MAINOMOBJECTPARCEL.PARCELID = PARCEL.PARCELID AND MAINOMOBJECTPARCEL.MAIN = 'TRUE'
		INNER JOIN OMOBJECTPARCEL ON PARCEL.PARCELID = OMOBJECTPARCEL.PARCELID
		INNER JOIN OMOBJECT ON OMOBJECTPARCEL.OMOBJECTID = OMOBJECT.OMOBJECTID
		INNER JOIN OMOBJECTTYPE ON OMOBJECT.OMOBJECTTYPEID = OMOBJECTTYPE.OMOBJECTTYPEID
		INNER JOIN OMOBJECTCLASSIFICATION ON OMOBJECT.OMOBJECTCLASSIFICATIONID = OMOBJECTCLASSIFICATION.OMOBJECTCLASSIFICATIONID 
		INNER JOIN OMOBJECTSTATUS ON OMOBJECT.OMOBJECTSTATUSID = OMOBJECTSTATUS.OMOBJECTSTATUSID 
WHERE	MAINOMOBJECT.OMOBJECTID = @OMOBJECTID


