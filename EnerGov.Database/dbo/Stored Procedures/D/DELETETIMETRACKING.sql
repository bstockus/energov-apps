
CREATE PROCEDURE [dbo].[DELETETIMETRACKING]
-- Add the parameters for the stored procedure here
@TimeTrackingID char(36)	
AS
BEGIN		
	DELETE FROM TIMETRACKING WHERE TIMETRACKINGID = @TimeTrackingID
END
