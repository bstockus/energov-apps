﻿CREATE PROCEDURE [dbo].[USP_TASKPRIORITY_SELECT_LOOKUP]	
AS
	SET NOCOUNT ON;
SELECT 
	[dbo].[TASKPRIORITY].[TASKPRIORITYID],
	[dbo].[TASKPRIORITY].[TASKPRIORITYNAME]
FROM [dbo].[TASKPRIORITY]
ORDER BY [dbo].[TASKPRIORITY].[TASKPRIORITYNAME]