﻿CREATE PROCEDURE [dbo].[USP_RPTIMAGELIB_INSERT]
(
	@RPTIMAGELIBID CHAR(36),
	@IMAGENAME NVARCHAR(50),
	@FILENAME NVARCHAR(150),
	@PRIORFILENAME NVARCHAR(150),
	@DIMENSIONS NVARCHAR(50),
	@IMAGE VARBINARY(MAX),
	@LASTCHANGEDBY CHAR(36),
	@LASTCHANGEDON DATETIME,
	@ROWVERSION INT
)
AS
DECLARE @OUTPUTTABLE as TABLE([ROWVERSION]  int)
INSERT INTO [dbo].[RPTIMAGELIB](
	[RPTIMAGELIBID],
	[IMAGENAME],
	[FILENAME],
	[PRIORFILENAME],
	[DIMENSIONS],
	[IMAGE],
	[LASTCHANGEDBY],
	[LASTCHANGEDON],
	[ROWVERSION]
)
OUTPUT inserted.[ROWVERSION] INTO @OUTPUTTABLE
VALUES
(
	@RPTIMAGELIBID,
	@IMAGENAME,
	@FILENAME,
	@PRIORFILENAME,
	@DIMENSIONS,
	@IMAGE,
	@LASTCHANGEDBY,
	@LASTCHANGEDON,
	@ROWVERSION
)
SELECT * FROM @OUTPUTTABLE