
CREATE PROCEDURE [dbo].[UPDATERECOMMENDATION]
-- Add the parameters for the stored procedure here
@RecommendID char(36),		
@Comments nvarchar(max),		
@LastChangedOn datetime,
@LastChangedBy char(36),
@FileVersionID char(36)	
AS
BEGIN		
	UPDATE PLPLANRECOMMENDATION 
	SET RECOMMENDATION = @Comments,		
		LASTCHANGEDON = @LastChangedOn,
		LASTCHANGEDBY = @LastChangedBy,
		ERPROJECTFILEVERSIONID = @FileVersionID		
	WHERE PLPLANRECOMENDATIONID = @RecommendID
END
