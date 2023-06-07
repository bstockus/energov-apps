﻿CREATE PROCEDURE [dbo].[USP_WORKFLOWACTIONTASK_DELETE_BYPARENTID]
(
	@WORKFLOWID CHAR(36),
    @WORKFLOWACTIONID CHAR(36)
)
AS
DELETE [dbo].[WORKFLOWACTIONTASK] FROM [dbo].[WORKFLOWACTIONTASK]
INNER JOIN [dbo].[WORKFLOWACTION] ON [dbo].[WORKFLOWACTIONTASK].[WORKFLOWACTIONID] =  [dbo].[WORKFLOWACTION].[WORKFLOWACTIONID]
WHERE
    (@WORKFLOWID IS NULL OR [dbo].[WORKFLOWACTION].[WORKFLOWID] = @WORKFLOWID) 
    AND (@WORKFLOWACTIONID IS NULL OR [dbo].[WORKFLOWACTIONTASK].[WORKFLOWACTIONID] = @WORKFLOWACTIONID)