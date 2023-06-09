﻿CREATE PROCEDURE [systemsettingsmanager].[USP_MEETING_RECENT]
(
  @USER_ID AS CHAR(36)
)
AS
BEGIN
	DECLARE @RECENTMEETINGLIST AS RecordIDs
	INSERT INTO @RECENTMEETINGLIST (RECORDID)

	SELECT TOP 15 RECENTHISTORYSYSTEMSETUP.ENTITYID 
	FROM RECENTHISTORYSYSTEMSETUP
	WHERE RECENTHISTORYSYSTEMSETUP.USERID = @USER_ID AND RECENTHISTORYMODULEID = 3 -- For Global Meeting
	ORDER BY RECENTHISTORYSYSTEMSETUP.LOGGEDDATETIME DESC
					
	EXEC [systemsettingsmanager].[USP_MEETING_GETBYIDS] @RECENTMEETINGLIST, @USER_ID 
END