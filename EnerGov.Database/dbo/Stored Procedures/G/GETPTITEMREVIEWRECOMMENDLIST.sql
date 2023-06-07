﻿
CREATE PROCEDURE [dbo].[GETPTITEMREVIEWRECOMMENDLIST]
-- Add the parameters for the stored procedure here
@ItemReviewID char(36)	
AS
BEGIN	
	SELECT	DISTINCT PLPLANRECOMMENDATION.PLPLANRECOMENDATIONID,  
			PLPLANRECOMMENDATION.RECOMMENDATION,
			PLPLANRECOMMENDATION.AUTONUMBER,
			PLPLANRECOMMENDATION.PLITEMREVIEWID,
			PLPLANRECOMMENDATION.ERPROJECTFILEVERSIONID,
			ERPROJECTFILEVERSION.SAVEFILENAME														
	FROM PLPLANRECOMMENDATION			
	LEFT OUTER JOIN ERPROJECTFILEVERSION ON ERPROJECTFILEVERSION.ERPROJECTFILEVERSIONID = PLPLANRECOMMENDATION.ERPROJECTFILEVERSIONID				
	WHERE (PLPLANRECOMMENDATION.PLITEMREVIEWID = @ItemReviewID AND ERPROJECTFILEVERSION.ALLOWVIEWCORRECTION = 1)	       
END
