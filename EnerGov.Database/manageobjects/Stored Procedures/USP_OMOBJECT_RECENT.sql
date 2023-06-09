﻿CREATE PROCEDURE [manageobjects].[USP_OMOBJECT_RECENT]
(
  @USER_ID AS CHAR(36)
)
AS
BEGIN
	DECLARE @RECENTOBJECTLIST AS RecordIDs
	INSERT INTO @RECENTOBJECTLIST (RECORDID)

	SELECT TOP 15 RECENTHISTORYOBJECTCASE.OBJECTCASEID 
	FROM RECENTHISTORYOBJECTCASE
	WHERE RECENTHISTORYOBJECTCASE.USERID = @USER_ID
	ORDER BY RECENTHISTORYOBJECTCASE.LOGGEDDATETIME DESC

	EXEC [manageobjects].[USP_OMOBJECT_GETBYIDS] @RECENTOBJECTLIST, @USER_ID 
END