﻿


CREATE PROCEDURE [dbo].[RPT_PM_PERMIT_HISTORY_REPORT]
@PERMITID AS VARCHAR(36)
AS
SELECT PMPERMIT.PERMITNUMBER, HISTORYPERMITMANAGEMENT.ROWVERSION, HISTORYPERMITMANAGEMENT.CHANGEDON, 
       HISTORYPERMITMANAGEMENT.FIELDNAME, HISTORYPERMITMANAGEMENT.OLDVALUE, HISTORYPERMITMANAGEMENT.NEWVALUE, HISTORYPERMITMANAGEMENT.ADDITIONALINFO, 
       USERS.FNAME, USERS.LNAME
FROM PMPERMIT 
INNER JOIN HISTORYPERMITMANAGEMENT ON PMPERMIT.PMPERMITID = HISTORYPERMITMANAGEMENT.ID 
INNER JOIN USERS ON HISTORYPERMITMANAGEMENT.CHANGEDBY = USERS.SUSERGUID
WHERE PMPERMIT.PMPERMITID = @PERMITID


