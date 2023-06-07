﻿
CREATE PROCEDURE [dbo].[GETITEMREVIEWCOLLABORATIONLIST]
-- Add the parameters for the stored procedure here
@ItemReviewID char(36)	
AS
BEGIN		
	SELECT	DISTINCT COLLABORATION.COLLABORATIONID,
			COLLABORATION.PLITEMREVIEWID,
			COLLABORATION.ERPROJECTID,
			COLLABORATION.SUBJECT,
			COLLABORATION.MESSAGE,			
			COLLABORATION.POSTBYUSER,			
			USERS.FNAME AS POSTBYUSERFIRSTNAME,			
			USERS.LNAME AS POSTBYUSERLASTNAME,
			COLLABORATION.POSTDATE,			
			COLLABORATION.APPLICATIONID,
			COLLABORATION.MARKREAD
	FROM COLLABORATION	
	INNER JOIN USERS ON USERS.SUSERGUID = COLLABORATION.POSTBYUSER
	WHERE PLITEMREVIEWID = @ItemReviewID
	ORDER BY POSTDATE ASC
END
