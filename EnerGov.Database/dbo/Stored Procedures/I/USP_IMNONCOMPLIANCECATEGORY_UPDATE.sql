﻿CREATE PROCEDURE [dbo].[USP_IMNONCOMPLIANCECATEGORY_UPDATE]
(
	@IMNONCOMPLIANCECATEGORYID CHAR(36),
	@NAME NVARCHAR(50),
	@DESCRIPTION NVARCHAR(2000),
	@LASTCHANGEDBY CHAR(36),
	@LASTCHANGEDON DATETIME,
	@ROWVERSION INT
)
AS
DECLARE @OUTPUTTABLE as TABLE([ROWVERSION]  int)
UPDATE [dbo].[IMNONCOMPLIANCECATEGORY] SET
	[NAME] = @NAME,
	[DESCRIPTION] = @DESCRIPTION,
	[LASTCHANGEDBY] = @LASTCHANGEDBY,
	[LASTCHANGEDON] = @LASTCHANGEDON,
	[ROWVERSION] = @ROWVERSION + 1
OUTPUT inserted.[ROWVERSION] INTO @OUTPUTTABLE
WHERE
	[IMNONCOMPLIANCECATEGORYID] = @IMNONCOMPLIANCECATEGORYID AND 
	[ROWVERSION]= @ROWVERSION

SELECT * FROM @OUTPUTTABLE