﻿CREATE PROCEDURE [systemsetup].[USP_USERS_GETBYID]
(
	@SUSERGUID CHAR(36)
)
AS
BEGIN
SET NOCOUNT ON;
SELECT 
	[dbo].[USERS].[SUSERGUID],
	[dbo].[USERS].[SROLEID],
	[dbo].[USERS].[SITEID],
	[dbo].[USERS].[ID],
	[dbo].[USERS].[FNAME],
	[dbo].[USERS].[LNAME],
	[dbo].[USERS].[PASSWORD],
	[dbo].[USERS].[PHONE],
	[dbo].[USERS].[EMAIL],
	[dbo].[USERS].[BACTIVE],
	[dbo].[USERS].[BGETINTERNETNOTES],
	[dbo].[USERS].[BGETBUSINESSNOTES],
	[dbo].[USERS].[BGETCODENEITES],
	[dbo].[USERS].[LASTCHANGEDON],
	[dbo].[USERS].[LASTCHANGEDBY],
	[dbo].[USERS].[GMAPID],
	[dbo].[USERS].[GLOBALENTITYID],
	[dbo].[USERS].[MAILINGADDRESSID],
	[dbo].[USERS].[ROWVERSION],
	[dbo].[USERS].[ISPASSWORDCHANGEREQUIRED],
	[dbo].[USERS].[APPLICATIONERRORS],
	[dbo].[USERS].[SECURITYISACTIVEDIRECTORY],
	[dbo].[USERS].[COMPANY],
	[dbo].[USERS].[MIDDLENAME],
	[dbo].[USERS].[CREATEDON],
	[dbo].[USERS].[TITLE],
	[dbo].[USERS].[CREDENTIALS],
	[dbo].[USERS].[OFFICEID],
	[dbo].[USERS].[LICENSE_SUITE],
	[dbo].[USERS].[MAINMAPSORTORDER],
	[dbo].[USERS].[GLOBALPREFFERCOMMID]
FROM [dbo].[USERS]
WHERE
	[dbo].[USERS].[SUSERGUID] = @SUSERGUID  

	EXEC [systemsetup].[USP_APPLICATIONALLOWED_GETBYPARENTID] @SUSERGUID
	EXEC [systemsetup].[USP_GISMAPLAYERXREF_GETBYPARENTID] @SUSERGUID
	EXEC [systemsetup].[USP_USERDEPARTMENT_GETBYPARENTID] @SUSERGUID
	EXEC [systemsetup].[USP_IMINSPECTORTYPEUSER_GETBYPARENTID] @SUSERGUID

END