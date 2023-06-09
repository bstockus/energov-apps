﻿CREATE PROCEDURE [businessmanagementsetup].[USP_TXREMITTANCETYPE_GETBYID]
(
	@TXREMITTANCETYPEID CHAR(36)
)
AS
BEGIN
SET NOCOUNT ON;
SELECT 
	[dbo].[TXREMITTANCETYPE].[TXREMITTANCETYPEID],
	[dbo].[TXREMITTANCETYPE].[NAME],
	[dbo].[TXREMITTANCETYPE].[DESCRIPTION],
	[dbo].[TXREMITTANCETYPE].[ACTIVE],
	[dbo].[TXREMITTANCETYPE].[DEFAULTSTATUSID],
	[dbo].[TXREMITTANCETYPE].[PREFIX],
	[dbo].[TXREMITTANCETYPE].[MULTIPLIERRATE],
	[dbo].[TXREMITTANCETYPE].[CAFEETEMPLATEID],
	[dbo].[TXREMITTANCETYPE].[CUSTOMFIELDLAYOUTID],
	[dbo].[TXREMITTANCETYPE].[ONLINECUSTOMFIELDLAYOUTID],
	[dbo].[TXREMITTANCETYPE].[INTERNETFLAG],
	[dbo].[TXREMITTANCETYPE].[INTERNETAPPLYTYPE],
	[dbo].[TXREMITTANCETYPE].[DEFAULTGENERATEDATE],
	[dbo].[TXREMITTANCETYPE].[FRIENDLYNAME],
	[dbo].[TXREMITTANCETYPE].[ENABLEEXEMPTIONS],
	[dbo].[TXREMITTANCETYPE].[LASTCHANGEDBY],
	[dbo].[TXREMITTANCETYPE].[LASTCHANGEDON],
	[dbo].[TXREMITTANCETYPE].[ROWVERSION]
FROM [dbo].[TXREMITTANCETYPE]
WHERE
	[TXREMITTANCETYPEID] = @TXREMITTANCETYPEID  

	EXEC [businessmanagementsetup].[USP_TXRMTTYPERPTPERIOD_GETBYPARENTID] @TXREMITTANCETYPEID
	EXEC [businessmanagementsetup].[USP_TXRMTCONTACTTYPEREF_GETBYPARENTID] @TXREMITTANCETYPEID
	EXEC [businessmanagementsetup].[USP_TXREMALLOWEDACTIVITY_GETBYPARENTID] @TXREMITTANCETYPEID

END