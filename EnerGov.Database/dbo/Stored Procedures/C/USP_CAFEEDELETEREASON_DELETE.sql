﻿CREATE PROCEDURE [dbo].[USP_CAFEEDELETEREASON_DELETE]
(
	@CAFEEDELETEREASONID CHAR(36),
	@ROWVERSION INT
)
AS
DELETE FROM [dbo].[CAFEEDELETEREASON]
WHERE
	[CAFEEDELETEREASONID] = @CAFEEDELETEREASONID AND 
	[ROWVERSION]= @ROWVERSION