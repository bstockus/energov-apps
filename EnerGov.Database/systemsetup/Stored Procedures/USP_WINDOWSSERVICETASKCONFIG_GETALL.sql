﻿CREATE PROCEDURE [systemsetup].[USP_WINDOWSSERVICETASKCONFIG_GETALL]
AS
BEGIN
	SET NOCOUNT ON;

	SELECT		[dbo].[WINDOWSSERVICETASKCONFIG].[WINDOWSSERVICETASKCONFIGID],
				[dbo].[WINDOWSSERVICETASKCONFIG].[SERVICETASK],
				[dbo].[WINDOWSSERVICETASKCONFIG].[SERVICEID],
				[dbo].[WINDOWSSERVICETASKCONFIG].[CONCURRENCYLIMIT],
				[dbo].[WINDOWSSERVICETASKCONFIG].[ISENABLED],
				[dbo].[WINDOWSSERVICETASK].[NAME]
	FROM	[dbo].[WINDOWSSERVICETASKCONFIG]
	JOIN	[dbo].[WINDOWSSERVICETASK] ON [dbo].[WINDOWSSERVICETASK].[WINDOWSSERVICETASKID] = [dbo].[WINDOWSSERVICETASKCONFIG].[SERVICETASK]
	ORDER BY	[dbo].[WINDOWSSERVICETASKCONFIG].[SERVICETASK]
END