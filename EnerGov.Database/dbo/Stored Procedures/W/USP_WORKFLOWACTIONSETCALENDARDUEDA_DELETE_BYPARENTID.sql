﻿CREATE PROCEDURE [dbo].[USP_WORKFLOWACTIONSETCALENDARDUEDA_DELETE_BYPARENTID]
(
	@WORKFLOWID CHAR(36),
    @WORKFLOWACTIONID CHAR(36)
)
AS
DELETE [dbo].[WORKFLOWACTIONSETCALENDARDUEDA] FROM [dbo].[WORKFLOWACTIONSETCALENDARDUEDA]
INNER JOIN [dbo].[WORKFLOWACTION] ON [dbo].[WORKFLOWACTIONSETCALENDARDUEDA].[WORKFLOWACTIONID] =  [dbo].[WORKFLOWACTION].[WORKFLOWACTIONID]
WHERE
    (@WORKFLOWID IS NULL OR [dbo].[WORKFLOWACTION].[WORKFLOWID] = @WORKFLOWID) 
    AND (@WORKFLOWACTIONID IS NULL OR [dbo].[WORKFLOWACTIONSETCALENDARDUEDA].[WORKFLOWACTIONID] = @WORKFLOWACTIONID)