﻿CREATE PROCEDURE [reviewcoordinator].[USP_PLSUBMITTAL_GETBYID]
	@ID CHAR(36),
	@ALLOWHOLDOVERRIDE BIT
AS
BEGIN

DECLARE @permitModule INT = 2
DECLARE @planModule INT = 1

SET NOCOUNT ON;
WITH RAW_DATA AS 
(
SELECT 
	@permitModule AS MODULE,
	PMPERMIT.PMPERMITID ENTITYID,
	PMPERMIT.PERMITNUMBER ENTITYNUMBER,
	PMPERMIT.ROWVERSION, 
	PMPERMIT.PMPERMITTYPEID ENTITYTYPEID,
	ERENTITYPROJECT.ERENTITYPROJECTID ENTITYPROJECTID,
	PLSUBMITTAL.PLSUBMITTALID,
	PLSUBMITTAL.DUEDATE,	
	PLSUBMITTALTYPE.TYPENAME,	
	PMPERMITWFACTIONSTEP.VERSIONNUMBER WORKFLOWACTIONVERSION,		
	HASACTIVEHOLDS = [reviewcoordinator].[UFN_HAS_ACTIVE_STOP_HOLDS](PMPERMIT.PMPERMITID, @ALLOWHOLDOVERRIDE),
	PMPERMIT.DESCRIPTION ENTITYDESCRIPTION
FROM PLSUBMITTAL
INNER JOIN PLSUBMITTALTYPE ON PLSUBMITTALTYPE.PLSUBMITTALTYPEID = PLSUBMITTAL.PLSUBMITTALTYPEID
INNER JOIN PLSUBMITTALSTATUS ON PLSUBMITTALSTATUS.PLSUBMITTALSTATUSID = PLSUBMITTAL.PLSUBMITTALSTATUSID
INNER JOIN PMPERMIT ON PMPERMIT.PMPERMITID = PLSUBMITTAL.PMPERMITID
INNER JOIN PMPERMITTYPE ON PMPERMITTYPE.PMPERMITTYPEID = PMPERMIT.PMPERMITTYPEID
LEFT OUTER JOIN PRPROJECTPERMIT ON PRPROJECTPERMIT.PMPERMITID = PMPERMIT.PMPERMITID
LEFT OUTER JOIN PMPERMITWFACTIONSTEP ON PMPERMITWFACTIONSTEP.PMPERMITWFACTIONSTEPID = PLSUBMITTAL.PMPERMITWFACTIONSTEPID
LEFT OUTER JOIN ERENTITYPROJECT ON ERENTITYPROJECT.PMPERMITID = PMPERMIT.PMPERMITID
UNION ALL
SELECT 
	@planModule AS MODULE,
	PLPLAN.PLPLANID ENTITYID,
	PLPLAN.PLANNUMBER ENTITYNUMBER,
	PLPLAN.ROWVERSION, 
	PLPLAN.PLPLANTYPEID ENTITYTYPEID,
	ERENTITYPROJECT.ERENTITYPROJECTID ENTITYPROJECTID,
	PLSUBMITTAL.PLSUBMITTALID,
	PLSUBMITTAL.DUEDATE,	
	PLSUBMITTALTYPE.TYPENAME,	
	PLPLANWFACTIONSTEP.VERSIONNUMBER WORKFLOWACTIONVERSION,		
	HASACTIVEHOLDS = [reviewcoordinator].[UFN_HAS_ACTIVE_STOP_HOLDS](PLPLAN.PLPLANID, @ALLOWHOLDOVERRIDE),
	PLPLAN.DESCRIPTION ENTITYDESCRIPTION
FROM PLSUBMITTAL
INNER JOIN PLSUBMITTALTYPE ON PLSUBMITTALTYPE.PLSUBMITTALTYPEID = PLSUBMITTAL.PLSUBMITTALTYPEID
INNER JOIN PLSUBMITTALSTATUS ON PLSUBMITTALSTATUS.PLSUBMITTALSTATUSID = PLSUBMITTAL.PLSUBMITTALSTATUSID
INNER JOIN PLPLAN ON PLPLAN.PLPLANID = PLSUBMITTAL.PLPLANID
INNER JOIN PLPLANTYPE ON PLPLANTYPE.PLPLANTYPEID = PLPLAN.PLPLANTYPEID
LEFT OUTER JOIN PRPROJECTPLAN ON PRPROJECTPLAN.PLPLANID = PLPLAN.PLPLANID
LEFT OUTER JOIN PLPLANWFACTIONSTEP ON PLPLANWFACTIONSTEP.PLPLANWFACTIONSTEPID = PLSUBMITTAL.PLPLANWFACTIONSTEPID
LEFT OUTER JOIN ERENTITYPROJECT ON ERENTITYPROJECT.PLPLANID = PLPLAN.PLPLANID
)
SELECT * FROM RAW_DATA
WHERE PLSUBMITTALID = @ID

DECLARE @ENTITYIDS RECORDIDS 
INSERT INTO @ENTITYIDS SELECT COALESCE(PMPERMITID, PLPLANID) FROM PLSUBMITTAL WHERE PLSUBMITTALID = @ID

DECLARE @SUBMITTALIDS RECORDIDS
INSERT INTO @SUBMITTALIDS VALUES (@ID)

exec [reviewcoordinator].[USP_ADDRESS_GETBYENTITYIDS] @ENTITYIDS = @ENTITYIDS
exec [reviewcoordinator].[USP_CONTACT_GETBYENTITYIDS] @ENTITYIDS = @ENTITYIDS
exec [reviewcoordinator].[USP_ERPROJECTFILEVERSION_GETBYENTITYIDS] @ENTITYIDS = @ENTITYIDS

exec [reviewcoordinator].[USP_ERENTITYSESSION_GETBYPLSUBMITTALID] @PLSUBMITTALID = @ID
exec [reviewcoordinator].[USP_ERENTITYPROJECTSESSIONFILE_GETBYPLSUBMITTALID] @PLSUBMITTALID = @ID

exec [reviewcoordinator].[USP_ERENTITYSESSIONTRANSACTION_GETBYPLSUBMITTALIDS] @SUBMITTALIDS = @SUBMITTALIDS

END