﻿CREATE PROCEDURE [dbo].[USP_CADISCOUNTSETUP_UPDATE]
(
	@CADISCOUNTSETUPID CHAR(36),
	@CADISCOUNTID CHAR(36),
	@CASCHEDULEID CHAR(36),
	@AMOUNT MONEY,
	@MINIMUMAMOUNT MONEY,
	@MAXIMUMAMOUNT MONEY,
	@COMPUTATIONVALUE DECIMAL(20,4),
	@COMPUTATIONVALUENAME NVARCHAR(50),
	@ROUNDINGTYPEID INT,
	@ROUNDINGVALUE DECIMAL(20,4),
	@ROWVERSION INT,
	@LASTCHANGEDBY CHAR(36),
	@LASTCHANGEDON DATETIME
)
AS
DECLARE @OUTPUTTABLE as TABLE([ROWVERSION]  int)
UPDATE [dbo].[CADISCOUNTSETUP] SET
	[CADISCOUNTID] = @CADISCOUNTID,
	[CASCHEDULEID] = @CASCHEDULEID,
	[AMOUNT] = @AMOUNT,
	[MINIMUMAMOUNT] = @MINIMUMAMOUNT,
	[MAXIMUMAMOUNT] = @MAXIMUMAMOUNT,
	[COMPUTATIONVALUE] = @COMPUTATIONVALUE,
	[COMPUTATIONVALUENAME] = @COMPUTATIONVALUENAME,
	[ROUNDINGTYPEID] = @ROUNDINGTYPEID,
	[ROUNDINGVALUE] = @ROUNDINGVALUE,
	[ROWVERSION] = @ROWVERSION + 1,
	[LASTCHANGEDBY] = @LASTCHANGEDBY,
	[LASTCHANGEDON] = @LASTCHANGEDON
OUTPUT inserted.[ROWVERSION] INTO @OUTPUTTABLE
WHERE
	[CADISCOUNTSETUPID] = @CADISCOUNTSETUPID AND 
	[ROWVERSION]= @ROWVERSION

SELECT * FROM @OUTPUTTABLE