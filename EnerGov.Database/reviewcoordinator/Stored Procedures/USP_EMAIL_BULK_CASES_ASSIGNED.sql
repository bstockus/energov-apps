﻿CREATE PROCEDURE [reviewcoordinator].[USP_EMAIL_BULK_CASES_ASSIGNED]
	@AssignedUserId char(36),
	@PERMITIDS RecordIds READONLY,
	@PLANIDS RecordIds READONLY
AS
BEGIN
	DECLARE @SENDMESSAGE AS BIT = 0;

	Declare @Message AS NVARCHAR(max);

	SET @message='<body style="font-family: arial, sans-serif;">The following cases have been assigned to you:<br/>'
	
	Declare @EmailTo AS NVARCHAR(50);

	SET @EmailTo=(SELECT CASE WHEN EMAIL = '' then NULL ELSE EMAIL END FROM USERS WHERE SUSERGUID = @AssignedUserId)		
	
	IF EXISTS(SELECT 1 FROM @PERMITIDS)
	BEGIN
		SET @Message = CONCAT(@Message,'<br/><strong>Permits:</strong><br/>');

		SELECT @Message = @Message + PMPERMIT.PERMITNUMBER + ' - ' + PMPERMITTYPE.NAME + ' - ' + PMPERMITWORKCLASS.NAME   + '<br/>' FROM PMPERMIT
							JOIN PMPERMITTYPE ON PMPERMIT.PMPERMITTYPEID=PMPERMITTYPE.PMPERMITTYPEID
							JOIN PMPERMITWORKCLASS ON PMPERMITWORKCLASS.PMPERMITWORKCLASSID=PMPERMIT.PMPERMITWORKCLASSID
							JOIN @PERMITIDS PERMITSIDS ON PMPERMIT.PMPERMITID=PERMITSIDS.RECORDID

		SET @SENDMESSAGE = 1;
	END
	
	IF EXISTS(SELECT 1 FROM @PLANIDS)
	BEGIN
		SET @Message = CONCAT(@Message,'<br/><strong>Plans:</strong><br/>');
		
		SELECT @Message = @Message + PLPLAN.PLANNUMBER + ' - ' + PLPLANTYPE.PLANNAME + ' - ' + PLPLANWORKCLASS.NAME   + '<br/>' FROM PLPLAN 
							JOIN PLPLANTYPE ON PLPLAN.PLPLANTYPEID=PLPLANTYPE.PLPLANTYPEID
							JOIN PLPLANWORKCLASS ON PLPLANWORKCLASS.PLPLANWORKCLASSID=PLPLAN.PLPLANWORKCLASSID
							JOIN @PLANIDS PLANIDS ON PLPLAN.PLPLANID = PLANIDS.RECORDID		

		SET @SENDMESSAGE = 1;
	END

	IF (@EmailTo IS NOT NULL AND @SENDMESSAGE = 1)
	BEGIN
		INSERT INTO dbo.EMAILQUEUE (ID, EMAILTO, SUBJECT, BODY, ISHTML, SENTTOBUS)
		VALUES (NEWID(), @EmailTo, 'Cases Have been Reassigned to You', @Message, 1, 0)
	END
END