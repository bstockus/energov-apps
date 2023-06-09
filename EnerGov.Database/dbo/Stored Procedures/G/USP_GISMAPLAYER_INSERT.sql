﻿CREATE PROCEDURE [dbo].[USP_GISMAPLAYER_INSERT]
(
	@GISMAPLAYERID CHAR(36),
	@LAYERURL VARCHAR(500),
	@DESCRIPTION VARCHAR(MAX),
	@NAME NVARCHAR(100),
	@LEGENDURL VARCHAR(500),
	@IS_KOOP_ENDPOINT BIT,
	@LASTCHANGEDBY CHAR(36),
	@LASTCHANGEDON DATETIME,
	@ROWVERSION INT
)
AS
DECLARE @OUTPUTTABLE as TABLE([ROWVERSION]  int)
INSERT INTO [dbo].[GISMAPLAYER](
	[GISMAPLAYERID],
	[LAYERURL],
	[DESCRIPTION],
	[NAME],
	[LEGENDURL],
	[IS_KOOP_ENDPOINT],
	[LASTCHANGEDBY],
	[LASTCHANGEDON],
	[ROWVERSION]
)
OUTPUT inserted.[ROWVERSION] INTO @OUTPUTTABLE
VALUES
(
	@GISMAPLAYERID,
	@LAYERURL,
	@DESCRIPTION,
	@NAME,
	@LEGENDURL,
	@IS_KOOP_ENDPOINT,
	@LASTCHANGEDBY,
	@LASTCHANGEDON,
	@ROWVERSION
)
SELECT * FROM @OUTPUTTABLE