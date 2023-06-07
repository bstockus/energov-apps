﻿CREATE PROCEDURE [dbo].[USP_EXAMTIMESLOT_UPDATE]
(
	@EXAMTIMESLOTID CHAR(36),
	@NAME NVARCHAR(50),
	@STARTTIME DATETIME,
	@ENDTIME DATETIME,
	@LASTCHANGEDBY CHAR(36),
	@LASTCHANGEDON DATETIME,
	@ROWVERSION INT
)
AS
DECLARE @OUTPUTTABLE as TABLE([ROWVERSION]  int)
UPDATE [dbo].[EXAMTIMESLOT] SET
	[NAME] = @NAME,
	[STARTTIME] = @STARTTIME,
	[ENDTIME] = @ENDTIME,
	[LASTCHANGEDBY] = @LASTCHANGEDBY,
	[LASTCHANGEDON] = @LASTCHANGEDON,
	[ROWVERSION] = @ROWVERSION + 1
OUTPUT inserted.[ROWVERSION] INTO @OUTPUTTABLE
WHERE
	[EXAMTIMESLOTID] = @EXAMTIMESLOTID AND 
	[ROWVERSION]= @ROWVERSION

SELECT * FROM @OUTPUTTABLE