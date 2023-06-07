

CREATE PROCEDURE [dbo].[DELETEMARKUPELEMENT]
-- Add the parameters for the stored procedure here
@ElementID char(36)	
AS
BEGIN		
	DELETE FROM ERMARKUPELEMENT WHERE ERMARKUPELEMENTID = @ElementID
END
