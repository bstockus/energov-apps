﻿CREATE PROCEDURE [dbo].[USP_BLEXTCOMPANYTYPE_UPDATE]
(
	@BLEXTCOMPANYTYPEID CHAR(36),
	@NAME NVARCHAR(50),
	@DESCRIPTION NVARCHAR(MAX),
	@BLEINFORMATID INT,
	@CUSTOMFIELDLAYOUTID CHAR(36),
	@CANAPPLYONLINE BIT,
	@DEFAULTWEBAPPLYSTATUSID CHAR(36),
	@ONLINECUSTOMFIELDLAYOUTID CHAR(36),
	@MANAGEBUSINESSTYPECODES BIT,
	@REQUIREBUSINESSTYPECODES BIT,
	@CAPADDRESSREQUIRED BIT,
	@LASTCHANGEDBY CHAR(36),
	@LASTCHANGEDON DATETIME,
	@ROWVERSION INT,
	@BLEXTCOMPANYTYPEMODULEID INT,
	@CAFEETEMPLATEID CHAR(36)
)
AS
DECLARE @OUTPUTTABLE as TABLE([ROWVERSION]  int)
UPDATE [dbo].[BLEXTCOMPANYTYPE] SET
	[NAME] = @NAME,
	[DESCRIPTION] = @DESCRIPTION,
	[BLEINFORMATID] = @BLEINFORMATID,
	[CUSTOMFIELDLAYOUTID] = @CUSTOMFIELDLAYOUTID,
	[CANAPPLYONLINE] = @CANAPPLYONLINE,
	[DEFAULTWEBAPPLYSTATUSID] = @DEFAULTWEBAPPLYSTATUSID,
	[ONLINECUSTOMFIELDLAYOUTID] = @ONLINECUSTOMFIELDLAYOUTID,
	[MANAGEBUSINESSTYPECODES] = @MANAGEBUSINESSTYPECODES,
	[REQUIREBUSINESSTYPECODES] = @REQUIREBUSINESSTYPECODES,
	[CAPADDRESSREQUIRED] = @CAPADDRESSREQUIRED,
	[LASTCHANGEDBY] = @LASTCHANGEDBY,
	[LASTCHANGEDON] = @LASTCHANGEDON,
	[ROWVERSION] = @ROWVERSION + 1,
	[BLEXTCOMPANYTYPEMODULEID] = @BLEXTCOMPANYTYPEMODULEID,
	[CAFEETEMPLATEID] = @CAFEETEMPLATEID
OUTPUT inserted.[ROWVERSION] INTO @OUTPUTTABLE
WHERE
	[BLEXTCOMPANYTYPEID] = @BLEXTCOMPANYTYPEID AND 
	[ROWVERSION]= @ROWVERSION

SELECT * FROM @OUTPUTTABLE