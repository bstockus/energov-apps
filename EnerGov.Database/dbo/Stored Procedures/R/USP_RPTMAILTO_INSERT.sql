﻿CREATE PROCEDURE [dbo].[USP_RPTMAILTO_INSERT]
(
	@RPTMAILTOID CHAR(36),
	@RPTAUTOMAILID CHAR(36),
	@FIRSTNAME NVARCHAR(50),
	@LASTNAME NVARCHAR(50),
	@GLOBALENTITYNAME NVARCHAR(100),
	@EMAIL NVARCHAR(80)
)
AS

INSERT INTO [dbo].[RPTMAILTO](
	[RPTMAILTOID],
	[RPTAUTOMAILID],
	[FIRSTNAME],
	[LASTNAME],
	[GLOBALENTITYNAME],
	[EMAIL]
)

VALUES
(
	@RPTMAILTOID,
	@RPTAUTOMAILID,
	@FIRSTNAME,
	@LASTNAME,
	@GLOBALENTITYNAME,
	@EMAIL
)