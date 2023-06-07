﻿CREATE PROCEDURE [workflow].[USP_GET_CODE_CASE_WORKFLOW_SUMMARY]
	@ID AS CHAR(36)
AS
SET NOCOUNT ON;;
SELECT 
	CMCODEWFACTIONSTEP.WORKFLOWSTATUSID,
	COUNT(1) AS TOTAL
FROM
	CMCODEWFACTIONSTEP
INNER JOIN CMCODEWFSTEP ON CMCODEWFSTEP.CMCODEWFSTEPID = CMCODEWFACTIONSTEP.CMCODEWFSTEPID
wHERE 
	CMCODEWFSTEP.CMCODECASEID = @ID AND CMCODEWFACTIONSTEP.WORKFLOWSTATUSID NOT IN (4,3,2,7)
GROUP BY CMCODEWFACTIONSTEP.WORKFLOWSTATUSID