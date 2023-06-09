﻿CREATE PROCEDURE [manageplan].[USP_PLPLAN_RECENT]
(
  @USER_ID AS CHAR(36)
)
AS
BEGIN
	DECLARE @RECENTPLANLIST AS RecordIDs
	INSERT INTO @RECENTPLANLIST (RECORDID)

	SELECT TOP 15 [RECENTHISTORYPLAN].PLANID 
	FROM [dbo].[RECENTHISTORYPLAN] 
	WHERE [RECENTHISTORYPLAN].USERID = @USER_ID
	ORDER BY [RECENTHISTORYPLAN].LOGGEDDATETIME DESC

	EXEC [manageplan].[USP_PLPLAN_GETBYIDS] @RECENTPLANLIST, @USER_ID 
END