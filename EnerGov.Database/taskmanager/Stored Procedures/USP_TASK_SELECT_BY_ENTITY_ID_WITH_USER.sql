﻿CREATE PROCEDURE [taskmanager].[USP_TASK_SELECT_BY_ENTITY_ID_WITH_USER]
(
	@ENTITY_ID CHAR(36)
)
AS
SET NOCOUNT ON;

SELECT 
	[dbo].[TASK].[TASKID],
	[dbo].[TASK].[SUBJECT],
	[dbo].[TASK].[TASKTEXT],
	[dbo].[TASK].[DUEDATE],
	[dbo].[TASKSTATUS].[TASKSTATUSNAME],
	COALESCE(USERDATA.FNAME, '') AS FNAME,
	COALESCE(USERDATA.LNAME, '') AS LNAME
FROM [dbo].[TASK]
INNER JOIN [dbo].[TASKSTATUS] WITH (NOLOCK) ON [dbo].[TASKSTATUS].[TASKSTATUSID] = [dbo].[TASK].[TASKSTATUSID]
OUTER APPLY
(
	SELECT TOP 1
		[dbo].[USERS].[FNAME] AS FNAME,
		[dbo].[USERS].[LNAME] AS LNAME
	FROM [dbo].[USERS] WITH (NOLOCK)
	WHERE [dbo].[USERS].[SUSERGUID] IN 
		(SELECT [dbo].[TASKUSER].[USERID] 
			FROM [dbo].[TASKUSER] 
			WHERE [dbo].[TASKUSER].[TASKID] = [dbo].[TASK].[TASKID])
) USERDATA 
WHERE [dbo].[TASK].[UNIQUERECORDID] = @ENTITY_ID AND [dbo].[TASKSTATUS].[ISCOMPLETED] <> 1
ORDER BY CASE WHEN [dbo].[TASK].[DUEDATE] IS NOT NULL THEN 0 ELSE 1 END, [dbo].[TASK].[DUEDATE], [dbo].[TASK].[SUBJECT]