﻿

CREATE PROCEDURE rpt_OM_SR_Object_Detailed_Report_Parcel
@OMOBJECTID AS VARCHAR(36)
AS

SELECT	PARCEL.PARCELNUMBER, OMOBJECTPARCEL.MAIN, OMOBJECTPARCEL.PARCELID

FROM	OMOBJECTPARCEL 
		INNER JOIN PARCEL ON OMOBJECTPARCEL.PARCELID = PARCEL.PARCELID
WHERE	OMOBJECTPARCEL.OMOBJECTID = @OMOBJECTID

