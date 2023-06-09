﻿CREATE PROCEDURE [manageobjects].[USP_OMOBJECT_GETBYIDS]
(
	@OMOBJECTLIST RecordIDs READONLY,
	@USERID AS CHAR(36) = NULL
)
AS
BEGIN

SELECT 
	OMOBJECT.OMOBJECTID,
	OMOBJECT.OBJECTNUMBER,
	OMOBJECT.INSTALLDATE,
	OMOBJECT.OPERATIONSTARTDATE,
	OMOBJECT.OPERATIONENDDATE,
	OMOBJECT.LASTCHANGEDON,
	OMOBJECT.DESCRIPTION,
	OMOBJECT.OMOBJECTPARENTID,
	PARENTOBJECT.OBJECTNUMBER AS PARENTOBJECTNUMBER,
	OMOBJECTTYPE.NAME AS TYPENAME,
	OMOBJECTCLASSIFICATION.NAME AS CLASSIFICATIONNAME,
	OMOBJECTSTATUS.NAME AS STATUSNAME,
	(SELECT TOP 1 PRPROJECT.NAME 
		FROM PRPROJECTOBJECT
		INNER JOIN PRPROJECT ON PRPROJECT.PRPROJECTID = PRPROJECTOBJECT.PRPROJECTID
		WHERE PRPROJECTOBJECT.OMOBJECTID = OMOBJECT.OMOBJECTID) AS PROJECTNAME,
	(SELECT TOP 1 PARCEL.PARCELNUMBER		
		FROM OMOBJECTPARCEL
		INNER JOIN PARCEL ON PARCEL.PARCELID = OMOBJECTPARCEL.PARCELID
		WHERE OMOBJECTPARCEL.OMOBJECTID = OMOBJECT.OMOBJECTID
		ORDER BY OMOBJECTPARCEL.MAIN DESC) AS PARCELNUMBER
FROM OMOBJECT 
INNER JOIN OMOBJECTTYPE ON OMOBJECT.OMOBJECTTYPEID = OMOBJECTTYPE.OMOBJECTTYPEID
INNER JOIN OMOBJECTCLASSIFICATION ON OMOBJECT.OMOBJECTCLASSIFICATIONID = OMOBJECTCLASSIFICATION.OMOBJECTCLASSIFICATIONID
INNER JOIN OMOBJECTSTATUS ON OMOBJECT.OMOBJECTSTATUSID = OMOBJECTSTATUS.OMOBJECTSTATUSID
LEFT JOIN OMOBJECT PARENTOBJECT ON OMOBJECT.OMOBJECTPARENTID = PARENTOBJECT.OMOBJECTID
INNER JOIN @OMOBJECTLIST OMOBJECTLIST ON OMOBJECT.OMOBJECTID = OMOBJECTLIST.RECORDID
LEFT OUTER JOIN RECENTHISTORYOBJECTCASE ON OMOBJECT.OMOBJECTID = RECENTHISTORYOBJECTCASE.OBJECTCASEID
AND RECENTHISTORYOBJECTCASE.USERID = @USERID
ORDER BY RECENTHISTORYOBJECTCASE.LOGGEDDATETIME DESC

EXEC [manageobjects].[USP_OMOBJECTADDRESS_GETBYIDS] @OMOBJECTLIST

END