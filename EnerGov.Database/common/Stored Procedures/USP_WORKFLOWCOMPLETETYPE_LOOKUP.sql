﻿CREATE PROCEDURE [common].[USP_WORKFLOWCOMPLETETYPE_LOOKUP]
AS
SET NOCOUNT ON;
SELECT 
	[dbo].[WORKFLOWCOMPLETETYPE].[WORKFLOWCOMPLETETYPEID],
	[dbo].[WORKFLOWCOMPLETETYPE].[NAME]
FROM [dbo].[WORKFLOWCOMPLETETYPE]
ORDER BY [dbo].[WORKFLOWCOMPLETETYPE].[NAME]