﻿CREATE PROCEDURE [globalsetup].[USP_WFTEMPLATESTEP_GETBYPARENTID]
(
	@PARENTID CHAR(36)
)
AS
BEGIN
SET NOCOUNT ON;
SELECT 
	[dbo].[WFTEMPLATESTEP].[WFTEMPLATESTEPID],
	[dbo].[WFTEMPLATESTEP].[WFTEMPLATEID],
	[dbo].[WFTEMPLATESTEP].[WFSTEPID],
	[dbo].[WFTEMPLATESTEP].[PRIORITYORDER],
	[dbo].[WFTEMPLATESTEP].[SORTORDER],
	[dbo].[WFTEMPLATESTEP].[AUTOFILL],
	[dbo].[WFTEMPLATESTEP].[NOPRIORITY],
	[dbo].[WFSTEP].[NAME] [WFSTEPNAME],
	[dbo].[WFSTEP].[DESCRIPTION],
	[dbo].[WFSTEPTYPE].[NAME] [WFSTEPTYPENAME],
	[dbo].[WFSTEPTYPE].[WFSTEPTYPEID]
FROM [dbo].[WFTEMPLATESTEP]
INNER JOIN 
	[dbo].[WFSTEP] on [dbo].[WFSTEP].[WFSTEPID] = [dbo].[WFTEMPLATESTEP].[WFSTEPID]
INNER JOIN 
	[dbo].[WFSTEPTYPE] ON [dbo].[WFSTEPTYPE].[WFSTEPTYPEID] = [dbo].[WFSTEP].[WFSTEPTYPEID]
WHERE
	[dbo].[WFTEMPLATESTEP].[WFTEMPLATEID] = @PARENTID
END