﻿

CREATE PROCEDURE [dbo].[rpt_PR_SR_Project_Detail_Report_Address]
@PRPROJECTID AS VARCHAR(36)
AS
SELECT	MAILINGADDRESS.ADDRESSLINE1, MAILINGADDRESS.ADDRESSLINE2, MAILINGADDRESS.ADDRESSLINE3, MAILINGADDRESS.CITY, MAILINGADDRESS.STATE, 
        MAILINGADDRESS.POSTALCODE, MAILINGADDRESS.POSTDIRECTION, MAILINGADDRESS.PREDIRECTION, MAILINGADDRESS.STREETTYPE, 
        MAILINGADDRESS.UNITORSUITE, PRPROJECTADDRESS.MAIN, MAILINGADDRESS.MAILINGADDRESSID
FROM    PRPROJECTADDRESS 
INNER JOIN MAILINGADDRESS ON PRPROJECTADDRESS.MAILINGADDRESSID = MAILINGADDRESS.MAILINGADDRESSID
WHERE PRPROJECTADDRESS.PRPROJECTID = @PRPROJECTID
