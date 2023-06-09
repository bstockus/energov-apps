﻿CREATE PROCEDURE [dbo].[USP_QUERYACTIONSETVALUE_DELETE_BYPARENTID]
(
	@QUERYID CHAR(36),
    @QUERYACTIONID CHAR(36)
)
AS
DELETE [dbo].[QUERYACTIONSETVALUE] FROM [dbo].[QUERYACTIONSETVALUE]
INNER JOIN [dbo].[QUERYACTION] ON [dbo].[QUERYACTIONSETVALUE].[QUERYACTIONID] =  [dbo].[QUERYACTION].[QUERYACTIONID]
WHERE
    (@QUERYID IS NULL OR [dbo].[QUERYACTION].[QUERYID] = @QUERYID) 
    AND (@QUERYACTIONID IS NULL OR [dbo].[QUERYACTIONSETVALUE].[QUERYACTIONID] = @QUERYACTIONID)