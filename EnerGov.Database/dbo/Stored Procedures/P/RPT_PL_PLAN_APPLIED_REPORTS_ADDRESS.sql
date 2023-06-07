﻿


CREATE PROCEDURE [dbo].[RPT_PL_PLAN_APPLIED_REPORTS_ADDRESS]
@PLANID AS VARCHAR(36)
AS
SELECT MAILINGADDRESS.ADDRESSLINE1, MAILINGADDRESS.ADDRESSLINE2, MAILINGADDRESS.ADDRESSLINE3, MAILINGADDRESS.CITY, MAILINGADDRESS.STATE, 
       MAILINGADDRESS.POSTALCODE, MAILINGADDRESS.POSTDIRECTION, MAILINGADDRESS.PREDIRECTION, MAILINGADDRESS.UNITORSUITE, 
       MAILINGADDRESS.STREETTYPE
FROM MAILINGADDRESS 
INNER JOIN PLPLANADDRESS ON MAILINGADDRESS.MAILINGADDRESSID = PLPLANADDRESS.MAILINGADDRESSID
WHERE (PLPLANADDRESS.PLPLANID = @PLANID) 
AND (PLPLANADDRESS.MAIN = 'TRUE')


