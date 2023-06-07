﻿CREATE PROCEDURE [energovnotifications].[USP_MYCALENDARTASKLIST_GETBYCRITERIA]
(
	@USERID CHAR(36),
	@STARTDATE DATETIME,
	@ENDDATE DATETIME
)
AS
BEGIN
SET NOCOUNT ON;
SELECT DISTINCT
	[dbo].[TASK].[TASKID],
	[dbo].[TASK].[SUBJECT],
	[dbo].[TASK].[TASKTYPEID],
	[dbo].[TASK].[STARTDATE],
	[dbo].[TASK].[DUEDATE],
	[dbo].[TASK].[SHOWONCALENDAR],
	[dbo].[TASK].[ROWVERSION],
	[dbo].[TASK].[TASKPRIORITYID]
	FROM [dbo].[TASK]
	JOIN [dbo].[TASKUSER] on [dbo].[TASK].[TASKID] = [dbo].[TASKUSER].[TASKID]
	WHERE
	[dbo].[TASK].[TASKSTATUSID] <> 2  AND  [dbo].[TASK].[SHOWONCALENDAR] = 1
	AND ([dbo].[TASKUSER].[USERID] = @USERID OR [dbo].[TASK].[CREATEDBYID] = @USERID)
	AND (([dbo].[TASK].[DUEDATE] >= @STARTDATE OR [dbo].[TASK].[DUEDATE] IS NULL) AND [dbo].[TASK].[STARTDATE] < @ENDDATE)
	ORDER BY [dbo].[Task].[SUBJECT]	
END