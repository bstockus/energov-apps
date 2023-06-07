

CREATE PROCEDURE [dbo].[DELETERECOMMEND]
-- Add the parameters for the stored procedure here
@RecommendID char(36)	
AS
BEGIN		
	DELETE FROM PLPLANRECOMMENDATION WHERE PLPLANRECOMENDATIONID = @RecommendID
END
