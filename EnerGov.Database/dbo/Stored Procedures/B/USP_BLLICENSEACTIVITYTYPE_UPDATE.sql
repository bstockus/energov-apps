﻿CREATE PROCEDURE [dbo].[USP_BLLICENSEACTIVITYTYPE_UPDATE]
(
	@BLLICENSEACTIVITYTYPEID CHAR(36),
	@NAME NVARCHAR(50),
	@DESCRIPTION NVARCHAR(MAX),
	@CANEDIT BIT,
	@CREATEID BIT,
	@PREFIXID NVARCHAR(20),
	@ALLOWDUPLICATE BIT,
	@CUSTOMFIELDLAYOUTID CHAR(36),
	@LASTCHANGEDBY CHAR(36),
	@LASTCHANGEDON DATETIME,
	@ROWVERSION INT
)
AS
DECLARE @OUTPUTTABLE as TABLE([ROWVERSION]  int)
UPDATE [dbo].[BLLICENSEACTIVITYTYPE] SET
	[NAME] = @NAME,
	[DESCRIPTION] = @DESCRIPTION,
	[CANEDIT] = @CANEDIT,
	[CREATEID] = @CREATEID,
	[PREFIXID] = @PREFIXID,
	[ALLOWDUPLICATE] = @ALLOWDUPLICATE,
	[CUSTOMFIELDLAYOUTID] = @CUSTOMFIELDLAYOUTID,
	[LASTCHANGEDBY] = @LASTCHANGEDBY,
	[LASTCHANGEDON] = @LASTCHANGEDON,
	[ROWVERSION] = @ROWVERSION + 1
OUTPUT inserted.[ROWVERSION] INTO @OUTPUTTABLE
WHERE
	[BLLICENSEACTIVITYTYPEID] = @BLLICENSEACTIVITYTYPEID AND 
	[ROWVERSION]= @ROWVERSION

SELECT * FROM @OUTPUTTABLE