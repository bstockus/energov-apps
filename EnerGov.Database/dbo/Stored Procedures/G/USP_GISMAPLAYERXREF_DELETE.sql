﻿CREATE PROCEDURE [dbo].[USP_GISMAPLAYERXREF_DELETE]
(
	@MAPLAYERSXREFID CHAR(36)
)
AS
DELETE FROM [dbo].[GISMAPLAYERXREF]
WHERE
	[MAPLAYERSXREFID] = @MAPLAYERSXREFID