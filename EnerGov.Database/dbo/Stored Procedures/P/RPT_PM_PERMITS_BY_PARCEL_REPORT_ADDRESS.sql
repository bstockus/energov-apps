﻿


CREATE PROCEDURE [dbo].[RPT_PM_PERMITS_BY_PARCEL_REPORT_ADDRESS]
@PARCELID AS VARCHAR(36)
AS
SELECT ADDRESSLINE1, ADDRESSLINE2, ADDRESSLINE3, CITY, STATE, POSTALCODE, POSTDIRECTION, PREDIRECTION, ADDRESSTYPE, STREETTYPE, PARCELID, UNITORSUITE
FROM MAILINGADDRESS
WHERE PARCELID = @PARCELID

