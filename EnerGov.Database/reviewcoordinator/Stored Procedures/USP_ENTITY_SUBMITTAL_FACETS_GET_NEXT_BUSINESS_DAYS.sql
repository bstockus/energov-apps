﻿CREATE PROCEDURE [reviewcoordinator].[USP_ENTITY_SUBMITTAL_FACETS_GET_NEXT_BUSINESS_DAYS]
	@ASSIGNEDUSERIDS AS RECORDIDS READONLY,
	@NEXTBUSINESSDAYBEGIN AS DATE = NULL,
	@NEXTBUSINESSDAYEND AS DATE = NULL
AS
BEGIN

WITH NEXT_BUSINESS_DAYS AS 
(
	-- permit submittals
	SELECT 		
		PLSUBMITTAL.DUEDATE AS DUEDATE,
		PMPERMIT.ASSIGNEDTO AS ASSIGNEDTO,
		PLSUBMITTAL.COMPLETED AS COMPLETED,
		PLSUBMITTAL.COMPLETEDATE AS COMPLETEDATE		
	FROM PLSUBMITTAL 
		INNER JOIN PMPERMIT ON PMPERMIT.PMPERMITID = PLSUBMITTAL.PMPERMITID								
	UNION ALL
	-- plan submittals
	SELECT 		
		PLSUBMITTAL.DUEDATE AS DUEDATE,
		PLPLAN.ASSIGNEDTO AS ASSIGNEDTO	,
		PLSUBMITTAL.COMPLETED AS COMPLETED,
		PLSUBMITTAL.COMPLETEDATE AS COMPLETEDATE
	FROM PLSUBMITTAL 
		INNER JOIN PLPLAN ON PLPLAN.PLPLANID = PLSUBMITTAL.PLPLANID
) 
SELECT ID = 'NextBusinessDays', NAME = 'NextBusinessDays', COUNT(*) COUNT
FROM NEXT_BUSINESS_DAYS 
WHERE 
(ASSIGNEDTO IN (SELECT RECORDID FROM @ASSIGNEDUSERIDS) AND COMPLETED = 0 AND COMPLETEDATE IS NULL)
AND DUEDATE >= @NEXTBUSINESSDAYBEGIN AND DUEDATE < DATEADD(D, 1, @NEXTBUSINESSDAYEND)

END