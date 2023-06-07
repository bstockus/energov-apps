﻿CREATE PROCEDURE [codemanagementsetup].[USP_CMCASETYPE_GETBYID]
(
	@CMCASETYPEID CHAR(36)
)
AS
BEGIN
SET NOCOUNT ON;
SELECT 
	[dbo].[CMCASETYPE].[CMCASETYPEID],
	[dbo].[CMCASETYPE].[NAME],
	[dbo].[CMCASETYPE].[CUSTOMFIELDID],
	[dbo].[CMCASETYPE].[WFTEMPLATEID],
	[dbo].[CMCASETYPE].[CAFEETEMPLATEID],
	[dbo].[CMCASETYPE].[ACTIVE],
	[dbo].[CMCASETYPE].[DEFAULTUSER],
	[dbo].[CMCASETYPE].[DEFAULTSTATUS],
	[dbo].[CMCASETYPE].[DESCRIPTION],
	[dbo].[CMCASETYPE].[PREFIX],
	[dbo].[CMCASETYPE].[USECASETYPENUMBERING],
	[dbo].[CMCASETYPE].[ONLINECUSTOMFIELDLAYOUTID],
	[dbo].[CMCASETYPE].[LASTCHANGEDBY],
	[dbo].[CMCASETYPE].[LASTCHANGEDON],
	[dbo].[CMCASETYPE].[ROWVERSION]
FROM [dbo].[CMCASETYPE]
WHERE
	[dbo].[CMCASETYPE].[CMCASETYPEID] = @CMCASETYPEID  

EXEC [codemanagementsetup].[USP_CMCODEALLOWEDACTIVITY_GETBYPARENTID] @CMCASETYPEID  
EXEC [codemanagementsetup].[USP_CMCODECASECONTACTTYPEREF_GETBYPARENTID] @CMCASETYPEID
END