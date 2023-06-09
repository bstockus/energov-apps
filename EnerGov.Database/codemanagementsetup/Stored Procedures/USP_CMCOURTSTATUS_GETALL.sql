﻿CREATE PROCEDURE [codemanagementsetup].[USP_CMCOURTSTATUS_GETALL]
AS
BEGIN
SELECT 
	[dbo].[CMCOURTSTATUS].[CMCOURTSTATUSID],
	[dbo].[CMCOURTSTATUS].[NAME],
	[dbo].[CMCOURTSTATUS].[DESCRIPTION],
	[dbo].[CMCOURTSTATUS].[ISCLOSED],
	[dbo].[CMCOURTSTATUS].[LASTCHANGEDBY],
	[dbo].[CMCOURTSTATUS].[LASTCHANGEDON],
	[dbo].[CMCOURTSTATUS].[ROWVERSION]
FROM [dbo].[CMCOURTSTATUS] ORDER BY [dbo].[CMCOURTSTATUS].[NAME] ASC
END