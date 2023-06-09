﻿CREATE PROCEDURE [gissetupapp].[USP_GEORULEPROCESS_GETBYPARENTID]
(
	@PARENTID CHAR(36)
)
AS
BEGIN
SET NOCOUNT ON;
SELECT 
	[dbo].[GEORULEPROCESS].[GEORULEPROCESSID],
	[dbo].[GEORULEPROCESS].[GEORULEID],
	[dbo].[GEORULEPROCESS].[GEORULEPROCESSTYPEID],
	[dbo].[GEORULEPROCESS].[GEORULECOMPARERID],
	[dbo].[GEORULEPROCESS].[PROCESSNAME],
	[dbo].[GEORULEPROCESS].[MESSAGETEXT],
	[dbo].[GEORULEPROCESS].[WORKFLOWSTEPID],
	[dbo].[GEORULEPROCESS].[WORKFLOWACTIONSTEPID],
	[dbo].[WFACTION].[NAME],
	[dbo].[GEORULEPROCESS].[COMPARER],
	[dbo].[GEORULEPROCESS].[PRIORITY],
	[dbo].[GEORULEPROCESS].[PLSUBMITTALTYPEID],
	[dbo].[GEORULEPROCESS].[PLITEMREVIEWTYPEID],
	[dbo].[GEORULEPROCESS].[GEORULEMULTIRETURNID],
	[dbo].[GEORULEPROCESS].[MULTIRETURNVALUE],
	[dbo].[GEORULEPROCESS].[GISATTRIBUTENAME],
	[dbo].[GEORULEPROCESSTYPE].[SYSTEMTYPE]
FROM [dbo].[GEORULEPROCESS]
INNER JOIN [dbo].[GEORULEPROCESSTYPE] ON [dbo].[GEORULEPROCESSTYPE].[GEORULEPROCESSTYPEID] = [dbo].[GEORULEPROCESS].[GEORULEPROCESSTYPEID]
LEFT JOIN [dbo].[WFACTION] ON [dbo].[WFACTION].[WFACTIONID] = [dbo].[GEORULEPROCESS].[WORKFLOWACTIONSTEPID]
WHERE
	[dbo].[GEORULEPROCESS].[GEORULEID] = @PARENTID  
ORDER BY
	[dbo].[GEORULEPROCESS].[PROCESSNAME]
		
END