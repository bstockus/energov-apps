﻿CREATE PROCEDURE [reviewcoordinator].[USP_PLSUBMITTAL_GETBYIDS]
	@SUBMITTALIDS RECORDIDS READONLY
AS
BEGIN

DECLARE @permitModule INT = 2
DECLARE @planModule INT = 1

SET NOCOUNT ON;
WITH RAW_DATA AS 
(
SELECT 
	PMPERMIT.PMPERMITID ENTITYID,
	PMPERMIT.PERMITNUMBER ENTITYNUMBER,
	PLSUBMITTAL.PLSUBMITTALID,
	PLSUBMITTALTYPE.PLSUBMITTALTYPEID TYPEID,
	PLSUBMITTALTYPE.TYPENAME,
	PLSUBMITTALSTATUS.NAME STATUSNAME,
	PMPERMITWFACTIONSTEP.NAME WORKFLOWACTIONNAME,
	PMPERMITWFACTIONSTEP.VERSIONNUMBER WORKFLOWACTIONVERSION,
	PLSUBMITTAL.DUEDATE,
	PLSUBMITTAL.RECEIVEDDATE,
	PLSUBMITTAL.COMPLETEDATE,
	@permitModule AS MODULE,
	PLSUBMITTALTYPE.TYPENAME + ' V' + CONVERT(VARCHAR, PMPERMITWFACTIONSTEP.VERSIONNUMBER) SUBMITTALDISPLAYNAME
FROM PLSUBMITTAL
INNER JOIN PLSUBMITTALTYPE ON PLSUBMITTALTYPE.PLSUBMITTALTYPEID = PLSUBMITTAL.PLSUBMITTALTYPEID
INNER JOIN PLSUBMITTALSTATUS ON PLSUBMITTALSTATUS.PLSUBMITTALSTATUSID = PLSUBMITTAL.PLSUBMITTALSTATUSID
INNER JOIN PMPERMIT ON PMPERMIT.PMPERMITID = PLSUBMITTAL.PMPERMITID
LEFT OUTER JOIN PMPERMITWFACTIONSTEP ON PMPERMITWFACTIONSTEP.PMPERMITWFACTIONSTEPID = PLSUBMITTAL.PMPERMITWFACTIONSTEPID
UNION ALL
SELECT 
	PLPLAN.PLPLANID ENTITYID,
	PLPLAN.PLANNUMBER ENTITYNUMBER,
	PLSUBMITTAL.PLSUBMITTALID,
	PLSUBMITTALTYPE.PLSUBMITTALTYPEID TYPEID,
	PLSUBMITTALTYPE.TYPENAME,
	PLSUBMITTALSTATUS.NAME STATUSNAME,
	PLPLANWFACTIONSTEP.NAME WORKFLOWACTIONNAME,
	PLPLANWFACTIONSTEP.VERSIONNUMBER WORKFLOWACTIONVERSION,
	PLSUBMITTAL.DUEDATE,
	PLSUBMITTAL.RECEIVEDDATE,
	PLSUBMITTAL.COMPLETEDATE,
	@planModule AS MODULE,
	PLSUBMITTALTYPE.TYPENAME + ' V' + CONVERT(VARCHAR, PLPLANWFACTIONSTEP.VERSIONNUMBER) SUBMITTALDISPLAYNAME
FROM PLSUBMITTAL
INNER JOIN PLSUBMITTALTYPE ON PLSUBMITTALTYPE.PLSUBMITTALTYPEID = PLSUBMITTAL.PLSUBMITTALTYPEID
INNER JOIN PLSUBMITTALSTATUS ON PLSUBMITTALSTATUS.PLSUBMITTALSTATUSID = PLSUBMITTAL.PLSUBMITTALSTATUSID
INNER JOIN PLPLAN ON PLPLAN.PLPLANID = PLSUBMITTAL.PLPLANID
LEFT OUTER JOIN PLPLANWFACTIONSTEP ON PLPLANWFACTIONSTEP.PLPLANWFACTIONSTEPID = PLSUBMITTAL.PLPLANWFACTIONSTEPID
)
SELECT * FROM RAW_DATA 
WHERE PLSUBMITTALID IN (SELECT RECORDID FROM @SUBMITTALIDS)
ORDER BY WORKFLOWACTIONVERSION DESC

exec [reviewcoordinator].[USP_ITEM_REVIEWS_GETBYPLSUBMITTALIDS] @SUBMITTALIDS = @SUBMITTALIDS

exec [reviewcoordinator].[USP_ERENTITYSESSION_GETBYPLSUBMITTALIDS] @SUBMITTALIDS = @SUBMITTALIDS
exec [reviewcoordinator].[USP_ERENTITYSESSIONTRANSACTION_GETBYPLSUBMITTALIDS] @SUBMITTALIDS = @SUBMITTALIDS
exec [reviewcoordinator].[USP_ERINTEGRATIONQUEUE_GETBYPLSUBMITTALIDS] @SUBMITTALIDS = @SUBMITTALIDS

END