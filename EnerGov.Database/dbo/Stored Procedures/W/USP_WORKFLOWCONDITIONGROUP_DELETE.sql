﻿CREATE PROCEDURE [dbo].[USP_WORKFLOWCONDITIONGROUP_DELETE]
(
	@WORKFLOWCONDITIONGROUPID CHAR(36)
)
AS

DECLARE @WORKFLOWID CHAR(36)

SELECT @WORKFLOWID = [WORKFLOWID] from  [dbo].[WORKFLOWCONDITIONGROUP] 
WHERE [WORKFLOWCONDITIONGROUPID] = @WORKFLOWCONDITIONGROUPID

EXEC [dbo].[USP_WORKFLOWCONDITION_DELETE_BYPARENTID]  @WORKFLOWID , @WORKFLOWCONDITIONGROUPID

DELETE FROM [dbo].[WORKFLOWCONDITIONGROUP]
WHERE
	[WORKFLOWCONDITIONGROUPID] = @WORKFLOWCONDITIONGROUPID