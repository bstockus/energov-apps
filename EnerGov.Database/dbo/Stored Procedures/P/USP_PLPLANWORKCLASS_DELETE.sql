﻿CREATE PROCEDURE [dbo].[USP_PLPLANWORKCLASS_DELETE]
(
	@PLPLANWORKCLASSID CHAR(36),
	@ROWVERSION INT
)
AS
DELETE FROM [dbo].[PLPLANWORKCLASS]
WHERE
	[PLPLANWORKCLASSID] = @PLPLANWORKCLASSID AND 
	[ROWVERSION]= @ROWVERSION