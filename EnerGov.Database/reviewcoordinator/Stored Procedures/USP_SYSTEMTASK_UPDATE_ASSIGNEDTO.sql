﻿CREATE PROCEDURE [reviewcoordinator].[USP_SYSTEMTASK_UPDATE_ASSIGNEDTO]
@ASSIGNEDTO CHAR(36),
@USERID CHAR(36),
@CURRENTDATETIME DATETIME,
@TASKIDS RecordIds READONLY AS
   
SET NOCOUNT ON;
BEGIN

	DECLARE @UPDATED_USER_FULLNAME VARCHAR(500), @CASEID VARCHAR(36), @TASKID VARCHAR(36), @TASKTYPEID INT, @HISTORYID INT;

	SET @UPDATED_USER_FULLNAME = (SELECT CASE WHEN USERS.FNAME IS NULL THEN '' ELSE USERS.FNAME END + ' ' + CASE WHEN USERS.LNAME IS NULL THEN '' ELSE USERS.LNAME END FROM USERS WHERE SUSERGUID = @ASSIGNEDTO);


	SELECT		SYSTEMTASKID, 
				PMPERMITID,
				PLPLANID,
				ASSIGNEDTO
	INTO		#tmpTasks
	FROM	(
	select		SYSTEMTASKID, 
				PMPERMITID,
				PLPLAN.PLPLANID,
				SYSTEMTASK.ASSIGNEDTO
	FROM		@TASKIDS
	JOIN		SYSTEMTASK ON SYSTEMTASK.SYSTEMTASKID = RECORDID
	LEFT JOIN	PMPERMIT ON SYSTEMTASK.UNIQUERECORDID = PMPERMIT.PMPERMITID
	LEFT JOIN	PLPLAN ON SYSTEMTASK.UNIQUERECORDID = PLPLAN.PLPLANID
	WHERE		SYSTEMTASKTYPEID = 1

	UNION ALL

	SELECT		SYSTEMTASKID, 
				PMPERMITID,
				PLPLANID,
				ASSIGNEDTO
	FROM		@TASKIDS
	JOIN		SYSTEMTASK ON SYSTEMTASK.SYSTEMTASKID = RECORDID
	JOIN		PLSUBMITTAL ON PLSUBMITTAL.PLSUBMITTALID = SYSTEMTASK.UNIQUERECORDID
	WHERE		SYSTEMTASKTYPEID != 1
	) AS tblTemp
	
	BEGIN TRANSACTION [TranUpdateTask]

		  BEGIN TRY

		  IF EXISTS (SELECT 1 FROM PMPERMIT JOIN #tmpTasks ON PMPERMIT.PMPERMITID = #tmpTasks.PMPERMITID)
		  BEGIN
			UPDATE		PMPERMIT
			SET			ROWVERSION = ROWVERSION + 1,
						LASTCHANGEDBY = @USERID,
						LASTCHANGEDON = @CURRENTDATETIME
			FROM		PMPERMIT 
			JOIN		#tmpTasks ON PMPERMIT.PMPERMITID = #tmpTasks.PMPERMITID;

			INSERT INTO	HISTORYPERMITMANAGEMENT (ID, ROWVERSION, CHANGEDON, CHANGEDBY, FIELDNAME, OLDVALUE, NEWVALUE, ADDITIONALINFO)
			SELECT PMPERMIT.PMPERMITID , PMPERMIT.ROWVERSION, @CURRENTDATETIME, @USERID, 'System Task Assigned To', CASE WHEN USERS.FNAME IS NULL THEN '' ELSE USERS.FNAME END + ' ' + CASE WHEN USERS.LNAME IS NULL THEN '' ELSE USERS.LNAME END, @UPDATED_USER_FULLNAME, 'System Task Assigned To updated through Bulk Update' 
			FROM #tmpTasks
			JOIN SYSTEMTASK ON SYSTEMTASK.SYSTEMTASKID = #tmpTasks.SYSTEMTASKID
			JOIN PMPERMIT ON PMPERMIT.PMPERMITID = #tmpTasks.PMPERMITID
			JOIN USERS ON SYSTEMTASK.ASSIGNEDTO = USERS.SUSERGUID	
		END
		IF EXISTS (SELECT 1 FROM PLPLAN JOIN #tmpTasks ON PLPLAN.PLPLANID = #tmpTasks.PLPLANID) 
		BEGIN
			UPDATE PLPLAN
			SET		ROWVERSION = ROWVERSION + 1,
			LASTCHANGEDBY = @USERID,
			LASTCHANGEDON = @CURRENTDATETIME
			FROM PLPLAN 
			JOIN		#tmpTasks ON PLPLAN.PLPLANID = #tmpTasks.PLPLANID;

			INSERT INTO	HISTORYPLANMANAGEMENT (ID, ROWVERSION, CHANGEDON, CHANGEDBY, FIELDNAME, OLDVALUE, NEWVALUE, ADDITIONALINFO)
			SELECT PLPLAN.PLPLANID , PLPLAN.ROWVERSION, @CURRENTDATETIME, @USERID, 'System Task Assigned To', CASE WHEN USERS.FNAME IS NULL THEN '' ELSE USERS.FNAME END + ' ' + CASE WHEN USERS.LNAME IS NULL THEN '' ELSE USERS.LNAME END, @UPDATED_USER_FULLNAME, 'System Task Assigned To updated through Bulk Update' 
			FROM #tmpTasks
			JOIN SYSTEMTASK ON SYSTEMTASK.SYSTEMTASKID = #tmpTasks.SYSTEMTASKID
			JOIN PLPLAN ON PLPLAN.PLPLANID = #tmpTasks.PLPLANID
			JOIN USERS ON SYSTEMTASK.ASSIGNEDTO = USERS.SUSERGUID
		END	

				
	UPDATE	SYSTEMTASK
	SET		ASSIGNEDTO = @ASSIGNEDTO
	FROM #tmpTasks
	JOIN SYSTEMTASK ON SYSTEMTASK.SYSTEMTASKID = #tmpTasks.SYSTEMTASKID

	COMMIT TRANSACTION [TranUpdateTask]

	END TRY

	BEGIN CATCH

		SELECT
			ERROR_NUMBER() AS ErrorNumber
			,ERROR_SEVERITY() AS ErrorSeverity
			,ERROR_STATE() AS ErrorState
			,ERROR_PROCEDURE() AS ErrorProcedure
			,ERROR_LINE() AS ErrorLine
			,ERROR_MESSAGE() AS ErrorMessage;
		ROLLBACK TRANSACTION [TranUpdateTask]

	END CATCH  

	DROP TABLE #tmpTasks;

END