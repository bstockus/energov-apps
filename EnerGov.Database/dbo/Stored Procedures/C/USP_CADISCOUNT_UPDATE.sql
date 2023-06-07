﻿CREATE PROCEDURE [dbo].[USP_CADISCOUNT_UPDATE]
(
	@CADISCOUNTID CHAR(36),
	@CACOMPUTATIONTYPEID INT,
	@NAME NVARCHAR(50),
	@DESCRIPTION NVARCHAR(MAX),
	@ACTIVE BIT,
	@ROWVERSION INT,
	@LASTCHANGEDBY CHAR(36),
	@LASTCHANGEDON DATETIME
)
AS
DECLARE @OUTPUTTABLE as TABLE([ROWVERSION]  int)
UPDATE [dbo].[CADISCOUNT] SET
	[CACOMPUTATIONTYPEID] = @CACOMPUTATIONTYPEID,
	[NAME] = @NAME,
	[DESCRIPTION] = @DESCRIPTION,
	[ACTIVE] = @ACTIVE,
	[ROWVERSION] = @ROWVERSION + 1,
	[LASTCHANGEDBY] = @LASTCHANGEDBY,
	[LASTCHANGEDON] = @LASTCHANGEDON
OUTPUT inserted.[ROWVERSION] INTO @OUTPUTTABLE
WHERE
	[CADISCOUNTID] = @CADISCOUNTID AND 
	[ROWVERSION]= @ROWVERSION

SELECT * FROM @OUTPUTTABLE