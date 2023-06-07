﻿


CREATE PROCEDURE [dbo].[RPT_PM_PERMIT_DETAIL_REPORT_NOTE]
@PERMITID AS VARCHAR(36)
AS
SELECT PMPERMITNOTE.PMPERMITNOTEID, PMPERMITNOTE.TEXT, PMPERMITNOTE.CREATEDBY, PMPERMITNOTE.CREATEDDATE, USERS.FNAME, USERS.LNAME
FROM PMPERMITNOTE 
INNER JOIN USERS ON PMPERMITNOTE.CREATEDBY = USERS.SUSERGUID
WHERE PMPERMITNOTE.PMPERMITID = @PERMITID

