﻿CREATE PROCEDURE [incidentrequest].[USP_CONTACT_PERMITRENEWAL_LINKEDRECORDS_GETBYPARENTID]
(
	@PARENTID CHAR(36)
)
AS
BEGIN
SET NOCOUNT ON;
SELECT 
	[PMRENEWALCASE].[NUMBER] PERMITRENEWALNUMBER,
	[PMRENEWALCASETYPE].[NAME] PERMITRENEWALTYPE,
	[PMRENEWALCASE].[ACTIVE]
FROM [PMRENEWALCASE]
INNER JOIN [PMRENEWALCASETYPE] WITH (NOLOCK)
ON [PMRENEWALCASETYPE].[PMRENEWALCASETYPEID] = [PMRENEWALCASE].[PMRENEWALCASETYPEID]
WHERE
	[PMRENEWALCASE].[BILLINGCONTACTID] = @PARENTID
END