﻿CREATE PROCEDURE [globalsetup].[USP_TIMETRACKINGTYPE_GETALL]
AS
BEGIN
SET NOCOUNT ON;
SELECT 
	[dbo].[TIMETRACKINGTYPE].[TIMETRACKINGTYPEID],
	[dbo].[TIMETRACKINGTYPE].[NAME],
	[dbo].[TIMETRACKINGTYPE].[DESCRIPTION],
	[dbo].[TIMETRACKINGTYPE].[BILLABLE],
	[dbo].[TIMETRACKINGTYPE].[MODULEID],
	[dbo].[TIMETRACKINGTYPE].[ACTIVE],
	[dbo].[TIMETRACKINGTYPE].[LASTCHANGEDBY],
	[dbo].[TIMETRACKINGTYPE].[LASTCHANGEDON],
	[dbo].[TIMETRACKINGTYPE].[ROWVERSION]
FROM [dbo].[TIMETRACKINGTYPE]
 ORDER BY [dbo].[TIMETRACKINGTYPE].[NAME] ASC
END