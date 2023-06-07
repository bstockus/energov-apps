
CREATE PROCEDURE [dbo].[DELETEERPROJECTFILE]
-- Add the parameters for the stored procedure here
@ERProjectFileID char(36)	
AS
BEGIN		
	DELETE FROM ERPROJECTFILE WHERE ERPROJECTFILEID = @ERProjectFileID
END
