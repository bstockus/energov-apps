﻿



CREATE PROCEDURE [dbo].[rpt_CM_Code_Cases_Assigned_To_By_Closed_Date_Address]
@CODECASEID AS VARCHAR(36)
AS
SELECT MAILINGADDRESS.ADDRESSLINE1 AS AddressLine1, MAILINGADDRESS.ADDRESSLINE2 AS AddressLine2, MAILINGADDRESS.ADDRESSLINE3 AS AddressLine3, 
       MAILINGADDRESS.CITY AS City, MAILINGADDRESS.STATE AS State, MAILINGADDRESS.POSTALCODE AS PostalCode, 
       MAILINGADDRESS.POSTDIRECTION AS PostDirection, MAILINGADDRESS.PREDIRECTION AS PreDirection, MAILINGADDRESS.STREETTYPE AS StreetType, 
       MAILINGADDRESS.UNITORSUITE AS UnitOrSuite
FROM CMCODECASEADDRESS 
INNER JOIN MAILINGADDRESS ON CMCODECASEADDRESS.MAILINGADDRESSID = MAILINGADDRESS.MAILINGADDRESSID
WHERE CMCODECASEADDRESS.CMCODECASEID = @CODECASEID 
AND CMCODECASEADDRESS.MAIN = 'TRUE'


