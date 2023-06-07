﻿CREATE PROCEDURE SEARCHREQUESTATTACHEDCODELIST
	@SearchText varchar(500)
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @KEY VARCHAR(50) = 'MaxNoRowsToReturnQuickSearch'
	DECLARE @limit INT = 100
	IF EXISTS(SELECT * FROM SETTINGS WHERE NAME=@KEY)
	BEGIN
	  SELECT @limit=ISNULL(INTVALUE,100) FROM SETTINGS WHERE NAME=@KEY
	END

	SELECT 	TOP (@limit)
		CMCODECASE.ROWVERSION,
		CMCODECASE. CMCODECASEID,
		CASENUMBER,
		CMCODECASE.CMCODECASESTATUSID STATUSID,
		CMCODECASESTATUS.NAME STATUSNAME,
		OPENEDDATE,
		CLOSEDDATE,
		CMCODECASE.DESCRIPTION,
		CMCODECASE.ASSIGNEDTO,
		USERS.FNAME FIRSTNAME,
		USERS.LNAME LASTNAME,
		(USERS.FNAME +' ' + USERS.LNAME) AS USERNAME,
		CMCODECASE.CMCASETYPEID,
		CMCASETYPE.NAME TYPENAME
		FROM CMCODECASE 
		LEFT JOIN USERS ON USERS.SUSERGUID = CMCODECASE.ASSIGNEDTO	
		INNER JOIN CMCODECASESTATUS ON CMCODECASESTATUS.CMCODECASESTATUSID = CMCODECASE.CMCODECASESTATUSID
		INNER JOIN CMCASETYPE ON CMCASETYPE.CMCASETYPEID = CMCODECASE.CMCASETYPEID
	WHERE CASENUMBER LIKE @SearchText  
		OR CMCODECASESTATUS.NAME LIKE @SearchText  
		OR (USERS.FNAME +' '+ USERS.LNAME) LIKE @SearchText  
		OR CMCASETYPE.NAME LIKE @SearchText 
	ORDER BY CMCODECASE.CASENUMBER
END