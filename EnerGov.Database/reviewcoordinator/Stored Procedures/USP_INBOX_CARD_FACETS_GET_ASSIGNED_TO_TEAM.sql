﻿CREATE PROCEDURE [reviewcoordinator].[USP_INBOX_CARD_FACETS_GET_ASSIGNED_TO_TEAM]
	@ASSIGNEDUSERIDS AS RECORDIDS READONLY,
	@OWNEDTEAMIDS AS RECORDIDS READONLY,
	@TODAY AS DATE
AS
BEGIN

WITH ASSIGNED_TO_TEAM AS 
(
	SELECT * FROM (
	SELECT 
		SYSTEMTASK.SYSTEMTASKID, TEAM.TEAMID, TEAM.NAME, SYSTEMTASK.COMPLETEDDATE, SYSTEMTASK.ASSIGNEDTO, SYSTEMTASK.TEAMASSIGNEDTO,
		SYSTEMTASK.SNOOZETYPEID, SYSTEMTASK.SNOOZEUNTILDATE,
		COALESCE(PLSUBMITTAL.PMPERMITID, PLSUBMITTAL.PLPLANID, SYSTEMTASK.UNIQUERECORDID) ENTITYID
		FROM SYSTEMTASK
		INNER JOIN TEAMRESOURCE ON TEAMRESOURCE.USERID = SYSTEMTASK.ASSIGNEDTO
		INNER JOIN RESOURCETYPE ON RESOURCETYPE.RESOURCETYPEID = TEAMRESOURCE.RESOURCETYPEID
		INNER JOIN TEAM ON TEAM.TEAMID = TEAMRESOURCE.TEAMID
		LEFT OUTER JOIN PLSUBMITTAL ON PLSUBMITTAL.PLSUBMITTALID = SYSTEMTASK.UNIQUERECORDID
		WHERE RESOURCETYPE.RESOURCESYSTEMTYPEID = 2 		-- Reviewer/Coordinator
		AND TEAM.TEAMID IN (SELECT RECORDID FROM @OWNEDTEAMIDS)
	UNION 
	SELECT 
		SYSTEMTASK.SYSTEMTASKID, TEAM.TEAMID, TEAM.NAME, SYSTEMTASK.COMPLETEDDATE, SYSTEMTASK.ASSIGNEDTO, SYSTEMTASK.TEAMASSIGNEDTO,
		SYSTEMTASK.SNOOZETYPEID, SYSTEMTASK.SNOOZEUNTILDATE,
		COALESCE(PLSUBMITTAL.PMPERMITID, PLSUBMITTAL.PLPLANID, SYSTEMTASK.UNIQUERECORDID) ENTITYID
		FROM SYSTEMTASK
		INNER JOIN TEAM ON TEAM.USERID = SYSTEMTASK.ASSIGNEDTO
		LEFT OUTER JOIN PLSUBMITTAL ON PLSUBMITTAL.PLSUBMITTALID = SYSTEMTASK.UNIQUERECORDID
		WHERE TEAM.TEAMID IN (SELECT RECORDID FROM @OWNEDTEAMIDS)
	UNION 
	SELECT 
		SYSTEMTASK.SYSTEMTASKID, TEAM.TEAMID, TEAM.NAME, SYSTEMTASK.COMPLETEDDATE, SYSTEMTASK.ASSIGNEDTO, SYSTEMTASK.TEAMASSIGNEDTO,
		SYSTEMTASK.SNOOZETYPEID, SYSTEMTASK.SNOOZEUNTILDATE,
		COALESCE(PLSUBMITTAL.PMPERMITID, PLSUBMITTAL.PLPLANID, SYSTEMTASK.UNIQUERECORDID) ENTITYID
		FROM SYSTEMTASK
		INNER JOIN TEAM ON TEAM.TEAMID = SYSTEMTASK.TEAMASSIGNEDTO
		LEFT OUTER JOIN PLSUBMITTAL ON PLSUBMITTAL.PLSUBMITTALID = SYSTEMTASK.UNIQUERECORDID
		WHERE SYSTEMTASK.ASSIGNEDTO IS NULL AND 
		TEAM.TEAMID IN (SELECT RECORDID FROM @OWNEDTEAMIDS)
	) AS QUERY_DATA
	WHERE 	
	(ASSIGNEDTO IN (SELECT RECORDID FROM @ASSIGNEDUSERIDS) OR 
	(ASSIGNEDTO IS NULL AND TEAMASSIGNEDTO IN (SELECT RECORDID FROM @OWNEDTEAMIDS))
	) AND
	COMPLETEDDATE IS NULL
	AND [reviewcoordinator].[UFN_IS_SNOOZED](SNOOZETYPEID, 
		[reviewcoordinator].[UFN_HAS_INVOICE_BALANCE_DUE](ENTITYID), 
		SNOOZEUNTILDATE, @TODAY) = 0
) 
SELECT
ASSIGNED_TO_TEAM.TEAMID, ASSIGNED_TO_TEAM.NAME, COUNT(*) COUNT
FROM ASSIGNED_TO_TEAM
GROUP BY ASSIGNED_TO_TEAM.TEAMID, ASSIGNED_TO_TEAM.NAME
ORDER BY COUNT(*) DESC, ASSIGNED_TO_TEAM.NAME

END