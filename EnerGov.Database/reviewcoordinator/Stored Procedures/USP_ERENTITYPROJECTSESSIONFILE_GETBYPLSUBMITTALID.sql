﻿CREATE PROCEDURE [reviewcoordinator].[USP_ERENTITYPROJECTSESSIONFILE_GETBYPLSUBMITTALID]
(
	@PLSUBMITTALID VARCHAR(36)
)
AS
BEGIN
SET NOCOUNT ON;
SELECT 
	ERENTITYPROJECTSESSIONFILE.ERENTITYPROJECTSESSIONFILEID,
	ERENTITYPROJECTSESSIONFILE.ERENTITYPROJECTID,
	ERENTITYPROJECTSESSIONFILE.ERENTITYSESSIONID,	
	ERENTITYPROJECTSESSIONFILE.ERPROJECTFILEVERSIONID,
	ERENTITYPROJECTSESSIONFILE.ERENTITYPROJECTFILEID
FROM ERENTITYPROJECTSESSIONFILE
INNER JOIN ERENTITYSESSION on ERENTITYPROJECTSESSIONFILE.ERENTITYSESSIONID = ERENTITYSESSION.ERENTITYSESSIONID
WHERE ERENTITYSESSION.PLSUBMITTALID = @PLSUBMITTALID
END