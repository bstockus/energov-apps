﻿CREATE PROCEDURE [systemsetup].[USP_JOBSCHEDULE_SELECT_LOOKUP]
AS
BEGIN
	SET NOCOUNT ON;
	SELECT 
	[dbo].[JOBSCHEDULE].[JOBSCHEDULEID],
	[dbo].[JOBSCHEDULE].[NAME]
	FROM [dbo].[JOBSCHEDULE]
	ORDER BY [dbo].[JOBSCHEDULE].[NAME]
END