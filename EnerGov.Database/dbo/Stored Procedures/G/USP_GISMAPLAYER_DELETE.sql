﻿CREATE PROCEDURE [dbo].[USP_GISMAPLAYER_DELETE]
(
	@GISMAPLAYERID CHAR(36),
	@ROWVERSION INT
)
AS
DELETE FROM [dbo].[GISMAPLAYER]
WHERE
	[GISMAPLAYERID] = @GISMAPLAYERID AND 
	[ROWVERSION]= @ROWVERSION