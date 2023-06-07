﻿CREATE PROCEDURE [reviewcoordinator].[USP_INBOX_CARD_SEARCH]
	@ASSIGNEDUSERIDS AS RECORDIDS READONLY,
	@ASSIGNEDTEAMIDS AS RECORDIDS READONLY,
	@COMPLETEDBYIDS AS RECORDIDS READONLY,
	@FILTER_BY_USER_AND_TEAM as bit = 0,
	@TODAY AS DATE = NULL,
	@NEXTBUSINESSDAYBEGIN AS DATE = NULL,
	@NEXTBUSINESSDAYEND AS DATE = NULL,
	@OVERDUEDATE AS DATE = NULL,		
	@CUSTOMBEGIN AS DATE = NULL,
	@CUSTOMEND AS DATE = NULL,
	@TASKTYPEIDS AS SYSTEM_TASK_TYPES READONLY,
	@TYPEIDS AS RECORDIDS READONLY,
	@ENTITYIDS AS RECORDIDS READONLY,
	@ALLOWHOLDOVERRIDE BIT,
	@PAGE_NUMBER AS INT = 1,
	@PAGE_SIZE AS INT = 10,
	@IS_ASCENDING AS BIT = 1,
	@SORTORDER as INT = 0,
	@LASTCOMPLETEDDATE AS DATE = NULL,
	@INCLUDE_SNOOZED AS BIT = 0
AS
BEGIN

SET NOCOUNT ON;
WITH RAW_DATA AS 
(
	(SELECT *, 
		CASE @IS_ASCENDING WHEN 1 THEN
			CASE WHEN @SORTORDER = 0 THEN ROW_NUMBER() OVER(ORDER BY APPLIEDDATE) ELSE 
			CASE WHEN @SORTORDER = 1 THEN ROW_NUMBER() OVER(ORDER BY DUEDATE) ELSE 
			CASE WHEN @SORTORDER = 3 THEN ROW_NUMBER() OVER(ORDER BY COMPLETEDDATE) ELSE 
				ROW_NUMBER() OVER(ORDER BY CREATEDON) END END END
		ELSE
			CASE WHEN @SORTORDER = 0 THEN ROW_NUMBER() OVER(ORDER BY APPLIEDDATE DESC) ELSE 
			CASE WHEN @SORTORDER = 1 THEN ROW_NUMBER() OVER(ORDER BY DUEDATE DESC) ELSE 
			CASE WHEN @SORTORDER = 3 THEN ROW_NUMBER() OVER(ORDER BY COMPLETEDDATE DESC) ELSE 
				ROW_NUMBER() OVER(ORDER BY CREATEDON DESC) END END END
		END AS RowNumber,
		COUNT(1) OVER() AS TotalRows
	FROM (
	-- permit
	SELECT 
		PMPERMIT.PMPERMITID ENTITYID,
		PMPERMIT.PERMITNUMBER ENTITYNUMBER,		
		PMPERMIT.PMPERMITTYPEID ENTITYTYPEID,
		PMPERMIT.PMPERMITWORKCLASSID ENTITYCLASSID,
		2 MODULE,
		PMPERMIT.ROWVERSION ROWVERSION,
		'' SUBMITTALID,
		'' SUBMITTALTYPEID,
		'' SUBMITTALNAME,
		SYSTEMTASK.SYSTEMTASKID,
		SYSTEMTASK.DUEDATE,
		SYSTEMTASK.SYSTEMTASKTYPEID TASKTYPEID,
		COALESCE(NULLIF(SYSTEMTASKTYPE.CUSTOMNAME,''), SYSTEMTASKTYPE.NAME) TASKTYPENAME,
		PMPERMITTYPE.NAME ENTITYTYPE,
		PMPERMITWORKCLASS.NAME ENTITYWORKCLASS,
		PMPERMIT.APPLYDATE APPLIEDDATE,
		PRPROJECT.NAME PROJECTNAME,
		PMPERMIT.DESCRIPTION ENTITYDESCRIPTION,		
		TEAM.TEAMIMAGE,
		SYSTEMTASK.TEAMASSIGNEDTO, 
		SYSTEMTASK.ASSIGNEDTO USERASSIGNEDTO,
		USERS.FNAME USERFIRSTNAME,
		USERS.LNAME USERLASTNAME,
		CAST(0 AS BIT) ISEXPEDITED,		
		RESUBMITTALREQUIREMENTSCOUNT = 
			(select count(*) from PLSUBMITTAL
			inner join PLSUBMITTALFILEVERSION on PLSUBMITTALFILEVERSION.PLSUBMITTALID = PLSUBMITTAL.PLSUBMITTALID
			inner join ERPROJECTFILEVERSION on ERPROJECTFILEVERSION.ERPROJECTFILEVERSIONID = PLSUBMITTALFILEVERSION.ERPROJECTFILEVERSIONID
			where PLSUBMITTAL.PMPERMITID = PMPERMIT.PMPERMITID AND ERPROJECTFILEVERSION.FILESTATUSID = 4),
		SYSTEMTASK.COMPLETEDDATE,
		HASSTOPHOLDS = [reviewcoordinator].UFN_HAS_ACTIVE_STOP_HOLDS(PMPERMIT.PMPERMITID, @ALLOWHOLDOVERRIDE),
		SYSTEMTASK.CREATEDON,
		HASINVOICEBALANCEDUE = [reviewcoordinator].[UFN_HAS_INVOICE_BALANCE_DUE](PMPERMIT.PMPERMITID),
		SYSTEMTASK.SNOOZETYPEID,
		SYSTEMTASK.SNOOZEUNTILDATE,
		SYSTEMTASK.COMPLETEDBY,
		COMPLETEDBYUSER.FNAME COMPLETEDBYUSERFIRSTNAME,
		COMPLETEDBYUSER.LNAME COMPLETEDBYUSERLASTNAME
	FROM SYSTEMTASK
	INNER JOIN SYSTEMTASKTYPE ON SYSTEMTASKTYPE.SYSTEMTASKTYPEID = SYSTEMTASK.SYSTEMTASKTYPEID
	INNER JOIN PMPERMIT ON PMPERMIT.PMPERMITID = SYSTEMTASK.UNIQUERECORDID
	INNER JOIN PMPERMITSTATUS ON PMPERMITSTATUS.PMPERMITSTATUSID = PMPERMIT.PMPERMITSTATUSID
	INNER JOIN PMPERMITTYPE ON PMPERMITTYPE.PMPERMITTYPEID = PMPERMIT.PMPERMITTYPEID
	INNER JOIN PMPERMITWORKCLASS ON PMPERMITWORKCLASS.PMPERMITWORKCLASSID = PMPERMIT.PMPERMITWORKCLASSID
	LEFT OUTER JOIN PRPROJECTPERMIT ON PRPROJECTPERMIT.PMPERMITID = PMPERMIT.PMPERMITID
	LEFT OUTER JOIN PRPROJECT ON PRPROJECT.PRPROJECTID = PRPROJECTPERMIT.PRPROJECTID	
	LEFT OUTER JOIN USERS ON USERS.SUSERGUID = SYSTEMTASK.ASSIGNEDTO
	LEFT OUTER JOIN TEAM ON TEAM.TEAMID = SYSTEMTASK.TEAMASSIGNEDTO
	LEFT OUTER JOIN USERS COMPLETEDBYUSER ON COMPLETEDBYUSER.SUSERGUID = SYSTEMTASK.COMPLETEDBY
	UNION ALL
	-- plan
	SELECT 
		PLPLAN.PLPLANID ENTITYID,
		PLPLAN.PLANNUMBER ENTITYNUMBER,
		PLPLAN.PLPLANTYPEID ENTITYTYPEID,
		PLPLAN.PLPLANWORKCLASSID ENTITYCLASSID,
		1 MODULE,
		PLPLAN.ROWVERSION ROWVERSION,
		'' SUBMITTALID,
		'' SUBMITTALTYPEID,
		'' SUBMITTALNAME,
		SYSTEMTASK.SYSTEMTASKID,
		SYSTEMTASK.DUEDATE,
		SYSTEMTASK.SYSTEMTASKTYPEID TASKTYPEID,
		COALESCE(NULLIF(SYSTEMTASKTYPE.CUSTOMNAME,''), SYSTEMTASKTYPE.NAME) TASKTYPENAME,
		PLPLANTYPE.PLANNAME ENTITYTYPE,
		PLPLANWORKCLASS.NAME ENTITYWORKCLASS,
		PLPLAN.APPLICATIONDATE APPLIEDDATE,
		PRPROJECT.NAME PROJECTNAME,
		PLPLAN.DESCRIPTION ENTITYDESCRIPTION,
		TEAM.TEAMIMAGE,
		SYSTEMTASK.TEAMASSIGNEDTO, 
		SYSTEMTASK.ASSIGNEDTO USERASSIGNEDTO,
		USERS.FNAME USERFIRSTNAME,
		USERS.LNAME USERLASTNAME,
		CAST(0 AS BIT) ISEXPEDITED,		
		RESUBMITTALREQUIREMENTSCOUNT = 
			(select count(*)from PLSUBMITTAL
			inner join PLSUBMITTALFILEVERSION on PLSUBMITTALFILEVERSION.PLSUBMITTALID = PLSUBMITTAL.PLSUBMITTALID
			inner join ERPROJECTFILEVERSION on ERPROJECTFILEVERSION.ERPROJECTFILEVERSIONID = PLSUBMITTALFILEVERSION.ERPROJECTFILEVERSIONID
			where PLSUBMITTAL.PLPLANID = PLPLAN.PLPLANID AND ERPROJECTFILEVERSION.FILESTATUSID = 4),
		SYSTEMTASK.COMPLETEDDATE,
		HASSTOPHOLDS = [reviewcoordinator].UFN_HAS_ACTIVE_STOP_HOLDS(PLPLAN.PLPLANID, @ALLOWHOLDOVERRIDE),
		SYSTEMTASK.CREATEDON,
		HASINVOICEBALANCEDUE = [reviewcoordinator].[UFN_HAS_INVOICE_BALANCE_DUE](PLPLAN.PLPLANID),
		SYSTEMTASK.SNOOZETYPEID,
		SYSTEMTASK.SNOOZEUNTILDATE,
		SYSTEMTASK.COMPLETEDBY,
		COMPLETEDBYUSER.FNAME COMPLETEDBYUSERFIRSTNAME,
		COMPLETEDBYUSER.LNAME COMPLETEDBYUSERLASTNAME
	FROM SYSTEMTASK
	INNER JOIN SYSTEMTASKTYPE ON SYSTEMTASKTYPE.SYSTEMTASKTYPEID = SYSTEMTASK.SYSTEMTASKTYPEID
	INNER JOIN PLPLAN ON PLPLAN.PLPLANID = SYSTEMTASK.UNIQUERECORDID
	INNER JOIN PLPLANSTATUS ON PLPLANSTATUS.PLPLANSTATUSID = PLPLAN.PLPLANSTATUSID
	INNER JOIN PLPLANTYPE ON PLPLANTYPE.PLPLANTYPEID = PLPLAN.PLPLANTYPEID
	INNER JOIN PLPLANWORKCLASS ON PLPLANWORKCLASS.PLPLANWORKCLASSID = PLPLAN.PLPLANWORKCLASSID
	LEFT OUTER JOIN PRPROJECTPLAN ON PRPROJECTPLAN.PLPLANID = PLPLAN.PLPLANID
	LEFT OUTER JOIN PRPROJECT ON PRPROJECT.PRPROJECTID = PRPROJECTPLAN.PRPROJECTID	
	LEFT OUTER JOIN USERS ON USERS.SUSERGUID = SYSTEMTASK.ASSIGNEDTO
	LEFT OUTER JOIN TEAM ON TEAM.TEAMID = SYSTEMTASK.TEAMASSIGNEDTO
	LEFT OUTER JOIN USERS COMPLETEDBYUSER ON COMPLETEDBYUSER.SUSERGUID = SYSTEMTASK.COMPLETEDBY
	UNION ALL
	-- permit submittals
	SELECT 
		PMPERMIT.PMPERMITID ENTITYID,
		PMPERMIT.PERMITNUMBER ENTITYNUMBER,		
		PMPERMIT.PMPERMITTYPEID ENTITYTYPEID,
		PMPERMIT.PMPERMITWORKCLASSID ENTITYCLASSID,
		2 MODULE,
		PMPERMIT.ROWVERSION ROWVERSION,
		PLSUBMITTAL.PLSUBMITTALID SUBMITTALID,
		PLSUBMITTALTYPE.PLSUBMITTALTYPEID SUBMITTALTYPEID,
		PLSUBMITTALTYPE.TYPENAME SUBMITTALNAME,
		SYSTEMTASK.SYSTEMTASKID,
		SYSTEMTASK.DUEDATE,
		SYSTEMTASK.SYSTEMTASKTYPEID TASKTYPEID,
		COALESCE(NULLIF(SYSTEMTASKTYPE.CUSTOMNAME,''), SYSTEMTASKTYPE.NAME) TASKTYPENAME,
		PMPERMITTYPE.NAME ENTITYTYPE,
		PMPERMITWORKCLASS.NAME ENTITYWORKCLASS,
		PMPERMIT.APPLYDATE APPLIEDDATE,
		PRPROJECT.NAME PROJECTNAME,
		PMPERMIT.DESCRIPTION ENTITYDESCRIPTION,
		TEAM.TEAMIMAGE,
		SYSTEMTASK.TEAMASSIGNEDTO, 
		SYSTEMTASK.ASSIGNEDTO USERASSIGNEDTO,
		USERS.FNAME USERFIRSTNAME,
		USERS.LNAME USERLASTNAME,
		CAST(0 AS BIT) ISEXPEDITED,		
		RESUBMITTALREQUIREMENTSCOUNT = 
			(select count(*) from PLSUBMITTAL
			inner join PLSUBMITTALFILEVERSION on PLSUBMITTALFILEVERSION.PLSUBMITTALID = PLSUBMITTAL.PLSUBMITTALID
			inner join ERPROJECTFILEVERSION on ERPROJECTFILEVERSION.ERPROJECTFILEVERSIONID = PLSUBMITTALFILEVERSION.ERPROJECTFILEVERSIONID
			where PLSUBMITTAL.PMPERMITID = PMPERMIT.PMPERMITID AND ERPROJECTFILEVERSION.FILESTATUSID = 4),
		SYSTEMTASK.COMPLETEDDATE,
		HASSTOPHOLDS = [reviewcoordinator].UFN_HAS_ACTIVE_STOP_HOLDS(PMPERMIT.PMPERMITID, @ALLOWHOLDOVERRIDE),
		SYSTEMTASK.CREATEDON,
		HASINVOICEBALANCEDUE = [reviewcoordinator].[UFN_HAS_INVOICE_BALANCE_DUE](PMPERMIT.PMPERMITID),
		SYSTEMTASK.SNOOZETYPEID,
		SYSTEMTASK.SNOOZEUNTILDATE,
		SYSTEMTASK.COMPLETEDBY,
		COMPLETEDBYUSER.FNAME COMPLETEDBYUSERFIRSTNAME,
		COMPLETEDBYUSER.LNAME COMPLETEDBYUSERLASTNAME
	FROM SYSTEMTASK
	INNER JOIN SYSTEMTASKTYPE ON SYSTEMTASKTYPE.SYSTEMTASKTYPEID = SYSTEMTASK.SYSTEMTASKTYPEID
	INNER JOIN PLSUBMITTAL ON PLSUBMITTAL.PLSUBMITTALID = SYSTEMTASK.UNIQUERECORDID
	INNER JOIN PLSUBMITTALTYPE ON PLSUBMITTALTYPE.PLSUBMITTALTYPEID = PLSUBMITTAL.PLSUBMITTALTYPEID
	INNER JOIN PMPERMIT ON PMPERMIT.PMPERMITID = PLSUBMITTAL.PMPERMITID
	INNER JOIN PMPERMITSTATUS ON PMPERMITSTATUS.PMPERMITSTATUSID = PMPERMIT.PMPERMITSTATUSID
	INNER JOIN PMPERMITTYPE ON PMPERMITTYPE.PMPERMITTYPEID = PMPERMIT.PMPERMITTYPEID
	INNER JOIN PMPERMITWORKCLASS ON PMPERMITWORKCLASS.PMPERMITWORKCLASSID = PMPERMIT.PMPERMITWORKCLASSID
	LEFT OUTER JOIN PRPROJECTPERMIT ON PRPROJECTPERMIT.PMPERMITID = PMPERMIT.PMPERMITID
	LEFT OUTER JOIN PRPROJECT ON PRPROJECT.PRPROJECTID = PRPROJECTPERMIT.PRPROJECTID	
	LEFT OUTER JOIN USERS ON USERS.SUSERGUID = SYSTEMTASK.ASSIGNEDTO
	LEFT OUTER JOIN TEAM ON TEAM.TEAMID = SYSTEMTASK.TEAMASSIGNEDTO
	LEFT OUTER JOIN USERS COMPLETEDBYUSER ON COMPLETEDBYUSER.SUSERGUID = SYSTEMTASK.COMPLETEDBY
	UNION ALL
	-- plan submittals
	SELECT 
		PLPLAN.PLPLANID ENTITYID,
		PLPLAN.PLANNUMBER ENTITYNUMBER,
		PLPLAN.PLPLANTYPEID ENTITYTYPEID,
		PLPLAN.PLPLANWORKCLASSID ENTITYCLASSID,
		1 MODULE,
		PLPLAN.ROWVERSION ROWVERSION,
		PLSUBMITTAL.PLSUBMITTALID SUBMITTALID,
		PLSUBMITTALTYPE.PLSUBMITTALTYPEID SUBMITTALTYPEID,
		PLSUBMITTALTYPE.TYPENAME SUBMITTALNAME,
		SYSTEMTASK.SYSTEMTASKID,
		SYSTEMTASK.DUEDATE,
		SYSTEMTASK.SYSTEMTASKTYPEID TASKTYPEID,
		COALESCE(NULLIF(SYSTEMTASKTYPE.CUSTOMNAME,''), SYSTEMTASKTYPE.NAME) TASKTYPENAME,
		PLPLANTYPE.PLANNAME ENTITYTYPE,
		PLPLANWORKCLASS.NAME ENTITYWORKCLASS,
		PLPLAN.APPLICATIONDATE APPLIEDDATE,
		PRPROJECT.NAME PROJECTNAME,
		PLPLAN.DESCRIPTION ENTITYDESCRIPTION,
		TEAM.TEAMIMAGE,
		SYSTEMTASK.TEAMASSIGNEDTO, 
		SYSTEMTASK.ASSIGNEDTO USERASSIGNEDTO,	
		USERS.FNAME USERFIRSTNAME,
		USERS.LNAME USERLASTNAME,
		CAST(0 AS BIT) ISEXPEDITED,		
		RESUBMITTALREQUIREMENTSCOUNT = 
			(select count(*)from PLSUBMITTAL
			inner join PLSUBMITTALFILEVERSION on PLSUBMITTALFILEVERSION.PLSUBMITTALID = PLSUBMITTAL.PLSUBMITTALID
			inner join ERPROJECTFILEVERSION on ERPROJECTFILEVERSION.ERPROJECTFILEVERSIONID = PLSUBMITTALFILEVERSION.ERPROJECTFILEVERSIONID
			where PLSUBMITTAL.PLPLANID = PLPLAN.PLPLANID AND ERPROJECTFILEVERSION.FILESTATUSID = 4),
		SYSTEMTASK.COMPLETEDDATE,
		HASSTOPHOLDS = [reviewcoordinator].UFN_HAS_ACTIVE_STOP_HOLDS(PLPLAN.PLPLANID, @ALLOWHOLDOVERRIDE),
		SYSTEMTASK.CREATEDON,
		HASINVOICEBALANCEDUE = [reviewcoordinator].[UFN_HAS_INVOICE_BALANCE_DUE](PLPLAN.PLPLANID),
		SYSTEMTASK.SNOOZETYPEID,
		SYSTEMTASK.SNOOZEUNTILDATE,
		SYSTEMTASK.COMPLETEDBY,
		COMPLETEDBYUSER.FNAME COMPLETEDBYUSERFIRSTNAME,
		COMPLETEDBYUSER.LNAME COMPLETEDBYUSERLASTNAME
	FROM SYSTEMTASK
	INNER JOIN SYSTEMTASKTYPE ON SYSTEMTASKTYPE.SYSTEMTASKTYPEID = SYSTEMTASK.SYSTEMTASKTYPEID
	INNER JOIN PLSUBMITTAL ON PLSUBMITTAL.PLSUBMITTALID = SYSTEMTASK.UNIQUERECORDID
	INNER JOIN PLSUBMITTALTYPE ON PLSUBMITTALTYPE.PLSUBMITTALTYPEID = PLSUBMITTAL.PLSUBMITTALTYPEID
	INNER JOIN PLPLAN ON PLPLAN.PLPLANID = PLSUBMITTAL.PLPLANID
	INNER JOIN PLPLANSTATUS ON PLPLANSTATUS.PLPLANSTATUSID = PLPLAN.PLPLANSTATUSID
	INNER JOIN PLPLANTYPE ON PLPLANTYPE.PLPLANTYPEID = PLPLAN.PLPLANTYPEID
	INNER JOIN PLPLANWORKCLASS ON PLPLANWORKCLASS.PLPLANWORKCLASSID = PLPLAN.PLPLANWORKCLASSID
	LEFT OUTER JOIN PRPROJECTPLAN ON PRPROJECTPLAN.PLPLANID = PLPLAN.PLPLANID
	LEFT OUTER JOIN PRPROJECT ON PRPROJECT.PRPROJECTID = PRPROJECTPLAN.PRPROJECTID	
	LEFT OUTER JOIN USERS ON USERS.SUSERGUID = SYSTEMTASK.ASSIGNEDTO
	LEFT OUTER JOIN TEAM ON TEAM.TEAMID = SYSTEMTASK.TEAMASSIGNEDTO
	LEFT OUTER JOIN USERS COMPLETEDBYUSER ON COMPLETEDBYUSER.SUSERGUID = SYSTEMTASK.COMPLETEDBY
) AS QUERY_DATA
	WHERE 	
	(
	(@FILTER_BY_USER_AND_TEAM = 0 AND 
	((NOT EXISTS(SELECT * FROM @ASSIGNEDUSERIDS) AND NOT EXISTS(SELECT * FROM @ASSIGNEDTEAMIDS)) OR
	(USERASSIGNEDTO IN (SELECT RECORDID FROM @ASSIGNEDUSERIDS) OR 
	(USERASSIGNEDTO IS NULL AND TEAMASSIGNEDTO IN (SELECT RECORDID FROM @ASSIGNEDTEAMIDS)))))
	OR 
	(@FILTER_BY_USER_AND_TEAM = 1 AND 
	(USERASSIGNEDTO IN (SELECT RECORDID FROM @ASSIGNEDUSERIDS)
	AND EXISTS(
		SELECT TEAMRESOURCE.USERID FROM @ASSIGNEDTEAMIDS
		INNER JOIN TEAMRESOURCE ON TEAMRESOURCE.TEAMID = [@ASSIGNEDTEAMIDS].RECORDID
		INNER JOIN RESOURCETYPE ON RESOURCETYPE.RESOURCETYPEID = TEAMRESOURCE.RESOURCETYPEID
		WHERE TEAMRESOURCE.USERID = USERASSIGNEDTO AND RESOURCETYPE.RESOURCESYSTEMTYPEID = 2
		UNION
		SELECT TEAM.USERID FROM @ASSIGNEDTEAMIDS
		INNER JOIN TEAM ON TEAM.TEAMID = [@ASSIGNEDTEAMIDS].RECORDID
		WHERE TEAM.USERID = USERASSIGNEDTO)))
	)
	AND
	(
		(@LASTCOMPLETEDDATE IS NULL AND COMPLETEDDATE IS NULL) 
		OR (@LASTCOMPLETEDDATE IS NOT NULL AND COMPLETEDDATE IS NOT NULL AND COMPLETEDDATE >= @LASTCOMPLETEDDATE AND
	(NOT EXISTS(SELECT * FROM @COMPLETEDBYIDS) OR COMPLETEDBY IN (SELECT RECORDID FROM @COMPLETEDBYIDS))
	)) AND
	(
		(@INCLUDE_SNOOZED = 0 AND ((SNOOZETYPEID = 1 OR SNOOZETYPEID is NULL) OR (SNOOZETYPEID = 3 AND HASINVOICEBALANCEDUE = 0) OR (SNOOZETYPEID = 2 AND (SNOOZEUNTILDATE < GETDATE())))) OR (@INCLUDE_SNOOZED = 1 AND ((SNOOZETYPEID = 3 AND HASINVOICEBALANCEDUE = 1) OR (SNOOZETYPEID = 2 AND SNOOZEUNTILDATE >= GETDATE())))
		
	) AND
	(
	@TODAY IS NULL AND @NEXTBUSINESSDAYBEGIN IS NULL AND @NEXTBUSINESSDAYEND IS NULL AND @OVERDUEDATE IS NULL AND @CUSTOMBEGIN IS NULL AND @CUSTOMEND IS NULL
	OR
	(	
	(DUEDATE >= @TODAY AND DUEDATE < DATEADD(D, 1, @TODAY)) OR	
	(DUEDATE >= @NEXTBUSINESSDAYBEGIN AND DUEDATE < DATEADD(D, 1, @NEXTBUSINESSDAYEND)) OR
	(DUEDATE < @OVERDUEDATE) OR
	(DUEDATE >= @CUSTOMBEGIN AND DUEDATE < DATEADD(D, 1, @CUSTOMEND))
	)
	) AND
	(NOT EXISTS(SELECT * FROM @TASKTYPEIDS) OR TASKTYPEID IN (SELECT SYSTEMTASKTYPEID FROM @TASKTYPEIDS)) AND	
	(NOT EXISTS(SELECT * FROM @TYPEIDS) OR ENTITYTYPEID IN (SELECT RECORDID FROM @TYPEIDS)) AND	
	(NOT EXISTS(SELECT * FROM @ENTITYIDS) OR ENTITYID IN (SELECT RECORDID FROM @ENTITYIDS))
) )

SELECT * 
INTO #RESULT_DATA
FROM RAW_DATA 
WHERE
	RowNumber > @PAGE_SIZE * (@PAGE_NUMBER - 1) AND 
	RowNumber <= @PAGE_SIZE * @PAGE_NUMBER

SELECT * FROM #RESULT_DATA ORDER BY RowNumber

DECLARE @RESULT_ENTITYIDS RECORDIDS
INSERT INTO @RESULT_ENTITYIDS SELECT DISTINCT ENTITYID FROM #RESULT_DATA

DECLARE @RESULT_SUBMITTALIDS RECORDIDS
INSERT INTO @RESULT_SUBMITTALIDS SELECT DISTINCT SUBMITTALID FROM #RESULT_DATA

DECLARE @RESULT_SYTEMTASKIDS RECORDIDS
INSERT INTO @RESULT_SYTEMTASKIDS SELECT DISTINCT SYSTEMTASKID FROM #RESULT_DATA

exec [reviewcoordinator].[USP_ADDRESS_GETBYENTITYIDS] @ENTITYIDS = @RESULT_ENTITYIDS
exec [reviewcoordinator].[USP_ITEM_REVIEWS_GETBYPLSUBMITTALIDS] @SUBMITTALIDS = @RESULT_SUBMITTALIDS
exec [reviewcoordinator].[USP_CONTACT_GETBYENTITYIDS] @ENTITYIDS = @RESULT_ENTITYIDS
exec [reviewcoordinator].[USP_ERPROJECTFILEVERSION_GETBYSYSTEMTASKIDS] @SYSTEMTASKIDS = @RESULT_SYTEMTASKIDS

END