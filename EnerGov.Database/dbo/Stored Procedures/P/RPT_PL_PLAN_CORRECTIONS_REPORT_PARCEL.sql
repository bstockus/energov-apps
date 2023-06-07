﻿


CREATE PROCEDURE [dbo].[RPT_PL_PLAN_CORRECTIONS_REPORT_PARCEL]
@PLANID AS VARCHAR(36)
AS
SELECT PARCEL.PARCELNUMBER
FROM PLPLANPARCEL 
INNER JOIN PARCEL ON PLPLANPARCEL.PARCELID = PARCEL.PARCELID
WHERE PLPLANPARCEL.PLPLANID = @PLANID 
AND PLPLANPARCEL.MAIN = 'TRUE'


