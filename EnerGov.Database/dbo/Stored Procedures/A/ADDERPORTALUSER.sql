﻿CREATE PROCEDURE [dbo].[ADDERPORTALUSER]
-- Add the parameters for the stored procedure here
@SUSERGUID char(36),
@FNAME nvarchar(30),
@MIDDLENAME nvarchar(50),
@LNAME nvarchar(30),
@EMAIL nvarchar(80),
@PASSWORD nvarchar(100),
@COMPANY nvarchar(100),
@PHONE nvarchar(40),
@MAILINGADDRESSID nvarchar(36)
AS
BEGIN		
	INSERT INTO USERS 	
	(
	SUSERGUID,
	FNAME,
	MIDDLENAME,
	LNAME,
	EMAIL,
	PASSWORD,
	COMPANY,
	PHONE,
	MAILINGADDRESSID	
	)
	VALUES(
	@SUSERGUID,
	@FNAME,
	@MIDDLENAME,
	@LNAME,
	@EMAIL,
	@PASSWORD,
	@COMPANY,
	@PHONE,
	@MAILINGADDRESSID	
	)		
END
