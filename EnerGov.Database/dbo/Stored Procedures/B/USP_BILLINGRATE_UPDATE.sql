﻿CREATE PROCEDURE [dbo].[USP_BILLINGRATE_UPDATE]
(
	@BILLINGRATEID CHAR(36),
	@NAME NVARCHAR(50),
	@DESCRIPTION NVARCHAR(MAX),
	@AMOUNT MONEY,
	@ACTIVE BIT,
	@LASTCHANGEDBY CHAR(36),
	@LASTCHANGEDON DATETIME,
	@ROWVERSION INT
)
AS
DECLARE @OUTPUTTABLE as TABLE([ROWVERSION]  int)
UPDATE [dbo].[BILLINGRATE] SET
	[NAME] = @NAME,
	[DESCRIPTION] = @DESCRIPTION,
	[AMOUNT] = @AMOUNT,
	[ACTIVE] = @ACTIVE,
	[LASTCHANGEDBY] = @LASTCHANGEDBY,
	[LASTCHANGEDON] = @LASTCHANGEDON,
	[ROWVERSION] = @ROWVERSION + 1
OUTPUT inserted.[ROWVERSION] INTO @OUTPUTTABLE
WHERE
	[BILLINGRATEID] = @BILLINGRATEID AND 
	[ROWVERSION]= @ROWVERSION

SELECT * FROM @OUTPUTTABLE