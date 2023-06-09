﻿CREATE PROCEDURE [dbo].[USP_CAPRORATESCHEDULE_INSERT]
(
	@CAPRORATESCHEDULEID CHAR(36),
	@NAME NVARCHAR(50),
	@DESCRIPTION NVARCHAR(255),
	@LASTCHANGEDBY CHAR(36),
	@LASTCHANGEDON DATETIME,
	@ROWVERSION INT
)
AS
DECLARE @OUTPUTTABLE as TABLE([ROWVERSION]  int)
INSERT INTO [dbo].[CAPRORATESCHEDULE](
	[CAPRORATESCHEDULEID],
	[NAME],
	[DESCRIPTION],
	[LASTCHANGEDBY],
	[LASTCHANGEDON],
	[ROWVERSION]
)
OUTPUT inserted.[ROWVERSION] INTO @OUTPUTTABLE
VALUES
(
	@CAPRORATESCHEDULEID,
	@NAME,
	@DESCRIPTION,
	@LASTCHANGEDBY,
	@LASTCHANGEDON,
	@ROWVERSION
)
SELECT * FROM @OUTPUTTABLE