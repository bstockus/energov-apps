﻿CREATE PROCEDURE [dbo].[USP_CAPSETTING_UPDATE]
(
	@CAPSETTINGID CHAR (36),
	@BITVALUE BIT,
	@STRINGVALUE NVARCHAR (500),
	@INTVALUE INT,
	@IMAGEVALUE VARBINARY,
	@LASTCHANGEDBY CHAR (36),
	@LASTCHANGEDON DATETIME,
	@ROWVERSION INT
)
AS
DECLARE @OUTPUTTABLE AS TABLE([ROWVERSION] INT)
UPDATE [dbo].[CAPSETTING] SET
	[BITVALUE] = @BITVALUE,
	[STRINGVALUE] = @STRINGVALUE,
	[INTVALUE] = @INTVALUE,
	[IMAGEVALUE] = @IMAGEVALUE,
	[LASTCHANGEDBY] = @LASTCHANGEDBY,
	[LASTCHANGEDON] = @LASTCHANGEDON,
	[ROWVERSION] = @ROWVERSION + 1
OUTPUT inserted.[ROWVERSION] INTO @OUTPUTTABLE
WHERE
	[CAPSETTINGID] = @CAPSETTINGID AND 
	[ROWVERSION]= @ROWVERSION

SELECT * FROM @OUTPUTTABLE