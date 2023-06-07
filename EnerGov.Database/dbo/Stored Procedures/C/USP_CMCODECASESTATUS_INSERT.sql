﻿CREATE PROCEDURE [dbo].[USP_CMCODECASESTATUS_INSERT]
(
	@CMCODECASESTATUSID CHAR(36),
	@NAME VARCHAR(50),
	@DESCRIPTION NVARCHAR(MAX),
	@SUCCESSFLAG BIT,
	@FAILUREFLAG BIT,
	@CANCELLEDFLAG BIT,
	@LASTCHANGEDBY CHAR(36),
	@LASTCHANGEDON DATETIME,
	@ROWVERSION INT
)
AS
DECLARE @OUTPUTTABLE as TABLE([ROWVERSION]  int)
INSERT INTO [dbo].[CMCODECASESTATUS](
	[CMCODECASESTATUSID],
	[NAME],
	[DESCRIPTION],
	[SUCCESSFLAG],
	[FAILUREFLAG],
	[CANCELLEDFLAG],
	[LASTCHANGEDBY],
	[LASTCHANGEDON],
	[ROWVERSION]
)
OUTPUT inserted.[ROWVERSION] INTO @OUTPUTTABLE
VALUES
(
	@CMCODECASESTATUSID,
	@NAME,
	@DESCRIPTION,
	@SUCCESSFLAG,
	@FAILUREFLAG,
	@CANCELLEDFLAG,
	@LASTCHANGEDBY,
	@LASTCHANGEDON,
	@ROWVERSION
)
SELECT * FROM @OUTPUTTABLE