﻿CREATE PROCEDURE [communitydevelopmentsetup].[USP_IPCONDITIONSYSTEMSTATUS_SELECT_LOOKUP]
AS
	SET NOCOUNT ON;
	SELECT 
		[dbo].[IPCONDITIONSYSTEMSTATUS].[IPCONDITIONSYSTEMSTATUSID],
		[dbo].[IPCONDITIONSYSTEMSTATUS].[NAME]
	FROM [dbo].[IPCONDITIONSYSTEMSTATUS]
	ORDER BY [dbo].[IPCONDITIONSYSTEMSTATUS].[NAME] ASC