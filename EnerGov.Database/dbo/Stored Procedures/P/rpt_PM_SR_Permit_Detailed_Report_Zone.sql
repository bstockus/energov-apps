﻿

/****** Object:  StoredProcedure [dbo].[rpt_PM_SR_Permit_Detailed_Report_ZONE]    Script Date: 02/25/2011 15:58:53 ******/
CREATE PROCEDURE [dbo].[rpt_PM_SR_Permit_Detailed_Report_Zone]
@PMPERMITID AS VARCHAR(36)
AS

SELECT PMPERMITZONE.MAIN, ZONE.ZONECODE, ZONE.NAME, PMPERMITZONE.ZONEID

FROM PMPERMITZONE 
INNER JOIN ZONE ON PMPERMITZONE.ZONEID = ZONE.ZONEID
WHERE PMPERMITZONE.PMPERMITID = @PMPERMITID

