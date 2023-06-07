﻿CREATE PROCEDURE [dbo].[USP_ADDDEPLOYUSER]
(
@ID NVARCHAR (254),  
@EMAIL NVARCHAR (80)
)
AS
BEGIN
	DECLARE @SUSERGUID CHAR (36)
	DECLARE @LASTCHANGEDBY CHAR (36)
	DECLARE @APPLICATIONUSERTYPEID CHAR (36)
	SELECT @ID = RTRIM(LTRIM(@ID))
	SELECT @EMAIL = RTRIM(LTRIM(@EMAIL))
	IF LEN(@ID) > 0 AND LEN(@EMAIL) > 0 AND NOT EXISTS(SELECT 1 FROM [dbo].[USERS] WHERE ID=@ID)
	BEGIN
	   SELECT @SUSERGUID = NEWID()

	   SELECT @LASTCHANGEDBY = CASE	WHEN EXISTS(SELECT 1 FROM USERS WHERE SUSERGUID = '2FB39FA9-DF43-41D7-BB8B-C91836D30987')
																	THEN '2FB39FA9-DF43-41D7-BB8B-C91836D30987'
																	ELSE 'a24df514-c3c1-49c7-8784-0b2bf58c79fa'
															END
	   --USERS
	   INSERT INTO USERS(SUSERGUID, ID, PASSWORD, SROLEID, EMAIL, FNAME, LNAME, LICENSE_SUITE, SECURITYISACTIVEDIRECTORY, LASTCHANGEDBY) VALUES
			(@SUSERGUID, @ID, '', 'A652344C-FDB0-4116-A63B-126FFCAF2B2D', @EMAIL, 'Tyler', 'Deploy', 'Admin', 1, @LASTCHANGEDBY)
		
	   --APPLICATIONALLOWED
	   SELECT @APPLICATIONUSERTYPEID = APPLICATIONUSERTYPEID FROM APPLICATIONUSERTYPE WHERE TYPENAME='User' AND APPLICATIONID = 1
	   INSERT INTO APPLICATIONALLOWED(APPLICATIONALLOWEDID, USERID, APPLICATIONID, APPLICATIONUSERTYPEID, APPROVED) VALUES
			(NEWID(), @SUSERGUID, 1, @APPLICATIONUSERTYPEID, 1)
		
	END
END