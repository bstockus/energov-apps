﻿CREATE PROCEDURE [reviewcoordinator].[USP_ERENTITYSESSIONTRANSACTIONTASK_GETBYPLSUBMITTALID]
	@PLSUBMITTALID AS CHAR(36)
AS
BEGIN
SET NOCOUNT ON;

declare @processTypeCloseSession int = 2;

SELECT 
	ERSESSIONTRANSACTIONTASK.ERSESSIONTRANSACTIONTASKID,
	ERSESSIONTRANSACTIONTASK.ERSESSIONTRANSACTIONID,
	ERSESSIONTRANSACTIONTASK.FILEID,
	ERPROJECTFILEVERSION.SAVEFILENAME FILENAME,
	ERSESSIONTRANSACTIONTASK.JOBTYPE,
	ERSESSIONTRANSACTIONTASK.ACTIONTYPE,
	ERSESSIONTRANSACTIONTASK.STATUS,
	ERSESSIONTRANSACTIONTASK.JOBID,
	ERSESSIONTRANSACTIONTASK.REQUESTEDDATE,
	ERSESSIONTRANSACTIONTASK.FINISHEDDATE,
	ERSESSIONTRANSACTION.ERENTITYPROJECTID,
	ERSESSIONTRANSACTION.ERENTITYSESSIONID
FROM ERSESSIONTRANSACTIONTASK 
INNER JOIN ERSESSIONTRANSACTION ON ERSESSIONTRANSACTION.ERSESSIONTRANSACTIONID = ERSESSIONTRANSACTIONTASK.ERSESSIONTRANSACTIONID
LEFT OUTER JOIN ERENTITYPROJECTSESSIONFILE ON ERENTITYPROJECTSESSIONFILE.ERENTITYPROJECTID = ERSESSIONTRANSACTION.ERENTITYPROJECTID AND
	ERENTITYPROJECTSESSIONFILE.ERENTITYSESSIONID = ERSESSIONTRANSACTION.ERENTITYSESSIONID AND
	ERENTITYPROJECTSESSIONFILE.ERENTITYPROJECTFILEID = ERSESSIONTRANSACTIONTASK.FILEID
LEFT OUTER JOIN ERPROJECTFILEVERSION ON ERPROJECTFILEVERSION.ERPROJECTFILEVERSIONID = ERENTITYPROJECTSESSIONFILE.ERPROJECTFILEVERSIONID
WHERE ERSESSIONTRANSACTION.PLSUBMITTALID = @PLSUBMITTALID AND ERSESSIONTRANSACTION.PROCESSTYPE = @processTypeCloseSession

END