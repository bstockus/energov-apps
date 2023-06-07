
CREATE PROCEDURE [dbo].[UPDATEERCORRECTIONACKNOWLEDGE]
-- Add the parameters for the stored procedure here
@CorrectionID char(36),
@Acknowledged bit
AS
BEGIN	
	UPDATE PLPLANCORRECTION SET REPLIED = @Acknowledged WHERE PLPLANCORRECTIONID = @CorrectionID
END
