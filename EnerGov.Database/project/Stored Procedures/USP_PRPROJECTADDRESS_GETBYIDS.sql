﻿CREATE PROCEDURE [project].[USP_PRPROJECTADDRESS_GETBYIDS]
(
	@PRPROJECTLIST RecordIDs READONLY
)
AS
BEGIN
	SELECT	PRPROJECTADDRESS.PRPROJECTID,
			PRPROJECTADDRESS.PRPROJECTADDRESSID,			
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
			PRPROJECTADDRESS.MAIN,
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
	FROM	PRPROJECTADDRESS
			JOIN MAILINGADDRESS ON PRPROJECTADDRESS.MAILINGADDRESSID = MAILINGADDRESS.MAILINGADDRESSID
			JOIN MAILINGADDRESSCOUNTRYTYPE ON MAILINGADDRESS.COUNTRYTYPE = MAILINGADDRESSCOUNTRYTYPE.MAILINGADDRESSCOUNTRYTYPEID
			JOIN @PRPROJECTLIST PRPROJECTLIST ON PRPROJECTADDRESS.PRPROJECTID = PRPROJECTLIST.RECORDID
	WHERE	PRPROJECTADDRESS.MAIN = 1
END