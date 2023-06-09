﻿CREATE PROCEDURE [systemsettingsmanager].[USP_HEARING_RECENT]
(
  @USER_ID AS CHAR(36)
)
AS
BEGIN
	DECLARE @RECENTHEARINGLIST AS RecordIDs
	INSERT INTO @RECENTHEARINGLIST (RECORDID)

	SELECT TOP 15 RECENTHISTORYSYSTEMSETUP.ENTITYID 
	FROM RECENTHISTORYSYSTEMSETUP
	WHERE RECENTHISTORYSYSTEMSETUP.USERID = @USER_ID AND RECENTHISTORYMODULEID = 2 -- For Global Hearing 
	ORDER BY RECENTHISTORYSYSTEMSETUP.LOGGEDDATETIME DESC
					
	EXEC [systemsettingsmanager].[USP_HEARING_GETBYIDS] @RECENTHEARINGLIST, @USER_ID 
END