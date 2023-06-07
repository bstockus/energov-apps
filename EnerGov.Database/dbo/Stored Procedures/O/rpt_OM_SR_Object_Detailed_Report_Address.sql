﻿

CREATE PROCEDURE rpt_OM_SR_Object_Detailed_Report_Address
@OMOBJECTID AS VARCHAR(36)
AS

SELECT	MAILINGADDRESS.ADDRESSLINE1, MAILINGADDRESS.ADDRESSLINE2, MAILINGADDRESS.ADDRESSLINE3, MAILINGADDRESS.CITY, MAILINGADDRESS.STATE, MAILINGADDRESS.POSTALCODE, 
		MAILINGADDRESS.POSTDIRECTION, MAILINGADDRESS.PREDIRECTION, MAILINGADDRESS.STREETTYPE, MAILINGADDRESS.PARCELNUMBER, MAILINGADDRESS.UNITORSUITE, OMOBJECTADDRESS.MAILINGADDRESSID, OMOBJECTADDRESS.MAIN

FROM	OMOBJECTADDRESS 
		INNER JOIN MAILINGADDRESS ON OMOBJECTADDRESS.MAILINGADDRESSID = MAILINGADDRESS.MAILINGADDRESSID
WHERE	OMOBJECTADDRESS.OMOBJECTID = @OMOBJECTID

