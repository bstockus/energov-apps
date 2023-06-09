﻿CREATE PROCEDURE [dbo].[USP_CMCODECATEGORY_INSERT]
(
	@CMCODECATEGORYID CHAR(36),
	@NAME NVARCHAR(100),
	@DESCRIPTION NVARCHAR(MAX),
	@REPORTNAME NVARCHAR(200),
	@CMCODESYSTEMTYPEID INT,
	@LASTCHANGEDBY CHAR(36),
	@LASTCHANGEDON DATETIME,
	@ROWVERSION INT
)
AS
DECLARE @OUTPUTTABLE as TABLE([ROWVERSION]  int)
INSERT INTO [dbo].[CMCODECATEGORY](
	[CMCODECATEGORYID],
	[NAME],
	[DESCRIPTION],
	[REPORTNAME],
	[CMCODESYSTEMTYPEID],
	[LASTCHANGEDBY],
	[LASTCHANGEDON],
	[ROWVERSION]
)
OUTPUT inserted.[ROWVERSION] INTO @OUTPUTTABLE
VALUES
(
	@CMCODECATEGORYID,
	@NAME,
	@DESCRIPTION,
	@REPORTNAME,
	@CMCODESYSTEMTYPEID,
	@LASTCHANGEDBY,
	@LASTCHANGEDON,
	@ROWVERSION
)
SELECT * FROM @OUTPUTTABLE