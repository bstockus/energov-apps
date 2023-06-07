﻿
CREATE PROCEDURE [dbo].[GETITEMREVIEWRECOMMENDLIST]
-- Add the parameters for the stored procedure here
@ItemReviewID char(36)	
AS
BEGIN	
	SELECT	DISTINCT PLPLANRECOMMENDATION.PLPLANRECOMENDATIONID,  
			PLPLANRECOMMENDATION.PLITEMREVIEWID,
			PLPLANRECOMMENDATION.RECOMMENDATION,
			PLPLANRECOMMENDATION.AUTONUMBER,			
			ERPROJECTFILEVERSION.ERPROJECTFILEVERSIONID,
			PLPLANRECOMMENDATION.CREATEDATE,
			USERS.FNAME AS ADDEDBYFIRSTNAME, 
			USERS.LNAME AS ADDEDBYLASTNAME,
			PLPLANRECOMMENDATION.ADDEDBYUSERID, 
			PLPLANRECOMMENDATION.LASTCHANGEDBY,			
			PLPLANRECOMMENDATION.LASTCHANGEDON,			
			ERPROJECTFILEVERSION.SAVEFILENAME						
	FROM PLPLANRECOMMENDATION	
	LEFT OUTER JOIN ERPROJECTFILEVERSION ON ERPROJECTFILEVERSION.ERPROJECTFILEVERSIONID = PLPLANRECOMMENDATION.ERPROJECTFILEVERSIONID	
	LEFT OUTER JOIN USERS ON USERS.SUSERGUID = PLPLANRECOMMENDATION.ADDEDBYUSERID	
	WHERE (PLPLANRECOMMENDATION.PLITEMREVIEWID = @ItemReviewID)	       
END
