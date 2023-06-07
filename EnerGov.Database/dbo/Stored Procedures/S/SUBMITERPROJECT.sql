
CREATE PROCEDURE [dbo].[SUBMITERPROJECT]
-- Add the parameters for the stored procedure here
@ERProjectID char(36),	
@ERProjectStatusID char(36),
@AllowFileUpload bit	
AS
BEGIN			
	DECLARE @RowVersion int
	SELECT @RowVersion = ROWVERSION FROM ERPROJECT WHERE ERPROJECTID = @ERProjectID
	SET @RowVersion = @RowVersion + 1
		
	UPDATE ERPROJECT 
	SET ERPROJECTSTATUSID = @ERProjectStatusID, ROWVERSION = @RowVersion, ALLOWFILEUPLOAD = @AllowFileUpload
	WHERE ERPROJECTID = @ERProjectID					
END	
