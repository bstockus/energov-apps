﻿


CREATE PROCEDURE [dbo].[RPT_PM_PERMIT_DETAIL_REPORT_HOLD]
@PERMITID AS VARCHAR(36)
AS
SELECT PMPERMITHOLD.PMPERMITHOLDID, PMPERMITHOLD.COMMENTS, PMPERMITHOLD.CREATEDDATE, PMPERMITHOLD.ACTIVE, USERS.FNAME, USERS.LNAME, 
       HOLDTYPESETUPS.NAME AS HOLDTYPE
FROM PMPERMITHOLD 
INNER JOIN HOLDTYPESETUPS ON PMPERMITHOLD.HOLDSETUPID = HOLDTYPESETUPS.HOLDSETUPID 
INNER JOIN USERS ON PMPERMITHOLD.SUSERGUID = USERS.SUSERGUID
WHERE PMPERMITHOLD.PMPERMITID = @PERMITID


