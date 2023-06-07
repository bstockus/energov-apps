﻿CREATE PROCEDURE [systemsetup].[USP_WORKFLOWACTIONSETVALUE_GETBYPARENTID]
(
	@WORKFLOWID CHAR(36)
)
AS
BEGIN
SET NOCOUNT ON;
SELECT 
	[dbo].[WORKFLOWACTIONSETVALUE].[WORKFLOWACTIONSETVALUEID],
	[dbo].[WORKFLOWACTIONSETVALUE].[WORKFLOWACTIONID],
	[dbo].[WORKFLOWACTIONSETVALUE].[SETVALUEFIELD],
	[dbo].[WORKFLOWACTIONSETVALUE].[SETVALUEFIELDFRIENDLYNAME],
	[dbo].[WORKFLOWACTIONSETVALUE].[SETVALUEFIELDVALUE],
	[dbo].[WORKFLOWACTIONSETVALUE].[SETVALUEFIELDADJUSTMENTVALUE],
	[dbo].[WORKFLOWACTIONSETVALUE].[SETVALUEWEEKDAYSONLY],
	[dbo].[WORKFLOWACTIONSETVALUE].[SETVALUEUSEPREVIOUSWEEKDAY]
FROM [dbo].[WORKFLOWACTIONSETVALUE]
INNER JOIN [dbo].[WORKFLOWACTION] ON [dbo].[WORKFLOWACTION].[WORKFLOWACTIONID] = [dbo].[WORKFLOWACTIONSETVALUE].[WORKFLOWACTIONID]
WHERE
	[dbo].[WORKFLOWACTION].[WORKFLOWID] = @WORKFLOWID
END