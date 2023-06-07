﻿

CREATE PROCEDURE [dbo].[rpt_PL_SR_Plan_Bonds_Listing_Notes]
@BONDID AS VARCHAR(36)
AS

SELECT BONDNOTE.TEXT, BONDNOTE.CREATEDATE, USERS.FNAME, USERS.LNAME, BONDNOTE.BONDNOTEID
FROM BONDNOTE 
INNER JOIN USERS ON BONDNOTE.CREATEDBY = USERS.SUSERGUID
WHERE BondNote.BondID = @BONDID


