﻿CREATE PROCEDURE [dbo].[USP_BUSETTING_UPDATE]
(
	@BUSETTINGID CHAR(36),
	@ENTITY INT,
	@STARTTIME DATETIME,
	@ENDTIME DATETIME,
	@NUMOFRECORD INT,
	@ACTIVE BIT,
	@LASTCHANGEDBY CHAR(36),
	@LASTCHANGEDON DATETIME,
	@ROWVERSION INT
)
AS

DECLARE @OUTPUTTABLE AS TABLE([ROWVERSION]  INT)
UPDATE	[dbo].[BUSETTING]
SET		[ENTITY] = @ENTITY,
		[STARTTIME] = @STARTTIME,
		[ENDTIME] = @ENDTIME,
		[NUMOFRECORD] = @NUMOFRECORD,
		[ACTIVE] = @ACTIVE,
		[LASTCHANGEDBY] = @LASTCHANGEDBY,
		[LASTCHANGEDON] = @LASTCHANGEDON,
		[ROWVERSION] = @ROWVERSION + 1
OUTPUT inserted.[ROWVERSION] INTO @OUTPUTTABLE
WHERE
	[BUSETTINGID] = @BUSETTINGID AND
	[ROWVERSION]= @ROWVERSION

SELECT * FROM @OUTPUTTABLE