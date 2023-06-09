﻿CREATE PROCEDURE [dbo].[USP_ZONE_INSERT]
(
	@ZONEID CHAR(36),
	@NAME NVARCHAR(50),
	@DESCRIPTION NVARCHAR(MAX),
	@ZONECODE NVARCHAR(100),
	@LASTCHANGEDBY CHAR(36),
	@LASTCHANGEDON DATETIME,
	@ROWVERSION INT
)
AS
DECLARE @OUTPUTTABLE as TABLE([ROWVERSION]  int)
INSERT INTO [dbo].[ZONE](
	[ZONEID],
	[NAME],
	[DESCRIPTION],
	[ZONECODE],
	[LASTCHANGEDBY],
	[LASTCHANGEDON],
	[ROWVERSION]
)
OUTPUT inserted.[ROWVERSION] INTO @OUTPUTTABLE
VALUES
(
	@ZONEID,
	@NAME,
	@DESCRIPTION,
	@ZONECODE,
	@LASTCHANGEDBY,
	@LASTCHANGEDON,
	@ROWVERSION
)
SELECT * FROM @OUTPUTTABLE