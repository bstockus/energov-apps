﻿


CREATE PROCEDURE [dbo].[RPT_PL_PLAN_CORRECTIONS_REPORT_ADDRESS]
@PLANID AS VARCHAR(36)
AS
SELECT MAILINGADDRESS.ADDRESSLINE1, MAILINGADDRESS.ADDRESSLINE2, MAILINGADDRESS.ADDRESSLINE3, MAILINGADDRESS.CITY, MAILINGADDRESS.STATE, MAILINGADDRESS.POSTALCODE, 
       MAILINGADDRESS.POSTDIRECTION, MAILINGADDRESS.PREDIRECTION, MAILINGADDRESS.STREETTYPE, MAILINGADDRESS.UNITORSUITE
FROM PLPLANADDRESS 
INNER JOIN MAILINGADDRESS ON PLPLANADDRESS.MAILINGADDRESSID = MAILINGADDRESS.MAILINGADDRESSID
WHERE PLPLANADDRESS.PLPLANID = @PLANID 
AND PLPLANADDRESS.MAIN = 'TRUE'

