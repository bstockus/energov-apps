
CREATE PROCEDURE [dbo].[ADDFILECATEGORYXREF]
-- Add the parameters for the stored procedure here
@FileCategoryXRefID char(36),
@ERProjectFileID char(36),
@ERProjectFileCategoryID char(36)	
AS
BEGIN		
	INSERT INTO ERPROJECTFILECATEGORYXREF 	
	(
	ERPROJECTFILECATEGORYXREFID,
	ERPROJECTFILEID,
	ERPROJECTFILECATEGORYID
	)
	VALUES(
	@FileCategoryXRefID,
	@ERProjectFileID,
	@ERProjectFileCategoryID
	)		
END
