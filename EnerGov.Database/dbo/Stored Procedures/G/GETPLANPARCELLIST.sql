﻿
CREATE PROCEDURE [dbo].[GETPLANPARCELLIST]
-- Add the parameters for the stored procedure here
@PlanID char(36)	
AS
BEGIN
SELECT DISTINCT
      PLPLANPARCEL.PARCELID
      ,PLPLANID
      ,MAIN
	  ,PARCELNUMBER
  FROM PLPLANPARCEL INNER JOIN PARCEL ON PARCEL.PARCELID = PLPLANPARCEL.PARCELID WHERE PLPLANID = @PlanID
END
