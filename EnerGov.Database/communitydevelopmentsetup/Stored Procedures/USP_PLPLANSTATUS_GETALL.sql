﻿CREATE PROCEDURE [communitydevelopmentsetup].[USP_PLPLANSTATUS_GETALL]
AS
BEGIN
SET NOCOUNT ON;
SELECT 
	[dbo].[PLPLANSTATUS].[PLPLANSTATUSID],
	[dbo].[PLPLANSTATUS].[NAME],
	[dbo].[PLPLANSTATUS].[SUCCESSFLAG],
	[dbo].[PLPLANSTATUS].[HOLDFLAG],
	[dbo].[PLPLANSTATUS].[FAILUREFLAG],
	[dbo].[PLPLANSTATUS].[CANCELLEDFLAG],
	[dbo].[PLPLANSTATUS].[DESCRIPTION],
	[dbo].[PLPLANSTATUS].[DESCRIPTION_SPANISH],
	[dbo].[PLPLANSTATUS].[LASTCHANGEDBY],
	[dbo].[PLPLANSTATUS].[LASTCHANGEDON],
	[dbo].[PLPLANSTATUS].[ROWVERSION]
FROM [dbo].[PLPLANSTATUS] ORDER BY [dbo].[PLPLANSTATUS].[NAME] ASC
END