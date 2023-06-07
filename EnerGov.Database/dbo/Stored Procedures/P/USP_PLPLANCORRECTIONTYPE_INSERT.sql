﻿CREATE PROCEDURE [dbo].[USP_PLPLANCORRECTIONTYPE_INSERT]
(
	@PLPLANCORRECTIONTYPEID CHAR(36),
	@NAME NVARCHAR(50),
	@DESCRIPTION NVARCHAR(MAX),
	@CORRECTIVEACTION NVARCHAR(MAX),
	@PLCORRECTIONTYPECATEGORYID CHAR(36),
	@LASTCHANGEDBY CHAR(36),
	@LASTCHANGEDON DATETIME,
	@ROWVERSION INT
)
AS
DECLARE @OUTPUTTABLE as TABLE([ROWVERSION]  int)
INSERT INTO [dbo].[PLPLANCORRECTIONTYPE](
	[PLPLANCORRECTIONTYPEID],
	[NAME],
	[DESCRIPTION],
	[CORRECTIVEACTION],
	[PLCORRECTIONTYPECATEGORYID],
	[LASTCHANGEDBY],
	[LASTCHANGEDON],
	[ROWVERSION]
)
OUTPUT inserted.[ROWVERSION] INTO @OUTPUTTABLE
VALUES
(
	@PLPLANCORRECTIONTYPEID,
	@NAME,
	@DESCRIPTION,
	@CORRECTIVEACTION,
	@PLCORRECTIONTYPECATEGORYID,
	@LASTCHANGEDBY,
	@LASTCHANGEDON,
	@ROWVERSION
)
SELECT * FROM @OUTPUTTABLE