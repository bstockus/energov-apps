﻿CREATE PROCEDURE [globalsetup].[USP_SERVICETASK_GETALL]
AS
BEGIN
SET NOCOUNT ON;
SELECT 
	[dbo].[SERVICETASK].[SERVICETASKID],
	[dbo].[SERVICETASK].[NAME],
	[dbo].[SERVICETASK].[DESCRIPTION],
	[dbo].[SERVICETASK].[ISMONITORINGSUPPORTED],
	[dbo].[SERVICETASK].[ISDETAILEDMONITORINGSUPPORTED],
	[dbo].[SERVICETASK].[ISQUEUEDISPLAYSUPPORTED],
	[dbo].[SERVICETASK].[ISMONITORINGENABLED],
	[dbo].[SERVICETASK].[ISDETAILEDMONITORINGENABLED],
	[dbo].[SERVICETASK].[LASTCHANGEDBY],
	[dbo].[SERVICETASK].[LASTCHANGEDON],
	[dbo].[SERVICETASK].[ROWVERSION]
FROM [dbo].[SERVICETASK] ORDER BY [dbo].[SERVICETASK].[NAME] ASC

EXEC [globalsetup].[USP_SERVICETASKSERVICE_GETALL]

END