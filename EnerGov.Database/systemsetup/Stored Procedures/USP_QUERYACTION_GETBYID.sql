﻿CREATE PROCEDURE [systemsetup].[USP_QUERYACTION_GETBYID]
	@QUERYID CHAR(36)
AS
BEGIN
SET NOCOUNT ON;
SELECT 
	[dbo].[QUERYACTION].[QUERYACTIONID],
	[dbo].[QUERYACTION].[QUERYID],
	[dbo].[QUERYACTION].[QUERYACTIONTYPEID],
	[dbo].[QUERYACTION].[ACTIONNAME],
	[dbo].[QUERYACTION].[CUSTOMMESSAGE],
	[dbo].[QUERYACTION].[ACTIONCLASSNAME],
	CONVERT(bit, 0) AS [RUNONLYWHENDIRTY],
	CONVERT(bit, 0) AS [DISABLEQUEUING],
	CONVERT(bit, 0) AS [POSTWORKFLOW],
	[dbo].[QUERYACTION].[PRIORITY],
	CONVERT(bit, 1) AS ISQUERYSETUP
FROM [dbo].[QUERYACTION]
INNER JOIN [dbo].[QUERY] ON [dbo].[QUERYACTION].[QUERYID] = [dbo].[QUERY].[QUERYID]
WHERE
	[dbo].[QUERY].[QUERYID] = @QUERYID
ORDER BY
	[dbo].[QUERYACTION].[PRIORITY], [dbo].[QUERYACTION].[ACTIONNAME]
END