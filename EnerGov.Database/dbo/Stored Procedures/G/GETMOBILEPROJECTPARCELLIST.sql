﻿CREATE PROCEDURE GETMOBILEPROJECTPARCELLIST
@ProjectId char(36)
AS
BEGIN
SELECT PRPROJECTPARCEL.PRPROJECTID, PRPROJECTPARCEL.PRPROJECTPARCELID, PRPROJECTPARCEL.PARCELID, PRPROJECTPARCEL.MAIN,PARCEL.PARCELNUMBER FROM PRPROJECTPARCEL,PARCEL WHERE PRPROJECTID = @ProjectId AND PARCEL.PARCELID = PRPROJECTPARCEL.PARCELID ORDER BY PARCEL.PARCELNUMBER
END
