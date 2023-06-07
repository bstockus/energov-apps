
CREATE PROCEDURE [dbo].[DELETECOLLABORATION]
-- Add the parameters for the stored procedure here
@CollaborationID char(36)	
AS
BEGIN		
	DELETE FROM COLLABORATION WHERE COLLABORATIONID = @CollaborationID
END
