﻿CREATE PROCEDURE [dbo].[USP_CONDITIONLIBRARY_INSERT]
(
	@CONDITIONLIBRARYID CHAR(36),
	@CONDITIONCATEGORYID CHAR(36),
	@NAME NVARCHAR(255),
	@DESCRIPTION NVARCHAR(MAX),
	@LASTCHANGEDBY CHAR(36),
	@LASTCHANGEDON DATETIME,
	@ROWVERSION INT
)
AS
DECLARE @OUTPUTTABLE as TABLE([ROWVERSION]  int)
INSERT INTO [dbo].[CONDITIONLIBRARY](
	[CONDITIONLIBRARYID],
	[CONDITIONCATEGORYID],
	[NAME],
	[DESCRIPTION],
	[LASTCHANGEDBY],
	[LASTCHANGEDON],
	[ROWVERSION]
)
OUTPUT inserted.[ROWVERSION] INTO @OUTPUTTABLE
VALUES
(
	@CONDITIONLIBRARYID,
	@CONDITIONCATEGORYID,
	@NAME,
	@DESCRIPTION,
	@LASTCHANGEDBY,
	@LASTCHANGEDON,
	@ROWVERSION
)
SELECT * FROM @OUTPUTTABLE