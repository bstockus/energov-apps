﻿CREATE PROCEDURE GETMOBILEPROJECTADDRESSLIST
@ProjectID char(36)
AS
BEGIN
SELECT	DISTINCT PRPROJECTADDRESS.PRPROJECTADDRESSID,
				PRPROJECTADDRESS.MAIN,
				MAILINGADDRESS.ADDRESSLINE1,	
				MAILINGADDRESS.ADDRESSLINE2,	
				MAILINGADDRESS.ADDRESSLINE3,	
				MAILINGADDRESS.POSTDIRECTION,	
				MAILINGADDRESS.PREDIRECTION,	
				MAILINGADDRESS.STREETTYPE,	
				MAILINGADDRESS.PARCELNUMBER,
				MAILINGADDRESS.ADDRESSTYPE,
				MAILINGADDRESS.UNITORSUITE,
				MAILINGADDRESS.CITY,
				MAILINGADDRESS.STATE,
				MAILINGADDRESS.COUNTRY,
				MAILINGADDRESS.POSTALCODE,
				MAILINGADDRESS.PARCELID,
				MAILINGADDRESS.PROVINCE,
				MAILINGADDRESS.RURALROUTE,
				MAILINGADDRESS.STATION,
				MAILINGADDRESS.COMPSITE,
				MAILINGADDRESS.POBOX,
				MAILINGADDRESS.ATTN,
				MAILINGADDRESS.GENERALDELIVERY,
				MAILINGADDRESS.COUNTRYTYPE
		FROM	PRPROJECTADDRESS
		INNER JOIN MAILINGADDRESS ON MAILINGADDRESS.MAILINGADDRESSID = PRPROJECTADDRESS.MAILINGADDRESSID	
		WHERE PRPROJECTADDRESS.PRPROJECTID = @ProjectID	ORDER BY MAILINGADDRESS.ADDRESSLINE1
END
