﻿CREATE PROCEDURE [dbo].[USP_CUSTOMFIELDTABLE_UPDATE]
(
	@CUSTOMFIELDTABLEID CHAR(36),
	@NAME NVARCHAR(50),
	@REQUIRED BIT,
	@DEFAULTROWNUM INT,
	@TOOLTIP VARCHAR(MAX),
	@SHOWONMOBILE BIT,
	@ISEDITINMOBILE BIT,
	@LASTCHANGEDBY CHAR(36),
	@LASTCHANGEDON DATETIME,
	@ROWVERSION INT
)
AS
DECLARE @OUTPUTTABLE as TABLE([ROWVERSION]  int)
UPDATE [dbo].[CUSTOMFIELDTABLE] SET
	[NAME] = @NAME,
	[REQUIRED] = @REQUIRED,
	[DEFAULTROWNUM] = @DEFAULTROWNUM,
	[TOOLTIP] = @TOOLTIP,
	[SHOWONMOBILE] = @SHOWONMOBILE,
	[ISEDITINMOBILE] = @ISEDITINMOBILE,
	[LASTCHANGEDBY] = @LASTCHANGEDBY,
	[LASTCHANGEDON] = @LASTCHANGEDON,
	[ROWVERSION] = @ROWVERSION + 1
OUTPUT inserted.[ROWVERSION] INTO @OUTPUTTABLE
WHERE
	[CUSTOMFIELDTABLEID] = @CUSTOMFIELDTABLEID AND 
	[ROWVERSION]= @ROWVERSION

SELECT * FROM @OUTPUTTABLE