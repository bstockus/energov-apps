﻿
CREATE PROCEDURE [dbo].[rpt_SR_SR_Code_Setup_Workflow_Template]

@CMCASETYPEID AS VARCHAR(36)

AS

SELECT	WFTEMPLATE.NAME AS WorkflowTemplate, 
		WFSTEP.NAME AS WorkflowStep, 
		WFTEMPLATESTEP.PRIORITYORDER AS StepPriority, WFTEMPLATESTEP.SORTORDER AS StepSort, 
		WFACTION.NAME AS WorkflowAction, 
		WFTEMPLATESTEPACTION.PRIORITYORDER AS ActionPriority, WFTEMPLATESTEPACTION.SORTORDER AS ActionSort, WFTEMPLATESTEPACTION.AUTOFILL AS ActionAutoFill, 
		WFTEMPLATESTEPACTION.AUTORECEIVE AS ActionAutoReceive,
		WFTEMPLATESTEP.AUTOFILL AS StepAutoFill, 
		CMCASETYPE.CMCASETYPEID, CMCASETYPE.NAME AS CaseType

FROM	CMCASETYPE 
		INNER JOIN WFTEMPLATE ON CMCASETYPE.WFTEMPLATEID = WFTEMPLATE.WFTEMPLATEID 
		INNER JOIN WFTEMPLATESTEP ON WFTEMPLATE.WFTEMPLATEID = WFTEMPLATESTEP.WFTEMPLATEID
		INNER JOIN WFSTEP ON WFSTEP.WFSTEPID = WFTEMPLATESTEP.WFSTEPID 
		LEFT OUTER JOIN WFTEMPLATESTEPACTION ON WFTEMPLATESTEP.WFTEMPLATESTEPID = WFTEMPLATESTEPACTION.WFTEMPLATESTEPID
		LEFT OUTER JOIN WFACTION ON WFTEMPLATESTEPACTION.WFACTIONID = WFACTION.WFACTIONID

WHERE	CMCASETYPE.CMCASETYPEID = @CMCASETYPEID

