﻿CREATE PROCEDURE [dbo].[USP_PRPROJECTTYPE_UPDATE]
(
	@PRPROJECTTYPEID CHAR(36),
	@NAME NVARCHAR(50),
	@DESCRIPTION NVARCHAR(MAX),
	@CUSTOMFIELDID CHAR(36),
	@CAFEETEMPLATEID CHAR(36),
	@ACTIVE BIT,
	@USECASETYPENUMBERING BIT,
	@LASTCHANGEDBY CHAR(36),
	@LASTCHANGEDON DATETIME,
	@ROWVERSION INT
)
AS
DECLARE @OUTPUTTABLE as TABLE([ROWVERSION]  int)
UPDATE [dbo].[PRPROJECTTYPE] SET
	[NAME] = @NAME,
	[DESCRIPTION] = @DESCRIPTION,
	[CUSTOMFIELDID] = @CUSTOMFIELDID,
	[CAFEETEMPLATEID] = @CAFEETEMPLATEID,
	[ACTIVE] = @ACTIVE,
	[USECASETYPENUMBERING] = @USECASETYPENUMBERING,
	[LASTCHANGEDBY] = @LASTCHANGEDBY,
	[LASTCHANGEDON] = @LASTCHANGEDON,
	[ROWVERSION] = @ROWVERSION + 1
OUTPUT inserted.[ROWVERSION] INTO @OUTPUTTABLE
WHERE
	[PRPROJECTTYPEID] = @PRPROJECTTYPEID AND 
	[ROWVERSION]= @ROWVERSION

SELECT * FROM @OUTPUTTABLE