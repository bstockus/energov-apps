﻿CREATE PROCEDURE [dbo].[USP_GISMAILINGTEMPLATE_INSERT]
(
	@GISMAILINGTEMPLATEID CHAR(36),
	@NAME NVARCHAR(250),
	@DESCRIPTION NVARCHAR(500),
	@MAPSERVICEURL NVARCHAR(MAX),
	@FEATURECLASSNAME NVARCHAR(500),
	@NAME1 NVARCHAR(500),
	@NAME2 NVARCHAR(500),
	@ADDRESS1 NVARCHAR(500),
	@ADDRESS2 NVARCHAR(500),
	@ADDRESS3 NVARCHAR(500),
	@ADDRESS4 NVARCHAR(500),
	@LASTCHANGEDBY CHAR(36),
	@LASTCHANGEDON DATETIME,
	@ROWVERSION INT
)
AS
DECLARE @OUTPUTTABLE as TABLE([ROWVERSION]  int)
INSERT INTO [dbo].[GISMAILINGTEMPLATE](
	[GISMAILINGTEMPLATEID],
	[NAME],
	[DESCRIPTION],
	[MAPSERVICEURL],
	[FEATURECLASSNAME],
	[NAME1],
	[NAME2],
	[ADDRESS1],
	[ADDRESS2],
	[ADDRESS3],
	[ADDRESS4],
	[LASTCHANGEDBY],
	[LASTCHANGEDON],
	[ROWVERSION]
)
OUTPUT inserted.[ROWVERSION] INTO @OUTPUTTABLE
VALUES
(
	@GISMAILINGTEMPLATEID,
	@NAME,
	@DESCRIPTION,
	@MAPSERVICEURL,
	@FEATURECLASSNAME,
	@NAME1,
	@NAME2,
	@ADDRESS1,
	@ADDRESS2,
	@ADDRESS3,
	@ADDRESS4,
	@LASTCHANGEDBY,
	@LASTCHANGEDON,
	@ROWVERSION
)
SELECT * FROM @OUTPUTTABLE