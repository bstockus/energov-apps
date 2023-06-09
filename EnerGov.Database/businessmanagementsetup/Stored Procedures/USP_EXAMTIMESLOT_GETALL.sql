﻿CREATE PROCEDURE [businessmanagementsetup].[USP_EXAMTIMESLOT_GETALL]
AS
SET NOCOUNT ON;
SELECT 
	[dbo].[EXAMTIMESLOT].[EXAMTIMESLOTID],
	[dbo].[EXAMTIMESLOT].[NAME],
	[dbo].[EXAMTIMESLOT].[STARTTIME],
	[dbo].[EXAMTIMESLOT].[ENDTIME],
	[dbo].[EXAMTIMESLOT].[LASTCHANGEDBY],
	[dbo].[EXAMTIMESLOT].[LASTCHANGEDON],
	[dbo].[EXAMTIMESLOT].[ROWVERSION]
FROM [dbo].[EXAMTIMESLOT]
ORDER BY [dbo].[EXAMTIMESLOT].[NAME] ASC