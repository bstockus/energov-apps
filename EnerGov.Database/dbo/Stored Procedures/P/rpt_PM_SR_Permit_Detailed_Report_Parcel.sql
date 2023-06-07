﻿

/****** Object:  StoredProcedure [dbo].[rpt_PM_SR_Permit_Detailed_Report_PARCEL]    Script Date: 02/25/2011 15:58:53 ******/
CREATE PROCEDURE [dbo].[rpt_PM_SR_Permit_Detailed_Report_Parcel]
@PMPERMITID AS VARCHAR(36)
AS

SELECT PARCEL.PARCELNUMBER, PMPERMITPARCEL.MAIN, PMPERMITPARCEL.PARCELID

FROM PMPERMITPARCEL 
INNER JOIN PARCEL ON PMPERMITPARCEL.PARCELID = PARCEL.PARCELID
WHERE PMPERMITPARCEL.PMPERMITID = @PMPERMITID
