﻿CREATE PROCEDURE [dbo].[USP_COMAPPEDVALUECERTTYPE_INSERT]
(
	@COMAPPEDVALUECERTTYPEID CHAR(36),
	@MAPPEDTYPE VARCHAR(50),
	@COSIMPLELICCERTTYPEID CHAR(36),
	@MAPPEDCATEGORY VARCHAR(50),
	@LASTCHANGEDBY CHAR(36),
	@LASTCHANGEDON DATETIME,
	@ROWVERSION INT
)
AS
DECLARE @OUTPUTTABLE as TABLE([ROWVERSION]  int)
INSERT INTO [dbo].[COMAPPEDVALUECERTTYPE](
	[COMAPPEDVALUECERTTYPEID],
	[MAPPEDTYPE],
	[COSIMPLELICCERTTYPEID],
	[MAPPEDCATEGORY],
	[LASTCHANGEDBY],
	[LASTCHANGEDON],
	[ROWVERSION]
)
OUTPUT inserted.[ROWVERSION] INTO @OUTPUTTABLE
VALUES
(
	@COMAPPEDVALUECERTTYPEID,
	@MAPPEDTYPE,
	@COSIMPLELICCERTTYPEID,
	@MAPPEDCATEGORY,
	@LASTCHANGEDBY,
	@LASTCHANGEDON,
	@ROWVERSION
)
SELECT * FROM @OUTPUTTABLE