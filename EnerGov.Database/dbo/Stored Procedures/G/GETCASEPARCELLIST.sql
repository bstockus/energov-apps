﻿CREATE PROCEDURE [dbo].[GETCASEPARCELLIST]
-- Add the parameters for the stored procedure here
@CaseID char(36),
@ModuleID int
AS
BEGIN
IF @ModuleID = 1
BEGIN
	SELECT DISTINCT
		  PLPLANPARCEL.PARCELID,
		  PLPLANID AS CASEID,
		  MAIN,
		  PARCELNUMBER,
		  1 AS MODULEID
	FROM PLPLANPARCEL INNER JOIN PARCEL ON PARCEL.PARCELID = PLPLANPARCEL.PARCELID WHERE PLPLANID = @CaseID
END
ELSE IF @ModuleID = 2
BEGIN
	SELECT DISTINCT
		  PMPERMITPARCEL.PARCELID,
		  PMPERMITID AS CASEID,
		  MAIN,
		  PARCELNUMBER,
		  2 AS MODULEID
	FROM PMPERMITPARCEL INNER JOIN PARCEL ON PARCEL.PARCELID = PMPERMITPARCEL.PARCELID WHERE PMPERMITID = @CaseID
END
END