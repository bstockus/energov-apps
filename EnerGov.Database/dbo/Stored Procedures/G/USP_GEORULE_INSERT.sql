﻿CREATE PROCEDURE [dbo].[USP_GEORULE_INSERT]
(
	@GEORULEID CHAR(36),
	@RULENAME NVARCHAR(150),
	@GEORULEENTITYID CHAR(36),
	@DESCRIPTION NVARCHAR(MAX),
	@GEOQUERYID CHAR(36),
	@ENTITYPROPERTY NVARCHAR(MAX),
	@ISCUSTOMFIELD BIT,
	@PROPERTYFRIENDLYNAME NVARCHAR(MAX),
	@ISASSETCOLLECTIONBASED BIT,
	@ASSETCOLLECTIONIDPROPERTYNAME NVARCHAR(MAX),
	@ISGISFEATURESBASED BIT,
	@GISFEATURESPROPERTYNAME NVARCHAR(MAX),
	@LASTCHANGEDBY CHAR(36),
	@LASTCHANGEDON DATETIME,
	@ROWVERSION INT
)
AS
DECLARE @OUTPUTTABLE as TABLE([ROWVERSION]  int)
INSERT INTO [dbo].[GEORULE](
	[GEORULEID],
	[RULENAME],
	[GEORULEENTITYID],
	[DESCRIPTION],
	[GEOQUERYID],
	[ENTITYPROPERTY],
	[ISCUSTOMFIELD],
	[PROPERTYFRIENDLYNAME],
	[ISASSETCOLLECTIONBASED],
	[ASSETCOLLECTIONIDPROPERTYNAME],
	[ISGISFEATURESBASED],
	[GISFEATURESPROPERTYNAME],
	[LASTCHANGEDBY],
	[LASTCHANGEDON],
	[ROWVERSION]
)
OUTPUT inserted.[ROWVERSION] INTO @OUTPUTTABLE
VALUES
(
	@GEORULEID,
	@RULENAME,
	@GEORULEENTITYID,
	@DESCRIPTION,
	@GEOQUERYID,
	@ENTITYPROPERTY,
	@ISCUSTOMFIELD,
	@PROPERTYFRIENDLYNAME,
	@ISASSETCOLLECTIONBASED,
	@ASSETCOLLECTIONIDPROPERTYNAME,
	@ISGISFEATURESBASED,
	@GISFEATURESPROPERTYNAME,
	@LASTCHANGEDBY,
	@LASTCHANGEDON,
	@ROWVERSION
)
SELECT * FROM @OUTPUTTABLE