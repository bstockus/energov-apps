﻿


CREATE PROCEDURE [dbo].[RPT_PM_PERMIT_BONDS_NOTES]
@BONDID AS VARCHAR(36)
AS
SELECT BONDNOTE.TEXT, BONDNOTE.CREATEDATE, USERS.FNAME, USERS.LNAME, BONDNOTE.BONDNOTEID
FROM BONDNOTE 
INNER JOIN USERS ON BONDNOTE.CREATEDBY = USERS.SUSERGUID
WHERE BONDNOTE.BONDID = @BONDID


