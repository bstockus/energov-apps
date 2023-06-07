CREATE PROCEDURE [dbo].[lax_email_inspector_permit_task_is_completed]
	@TASKID AS VARCHAR(36),
	@PERMITID AS VARCHAR(36)
AS
	BEGIN
		
		DECLARE @notificationid VARCHAR(36)

		SET @notificationid = NEWID()

		INSERT INTO [$(EnerGovDatabase)].[dbo].NOTIFICATIONS
			(NOTIFICATIONSID, SUBJECT, BODY, UNIQUERECORDID, FORMID)
			VALUES (
				@notificationid, 
				'Permit Task Completed', 
				(SELECT TOP 1 TASKTYPE.NAME FROM [$(EnerGovDatabase)].[dbo].[TASK] INNER JOIN [$(EnerGovDatabase)].[dbo].[TASKTYPE] ON [TASK].[TASKTYPEID] = [TASKTYPE].[TASKTYPEID] WHERE TASKID = @TASKID),
				@PERMITID,
				'7877DE83-7CC1-467F-8EC3-8C5367C00C86');

		INSERT INTO [$(EnerGovDatabase)].[dbo].USERNOTIFICATION
			(USERID, NOTIFICATIONSID, DATECREATED)
			VALUES (
				(SELECT TOP 1 ASSIGNEDTO FROM [$(EnerGovDatabase)].[dbo].[PMPERMIT] WHERE PMPERMITID = @PERMITID),
				@notificationid,
				GETDATE());

	END
