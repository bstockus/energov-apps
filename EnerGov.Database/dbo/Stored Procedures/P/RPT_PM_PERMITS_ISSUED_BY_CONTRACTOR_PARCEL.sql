﻿

CREATE PROCEDURE [dbo].[RPT_PM_PERMITS_ISSUED_BY_CONTRACTOR_PARCEL]
@PERMITID AS VARCHAR(36)
AS
SELECT PARCEL.PARCELNUMBER AS PARCELNUMBER
FROM PARCEL 
INNER JOIN PMPERMITPARCEL ON PARCEL.PARCELID = PMPERMITPARCEL.PARCELID
WHERE PMPERMITPARCEL.PMPERMITID = @PERMITID
