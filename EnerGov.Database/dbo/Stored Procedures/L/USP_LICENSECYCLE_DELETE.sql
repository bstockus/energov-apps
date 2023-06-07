﻿CREATE PROCEDURE [dbo].[USP_LICENSECYCLE_DELETE]
(
	@LICENSECYCLEID CHAR(36),
	@ROWVERSION INT
)
AS
DELETE FROM [dbo].[LICENSECYCLE]
WHERE
	[LICENSECYCLEID] = @LICENSECYCLEID AND 
	[ROWVERSION]= @ROWVERSION