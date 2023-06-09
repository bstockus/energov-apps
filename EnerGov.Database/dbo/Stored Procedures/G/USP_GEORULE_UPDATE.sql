﻿CREATE PROCEDURE [dbo].[USP_GEORULE_UPDATE]
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
UPDATE [dbo].[GEORULE] SET
	[RULENAME] = @RULENAME,
	[GEORULEENTITYID] = @GEORULEENTITYID,
	[DESCRIPTION] = @DESCRIPTION,
	[GEOQUERYID] = @GEOQUERYID,
	[ENTITYPROPERTY] = @ENTITYPROPERTY,
	[ISCUSTOMFIELD] = @ISCUSTOMFIELD,
	[PROPERTYFRIENDLYNAME] = @PROPERTYFRIENDLYNAME,
	[ISASSETCOLLECTIONBASED] = @ISASSETCOLLECTIONBASED,
	[ASSETCOLLECTIONIDPROPERTYNAME] = @ASSETCOLLECTIONIDPROPERTYNAME,
	[ISGISFEATURESBASED] = @ISGISFEATURESBASED,
	[GISFEATURESPROPERTYNAME] = @GISFEATURESPROPERTYNAME,
	[LASTCHANGEDBY] = @LASTCHANGEDBY,
	[LASTCHANGEDON] = @LASTCHANGEDON,
	[ROWVERSION] = @ROWVERSION + 1
OUTPUT inserted.[ROWVERSION] INTO @OUTPUTTABLE
WHERE
	[GEORULEID] = @GEORULEID AND 
	[ROWVERSION]= @ROWVERSION

SELECT * FROM @OUTPUTTABLE