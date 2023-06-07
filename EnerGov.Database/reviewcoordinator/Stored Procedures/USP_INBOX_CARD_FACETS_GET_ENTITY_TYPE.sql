﻿CREATE PROCEDURE [reviewcoordinator].[USP_INBOX_CARD_FACETS_GET_ENTITY_TYPE]
	@FACETTYPE AS INT,	-- 0 = incomplete, 1 = complete, 2 = snoozed
	@ASSIGNEDUSERIDS AS RECORDIDS READONLY,
	@ASSIGNEDTEAMIDS AS RECORDIDS READONLY,
	@LASTCOMPLETEDDATE AS DATE = NULL,
	@TODAY AS DATE = NULL
AS
BEGIN

WITH ENTITY_TYPE AS
(
	SELECT 		
		PMPERMIT.PMPERMITTYPEID ENTITYTYPEID,
		PMPERMITTYPE.NAME ENTITYTYPE,
		SYSTEMTASK.SYSTEMTASKID
	FROM SYSTEMTASK
	INNER JOIN PMPERMIT ON PMPERMIT.PMPERMITID = SYSTEMTASK.UNIQUERECORDID	
	INNER JOIN PMPERMITTYPE ON PMPERMITTYPE.PMPERMITTYPEID = PMPERMIT.PMPERMITTYPEID	
	WHERE (SYSTEMTASK.ASSIGNEDTO IN (SELECT RECORDID FROM @ASSIGNEDUSERIDS) OR
	(SYSTEMTASK.ASSIGNEDTO IS NULL AND TEAMASSIGNEDTO IN (SELECT RECORDID FROM @ASSIGNEDTEAMIDS))
	)
	AND PMPERMIT.PMPERMITTYPEID IS NOT NULL
	AND (		
		(@FACETTYPE = 0 AND COMPLETEDDATE IS NULL AND [reviewcoordinator].[UFN_IS_SNOOZED](SNOOZETYPEID, [reviewcoordinator].[UFN_HAS_INVOICE_BALANCE_DUE](PMPERMIT.PMPERMITID), SNOOZEUNTILDATE, @TODAY) = 0)
		OR
		(@FACETTYPE = 1 AND @LASTCOMPLETEDDATE IS NOT NULL AND COMPLETEDDATE IS NOT NULL AND COMPLETEDDATE >= @LASTCOMPLETEDDATE)
		OR
		(@FACETTYPE = 2 AND COMPLETEDDATE IS NULL AND [reviewcoordinator].[UFN_IS_SNOOZED](SNOOZETYPEID, [reviewcoordinator].[UFN_HAS_INVOICE_BALANCE_DUE](PMPERMIT.PMPERMITID), SNOOZEUNTILDATE, @TODAY) = 1)
	)
	UNION ALL
	-- plan
	SELECT 		
		PLPLAN.PLPLANTYPEID ENTITYTYPEID,
		PLPLANTYPE.PLANNAME ENTITYTYPE,	
		SYSTEMTASK.SYSTEMTASKID
	FROM SYSTEMTASK
	INNER JOIN PLPLAN ON PLPLAN.PLPLANID = SYSTEMTASK.UNIQUERECORDID
	INNER JOIN PLPLANTYPE ON PLPLANTYPE.PLPLANTYPEID = PLPLAN.PLPLANTYPEID	
	WHERE (SYSTEMTASK.ASSIGNEDTO IN (SELECT RECORDID FROM @ASSIGNEDUSERIDS) OR
	(SYSTEMTASK.ASSIGNEDTO IS NULL AND TEAMASSIGNEDTO IN (SELECT RECORDID FROM @ASSIGNEDTEAMIDS))
	)
	AND PLPLAN.PLPLANTYPEID IS NOT NULL
	AND (		
		(@FACETTYPE = 0 AND COMPLETEDDATE IS NULL AND [reviewcoordinator].[UFN_IS_SNOOZED](SNOOZETYPEID, [reviewcoordinator].[UFN_HAS_INVOICE_BALANCE_DUE](PLPLAN.PLPLANID), SNOOZEUNTILDATE, @TODAY) = 0)
		OR
		(@FACETTYPE = 1 AND @LASTCOMPLETEDDATE IS NOT NULL AND COMPLETEDDATE IS NOT NULL AND COMPLETEDDATE >= @LASTCOMPLETEDDATE)
		OR
		(@FACETTYPE = 2 AND COMPLETEDDATE IS NULL AND [reviewcoordinator].[UFN_IS_SNOOZED](SNOOZETYPEID, [reviewcoordinator].[UFN_HAS_INVOICE_BALANCE_DUE](PLPLAN.PLPLANID), SNOOZEUNTILDATE, @TODAY) = 1)
	)
	UNION ALL
	-- permit submittals
	SELECT 		
		PMPERMIT.PMPERMITTYPEID ENTITYTYPEID,
		PMPERMITTYPE.NAME ENTITYTYPE,	
		SYSTEMTASK.SYSTEMTASKID
	FROM SYSTEMTASK
	INNER JOIN PLSUBMITTAL ON PLSUBMITTAL.PLSUBMITTALID = SYSTEMTASK.UNIQUERECORDID
	INNER JOIN PMPERMIT ON PMPERMIT.PMPERMITID = PLSUBMITTAL.PMPERMITID
	INNER JOIN PMPERMITTYPE ON PMPERMITTYPE.PMPERMITTYPEID = PMPERMIT.PMPERMITTYPEID		
	WHERE (SYSTEMTASK.ASSIGNEDTO IN (SELECT RECORDID FROM @ASSIGNEDUSERIDS) OR
	(SYSTEMTASK.ASSIGNEDTO IS NULL AND TEAMASSIGNEDTO IN (SELECT RECORDID FROM @ASSIGNEDTEAMIDS))
	)
	AND PMPERMIT.PMPERMITTYPEID IS NOT NULL
	AND (		
		(@FACETTYPE = 0 AND COMPLETEDDATE IS NULL AND [reviewcoordinator].[UFN_IS_SNOOZED](SNOOZETYPEID, [reviewcoordinator].[UFN_HAS_INVOICE_BALANCE_DUE](PMPERMIT.PMPERMITID), SNOOZEUNTILDATE, @TODAY) = 0)
		OR
		(@FACETTYPE = 1 AND @LASTCOMPLETEDDATE IS NOT NULL AND COMPLETEDDATE IS NOT NULL AND COMPLETEDDATE >= @LASTCOMPLETEDDATE)
		OR
		(@FACETTYPE = 2 AND COMPLETEDDATE IS NULL AND [reviewcoordinator].[UFN_IS_SNOOZED](SNOOZETYPEID, [reviewcoordinator].[UFN_HAS_INVOICE_BALANCE_DUE](PMPERMIT.PMPERMITID), SNOOZEUNTILDATE, @TODAY) = 1)
	)
	UNION ALL
	-- plan submittals
	SELECT 		
		PLPLAN.PLPLANTYPEID ENTITYTYPEID,
		PLPLANTYPE.PLANNAME ENTITYTYPE,
		SYSTEMTASK.SYSTEMTASKID
	FROM SYSTEMTASK
	INNER JOIN PLSUBMITTAL ON PLSUBMITTAL.PLSUBMITTALID = SYSTEMTASK.UNIQUERECORDID
	INNER JOIN PLPLAN ON PLPLAN.PLPLANID = PLSUBMITTAL.PLPLANID
	INNER JOIN PLPLANTYPE ON PLPLANTYPE.PLPLANTYPEID = PLPLAN.PLPLANTYPEID
	WHERE (SYSTEMTASK.ASSIGNEDTO IN (SELECT RECORDID FROM @ASSIGNEDUSERIDS) OR
	(SYSTEMTASK.ASSIGNEDTO IS NULL AND TEAMASSIGNEDTO IN (SELECT RECORDID FROM @ASSIGNEDTEAMIDS))
	)
	AND PLPLAN.PLPLANTYPEID IS NOT NULL
	AND (		
		(@FACETTYPE = 0 AND COMPLETEDDATE IS NULL AND [reviewcoordinator].[UFN_IS_SNOOZED](SNOOZETYPEID, [reviewcoordinator].[UFN_HAS_INVOICE_BALANCE_DUE](PLPLAN.PLPLANID), SNOOZEUNTILDATE, @TODAY) = 0)
		OR
		(@FACETTYPE = 1 AND @LASTCOMPLETEDDATE IS NOT NULL AND COMPLETEDDATE IS NOT NULL AND COMPLETEDDATE >= @LASTCOMPLETEDDATE)
		OR
		(@FACETTYPE = 2 AND COMPLETEDDATE IS NULL AND [reviewcoordinator].[UFN_IS_SNOOZED](SNOOZETYPEID, [reviewcoordinator].[UFN_HAS_INVOICE_BALANCE_DUE](PLPLAN.PLPLANID), SNOOZEUNTILDATE, @TODAY) = 1)
	)
) 
SELECT ENTITYTYPEID ID, ENTITYTYPE NAME, COUNT(*) COUNT 
FROM ENTITY_TYPE
GROUP BY ENTITYTYPEID, ENTITYTYPE
ORDER BY COUNT(*) DESC, ENTITYTYPE

END