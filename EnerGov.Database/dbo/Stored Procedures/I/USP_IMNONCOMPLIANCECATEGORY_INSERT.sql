﻿CREATE PROCEDURE [dbo].[USP_IMNONCOMPLIANCECATEGORY_INSERT]
(
	@IMNONCOMPLIANCECATEGORYID CHAR(36),
	@NAME NVARCHAR(50),
	@DESCRIPTION NVARCHAR(2000),
	@LASTCHANGEDBY CHAR(36),
	@LASTCHANGEDON DATETIME,
	@ROWVERSION INT
)
AS
DECLARE @OUTPUTTABLE as TABLE([ROWVERSION]  int)
INSERT INTO [dbo].[IMNONCOMPLIANCECATEGORY](
	[IMNONCOMPLIANCECATEGORYID],
	[NAME],
	[DESCRIPTION],
	[LASTCHANGEDBY],
	[LASTCHANGEDON],
	[ROWVERSION]
)
OUTPUT inserted.[ROWVERSION] INTO @OUTPUTTABLE
VALUES
(
	@IMNONCOMPLIANCECATEGORYID,
	@NAME,
	@DESCRIPTION,
	@LASTCHANGEDBY,
	@LASTCHANGEDON,
	@ROWVERSION
)
SELECT * FROM @OUTPUTTABLE