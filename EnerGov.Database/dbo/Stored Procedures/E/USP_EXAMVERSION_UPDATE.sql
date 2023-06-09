﻿CREATE PROCEDURE [dbo].[USP_EXAMVERSION_UPDATE]
(
	@EXAMVERSIONID CHAR(36),
	@NAME NVARCHAR(50),
	@DESCRIPTION NVARCHAR(MAX),
	@LASTCHANGEDBY CHAR(36),
	@LASTCHANGEDON DATETIME,
	@ROWVERSION INT
)
AS
DECLARE @OUTPUTTABLE as TABLE([ROWVERSION]  int)
UPDATE [dbo].[EXAMVERSION] SET
	[NAME] = @NAME,
	[DESCRIPTION] = @DESCRIPTION,
	[LASTCHANGEDBY] = @LASTCHANGEDBY,
	[LASTCHANGEDON] = @LASTCHANGEDON,
	[ROWVERSION] = @ROWVERSION + 1
OUTPUT inserted.[ROWVERSION] INTO @OUTPUTTABLE
WHERE
	[EXAMVERSIONID] = @EXAMVERSIONID AND 
	[ROWVERSION]= @ROWVERSION

SELECT * FROM @OUTPUTTABLE