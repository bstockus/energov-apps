﻿CREATE PROCEDURE [manageobjects].[USP_OMOBJECTADDRESS_GETBYIDS]
(
	@OMOBJECTLIST RecordIDs READONLY
)
AS
BEGIN
SELECT 
		OMOBJECTADDRESS.OMOBJECTID,
		OMOBJECTADDRESS.OMOBJECTADDRESSID, 
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
		OMOBJECTADDRESS.MAIN,
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
	FROM OMOBJECTADDRESS 
	INNER JOIN MAILINGADDRESS ON OMOBJECTADDRESS.MAILINGADDRESSID = MAILINGADDRESS.MAILINGADDRESSID
	INNER JOIN MAILINGADDRESSCOUNTRYTYPE ON MAILINGADDRESS.COUNTRYTYPE = MAILINGADDRESSCOUNTRYTYPE.MAILINGADDRESSCOUNTRYTYPEID
	INNER JOIN @OMOBJECTLIST OMOBJECTLIST ON OMOBJECTADDRESS.OMOBJECTID = OMOBJECTLIST.RECORDID
	WHERE OMOBJECTADDRESS.MAIN = 1
END