
CREATE PROCEDURE [dbo].[SUBMITFILE]
-- Add the parameters for the stored procedure here
@FileID char(36),	
@AllowRevisionFileUpload bit,
@Pending bit	
AS
BEGIN			
	DECLARE @RowVersion int
	SELECT @RowVersion = ROWVERSION FROM ERPROJECTFILE WHERE ERPROJECTFILEID = @FileID
	SET @RowVersion = @RowVersion + 1
		
	UPDATE ERPROJECTFILE 
	SET ALLOWREVISIONFILEUPLOAD = @AllowRevisionFileUpload, ROWVERSION = @RowVersion, PENDING = @Pending
	WHERE ERPROJECTFILEID = @FileID					
END	
