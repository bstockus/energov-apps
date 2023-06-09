﻿CREATE PROCEDURE [dbo].[USP_CMCODEACTIVITYTYPE_UPDATE]
(
	@CMCODEACTIVITYTYPEID CHAR(36),
	@NAME NVARCHAR(50),
	@DESCRIPTION NVARCHAR(MAX),
	@CANEDIT BIT,
	@CREATEID BIT,
	@PREFIXID NVARCHAR(20),
	@ALLOWDUPLICATE BIT,
	@CUSTOMFIELDID CHAR(36),
	@LASTCHANGEDBY CHAR(36),
	@LASTCHANGEDON DATETIME,
	@ROWVERSION INT
)
AS
DECLARE @OUTPUTTABLE as TABLE([ROWVERSION]  int)
UPDATE [dbo].[CMCODEACTIVITYTYPE] SET
	[NAME] = @NAME,
	[DESCRIPTION] = @DESCRIPTION,
	[CANEDIT] = @CANEDIT,
	[CREATEID] = @CREATEID,
	[PREFIXID] = @PREFIXID,
	[ALLOWDUPLICATE] = @ALLOWDUPLICATE,
	[CUSTOMFIELDID] = @CUSTOMFIELDID,
	[LASTCHANGEDBY] = @LASTCHANGEDBY,
	[LASTCHANGEDON] = @LASTCHANGEDON,
	[ROWVERSION] = @ROWVERSION + 1
OUTPUT inserted.[ROWVERSION] INTO @OUTPUTTABLE
WHERE
	[CMCODEACTIVITYTYPEID] = @CMCODEACTIVITYTYPEID AND 
	[ROWVERSION]= @ROWVERSION

SELECT * FROM @OUTPUTTABLE