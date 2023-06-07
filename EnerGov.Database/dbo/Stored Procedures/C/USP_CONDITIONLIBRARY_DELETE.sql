﻿CREATE PROCEDURE [dbo].[USP_CONDITIONLIBRARY_DELETE]
(
	@CONDITIONLIBRARYID CHAR(36),
	@ROWVERSION INT
)
AS
DELETE FROM [dbo].[CONDITIONLIBRARY]
WHERE
	[CONDITIONLIBRARYID] = @CONDITIONLIBRARYID AND 
	[ROWVERSION]= @ROWVERSION