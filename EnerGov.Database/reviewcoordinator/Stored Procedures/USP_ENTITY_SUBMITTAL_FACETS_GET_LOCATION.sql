﻿CREATE PROCEDURE [reviewcoordinator].[USP_ENTITY_SUBMITTAL_FACETS_GET_LOCATION]
	@ASSIGNEDUSERIDS AS RECORDIDS READONLY
AS
BEGIN

WITH ADDRESS AS 
(
	SELECT * FROM (
	SELECT
		PMPERMIT.PMPERMITID AS PARENTID,		
		PMPERMITADDRESS.PMPERMITADDRESSID AS ENTITYID, 
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
		MAILINGADDRESS.MAILINGADDRESSID,
		PMPERMIT.ASSIGNEDTO,
		PLSUBMITTAL.COMPLETED,
		PLSUBMITTAL.COMPLETEDATE
	FROM PLSUBMITTAL
	INNER JOIN PMPERMIT ON PMPERMIT.PMPERMITID = PLSUBMITTAL.PMPERMITID
	LEFT OUTER JOIN PMPERMITADDRESS ON PMPERMITADDRESS.PMPERMITID = PMPERMIT.PMPERMITID AND PMPERMITADDRESS.MAIN = 1
	LEFT OUTER JOIN MAILINGADDRESS ON MAILINGADDRESS.MAILINGADDRESSID = PMPERMITADDRESS.MAILINGADDRESSID
	LEFT OUTER JOIN MAILINGADDRESSCOUNTRYTYPE ON MAILINGADDRESSCOUNTRYTYPE.MAILINGADDRESSCOUNTRYTYPEID = MAILINGADDRESS.COUNTRYTYPE
	UNION ALL
	SELECT
		PLPLAN.PLPLANID AS PARENTID,		
		PLPLANADDRESS.PLPLANADDRESSID AS ENTITYID, 
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
		PLPLANADDRESS.MAIN,
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
		MAILINGADDRESS.MAILINGADDRESSID,
		PLPLAN.ASSIGNEDTO,
		PLSUBMITTAL.COMPLETED,
		PLSUBMITTAL.COMPLETEDATE
	FROM PLSUBMITTAL
	INNER JOIN PLPLAN ON PLPLAN.PLPLANID = PLSUBMITTAL.PLPLANID
	LEFT OUTER JOIN PLPLANADDRESS ON PLPLANADDRESS.PLPLANID = PLPLAN.PLPLANID AND PLPLANADDRESS.MAIN = 1
	LEFT OUTER JOIN MAILINGADDRESS ON MAILINGADDRESS.MAILINGADDRESSID = PLPLANADDRESS.MAILINGADDRESSID
	LEFT OUTER JOIN MAILINGADDRESSCOUNTRYTYPE ON MAILINGADDRESSCOUNTRYTYPE.MAILINGADDRESSCOUNTRYTYPEID = MAILINGADDRESS.COUNTRYTYPE
	) AS QUERYDATA
	WHERE (ASSIGNEDTO IN (SELECT RECORDID FROM @ASSIGNEDUSERIDS) AND COMPLETED = 0 AND COMPLETEDATE IS NULL)
) SELECT * FROM ADDRESS

END