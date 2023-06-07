﻿CREATE PROCEDURE [globalsetup].[USP_WFACTIONGROUP_GETALL]
AS
BEGIN
SET NOCOUNT ON;
SELECT 
	[dbo].[WFACTIONGROUP].[WFACTIONGROUPID],
	[dbo].[WFACTIONGROUP].[NAME],
	[dbo].[WFACTIONGROUP].[DESCRIPTION],
	[dbo].[WFACTIONGROUP].[WFENTITYID],
	[dbo].[WFENTITY].[NAME] AS WFENTITYNAME,
	[dbo].[WFACTIONGROUP].[WFSTEPTYPEID],
	[dbo].[WFSTEPTYPE].[NAME] AS WFSTEPTYPENAME,
	[dbo].[WFACTIONGROUP].[ROWVERSION],
	[dbo].[WFACTIONGROUP].[LASTCHANGEDON],
	[dbo].[WFACTIONGROUP].[LASTCHANGEDBY]
FROM [dbo].[WFACTIONGROUP]
JOIN [dbo].[WFENTITY] ON [dbo].[WFACTIONGROUP].[WFENTITYID] = [WFENTITY].[WFENTITYID]
JOIN [dbo].[WFSTEPTYPE] ON [dbo].[WFACTIONGROUP].[WFSTEPTYPEID] = [dbo].[WFSTEPTYPE].[WFSTEPTYPEID]
ORDER BY [dbo].[WFACTIONGROUP].[NAME] ASC

EXEC [globalsetup].[USP_WFACTIONGROUPACTIONXREF_GETALL]
END