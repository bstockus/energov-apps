﻿CREATE PROCEDURE [dbo].[USP_PMPERMITWORKCLASS_INSERT]
(
	@PMPERMITWORKCLASSID CHAR(36),
	@NAME NVARCHAR(100),
	@DESCRIPTION NVARCHAR(MAX),
	@LASTCHANGEDBY CHAR(36),
	@LASTCHANGEDON DATETIME,
	@ROWVERSION INT
)
AS
DECLARE @OUTPUTTABLE as TABLE([ROWVERSION]  int)
INSERT INTO [dbo].[PMPERMITWORKCLASS](
	[PMPERMITWORKCLASSID],
	[NAME],
	[DESCRIPTION],
	[LASTCHANGEDBY],
	[LASTCHANGEDON],
	[ROWVERSION]
)
OUTPUT inserted.[ROWVERSION] INTO @OUTPUTTABLE
VALUES
(
	@PMPERMITWORKCLASSID,
	@NAME,
	@DESCRIPTION,
	@LASTCHANGEDBY,
	@LASTCHANGEDON,
	@ROWVERSION
)
SELECT * FROM @OUTPUTTABLE