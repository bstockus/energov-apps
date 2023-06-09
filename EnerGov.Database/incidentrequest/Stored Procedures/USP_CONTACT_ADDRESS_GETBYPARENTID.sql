﻿CREATE PROCEDURE [incidentrequest].[USP_CONTACT_ADDRESS_GETBYPARENTID]
(
	@PARENTID CHAR(36)
)
AS
BEGIN
SET NOCOUNT ON;
SELECT 
	[MAILINGADDRESS].[ADDRESSTYPE],
	[MAILINGADDRESSCOUNTRYTYPE].[MAILINGADDRESSCOUNTRYTYPENAME] COUNTRYTYPE,
	[MAILINGADDRESS].[ADDRESSLINE1] HOMENUMBER,
	[MAILINGADDRESS].[ADDRESSLINE2],
	[MAILINGADDRESS].[STREETTYPE],
	[MAILINGADDRESS].[POSTDIRECTION],
	[MAILINGADDRESS].[UNITORSUITE],
	[MAILINGADDRESS].[POBOX],
	[MAILINGADDRESS].[CITY],
	[MAILINGADDRESS].[STATE],
	[MAILINGADDRESS].[POSTALCODE],
	[MAILINGADDRESS].[COUNTY],
	[MAILINGADDRESS].[PARCELNUMBER],
	[MAILINGADDRESS].[ADDRESSLINE3],
	[GLOBALENTITYMAILINGADDRESS].[MAIN]	
FROM [MAILINGADDRESS] WITH (NOLOCK)
INNER JOIN [GLOBALENTITYMAILINGADDRESS]
ON [MAILINGADDRESS].[MAILINGADDRESSID] = [GLOBALENTITYMAILINGADDRESS].[MAILINGADDRESSID]
INNER JOIN [MAILINGADDRESSCOUNTRYTYPE]
ON [MAILINGADDRESSCOUNTRYTYPE].MAILINGADDRESSCOUNTRYTYPEID = [MAILINGADDRESS].COUNTRYTYPE
WHERE
	[GLOBALENTITYMAILINGADDRESS].[GLOBALENTITYID] = @PARENTID
END