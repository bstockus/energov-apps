

CREATE PROCEDURE [dbo].[DELETEMARKUPELEMENTS]
-- Add the parameters for the stored procedure here
@CorrectionID char(36)	
AS
BEGIN		
	DELETE FROM ERMARKUPELEMENT WHERE PLPLANCORRECTIONID = @CorrectionID
END
