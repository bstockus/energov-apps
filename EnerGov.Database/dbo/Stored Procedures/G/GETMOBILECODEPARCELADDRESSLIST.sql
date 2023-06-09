﻿CREATE PROCEDURE GETMOBILECODEPARCELADDRESSLIST
@ParcelID char(36)
AS
BEGIN
SELECT [ADDRESSID]
      ,[ADDRESSLINE1]
      ,[ADDRESSLINE2]
      ,[ADDRESSLINE3]
      ,[CITY]
      ,[STATE]
      ,[POSTALCODE]
      ,[TAXNO]
      ,[STREETTYPE]
      ,[POSTDIRECTION]
      ,[ZONEID]
      ,[DIRECTIONTOPROP]
      ,[PREDIRECTION]
      ,[PARCELID]
      ,[COUNTY]
      ,[COUNTRY]
      ,[COUNTRYTYPE]
      ,[ADDRESSTYPE]
      ,[GISY]
      ,[GISX]
      ,[GISADDRESSID]
      ,[UNITORSUITE]
      ,[PARCELNUMBER]
  FROM [PARCELADDRESS] WHERE PARCELID = @ParcelID
END
