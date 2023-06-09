﻿
CREATE PROCEDURE [dbo].[GETERPORTALDEFAULTPLANLIST]
-- Add the parameters for the stored procedure here
@GlobalEntityID char(36),
@NumOfDay int	
AS
BEGIN
	DECLARE @ApplyDate datetime
	SET @ApplyDate = getdate() - @NumOfDay	
	SELECT	DISTINCT PLPLAN.PLPLANID,
			PLPLAN.PLANNUMBER,				
			PLPLANSTATUS.NAME AS PLANSTATUSNAME,				
			PLPLAN.APPLICATIONDATE,
			PLPLAN.COMPLETEDATE,
			PLPLAN.EXPIREDATE,
			PRPROJECT.NAME AS PROJECTNAME,
			PRPROJECT.PROJECTNUMBER AS PROJECTNUMBER							
	FROM PLPLAN		
	INNER JOIN PLPLANSTATUS ON PLPLANSTATUS.PLPLANSTATUSID = PLPLAN.PLPLANSTATUSID
	INNER JOIN PLPLANCONTACT ON PLPLANCONTACT.PLPLANID = PLPLAN.PLPLANID	
	LEFT OUTER JOIN PRPROJECTPLAN ON PRPROJECTPLAN.PLPLANID = PLPLAN.PLPLANID
	LEFT OUTER JOIN PRPROJECT ON PRPROJECT.PRPROJECTID = PRPROJECTPLAN.PRPROJECTID	
	WHERE (PLPLANCONTACT.GLOBALENTITYID = @GlobalEntityID AND PLPLAN.APPLICATIONDATE > @ApplyDate)
END
