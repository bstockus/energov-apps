﻿CREATE PROCEDURE [dbo].[USP_HEARINGSTATUS_DELETE]
(
	@HEARINGSTATUSID CHAR(36),
	@ROWVERSION INT
)
AS
DELETE FROM [dbo].[HEARINGSTATUS]
WHERE
	[HEARINGSTATUSID] = @HEARINGSTATUSID AND 
	[ROWVERSION]= @ROWVERSION