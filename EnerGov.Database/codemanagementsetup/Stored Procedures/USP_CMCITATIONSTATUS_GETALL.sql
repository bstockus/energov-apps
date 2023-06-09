﻿CREATE PROCEDURE [codemanagementsetup].[USP_CMCITATIONSTATUS_GETALL]
AS
BEGIN
SELECT 
	[dbo].[CMCITATIONSTATUS].[CMCITATIONSTATUSID],
	[dbo].[CMCITATIONSTATUS].[NAME],
	[dbo].[CMCITATIONSTATUS].[DESCRIPTION],
	[dbo].[CMCITATIONSTATUS].[ISSUEDFLAG],
	[dbo].[CMCITATIONSTATUS].[CLOSEDFLAG],
	[dbo].[CMCITATIONSTATUS].[LASTCHANGEDBY],
	[dbo].[CMCITATIONSTATUS].[LASTCHANGEDON],
	[dbo].[CMCITATIONSTATUS].[ROWVERSION]
FROM [dbo].[CMCITATIONSTATUS] ORDER BY [dbo].[CMCITATIONSTATUS].[NAME] ASC
END