﻿CREATE PROCEDURE [dbo].[USP_EMAILQUEUE_INSERT]
(
	@ID CHAR(36),
	@EMAILFROM NVARCHAR(MAX),
	@EMAILTO NVARCHAR(MAX),
	@CC NVARCHAR(MAX),
	@BCC NVARCHAR(MAX),
	@SUBJECT NVARCHAR(MAX),
	@BODY NVARCHAR(MAX),
	@ISHTML BIT,
	@DATESENT DATETIME,
	@UNIQUERECORDID CHAR(36),
	@ATTACHEMENTFILE VARCHAR(MAX),
	@SENTTOBUS BIT,
	@RPTPARAMVALUECOLLECTIONID CHAR(36) = NULL
)
AS

INSERT INTO [dbo].[EMAILQUEUE](
	[ID],
	[EMAILFROM],
	[EMAILTO],
	[CC],
	[BCC],
	[SUBJECT],
	[BODY],
	[ISHTML],
	[DATESENT],
	[UNIQUERECORDID],
	[ATTACHEMENTFILE],
	[SENTTOBUS],
	[RPTPARAMVALUECOLLECTIONID]
)

VALUES
(
	NEWID(),
	@EMAILFROM,
	@EMAILTO,
	@CC,
	@BCC,
	@SUBJECT,
	@BODY,
	@ISHTML,
	@DATESENT,
	@UNIQUERECORDID,
	@ATTACHEMENTFILE,
	@SENTTOBUS,
	@RPTPARAMVALUECOLLECTIONID
)