
CREATE PROCEDURE [dbo].[MARKCOLLABORATIONREAD]
-- Add the parameters for the stored procedure here
@CollaborationID char(36)	
AS
BEGIN		
	UPDATE COLLABORATION SET MARKREAD = 1 WHERE COLLABORATIONID = @CollaborationID
END
