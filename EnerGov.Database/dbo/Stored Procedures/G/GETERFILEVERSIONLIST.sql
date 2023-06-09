﻿

CREATE PROCEDURE [dbo].[GETERFILEVERSIONLIST]
-- Add the parameters for the stored procedure here
@ERProjectFileID char(36)	
AS
BEGIN	
	SELECT DISTINCT ERPROJECTFILEVERSION.ERPROJECTFILEVERSIONID, 
					ERPROJECTFILEVERSION.ERPROJECTFILEID,
					ERPROJECTFILEVERSION.SAVEFILENAME,
					ERPROJECTFILEVERSION.FILEVERSION,
					ERPROJECTFILEVERSION.LATEST,
					ERPROJECTFILEVERSION.LOCKED,
					ERPROJECTFILEVERSION.ERPROJECTFILESTATUSID,
					ERPROJECTFILESTATUS.ERPROJECTFILESYSTEMSTATUSID,
					ERPROJECTFILEVERSION.LASTCHANGEDBY,
					ERPROJECTFILEVERSION.ROWVERSION,											
					ERPROJECTFILEVERSION.LASTCHANGEDON,											
					ERPROJECTFILEVERSION.LASTMODIFIED

	FROM		ERPROJECTFILEVERSION
	INNER JOIN	ERPROJECTFILESTATUS ON ERPROJECTFILESTATUS.ERPROJECTFILESTATUSID = ERPROJECTFILEVERSION.ERPROJECTFILESTATUSID
	WHERE ERPROJECTFILEID = @ERProjectFileID AND MARKDELETE = 0
	ORDER BY FILEVERSION ASC
END
