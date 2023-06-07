﻿CREATE PROCEDURE [dbo].[USP_IMCHECKLISTCATEGORY_UPDATE]
(
	@IMCHECKLISTCATEGORYID CHAR(36),
	@NAME NVARCHAR(255),
	@DESCRIPTION NVARCHAR(MAX),
	@LASTCHANGEDBY CHAR(36),
	@LASTCHANGEDON DATETIME,
	@ROWVERSION INT
)
AS
DECLARE @OUTPUTTABLE as TABLE([ROWVERSION]  int)
UPDATE [dbo].[IMCHECKLISTCATEGORY] SET
	[NAME] = @NAME,
	[DESCRIPTION] = @DESCRIPTION,
	[LASTCHANGEDBY] = @LASTCHANGEDBY,
	[LASTCHANGEDON] = @LASTCHANGEDON,
	[ROWVERSION] = @ROWVERSION + 1
OUTPUT inserted.[ROWVERSION] INTO @OUTPUTTABLE
WHERE
	[IMCHECKLISTCATEGORYID] = @IMCHECKLISTCATEGORYID AND 
	[ROWVERSION]= @ROWVERSION

SELECT * FROM @OUTPUTTABLE