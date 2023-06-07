﻿CREATE PROCEDURE [impactcase].[USP_IMPACTCASEADDRESS_GETBYIDS]
(
	@IPCASELIST RecordIDs READONLY
)
AS
BEGIN
	SELECT 
		IPCASEADDRESS.IPCASEID,
		IPCASEADDRESS.IPCASEADDRESSID, 
		MAILINGADDRESS.ADDRESSLINE1,
		MAILINGADDRESS.ADDRESSLINE2,
		MAILINGADDRESS.ADDRESSLINE3,
		MAILINGADDRESS.ADDRESSTYPE,
		MAILINGADDRESS.ATTN,
		MAILINGADDRESS.CITY,
		MAILINGADDRESS.COMPSITE,
		MAILINGADDRESS.COUNTRY,
		MAILINGADDRESSCOUNTRYTYPE.MAILINGADDRESSCOUNTRYTYPEID,
		MAILINGADDRESSCOUNTRYTYPE.MAILINGADDRESSCOUNTRYTYPENAME,
		IPCASEADDRESS.MAIN,
		MAILINGADDRESS.POBOX,
		MAILINGADDRESS.POSTALCODE,
		MAILINGADDRESS.POSTDIRECTION,
		MAILINGADDRESS.PREDIRECTION,
		MAILINGADDRESS.PROVINCE,
		MAILINGADDRESS.RURALROUTE,
		MAILINGADDRESS.STATE,
		MAILINGADDRESS.STATION,
		MAILINGADDRESS.STREETTYPE,
		MAILINGADDRESS.UNITORSUITE,
		MAILINGADDRESS.ADDRESSID
	FROM IPCASEADDRESS 
	INNER JOIN MAILINGADDRESS ON IPCASEADDRESS.MAILINGADDRESSID = MAILINGADDRESS.MAILINGADDRESSID
	INNER JOIN MAILINGADDRESSCOUNTRYTYPE ON MAILINGADDRESS.COUNTRYTYPE = MAILINGADDRESSCOUNTRYTYPE.MAILINGADDRESSCOUNTRYTYPEID
	INNER JOIN @IPCASELIST IPCASELIST ON IPCASEADDRESS.IPCASEID = IPCASELIST.RECORDID
	WHERE IPCASEADDRESS.MAIN = 1
END