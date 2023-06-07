
CREATE PROCEDURE [dbo].[UPDATETIMETRACKING]
-- Add the parameters for the stored procedure here
@TimeTrackingID char(36),
@Comments nvarchar(max)
AS
BEGIN		
	UPDATE TIMETRACKING SET COMMENTS = @Comments WHERE TIMETRACKINGID = @TimeTrackingID
END
