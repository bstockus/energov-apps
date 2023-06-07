﻿CREATE PROCEDURE [dbo].[USP_CMVIOLATIONSTATUS_INSERT]
(
	@CMVIOLATIONSTATUSID CHAR(36),
	@NAME NVARCHAR(100),
	@DESCRIPTION NVARCHAR(MAX),
	@SUCCESSFLAG BIT,
	@DEFAULTFLAG BIT,
	@FAILUREFLAG BIT,
	@LASTCHANGEDBY CHAR(36),
	@LASTCHANGEDON DATETIME,
	@ROWVERSION INT
)
AS
DECLARE @OUTPUTTABLE as TABLE([ROWVERSION]  int)
INSERT INTO [dbo].[CMVIOLATIONSTATUS](
	[CMVIOLATIONSTATUSID],
	[NAME],
	[DESCRIPTION],
	[SUCCESSFLAG],
	[DEFAULTFLAG],
	[FAILUREFLAG],
	[LASTCHANGEDBY],
	[LASTCHANGEDON],
	[ROWVERSION]
)
OUTPUT inserted.[ROWVERSION] INTO @OUTPUTTABLE
VALUES
(
	@CMVIOLATIONSTATUSID,
	@NAME,
	@DESCRIPTION,
	@SUCCESSFLAG,
	@DEFAULTFLAG,
	@FAILUREFLAG,
	@LASTCHANGEDBY,
	@LASTCHANGEDON,
	@ROWVERSION
)
SELECT * FROM @OUTPUTTABLE