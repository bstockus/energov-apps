﻿CREATE PROCEDURE [systemsetup].[USP_WORKFLOWPROPERTYCONDITIONTYPE_GETALL]
AS
BEGIN
	SELECT 
		[dbo].[WORKFLOWPROPERTYCONDITIONTYPE].WORKFLOWPROPERTYCONDTYPEID,
		[dbo].[WORKFLOWPROPERTYCONDITIONTYPE].PROPERTYCONDITIONTYPENAME
	FROM [dbo].[WORKFLOWPROPERTYCONDITIONTYPE]
	ORDER BY [dbo].[WORKFLOWPROPERTYCONDITIONTYPE].WORKFLOWPROPERTYCONDTYPEID
END