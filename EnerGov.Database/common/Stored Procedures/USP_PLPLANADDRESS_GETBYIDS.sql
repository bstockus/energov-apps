﻿CREATE PROCEDURE [common].[USP_PLPLANADDRESS_GETBYIDS]
(
	@PLPLANLIST RecordIDs READONLY
)
AS
BEGIN
	SELECT 
		[PLPLANADDRESS].[PLPLANID],
		[PLPLANADDRESS].[PLPLANADDRESSID],
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
		[PLPLANADDRESS].[MAIN],
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
	FROM [dbo].[PLPLANADDRESS] 
	INNER JOIN [dbo].[MAILINGADDRESS] ON [PLPLANADDRESS].[MAILINGADDRESSID] = [MAILINGADDRESS].[MAILINGADDRESSID]
	INNER JOIN [dbo].[MAILINGADDRESSCOUNTRYTYPE] ON [MAILINGADDRESS].[COUNTRYTYPE] = [MAILINGADDRESSCOUNTRYTYPE].[MAILINGADDRESSCOUNTRYTYPEID]
	INNER JOIN @PLPLANLIST [PLPLANLIST] ON [PLPLANADDRESS].[PLPLANID] = [PLPLANLIST].[RECORDID]
	WHERE [PLPLANADDRESS].[MAIN] = 1
END