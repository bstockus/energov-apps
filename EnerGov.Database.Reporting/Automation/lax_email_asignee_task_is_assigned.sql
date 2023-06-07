CREATE PROCEDURE [dbo].[lax_email_asignee_task_is_assigned]
	@TASKID AS VARCHAR(36)
AS
	BEGIN
		
		INSERT INTO [$(EnerGovDatabase)].dbo.EMAILQUEUE
                      (ID,
                       EMAILFROM,
                       EMAILTO,
                       SUBJECT,
                       BODY,
                       BCC,
                       ISHTML)
          VALUES      (NEWID(),
                       'energov@cityoflacrosse.org',
                       (SELECT TOP 1 EMAIL FROM [$(EnerGovDatabase)].[dbo].[TASKUSER] INNER JOIN [$(EnerGovDatabase)].[dbo].[USERS] ON [TASKUSER].[USERID] = [USERS].[SUSERGUID] WHERE TASKID = @TASKID),
                       'New Task Assigned in EnerGov',
                       'You have a new task assigned to you in EnerGov.',
                       '',
                       0)

	END
