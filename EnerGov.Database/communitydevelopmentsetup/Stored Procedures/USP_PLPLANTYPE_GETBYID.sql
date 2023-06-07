﻿CREATE PROCEDURE [communitydevelopmentsetup].[USP_PLPLANTYPE_GETBYID]
(
	@PLPLANTYPEID CHAR(36)
)
AS
BEGIN
SET NOCOUNT ON;
SELECT 
	[dbo].[PLPLANTYPE].[PLPLANTYPEID],
	[dbo].[PLPLANTYPE].[PLPLANTYPEGROUPID],
	[dbo].[PLPLANTYPE].[PLANNAME],
	[dbo].[PLPLANTYPE].[PREFIX],
	[dbo].[PLPLANTYPE].[DAYSTOEXPIRE],
	[dbo].[PLPLANTYPE].[ACTIVE],
	[dbo].[PLPLANTYPE].[TABLENAME],
	[dbo].[PLPLANTYPE].[UNLIMITED],
	[dbo].[PLPLANTYPE].[REPORTNAME],
	[dbo].[PLPLANTYPE].[ALLOWINTERNETSUBMISSION],
	[dbo].[PLPLANTYPE].[EXPIRABLE],
	[dbo].[PLPLANTYPE].[ASSIGNEDUSER],
	[dbo].[PLPLANTYPE].[DEFAULTSTATUS],
	[dbo].[PLPLANTYPE].[DEFAULTUSER],
	[dbo].[PLPLANTYPE].[SHOWINLICENSING],
	[dbo].[PLPLANTYPE].[ALLOWCOMPLETEWITHOPENINVOICE],
	[dbo].[PLPLANTYPE].[DAYSTOPLANAPPROVALEXPIRE],
	[dbo].[PLPLANTYPE].[VALUATION],
	[dbo].[PLPLANTYPE].[SQUAREFEET],
	[dbo].[PLPLANTYPE].[USINGCLOCK],
	[dbo].[PLPLANTYPE].[CLOCKLIMITEDDAYS],
	[dbo].[PLPLANTYPE].[DEFAULTINTERNETPLPLANSTATUSID],
	[dbo].[PLPLANTYPE].[USEPREFIXASSUFFIX],
	[dbo].[PLPLANTYPE].[ALLOWOBJECTASSOCIATION],
	[dbo].[PLPLANTYPE].[USECASETYPENUMBERING],	
	[dbo].[PLPLANTYPE].[LASTCHANGEDBY],
	[dbo].[PLPLANTYPE].[LASTCHANGEDON],
	[dbo].[PLPLANTYPE].[ROWVERSION],
	[dbo].[PLPLANTYPE].[PLPLANTYPECSSUPLOADSETTINGTYPEID]
FROM [dbo].[PLPLANTYPE]
WHERE
	[PLPLANTYPEID] = @PLPLANTYPEID  

EXEC [communitydevelopmentsetup].[USP_PLPLANTYPEWORKCLASS_GETBYPARENTID] @PLPLANTYPEID
EXEC [communitydevelopmentsetup].[USP_PLPLANTYPEUNITTYPE_GETBYPARENTID] @PLPLANTYPEID
EXEC [communitydevelopmentsetup].[USP_PLCONTACTTYPEREF_PLPLANTYPE_GETBYPARENTID] @PLPLANTYPEID
EXEC [communitydevelopmentsetup].[USP_ATTACHMENTREQFILEREF_PLPLANTYPE_GETBYPARENTID] @PLPLANTYPEID
EXEC [communitydevelopmentsetup].[USP_PLPLANALLOWEDACTIVITY_GETBYPARENTID] @PLPLANTYPEID

END