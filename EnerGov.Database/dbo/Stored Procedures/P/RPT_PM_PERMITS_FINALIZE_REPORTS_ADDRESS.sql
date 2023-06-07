﻿



CREATE PROCEDURE [dbo].[RPT_PM_PERMITS_FINALIZE_REPORTS_ADDRESS]
@PERMITID AS VARCHAR(36)
AS
SELECT MAILINGADDRESS.ADDRESSLINE1, MAILINGADDRESS.ADDRESSLINE2, MAILINGADDRESS.ADDRESSLINE3, MAILINGADDRESS.CITY, MAILINGADDRESS.STATE, MAILINGADDRESS.POSTALCODE, 
       MAILINGADDRESS.POSTDIRECTION, MAILINGADDRESS.PREDIRECTION, MAILINGADDRESS.STREETTYPE, MAILINGADDRESS.UNITORSUITE
FROM PMPERMITADDRESS 
INNER JOIN MAILINGADDRESS ON PMPERMITADDRESS.MAILINGADDRESSID = MAILINGADDRESS.MAILINGADDRESSID
WHERE PMPERMITADDRESS.MAIN = 'TRUE' AND PMPERMITADDRESS.PMPERMITID = @PERMITID


