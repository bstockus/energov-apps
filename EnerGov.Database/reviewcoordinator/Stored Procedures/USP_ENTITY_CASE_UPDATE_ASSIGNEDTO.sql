﻿CREATE PROCEDURE [reviewcoordinator].[USP_ENTITY_CASE_UPDATE_ASSIGNEDTO]
@ASSIGNEDTO CHAR(36),
@USERID CHAR(36),
@CURRENTDATETIME DATETIME,
@PERMITIDS RecordIds READONLY,
@PLANIDS RecordIds READONLY AS
   
SET NOCOUNT ON;
BEGIN

DECLARE @UPDATED_USER_FULLNAME VARCHAR(500), @CASEID VARCHAR(36), @HISTORYID INT;

SET @UPDATED_USER_FULLNAME = (SELECT CASE WHEN USERS.FNAME IS NULL THEN '' ELSE USERS.FNAME END + ' ' + CASE WHEN USERS.LNAME IS NULL THEN '' ELSE USERS.LNAME END FROM USERS WHERE SUSERGUID = @ASSIGNEDTO);
BEGIN
	  BEGIN TRANSACTION [TranUpdateCase]

	  BEGIN TRY

	  --Update Permit assigned to
	  INSERT INTO HISTORYPERMITMANAGEMENT (ID, ROWVERSION, CHANGEDON, CHANGEDBY, FIELDNAME, OLDVALUE, NEWVALUE, ADDITIONALINFO)
		SELECT PMPERMIT.PMPERMITID, PMPERMIT.ROWVERSION + 1, @CURRENTDATETIME, @USERID, 'Permit Assigned To', CASE WHEN USERS.FNAME IS NULL THEN '' ELSE USERS.FNAME END + ' ' + CASE WHEN USERS.LNAME IS NULL THEN '' ELSE USERS.LNAME END, @UPDATED_USER_FULLNAME, 'Permit Assigned To updated through Bulk Update'
				FROM @PERMITIDS PERMITIDS 
				INNER JOIN PMPERMIT ON PERMITIDS.RECORDID = PMPERMIT.PMPERMITID
				INNER JOIN USERS ON PMPERMIT.ASSIGNEDTO = USERS.SUSERGUID
	  UPDATE PMPERMIT SET ASSIGNEDTO = @ASSIGNEDTO, ROWVERSION = ROWVERSION + 1, LASTCHANGEDBY = @USERID, LASTCHANGEDON = @CURRENTDATETIME WHERE PMPERMITID IN (SELECT RECORDID FROM @PERMITIDS)

	  -- Write History for Permit's new files tasks
	  INSERT INTO HISTORYPERMITMANAGEMENT (ID, ROWVERSION, CHANGEDON, CHANGEDBY, FIELDNAME, OLDVALUE, NEWVALUE, ADDITIONALINFO)
		SELECT PMPERMIT.PMPERMITID, PMPERMIT.ROWVERSION, @CURRENTDATETIME, @USERID, 'System Task Assigned To',  CASE WHEN USERS.FNAME IS NULL THEN '' ELSE USERS.FNAME END + ' ' + CASE WHEN USERS.LNAME IS NULL THEN '' ELSE USERS.LNAME END, @UPDATED_USER_FULLNAME, 'System Task Assigned To updated'
				FROM @PERMITIDS PERMITIDS 
				INNER JOIN PMPERMIT ON PERMITIDS.RECORDID = PMPERMIT.PMPERMITID
				INNER JOIN SYSTEMTASK ON SYSTEMTASK.UNIQUERECORDID = PMPERMIT.PMPERMITID
				INNER JOIN USERS ON SYSTEMTASK.ASSIGNEDTO = USERS.SUSERGUID
				WHERE SYSTEMTASK.ASSIGNEDTO IS NOT NULL AND SYSTEMTASK.COMPLETEDDATE IS NULL

	-- Write History for Permit's  failed and approved submittal tasks
	  INSERT INTO HISTORYPERMITMANAGEMENT (ID, ROWVERSION, CHANGEDON, CHANGEDBY, FIELDNAME, OLDVALUE, NEWVALUE, ADDITIONALINFO)
		SELECT PMPERMIT.PMPERMITID, PMPERMIT.ROWVERSION, @CURRENTDATETIME, @USERID, 'System Task Assigned To',  CASE WHEN USERS.FNAME IS NULL THEN '' ELSE USERS.FNAME END + ' ' + CASE WHEN USERS.LNAME IS NULL THEN '' ELSE USERS.LNAME END, @UPDATED_USER_FULLNAME, 'System Task Assigned To updated'
				FROM @PERMITIDS PERMITIDS 
				INNER JOIN PMPERMIT ON PERMITIDS.RECORDID = PMPERMIT.PMPERMITID
				INNER JOIN PLSUBMITTAL ON PLSUBMITTAL.PMPERMITID = PMPERMIT.PMPERMITID
				INNER JOIN SYSTEMTASK ON SYSTEMTASK.UNIQUERECORDID = PLSUBMITTAL.PLSUBMITTALID
				INNER JOIN SYSTEMTASKTYPESUBMITTALTYPE ON SYSTEMTASKTYPESUBMITTALTYPE.PLSUBMITTALTYPEID = PLSUBMITTAL.PLSUBMITTALTYPEID AND SYSTEMTASK.SYSTEMTASKTYPEID = SYSTEMTASKTYPESUBMITTALTYPE.SYSTEMTASKTYPEID
				INNER JOIN USERS ON SYSTEMTASK.ASSIGNEDTO = USERS.SUSERGUID
				WHERE SYSTEMTASK.ASSIGNEDTO IS NOT NULL AND SYSTEMTASK.COMPLETEDDATE IS NULL AND SYSTEMTASKTYPESUBMITTALTYPE.ASSIGNTOOBJECT = 1 --CaseAssignedTo
				
	  -- Update assigned to for permit's new files tasks
	  UPDATE SYSTEMTASK SET ASSIGNEDTO = @ASSIGNEDTO WHERE SYSTEMTASK.COMPLETEDDATE IS NULL AND SYSTEMTASK.ASSIGNEDTO IS NOT NULL AND UNIQUERECORDID IN (SELECT RECORDID FROM @PERMITIDS)
	  -- Update assigned to for permit's failed and approved submittal tasks
	  UPDATE SYSTEMTASK SET ASSIGNEDTO = @ASSIGNEDTO 
	  WHERE SYSTEMTASK.COMPLETEDDATE IS NULL AND SYSTEMTASK.ASSIGNEDTO IS NOT NULL AND UNIQUERECORDID IN 
	  (
		SELECT PLSUBMITTALID FROM PLSUBMITTAL
		INNER JOIN SYSTEMTASKTYPESUBMITTALTYPE ON SYSTEMTASKTYPESUBMITTALTYPE.PLSUBMITTALTYPEID = PLSUBMITTAL.PLSUBMITTALTYPEID  AND SYSTEMTASK.SYSTEMTASKTYPEID = SYSTEMTASKTYPESUBMITTALTYPE.SYSTEMTASKTYPEID
		WHERE SYSTEMTASKTYPESUBMITTALTYPE.ASSIGNTOOBJECT = 1 AND PLSUBMITTAL.PMPERMITID IN (SELECT RECORDID FROM @PERMITIDS)
	  )

	  --Update Plan assigned to
	  INSERT INTO HISTORYPLANMANAGEMENT(ID, ROWVERSION, CHANGEDON, CHANGEDBY, FIELDNAME, OLDVALUE, NEWVALUE, ADDITIONALINFO)
		SELECT PLPLAN.PLPLANID, PLPLAN.ROWVERSION + 1, @CURRENTDATETIME, @USERID, 'Plan Assigned To', CASE WHEN USERS.FNAME IS NULL THEN '' ELSE USERS.FNAME END + ' ' + CASE WHEN USERS.LNAME IS NULL THEN '' ELSE USERS.LNAME END, @UPDATED_USER_FULLNAME, 'Plan Assigned To updated through Bulk Update'
				FROM @PLANIDS PLANIDS 
				INNER JOIN PLPLAN ON PLANIDS.RECORDID = PLPLAN.PLPLANID
				INNER JOIN USERS ON PLPLAN.ASSIGNEDTO = USERS.SUSERGUID
	  UPDATE PLPLAN SET ASSIGNEDTO = @ASSIGNEDTO, ROWVERSION = ROWVERSION + 1, LASTCHANGEDBY = @USERID, LASTCHANGEDON = @CURRENTDATETIME WHERE PLPLANID IN (SELECT RECORDID FROM @PLANIDS)

	  -- Write History for Plan's new files tasks
	  INSERT INTO HISTORYPLANMANAGEMENT(ID, ROWVERSION, CHANGEDON, CHANGEDBY, FIELDNAME, OLDVALUE, NEWVALUE, ADDITIONALINFO)
		SELECT PLPLAN.PLPLANID, PLPLAN.ROWVERSION, @CURRENTDATETIME, @USERID, 'System Task Assigned To',  CASE WHEN USERS.FNAME IS NULL THEN '' ELSE USERS.FNAME END + ' ' + CASE WHEN USERS.LNAME IS NULL THEN '' ELSE USERS.LNAME END, @UPDATED_USER_FULLNAME, 'System Task Assigned To updated'
				FROM @PLANIDS PLANIDS 
				INNER JOIN PLPLAN ON PLANIDS.RECORDID = PLPLAN.PLPLANID
				INNER JOIN SYSTEMTASK ON SYSTEMTASK.UNIQUERECORDID = PLPLAN.PLPLANID
				INNER JOIN USERS ON SYSTEMTASK.ASSIGNEDTO = USERS.SUSERGUID
				WHERE SYSTEMTASK.ASSIGNEDTO IS NOT NULL AND SYSTEMTASK.COMPLETEDDATE IS NULL


	-- Write History for Plan's  failed and approved submittal tasks
	  INSERT INTO HISTORYPLANMANAGEMENT (ID, ROWVERSION, CHANGEDON, CHANGEDBY, FIELDNAME, OLDVALUE, NEWVALUE, ADDITIONALINFO)
		SELECT PLPLAN.PLPLANID, PLPLAN.ROWVERSION, @CURRENTDATETIME, @USERID, 'System Task Assigned To',  CASE WHEN USERS.FNAME IS NULL THEN '' ELSE USERS.FNAME END + ' ' + CASE WHEN USERS.LNAME IS NULL THEN '' ELSE USERS.LNAME END, @UPDATED_USER_FULLNAME, 'System Task Assigned To updated'
				FROM @PLANIDS PLANIDS 
				INNER JOIN PLPLAN ON PLANIDS.RECORDID = PLPLAN.PLPLANID
				INNER JOIN PLSUBMITTAL ON PLSUBMITTAL.PLPLANID = PLPLAN.PLPLANID
				INNER JOIN SYSTEMTASK ON SYSTEMTASK.UNIQUERECORDID = PLSUBMITTAL.PLSUBMITTALID
				INNER JOIN SYSTEMTASKTYPESUBMITTALTYPE ON SYSTEMTASKTYPESUBMITTALTYPE.PLSUBMITTALTYPEID = PLSUBMITTAL.PLSUBMITTALTYPEID AND SYSTEMTASK.SYSTEMTASKTYPEID = SYSTEMTASKTYPESUBMITTALTYPE.SYSTEMTASKTYPEID
				INNER JOIN USERS ON SYSTEMTASK.ASSIGNEDTO = USERS.SUSERGUID
				WHERE SYSTEMTASK.ASSIGNEDTO IS NOT NULL AND SYSTEMTASK.COMPLETEDDATE IS NULL AND SYSTEMTASKTYPESUBMITTALTYPE.ASSIGNTOOBJECT = 1 --CaseAssignedTo


	  -- Update assigned to for plan's new files tasks
	  UPDATE SYSTEMTASK SET ASSIGNEDTO = @ASSIGNEDTO WHERE SYSTEMTASK.COMPLETEDDATE IS NULL AND SYSTEMTASK.ASSIGNEDTO IS NOT NULL AND UNIQUERECORDID IN (SELECT RECORDID FROM @PLANIDS)
	  -- Update assigned to for plan's failed and approved submittal tasks
	  UPDATE SYSTEMTASK SET ASSIGNEDTO = @ASSIGNEDTO WHERE SYSTEMTASK.COMPLETEDDATE IS NULL AND SYSTEMTASK.ASSIGNEDTO IS NOT NULL AND UNIQUERECORDID IN 
	  (
		SELECT PLSUBMITTALID FROM PLSUBMITTAL
		INNER JOIN SYSTEMTASKTYPESUBMITTALTYPE ON SYSTEMTASKTYPESUBMITTALTYPE.PLSUBMITTALTYPEID = PLSUBMITTAL.PLSUBMITTALTYPEID  AND SYSTEMTASK.SYSTEMTASKTYPEID = SYSTEMTASKTYPESUBMITTALTYPE.SYSTEMTASKTYPEID
		WHERE SYSTEMTASKTYPESUBMITTALTYPE.ASSIGNTOOBJECT = 1 AND PLSUBMITTAL.PLPLANID IN (SELECT RECORDID FROM @PLANIDS)
	  )

	  EXECUTE [reviewcoordinator].[USP_EMAIL_BULK_CASES_ASSIGNED] @ASSIGNEDTO, @PERMITIDS, @PLANIDS 

	  COMMIT TRANSACTION [TranUpdateCase]

	  END TRY

	  BEGIN CATCH
		SELECT
			ERROR_NUMBER() AS ErrorNumber
			,ERROR_SEVERITY() AS ErrorSeverity
			,ERROR_STATE() AS ErrorState
			,ERROR_PROCEDURE() AS ErrorProcedure
			,ERROR_LINE() AS ErrorLine
			,ERROR_MESSAGE() AS ErrorMessage;
		ROLLBACK TRANSACTION [TranUpdateCase]

	  END CATCH

    END

END