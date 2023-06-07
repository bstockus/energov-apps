CREATE PROCEDURE [project].[USP_PRPROJECT_RECENT_WORKFLOW_STATUS]
(	
	@PROJECTID	CHAR(36),
	@USERID		CHAR(36),
	@PAGE		INT,
	@PAGESIZE	INT
)
AS
BEGIN
		SET NOCOUNT ON

		IF @PAGESIZE IS NULL OR @PAGESIZE <= 0
		BEGIN
			SET @PAGESIZE = 20
		END

		DECLARE @START INT;
		DECLARE @END INT;
		SET @START = (@PAGE - 1) * @PAGESIZE + 1;
		SET @END = @PAGE * @PAGESIZE;

		WITH RecentCaseWorkflowItems (RowNumber, TotalCases, EntityId, Module, EntityType, EntityNumber, UpdatedOn, IsCompleted, InProgress, NotStarted, Completed,Total, WorkClass) AS 
			(
			SELECT ROW_NUMBER() OVER (ORDER BY
			CASE WHEN IsCompleted <> 1 AND Completed <> 0 AND Completed <> Total  THEN UpdatedOn END DESC,
			CASE WHEN IsCompleted <> 1 AND Completed <> Total AND Completed = 0 THEN UpdatedOn END DESC,
			CASE WHEN IsCompleted = 1 OR Completed = Total OR Total = 0 THEN UpdatedOn END DESC) AS RowNumber, COUNT(1) OVER() AS TotalCases, EntityId, Module, EntityType, EntityNumber,
			 UpdatedOn, IsCompleted, InProgress, NotStarted, Completed,Total, WorkClass FROM (
				SELECT EntityId, 2 AS Module, EntityType, EntityNumber, UpdatedOn, IsCompleted, -- SYSTEMMODULE - 2 Permit management
				-- exclude workflow steps with status 'Skipped'
				COUNT(CASE WHEN (StepStatus != 3 AND ActionStatus = 5) THEN 1 ELSE NULL END) AS InProgress, -- status Started
				COUNT(CASE WHEN (StepStatus != 3 AND ActionStatus = 0) THEN 1 ELSE NULL END) AS NotStarted, -- status Not Started
				COUNT(CASE WHEN (StepStatus != 3 AND (ActionStatus = 1 OR ActionStatus = 6)) THEN 1 ELSE NULL END) AS Completed, -- status Passed or Partially Passed
				COUNT(CASE WHEN (StepStatus != 3 AND (ActionStatus = 1 OR ActionStatus = 6 OR ActionStatus = 5 OR ActionStatus = 0)) THEN 1 ELSE NULL END) AS Total,
				WorkClass
				FROM (
				SELECT p.PMPERMITID AS EntityId, p.PERMITNUMBER AS EntityNumber, (SELECT TOP 1 NAME FROM PMPERMITTYPE WHERE PMPERMITTYPEID = p.PMPERMITTYPEID) AS EntityType, p.LASTCHANGEDON AS UpdatedOn, 
				(SELECT TOP 1 COMPLETEDFLAG FROM PMPERMITSTATUS WHERE PMPERMITSTATUSID = p.PMPERMITSTATUSID) AS IsCompleted, pwsa.WORKFLOWSTATUSID AS ActionStatus, pws.WORKFLOWSTATUSID StepStatus,
				(SELECT TOP 1 NAME FROM PMPERMITWORKCLASS WHERE PMPERMITWORKCLASSID = p.PMPERMITWORKCLASSID) AS WorkClass
				FROM PRPROJECTPERMIT prp
				JOIN PMPERMIT p ON prp.PMPERMITID = p.PMPERMITID AND prp.PRPROJECTID = @PROJECTID
				JOIN PMPERMITWFSTEP pws ON p.PMPERMITID = pws.PMPERMITID 
				JOIN PMPERMITWFACTIONSTEP pwsa ON pws.PMPERMITWFSTEPID = pwsa.PMPERMITWFSTEPID 
				JOIN GETUSERVISIBLERECORDTYPES(@USERID) ut ON ut.RECORDTYPEID = p.PMPERMITTYPEID
				) Permits GROUP BY EntityId, EntityNumber, EntityType, UpdatedOn, IsCompleted, WorkClass
				UNION ALL
				SELECT EntityId, 3 AS Module, EntityType, EntityNumber, UpdatedOn, IsCompleted, -- SYSTEMMODULE - 3 Plan management
				-- exclude workflow steps with status 'Skipped'
				COUNT(CASE WHEN (StepStatus != 3 AND ActionStatus = 5) THEN 1 ELSE NULL END) AS InProgress, -- status Started
				COUNT(CASE WHEN (StepStatus != 3 AND ActionStatus = 0) THEN 1 ELSE NULL END) AS NotStarted, -- status Not Started
				COUNT(CASE WHEN (StepStatus != 3 AND (ActionStatus = 1 OR ActionStatus = 6)) THEN 1 ELSE NULL END) AS Completed, -- status Passed or Partially Passed
				COUNT(CASE WHEN (StepStatus != 3 AND (ActionStatus = 1 OR ActionStatus = 6 OR ActionStatus = 5 OR ActionStatus = 0)) THEN 1 ELSE NULL END) AS Total,
				WorkClass
				FROM (
				SELECT p.PLPLANID AS EntityId, p.PLANNUMBER AS EntityNumber, (SELECT TOP 1 PLANNAME FROM PLPLANTYPE WHERE PLPLANTYPEID = p.PLPLANTYPEID) AS EntityType, p.LASTCHANGEDON AS UpdatedOn, 
				(SELECT SUCCESSFLAG FROM PLPLANSTATUS WHERE PLPLANSTATUSID = p.PLPLANSTATUSID) AS IsCompleted, pwsa.WORKFLOWSTATUSID AS ActionStatus, pws.WORKFLOWSTATUSID StepStatus,
				(SELECT TOP 1 NAME FROM PLPLANWORKCLASS WHERE PLPLANWORKCLASSID = p.PLPLANWORKCLASSID) AS WorkClass
				FROM PRPROJECTPLAN prp
				JOIN PLPLAN p ON prp.PLPLANID = p.PLPLANID AND prp.PRPROJECTID = @PROJECTID
				JOIN PLPLANTYPE pt ON p.PLPLANTYPEID = pt.PLPLANTYPEID
				JOIN PLPLANSTATUS ps ON p.PLPLANSTATUSID = ps.PLPLANSTATUSID
				JOIN PLPLANWFSTEP pws ON p.PLPLANID = pws.PLPLANID 
				JOIN PLPLANWFACTIONSTEP pwsa ON pws.PLPLANWFSTEPID = pwsa.PLPLANWFSTEPID 
				JOIN GETUSERVISIBLERECORDTYPES(@USERID) ut ON ut.RECORDTYPEID = p.PLPLANTYPEID
				
				) Plans GROUP BY EntityId, EntityNumber, EntityType, UpdatedOn, IsCompleted, WorkClass
				UNION ALL
				SELECT EntityId, 5 AS Module, EntityType, EntityNumber, UpdatedOn, IsCompleted, -- SYSTEMMODULE - 5 Code management
				-- exclude workflow steps with status 'Skipped'
				COUNT(CASE WHEN (StepStatus != 3 AND ActionStatus = 5) THEN 1 ELSE NULL END) AS InProgress, -- status Started
				COUNT(CASE WHEN (StepStatus != 3 AND ActionStatus = 0) THEN 1 ELSE NULL END) AS NotStarted, -- status Not Started
				COUNT(CASE WHEN (StepStatus != 3 AND (ActionStatus = 1 OR ActionStatus = 6)) THEN 1 ELSE NULL END) AS Completed, -- status Passed or Partially Passed
				COUNT(CASE WHEN (StepStatus != 3 AND (ActionStatus = 1 OR ActionStatus = 6 OR ActionStatus = 5 OR ActionStatus = 0)) THEN 1 ELSE NULL END) AS Total,
				NULL as WorkClass
				FROM (
				SELECT p.CMCODECASEID AS EntityId, p.CASENUMBER AS EntityNumber, (SELECT TOP 1 NAME FROM CMCASETYPE WHERE CMCASETYPEID = p.CMCASETYPEID) AS EntityType, p.LASTCHANGEDON AS UpdatedOn, 
				(SELECT TOP 1 SUCCESSFLAG FROM CMCODECASESTATUS WHERE CMCODECASESTATUSID = p.CMCODECASESTATUSID) AS IsCompleted, pwsa.WORKFLOWSTATUSID AS ActionStatus, pws.WORKFLOWSTATUSID StepStatus  
				FROM PRPROJECTCODECASE prp
				JOIN CMCODECASE p ON prp.CMCODECASEID = p.CMCODECASEID AND prp.PRPROJECTID = @PROJECTID
				JOIN CMCODEWFSTEP pws ON p.CMCODECASEID = pws.CMCODECASEID
				JOIN CMCODEWFACTIONSTEP pwsa ON pws.CMCODEWFSTEPID = pwsa.CMCODEWFSTEPID 
				JOIN GETUSERVISIBLERECORDTYPES(@USERID) ut ON ut.RECORDTYPEID = p.CMCASETYPEID 
				) Codecases GROUP BY EntityId, EntityNumber, EntityType, UpdatedOn, IsCompleted

			) relatedCases
		)

		SELECT	TotalCases, EntityId, Module, EntityType, EntityNumber, 
				UpdatedOn, IsCompleted, 
				InProgress = CAST(InProgress AS DECIMAL(18, 2)),
				NotStarted = CAST(NotStarted AS DECIMAL(18, 2)),
				Completed = CAST(Completed AS DECIMAL(18, 2)),
				Total,
				WorkClass
		FROM	RecentCaseWorkflowItems 
		WHERE	RowNumber >= @START 
				AND RowNumber <= @END
END