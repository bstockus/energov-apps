﻿
CREATE PROCEDURE [dbo].[rpt_CM_SR_Code_Case_Detailed_Report_Zone]
@CMCODECASEID AS VARCHAR(36)
AS
SELECT CMCODECASEZONE.MAIN, ZONE.ZONECODE, ZONE.NAME, CMCODECASEZONE.ZONEID
FROM CMCODECASEZONE
INNER JOIN ZONE ON CMCODECASEZONE.ZONEID = ZONE.ZONEID
WHERE CMCODECASEZONE.CMCODECASEID = @CMCODECASEID

