﻿CREATE PROCEDURE [impactcase].[USP_IMPACTCASES_RECENT]
(
  @USER_ID AS CHAR(36)
)
AS
BEGIN
	DECLARE @RECENTIPLACTCASELIST AS RecordIDs
	INSERT INTO @RECENTIPLACTCASELIST (RECORDID)

	SELECT TOP 15 [dbo].RECENTHISTORYIMPACTCASE.IMPACTCASEID 
	FROM [dbo].RECENTHISTORYIMPACTCASE
	WHERE [dbo].RECENTHISTORYIMPACTCASE.USERID = @USER_ID
	ORDER BY [dbo].RECENTHISTORYIMPACTCASE.LOGGEDDATETIME DESC

	EXEC [impactcase].[USP_IMPACTCASES_GETBYIDS] @RECENTIPLACTCASELIST, @USER_ID 
END