﻿CREATE PROCEDURE [reviewcoordinator].[USP_ERENTITYSESSION_GETBYID]
(
	@ID VARCHAR(36)
)
AS
BEGIN
SET NOCOUNT ON;
SELECT 
	ERENTITYSESSIONID,
	SESSIONNAME,
	SESSIONSTATUSID,
	PLSUBMITTALID,
	APIRESPONSE
FROM ERENTITYSESSION
WHERE
	ERENTITYSESSIONID = @ID  

SELECT 
	ERENTITYPROJECTSESSIONFILEID,
	ERENTITYPROJECTID,
	ERENTITYSESSIONID,	
	ERPROJECTFILEVERSIONID,
	ERENTITYPROJECTFILEID
FROM ERENTITYPROJECTSESSIONFILE
WHERE 
	ERENTITYSESSIONID = @ID

END