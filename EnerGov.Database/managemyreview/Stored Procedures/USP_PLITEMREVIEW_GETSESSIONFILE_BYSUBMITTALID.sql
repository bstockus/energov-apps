﻿CREATE PROCEDURE [managemyreview].[USP_PLITEMREVIEW_GETSESSIONFILE_BYSUBMITTALID]
	@PLSUBMITTALID CHAR(36)
AS

SET NOCOUNT ON
BEGIN
	SELECT		ERENTITYPROJECTSESSIONFILE.ERPROJECTFILEVERSIONID
	FROM		ERENTITYSESSION
	INNER JOIN	ERENTITYPROJECTSESSIONFILE ON ERENTITYPROJECTSESSIONFILE.ERENTITYSESSIONID = ERENTITYSESSION.ERENTITYSESSIONID
	WHERE		ERENTITYSESSION.PLSUBMITTALID = @PLSUBMITTALID
	AND			ERENTITYSESSION.SESSIONSTATUSID = 0

END