CREATE PROCEDURE [dbo].[UPDATERECOMMENDELEMENT]
-- Add the parameters for the stored procedure here
@ElementID char(36),
@Comments nvarchar(max)	
AS
BEGIN	
	UPDATE ERRECOMMENDATIONELEMENT SET COMMENTS = @Comments WHERE ERRECOMMENDATIONELEMENTID = @ElementID						
END
