
CREATE PROCEDURE [dbo].[UPDATEFILEVERSIONLASTMODIFIED]
-- Add the parameters for the stored procedure here
@FileVersionID char(36),
@LastModified datetime = null
AS
BEGIN						
	UPDATE ERPROJECTFILEVERSION 
	SET LASTMODIFIED = @LastModified
	WHERE ERPROJECTFILEVERSIONID = @FileVersionID				
END	
