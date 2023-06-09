﻿CREATE PROCEDURE [reviewcoordinator].[USP_PLSUBMITTALS_REVIEWED_SUBMITTALS_GET]
	@ENTITYID CHAR(36),
	@PLSUBMITTALID CHAR(36) = NULL
AS
BEGIN

DECLARE @SUBMITTALIDS RECORDIDS

SET NOCOUNT ON

DECLARE @workflowStatusFailed INT = 2;

IF (@PLSUBMITTALID IS NOT NULL)
BEGIN	
	;WITH SUBMITTAL_RAW (PLSUBMITTALID, PLSUBMITTALPARENTID, WFPARENTACTIONSTEPID) 
	AS (
		SELECT PLSUBMITTALID, PLSUBMITTALPARENTID,
			COALESCE(PMPERMITWFACTIONSTEP.PMPERMITWFPARENTACTIONSTEPID, PLPLANWFACTIONSTEP.PLPLANWFPARENTACTIONSTEPID) WFPARENTACTIONSTEPID
		 FROM PLSUBMITTAL
			LEFT OUTER JOIN PMPERMITWFACTIONSTEP ON PMPERMITWFACTIONSTEP.PMPERMITWFACTIONSTEPID = PLSUBMITTAL.PMPERMITWFACTIONSTEPID
			LEFT OUTER JOIN PLPLANWFACTIONSTEP ON PLPLANWFACTIONSTEP.PLPLANWFACTIONSTEPID = PLSUBMITTAL.PLPLANWFACTIONSTEPID
			WHERE (PMPERMITID = @ENTITYID OR PLPLANID = @ENTITYID) AND PLSUBMITTALID = @PLSUBMITTALID
		UNION ALL
		SELECT    
			PLSUBMITTAL.PLSUBMITTALID, PLSUBMITTAL.PLSUBMITTALPARENTID, 
			PMPERMITWFACTIONSTEP.PMPERMITWFPARENTACTIONSTEPID WFPARENTACTIONSTEPID
			FROM SUBMITTAL_RAW
			INNER JOIN PMPERMITWFACTIONSTEP ON PMPERMITWFACTIONSTEP.PMPERMITWFACTIONSTEPID = SUBMITTAL_RAW.WFPARENTACTIONSTEPID
			INNER JOIN PLSUBMITTAL ON PLSUBMITTAL.PMPERMITWFACTIONSTEPID = PMPERMITWFACTIONSTEP.PMPERMITWFACTIONSTEPID	
			WHERE PMPERMITWFACTIONSTEP.WORKFLOWSTATUSID = @workflowStatusFailed
		UNION ALL
		SELECT        
			PLSUBMITTAL.PLSUBMITTALID, PLSUBMITTAL.PLSUBMITTALPARENTID, 
			PLPLANWFACTIONSTEP.PLPLANWFPARENTACTIONSTEPID WFPARENTACTIONSTEPID
			FROM SUBMITTAL_RAW
			INNER JOIN PLPLANWFACTIONSTEP ON PLPLANWFACTIONSTEP.PLPLANWFACTIONSTEPID = SUBMITTAL_RAW.WFPARENTACTIONSTEPID
			INNER JOIN PLSUBMITTAL ON PLSUBMITTAL.PLPLANWFACTIONSTEPID = PLPLANWFACTIONSTEP.PLPLANWFACTIONSTEPID
			WHERE PLPLANWFACTIONSTEP.WORKFLOWSTATUSID = @workflowStatusFailed
	) 
	INSERT INTO @SUBMITTALIDS SELECT PLSUBMITTALID FROM SUBMITTAL_RAW WHERE PLSUBMITTALID <> @PLSUBMITTALID
END
ELSE 
BEGIN
	;WITH WORKFLOW_RAW (PLSUBMITTALID)
	AS (
	SELECT PLSUBMITTALID FROM PLSUBMITTAL
		LEFT OUTER JOIN PMPERMITWFACTIONSTEP ON PMPERMITWFACTIONSTEP.PMPERMITWFACTIONSTEPID = PLSUBMITTAL.PMPERMITWFACTIONSTEPID
		LEFT OUTER JOIN PLPLANWFACTIONSTEP ON PLPLANWFACTIONSTEP.PLPLANWFACTIONSTEPID = PLSUBMITTAL.PLPLANWFACTIONSTEPID
		WHERE (PMPERMITID = @ENTITYID AND PMPERMITWFACTIONSTEP.WORKFLOWSTATUSID = @workflowStatusFailed) OR 
			  (PLPLANID = @ENTITYID AND PLPLANWFACTIONSTEP.WORKFLOWSTATUSID = @workflowStatusFailed)
	) 	
	INSERT INTO @SUBMITTALIDS SELECT PLSUBMITTALID FROM WORKFLOW_RAW
END

exec [reviewcoordinator].[USP_PLSUBMITTAL_GETBYIDS] @SUBMITTALIDS = @SUBMITTALIDS

END