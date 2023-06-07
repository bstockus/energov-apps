﻿CREATE PROCEDURE [livelink].[USP_MAPREQUEST_ISRECORDAVAILABLE_GETBYREQUESTDATE]
(
	@REQUESTDATE DATETIME
)
AS
BEGIN
	SELECT (
		CASE 
			WHEN EXISTS(SELECT 1 FROM [DBO].[MAPREQUEST] WHERE REQUESTDATE < @REQUESTDATE ) THEN CAST(1 AS BIT) 
			ELSE CAST(0 AS BIT) 
		END 
			) [ISRECORDAVILABLE]  
END