﻿CREATE PROCEDURE [dbo].[USP_TASKSTATUS_DELETE]
(
	@TASKSTATUSID INT,
	@ROWVERSION INT
)
AS
DELETE FROM [dbo].[TASKSTATUS]
WHERE
	[TASKSTATUSID] = @TASKSTATUSID AND 
	[ROWVERSION]= @ROWVERSION