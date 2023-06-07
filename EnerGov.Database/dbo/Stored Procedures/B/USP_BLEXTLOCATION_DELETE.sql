﻿CREATE PROCEDURE [dbo].[USP_BLEXTLOCATION_DELETE]
(
	@BLEXTLOCATIONID CHAR(36),
	@ROWVERSION INT
)
AS
DELETE FROM [dbo].[BLEXTLOCATION]
WHERE
	[BLEXTLOCATIONID] = @BLEXTLOCATIONID AND 
	[ROWVERSION]= @ROWVERSION