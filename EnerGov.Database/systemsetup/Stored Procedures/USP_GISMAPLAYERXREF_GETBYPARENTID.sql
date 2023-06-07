﻿CREATE PROCEDURE [systemsetup].[USP_GISMAPLAYERXREF_GETBYPARENTID]
(
	@PARENTID CHAR(36)
)
AS
BEGIN
SET NOCOUNT ON;
SELECT 
	[dbo].[GISMAPLAYERXREF].[MAPLAYERSXREFID],
	[dbo].[GISMAPLAYERXREF].[GISMAPLAYERID],
	[dbo].[GISMAPLAYERXREF].[SUSERGUID],
	[dbo].[GISMAPLAYERXREF].[SORTORDER],
	[dbo].[GISMAPLAYERXREF].[DEFAULTACTIVE]
FROM [dbo].[GISMAPLAYERXREF]
WHERE
	[dbo].[GISMAPLAYERXREF].[SUSERGUID] = @PARENTID  
ORDER BY 
	[dbo].[GISMAPLAYERXREF].[SORTORDER] ASC
END