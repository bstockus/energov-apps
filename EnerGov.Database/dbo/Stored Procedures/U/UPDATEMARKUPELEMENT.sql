CREATE PROCEDURE [dbo].[UPDATEMARKUPELEMENT]
-- Add the parameters for the stored procedure here
@ElementID char(36),
@Comments nvarchar(max)	
AS
BEGIN	
	UPDATE ERMARKUPELEMENT SET COMMENTS = @Comments WHERE ERMARKUPELEMENTID = @ElementID						
END
