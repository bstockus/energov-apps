﻿CREATE PROCEDURE [dbo].[USP_PLAPPLICATIONACTIVITYTYPE_UPDATE]
(
	@PLAPPLICATIONACTIVITYTYPEID CHAR(36),
	@NAME NVARCHAR(100),
	@DESCRIPTION NVARCHAR(MAX),
	@CANEDIT BIT,
	@CREATEID BIT,
	@PREFIXID NVARCHAR(40),
	@ALLOWDUPLICATE BIT,
	@CUSTOMFIELDID CHAR(36),
	@LASTCHANGEDBY CHAR(36),
	@LASTCHANGEDON DATETIME,
	@ROWVERSION INT
)
AS
DECLARE @OUTPUTTABLE as TABLE([ROWVERSION]  int)
UPDATE [dbo].[PLAPPLICATIONACTIVITYTYPE] SET
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
	[PLAPPLICATIONACTIVITYTYPEID] = @PLAPPLICATIONACTIVITYTYPEID AND 
	[ROWVERSION]= @ROWVERSION

SELECT * FROM @OUTPUTTABLE