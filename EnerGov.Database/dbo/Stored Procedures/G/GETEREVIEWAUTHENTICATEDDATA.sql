﻿

CREATE PROCEDURE [dbo].[GETEREVIEWAUTHENTICATEDDATA]
-- Add the parameters for the stored procedure here
@UserID nvarchar(36)
AS
BEGIN
	DECLARE @ActiveDirectoryPath nvarchar(500)
	SET @ActiveDirectoryPath = ''
	SELECT TOP 1 @ActiveDirectoryPath = STRINGVALUE FROM SETTINGS WHERE NAME = 'ActiveDirectoryPath'
		
	SELECT USERS.SUSERGUID, USERS.FNAME, USERS.LNAME, USERS.PASSWORD, USERS.SROLEID, @ActiveDirectoryPath AS ActiveDirectoryPath
	,SECURITYISACTIVEDIRECTORY
	FROM USERS
	INNER JOIN APPLICATIONALLOWED ON USERS.SUSERGUID = APPLICATIONALLOWED.USERID 	
	WHERE USERS.ID = @UserID AND APPLICATIONALLOWED.APPROVED = 1 AND APPLICATIONALLOWED.APPLICATIONID = 1 AND USERS.BACTIVE = 1
END

