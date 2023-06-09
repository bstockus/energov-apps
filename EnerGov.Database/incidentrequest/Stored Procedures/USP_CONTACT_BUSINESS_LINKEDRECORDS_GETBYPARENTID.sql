﻿CREATE PROCEDURE [incidentrequest].[USP_CONTACT_BUSINESS_LINKEDRECORDS_GETBYPARENTID]
(
	@PARENTID CHAR(36)
)
AS
BEGIN
SET NOCOUNT ON;
SELECT 
	[BLGLOBALENTITYEXTENSION].[REGISTRATIONID] BUSINESSNUMBER,
	[BLGLOBALENTITYEXTENSION].[COMPANYNAME],
	[BLGLOBALENTITYEXTENSION].[DBA],
	[BLEXTCOMPANYTYPE].[NAME] COMPANYTYPE,
	[BLEXTSTATUS].[NAME] [STATUS],
	[BLEXTSTATUSSYSTEM].[NAME] SYSTEMSTATUS,
	[BLGLOBALENTITYEXTENSION].[OPENDATE],
	[BLGLOBALENTITYEXTENSION].[CLOSEDATE]
FROM [BLGLOBALENTITYEXTENSION]
INNER JOIN [BLGLOBALENTITYEXTENSIONCONTACT]
ON [BLGLOBALENTITYEXTENSION].[BLGLOBALENTITYEXTENSIONID] = [BLGLOBALENTITYEXTENSIONCONTACT].[BLGLOBALENTITYEXTENSIONID]
INNER JOIN [BLEXTCOMPANYTYPE] WITH (NOLOCK)
ON [BLEXTCOMPANYTYPE].[BLEXTCOMPANYTYPEID] = [BLGLOBALENTITYEXTENSION].[BLEXTCOMPANYTYPEID]
INNER JOIN [BLEXTSTATUS] WITH (NOLOCK)
ON [BLEXTSTATUS].[BLEXTSTATUSID] = [BLGLOBALENTITYEXTENSION].[BLEXTSTATUSID]
INNER JOIN [BLEXTSTATUSSYSTEM]
ON [BLEXTSTATUS].[BLEXTSTATUSSYSTEMID] = [BLEXTSTATUSSYSTEM].[BLEXTSTATUSSYSTEMID]
WHERE
	[BLGLOBALENTITYEXTENSIONCONTACT].[GLOBALENTITYID] = @PARENTID
END