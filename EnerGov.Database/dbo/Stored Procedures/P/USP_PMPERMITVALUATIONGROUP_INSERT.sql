﻿CREATE PROCEDURE [dbo].[USP_PMPERMITVALUATIONGROUP_INSERT]
(
	@PMPERMITVALUATIONGROUPID CHAR(36),
	@NAME NVARCHAR(100),
	@DESCRIPTION NVARCHAR(MAX),
	@LASTCHANGEDBY CHAR(36),
	@LASTCHANGEDON DATETIME,
	@ROWVERSION INT
)
AS
DECLARE @OUTPUTTABLE as TABLE([ROWVERSION]  int)
INSERT INTO [dbo].[PMPERMITVALUATIONGROUP](
	[PMPERMITVALUATIONGROUPID],
	[NAME],
	[DESCRIPTION],
	[LASTCHANGEDBY],
	[LASTCHANGEDON],
	[ROWVERSION]
)
OUTPUT inserted.[ROWVERSION] INTO @OUTPUTTABLE
VALUES
(
	@PMPERMITVALUATIONGROUPID,
	@NAME,
	@DESCRIPTION,
	@LASTCHANGEDBY,
	@LASTCHANGEDON,
	@ROWVERSION
)
SELECT * FROM @OUTPUTTABLE