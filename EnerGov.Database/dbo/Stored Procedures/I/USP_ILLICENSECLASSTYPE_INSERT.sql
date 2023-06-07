﻿CREATE PROCEDURE [dbo].[USP_ILLICENSECLASSTYPE_INSERT]
(
	@ILLICENSECLASSTYPEID CHAR(36),
	@NAME NVARCHAR(50),
	@DESCRIPTION NVARCHAR(MAX),
	@ILLICENSECLASSTYPECATEGORYID CHAR(36),
	@LASTCHANGEDBY CHAR(36),
	@LASTCHANGEDON DATETIME,
	@ROWVERSION INT
)
AS
DECLARE @OUTPUTTABLE as TABLE([ROWVERSION]  int)
INSERT INTO [dbo].[ILLICENSECLASSTYPE](
	[ILLICENSECLASSTYPEID],
	[NAME],
	[DESCRIPTION],
	[ILLICENSECLASSTYPECATEGORYID],
	[LASTCHANGEDBY],
	[LASTCHANGEDON],
	[ROWVERSION]
)
OUTPUT inserted.[ROWVERSION] INTO @OUTPUTTABLE
VALUES
(
	@ILLICENSECLASSTYPEID,
	@NAME,
	@DESCRIPTION,
	@ILLICENSECLASSTYPECATEGORYID,
	@LASTCHANGEDBY,
	@LASTCHANGEDON,
	@ROWVERSION
)
SELECT * FROM @OUTPUTTABLE