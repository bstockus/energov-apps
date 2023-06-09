﻿CREATE PROCEDURE [dbo].[USP_RPTMAILTO_UPDATE]
(
	@RPTMAILTOID CHAR(36),
	@RPTAUTOMAILID CHAR(36),
	@FIRSTNAME NVARCHAR(50),
	@LASTNAME NVARCHAR(50),
	@GLOBALENTITYNAME NVARCHAR(100),
	@EMAIL NVARCHAR(80)
)
AS

UPDATE [dbo].[RPTMAILTO] SET
	[RPTAUTOMAILID] = @RPTAUTOMAILID,
	[FIRSTNAME] = @FIRSTNAME,
	[LASTNAME] = @LASTNAME,
	[GLOBALENTITYNAME] = @GLOBALENTITYNAME,
	[EMAIL] = @EMAIL

WHERE
	[RPTMAILTOID] = @RPTMAILTOID