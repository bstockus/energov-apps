﻿CREATE PROCEDURE [incidentrequest].[USP_CONTACT_IPCASE_LINKEDRECORDS_GETBYPARENTID]
(
	@PARENTID CHAR(36)
)
AS
BEGIN
SET NOCOUNT ON;
SELECT 
	[IPCASE].[CASENUMBER],
	[IPCASETYPE].[NAME] CASETYPE,
	[IPCASESTATUS].[NAME] [STATUS],
	[IPCASESTATUS].[ACTIVE] ACTIVEFLAG,
	[IPCASESTATUS].[APPROVAL] APPROVALFLAG,
	[IPCASESTATUS].[CANCELLED] CANCELLEDFLAG
FROM [IPCASE]
INNER JOIN [IPCASECONTACT]
ON [IPCASECONTACT].[IPCASEID] = [IPCASE].[IPCASEID]
INNER JOIN [IPCASETYPE] WITH (NOLOCK)
ON [IPCASETYPE].[IPCASETYPEID] = [IPCASE].[IPCASETYPEID]
INNER JOIN [IPCASESTATUS] WITH (NOLOCK)
ON [IPCASESTATUS].[IPCASESTATUSID] = [IPCASE].[IPCASESTATUSID]
WHERE
	[IPCASECONTACT].[GLOBALENTITYID] = @PARENTID
END