﻿CREATE PROCEDURE [dbo].[USP_TASK_GET_COUNT_OF_NOT_COMPLETED_OF_USER]
  @UserId CHAR(36)
AS
BEGIN
  SELECT COUNT(TASKUSERID)
    FROM [TASK]
    JOIN [TASKUSER] ON [TASK].[TASKID] = [TASKUSER].[TASKID]
    JOIN [TASKSTATUS] ON [TASK].[TASKSTATUSID] = [TASKSTATUS].[TASKSTATUSID]
   WHERE [TASKSTATUS].[ISCOMPLETED] = 0
     AND [TASKUSER].[USERID] = @UserId
END