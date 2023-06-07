﻿CREATE PROCEDURE [reviewcoordinator].[USP_ERENTITYSESSION_GETBYPLSUBMITTALIDS]
(
	@SUBMITTALIDS AS RECORDIDS READONLY
)
AS
BEGIN
SET NOCOUNT ON;

SELECT 
	ERENTITYSESSION.ERENTITYSESSIONID,
	ERENTITYSESSION.SESSIONNAME,
	ERENTITYSESSION.SESSIONSTATUSID,
	ERENTITYSESSION.PLSUBMITTALID,
	ERENTITYSESSION.APIRESPONSE
FROM ERENTITYSESSION WHERE PLSUBMITTALID IN (SELECT RECORDID FROM @SUBMITTALIDS)

END