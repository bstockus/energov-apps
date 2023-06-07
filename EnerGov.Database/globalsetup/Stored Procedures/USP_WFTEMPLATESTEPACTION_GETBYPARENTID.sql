﻿CREATE PROCEDURE [globalsetup].[USP_WFTEMPLATESTEPACTION_GETBYPARENTID]
(
	@PARENTID CHAR(36)
)
AS
BEGIN
SET NOCOUNT ON;
SELECT 
	[dbo].[WFTEMPLATESTEPACTION].[WFTEMPLATESTEPACTIONID],
	[dbo].[WFTEMPLATESTEPACTION].[WFTEMPLATESTEPID],
	[dbo].[WFTEMPLATESTEPACTION].[WFACTIONID],
	[dbo].[WFTEMPLATESTEPACTION].[PRIORITYORDER],
	[dbo].[WFTEMPLATESTEPACTION].[SORTORDER],
	[dbo].[WFTEMPLATESTEPACTION].[AUTOFILL],
	[dbo].[WFTEMPLATESTEPACTION].[NOPRIORITY],
	[dbo].[WFTEMPLATESTEPACTION].[AUTORECEIVE],
	[dbo].[WFTEMPLATESTEPACTION].[ISCAPOPTIONALINSPECTION],
	[dbo].[WFTEMPLATESTEPACTION].[INSPECTIONSET],
	[dbo].[WFACTION].[NAME] [WFACTIONNAME],
	[dbo].[WFACTION].[DESCRIPTION],
	[dbo].[WFACTIONTYPE].[NAME] [WFACTIONTYPENAME],
	[dbo].[WFACTIONTYPE].[WFACTIONTYPEID]
FROM [WFTEMPLATESTEPACTION]
INNER JOIN 
	[dbo].[WFTEMPLATESTEP] ON [dbo].[WFTEMPLATESTEPACTION].[WFTEMPLATESTEPID] = [dbo].[WFTEMPLATESTEP].[WFTEMPLATESTEPID]
INNER JOIN 
	[dbo].[WFACTION] ON [dbo].[WFACTION].[WFACTIONID] = [dbo].[WFTEMPLATESTEPACTION].[WFACTIONID]
INNER JOIN 
	[dbo].[WFACTIONTYPE] ON [dbo].[WFACTIONTYPE].[WFACTIONTYPEID] = [dbo].[WFACTION].[WFACTIONTYPEID]
WHERE
	[dbo].[WFTEMPLATESTEP].[WFTEMPLATEID] = @PARENTID
ORDER BY [dbo].[WFTEMPLATESTEPACTION].[PRIORITYORDER], [dbo].[WFTEMPLATESTEPACTION].[SORTORDER], [dbo].[WFACTION].NAME
END