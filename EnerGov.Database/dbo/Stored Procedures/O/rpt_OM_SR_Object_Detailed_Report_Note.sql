﻿

CREATE PROCEDURE rpt_OM_SR_Object_Detailed_Report_Note
@OMOBJECTID AS VARCHAR(36)
AS

SELECT	OMOBJECTNOTE.OMOBJECTNOTEID, OMOBJECTNOTE.TEXT, OMOBJECTNOTE.CREATEDBY, 
		OMOBJECTNOTE.CREATEDDATE, USERS.FNAME, USERS.LNAME
		
FROM	OMOBJECTNOTE 
		INNER JOIN USERS ON OMOBJECTNOTE.CREATEDBY = USERS.SUSERGUID
WHERE	OMOBJECTNOTE.OMOBJECTID = @OMOBJECTID

