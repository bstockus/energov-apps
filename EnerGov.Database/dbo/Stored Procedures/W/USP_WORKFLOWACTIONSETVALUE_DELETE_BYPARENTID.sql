﻿CREATE PROCEDURE [dbo].[USP_WORKFLOWACTIONSETVALUE_DELETE_BYPARENTID]
(
	@WORKFLOWID CHAR(36),
    @WORKFLOWACTIONID CHAR(36)
)
AS
DELETE [dbo].[WORKFLOWACTIONSETVALUE] FROM [dbo].[WORKFLOWACTIONSETVALUE]
INNER JOIN [dbo].[WORKFLOWACTION] ON [dbo].[WORKFLOWACTIONSETVALUE].[WORKFLOWACTIONID] =  [dbo].[WORKFLOWACTION].[WORKFLOWACTIONID]
WHERE
    (@WORKFLOWID IS NULL OR [dbo].[WORKFLOWACTION].[WORKFLOWID] = @WORKFLOWID) 
    AND (@WORKFLOWACTIONID IS NULL OR [dbo].[WORKFLOWACTIONSETVALUE].[WORKFLOWACTIONID] = @WORKFLOWACTIONID)