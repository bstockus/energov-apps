﻿CREATE PROCEDURE [managecontacts].[USP_MANAGECONTACTADDRESS_GETBYIDS]
(
	@MANAGECONTACTLIST RecordIDs READONLY
)
AS
BEGIN
	SELECT 
		[GLOBALENTITY].[GLOBALENTITYID],
		[GLOBALENTITY].[PARENTGLOBALENTITYID], 
		[MAILINGADDRESS].[ADDRESSLINE1],
		[MAILINGADDRESS].[ADDRESSLINE2],
		[MAILINGADDRESS].[ADDRESSLINE3],
		[MAILINGADDRESS].[ADDRESSTYPE],
		[MAILINGADDRESS].[ATTN],
		[MAILINGADDRESS].[CITY],
		[MAILINGADDRESS].[COMPSITE],
		[MAILINGADDRESS].[COUNTRY],
		[MAILINGADDRESSCOUNTRYTYPE].[MAILINGADDRESSCOUNTRYTYPEID],
		[MAILINGADDRESSCOUNTRYTYPE].[MAILINGADDRESSCOUNTRYTYPENAME],
		[GLOBALENTITYMAILINGADDRESS].[MAIN],
		[MAILINGADDRESS].[POBOX],
		[MAILINGADDRESS].[POSTALCODE],
		[MAILINGADDRESS].[POSTDIRECTION],
		[MAILINGADDRESS].[PREDIRECTION],
		[MAILINGADDRESS].[PROVINCE],
		[MAILINGADDRESS].[RURALROUTE],
		[MAILINGADDRESS].[STATE],
		[MAILINGADDRESS].[STATION],
		[MAILINGADDRESS].[STREETTYPE],
		[MAILINGADDRESS].[UNITORSUITE],
		[MAILINGADDRESS].[ADDRESSID]
	FROM [dbo].[GLOBALENTITY] 
	INNER JOIN [dbo].[GLOBALENTITYMAILINGADDRESS] ON [GLOBALENTITYMAILINGADDRESS].[GLOBALENTITYID] = [GLOBALENTITY].[GLOBALENTITYID]
	INNER JOIN [dbo].[MAILINGADDRESS] ON [GLOBALENTITYMAILINGADDRESS].[MAILINGADDRESSID] = [MAILINGADDRESS].[MAILINGADDRESSID]
	INNER JOIN [dbo].[MAILINGADDRESSCOUNTRYTYPE] ON [MAILINGADDRESS].[COUNTRYTYPE] = [MAILINGADDRESSCOUNTRYTYPE].[MAILINGADDRESSCOUNTRYTYPEID]
	INNER JOIN @MANAGECONTACTLIST MANAGECONTACTLIST ON [GLOBALENTITY].[GLOBALENTITYID] = [MANAGECONTACTLIST].[RECORDID]
	WHERE [GLOBALENTITYMAILINGADDRESS].[MAIN] = 1
END