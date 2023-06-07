﻿CREATE PROCEDURE [dbo].[USP_WORKFLOWACTIONPARAMETER_DELETE_BYPARENTID]
(
    @WORKFLOWID CHAR(36),
    @WORKFLOWACTIONID CHAR(36)
)
AS
DELETE [dbo].[WORKFLOWACTIONPARAMETER] FROM [dbo].[WORKFLOWACTIONPARAMETER]
	INNER JOIN [dbo].[WORKFLOWACTION] 
	ON [dbo].[WORKFLOWACTIONPARAMETER].[WORKFLOWACTIONID] = [dbo].[WORKFLOWACTION].[WORKFLOWACTIONID]
    WHERE (@WORKFLOWID IS NULL OR [dbo].[WORKFLOWACTION].[WORKFLOWID]= @WORKFLOWID) 
    AND (@WORKFLOWACTIONID IS NULL OR [dbo].[WORKFLOWACTIONPARAMETER].[WORKFLOWACTIONID] = @WORKFLOWACTIONID)