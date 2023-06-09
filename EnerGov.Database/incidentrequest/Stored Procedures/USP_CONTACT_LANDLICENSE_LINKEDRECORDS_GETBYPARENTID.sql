﻿CREATE PROCEDURE [incidentrequest].[USP_CONTACT_LANDLICENSE_LINKEDRECORDS_GETBYPARENTID]
(
	@PARENTID CHAR(36)
)
AS
BEGIN
SET NOCOUNT ON;
SELECT 
	[RPLANDLORDLICENSE].[LANDLORDNUMBER],
	[RPLANDLORDLICENSETYPE].[NAME] LANDLICENSETYPE,
	[RPLANDLORDLICENSESTATUS].[NAME] [STATUS],
	[RPLANDLORDLICENSESYSSTATUS].[NAME] SYSTEMSTATUS
FROM [RPLANDLORDLICENSE]
INNER JOIN [RPLANDLORDLICENSECONTACT]
ON [RPLANDLORDLICENSE].RPLANDLORDLICENSEID = [RPLANDLORDLICENSECONTACT].[RPLANDLORDLICENSEID]
INNER JOIN [RPLANDLORDLICENSETYPE] WITH (NOLOCK)
ON [RPLANDLORDLICENSETYPE].[RPLANDLORDLICENSETYPEID] = [RPLANDLORDLICENSE].[RPLANDLORDLICENSETYPEID]
INNER JOIN [RPLANDLORDLICENSESTATUS] WITH (NOLOCK)
ON [RPLANDLORDLICENSESTATUS].[RPLANDLORDLICENSESTATUSID] = [RPLANDLORDLICENSE].[RPLANDLORDLICENSESTATUSID]
INNER JOIN [RPLANDLORDLICENSESYSSTATUS] WITH (NOLOCK)
ON [RPLANDLORDLICENSESTATUS].[RPLANDLORDLICENSESYSSTATUSID] = [RPLANDLORDLICENSESYSSTATUS].[RPLANDLORDLICENSESYSSTATUSID]
WHERE
	[RPLANDLORDLICENSECONTACT].[GLOBALENTITYID] = @PARENTID
END