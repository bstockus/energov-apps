﻿CREATE PROCEDURE [application].[USP_PLAPPLICATION_GETBYIDS]
(
	@PLAPPLICATIONLIST RecordIDs READONLY
)
AS
BEGIN
	SELECT 		
		PLAPPLICATION.PLAPPLICATIONID,
		PLAPPLICATION.APPNUMBER,
		PLAPPLICATIONTYPE.APPLICATIONTYPENAME AS TYPE,
		PLAPPLICATIONSTATUS.STATUS AS STATUS,
		PLAPPLICATION.APPLICATIONDATE,
		PLAPPLICATION.DESCRIPTION,
		USERS.FNAME AS ASSIGNEDTOFNAME,
		USERS.LNAME AS ASSIGNEDTOLNAME,
		PRPROJECT.NAME AS PRPROJECTNAME,
		15 TotalRows
	FROM PLAPPLICATION
	INNER JOIN @PLAPPLICATIONLIST PLAPPLICATIONLIST ON PLAPPLICATIONLIST.RECORDID = PLAPPLICATION.PLAPPLICATIONID
	INNER JOIN PLAPPLICATIONSTATUS ON PLAPPLICATIONSTATUS.PLAPPLICATIONSTATUSID = PLAPPLICATION.PLAPPLICATIONSTATUSID
	INNER JOIN PLAPPLICATIONTYPE ON PLAPPLICATIONTYPE.PLAPPLICATIONTYPEID = PLAPPLICATION.PLAPPLICATIONTYPEID
	LEFT JOIN PRPROJECTAPPLICATION ON PLAPPLICATION.PLAPPLICATIONID = PRPROJECTAPPLICATION.PLAPPLICATIONID
	LEFT JOIN PRPROJECT ON PRPROJECTAPPLICATION.PRPROJECTID = PRPROJECT.PRPROJECTID
	LEFT JOIN USERS ON PLAPPLICATION.ASSIGNEDTO = USERS.SUSERGUID 
END