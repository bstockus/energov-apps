﻿CREATE PROCEDURE [maps].[USP_PERMITPARCEL_ADDRESSES]
(
	@PARCELS RecordIDs READONLY,
	@CASEID AS CHAR(36)
)
AS 
BEGIN
SELECT 
		PMPERMITADDRESS.PMPERMITID,
		PMPERMITADDRESS.PMPERMITADDRESSID, 
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
		PMPERMITADDRESS.MAIN,
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
		MAILINGADDRESS.ADDRESSID,
		MAILINGADDRESS.PARCELID,
		MAILINGADDRESS.PARCELNUMBER,
		MAILINGADDRESS.COUNTY
	FROM MAILINGADDRESS
	INNER JOIN @PARCELS PARCELS ON MAILINGADDRESS.PARCELID = PARCELS.RECORDID
	INNER JOIN PMPERMITADDRESS ON PMPERMITADDRESS.MAILINGADDRESSID = MAILINGADDRESS.MAILINGADDRESSID AND PMPERMITADDRESS.PMPERMITID = @CASEID
	INNER JOIN MAILINGADDRESSCOUNTRYTYPE ON MAILINGADDRESS.COUNTRYTYPE = MAILINGADDRESSCOUNTRYTYPE.MAILINGADDRESSCOUNTRYTYPEID
END