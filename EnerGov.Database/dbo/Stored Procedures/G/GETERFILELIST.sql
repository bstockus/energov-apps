﻿

CREATE PROCEDURE [dbo].[GETERFILELIST]
-- Add the parameters for the stored procedure here
@ERFileCategoryID char(36),
@ERProjectID char(36)		
AS
BEGIN	
	SELECT DISTINCT ERPROJECTFILE.ERPROJECTFILEID, ERPROJECTFILE.FILENAME
	FROM ERPROJECTFILE
	INNER JOIN ERPROJECTFILECATEGORYXREF ON ERPROJECTFILECATEGORYXREF.ERPROJECTFILEID = ERPROJECTFILE.ERPROJECTFILEID	
	WHERE	ERPROJECTFILECATEGORYXREF.ERPROJECTFILECATEGORYID = @ERFileCategoryID AND
			ERPROJECTFILE.ERPROJECTID = @ERProjectID
	ORDER BY ERPROJECTFILE.FILENAME ASC			
END
