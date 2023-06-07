﻿CREATE PROCEDURE [dbo].[USP_TASK_DELETE]
(
	@TASKID CHAR(36),
	@ROWVERSION INT
)
AS
SET NOCOUNT ON;
EXEC [dbo].[USP_TASKUSER_DELETE_BY_TASKID] @TASKID
SET NOCOUNT OFF;

DELETE FROM [dbo].[TASK]
WHERE
	[TASKID] = @TASKID AND 
	[ROWVERSION]= @ROWVERSION