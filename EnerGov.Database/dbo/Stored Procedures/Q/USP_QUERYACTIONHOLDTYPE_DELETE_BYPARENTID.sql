﻿CREATE PROCEDURE [dbo].[USP_QUERYACTIONHOLDTYPE_DELETE_BYPARENTID]
(
    @QUERYID CHAR(36),
    @QUERYACTIONID CHAR(36)
    
)
AS
DELETE [dbo].[QUERYACTIONHOLDTYPE] FROM [dbo].[QUERYACTIONHOLDTYPE]
INNER JOIN [dbo].[QUERYACTION] ON [dbo].[QUERYACTIONHOLDTYPE].[QUERYACTIONID] =  [dbo].[QUERYACTION].[QUERYACTIONID]
WHERE
    (@QUERYID IS NULL OR [dbo].[QUERYACTION].[QUERYID]= @QUERYID) 
    AND (@QUERYACTIONID IS NULL OR [dbo].[QUERYACTIONHOLDTYPE].[QUERYACTIONID] = @QUERYACTIONID)