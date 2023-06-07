﻿CREATE PROCEDURE [systemsetup].[USP_QUERYACTIONTASK_GETBYPARENTID]
(
	@QUERYID CHAR(36)
)
AS
BEGIN
SET NOCOUNT ON;
SELECT 
	[dbo].[QUERYACTIONTASK].[QUERYACTIONTASKID],
	[dbo].[QUERYACTIONTASK].[QUERYACTIONID],
	[dbo].[QUERYACTIONTASK].[TASKSUBJECT],
	[dbo].[QUERYACTIONTASK].[TASKTEXT],
	[dbo].[QUERYACTIONTASK].[STARTDATE],
	[dbo].[QUERYACTIONTASK].[DUEDATE],
	[dbo].[QUERYACTIONTASK].[STARTTIME],
	[dbo].[QUERYACTIONTASK].[DUETIME],
	[dbo].[QUERYACTIONTASK].[STARTDATEOFFSETDAYS],
	[dbo].[QUERYACTIONTASK].[DUEDATEOFFSETDAYS],
	[dbo].[QUERYACTIONTASK].[TASKPRIORITYID],
	[dbo].[QUERYACTIONTASK].[SHOWONCALENDAR],
	[dbo].[QUERYACTIONTASK].[ASSIGNEDTO]
FROM [dbo].[QUERYACTIONTASK]
INNER JOIN [dbo].[QUERYACTION] ON [dbo].[QUERYACTION].[QUERYACTIONID] = [dbo].[QUERYACTIONTASK].[QUERYACTIONID]
WHERE
	[dbo].[QUERYACTION].[QUERYID] = @QUERYID
END