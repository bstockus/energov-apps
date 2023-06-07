﻿CREATE PROCEDURE GETMOBILECODECASENOTELIST
@CodeCaseId char(36)
AS
BEGIN
SELECT	DISTINCT CMCODECASENOTEID, TEXT, CREATEDBY, CREATEDDATE, FNAME FIRSTNAME, LNAME LASTNAME
		FROM CMCODECASENOTE
		INNER JOIN USERS ON USERS.SUSERGUID = CREATEDBY
		WHERE CMCODECASENOTE.CMCODECASEID = @CodeCaseId	ORDER BY CREATEDDATE
END