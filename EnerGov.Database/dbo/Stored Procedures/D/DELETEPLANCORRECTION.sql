

CREATE PROCEDURE [dbo].[DELETEPLANCORRECTION]
-- Add the parameters for the stored procedure here
@CorrectionID char(36)	
AS
BEGIN		
	DELETE FROM PLPLANCORRECTION WHERE PLPLANCORRECTIONID = @CorrectionID
END
