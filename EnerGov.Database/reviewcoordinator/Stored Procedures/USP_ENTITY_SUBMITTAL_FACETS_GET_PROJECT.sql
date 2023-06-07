﻿CREATE PROCEDURE [reviewcoordinator].[USP_ENTITY_SUBMITTAL_FACETS_GET_PROJECT]
	@ASSIGNEDUSERIDS AS RECORDIDS READONLY
AS
BEGIN

WITH PROJECT AS 
(	
	SELECT * FROM (	
		-- permit submittals
		SELECT 
			PMPERMIT.ASSIGNEDTO AS ASSIGNEDTO,
			PLSUBMITTAL.COMPLETED AS COMPLETED,
			PLSUBMITTAL.COMPLETEDATE AS COMPLETEDATE,
			PRPROJECT.PRPROJECTID AS PROJECTID,
			PRPROJECT.NAME AS PROJECTNAME
		FROM PLSUBMITTAL 
			INNER JOIN PMPERMIT ON PMPERMIT.PMPERMITID = PLSUBMITTAL.PMPERMITID			
			LEFT JOIN PRPROJECTPERMIT ON PMPERMIT.PMPERMITID = PRPROJECTPERMIT.PMPERMITID
			LEFT JOIN PRPROJECT ON PRPROJECTPERMIT.PRPROJECTID = PRPROJECT.PRPROJECTID								
		UNION ALL
		-- plan submittals
		SELECT 			
			PLPLAN.ASSIGNEDTO AS ASSIGNEDTO	,
			PLSUBMITTAL.COMPLETED AS COMPLETED,
			PLSUBMITTAL.COMPLETEDATE AS COMPLETEDATE,
			PRPROJECT.PRPROJECTID AS PROJECTID,
			PRPROJECT.NAME AS PROJECTNAME
		FROM PLSUBMITTAL 
			INNER JOIN PLPLAN ON PLPLAN.PLPLANID = PLSUBMITTAL.PLPLANID			
			LEFT JOIN PRPROJECTPLAN ON PLPLAN.PLPLANID = PRPROJECTPLAN.PLPLANID
			LEFT JOIN PRPROJECT ON PRPROJECTPLAN.PRPROJECTID = PRPROJECT.PRPROJECTID				
) AS QUERY_DATA
WHERE 	
	(ASSIGNEDTO IN (SELECT RECORDID FROM @ASSIGNEDUSERIDS) AND COMPLETED = 0 AND COMPLETEDATE IS NULL)
)
SELECT PROJECTID AS ID, PROJECTNAME AS NAME, COUNT(*) AS COUNT
FROM PROJECT 
GROUP BY PROJECTID, PROJECTNAME
ORDER BY COUNT(*) DESC, PROJECTNAME

END