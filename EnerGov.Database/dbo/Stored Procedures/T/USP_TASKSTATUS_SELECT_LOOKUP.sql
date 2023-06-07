﻿CREATE PROCEDURE [dbo].[USP_TASKSTATUS_SELECT_LOOKUP]	
AS
	SET NOCOUNT ON;
SELECT 
	[dbo].[TASKSTATUS].[TASKSTATUSID],
	[dbo].[TASKSTATUS].[TASKSTATUSNAME],
	[dbo].[TASKSTATUS].[ISCOMPLETED]
FROM [dbo].[TASKSTATUS]
ORDER BY [dbo].[TASKSTATUS].[TASKSTATUSNAME]