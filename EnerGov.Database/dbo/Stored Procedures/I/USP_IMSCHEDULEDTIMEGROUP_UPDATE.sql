﻿CREATE PROCEDURE [dbo].[USP_IMSCHEDULEDTIMEGROUP_UPDATE]
(
	@IMSCHEDULEDTIMEGROUPID CHAR(36),
	@NAME NVARCHAR(50),
	@STARTTIME DATETIME,
	@ENDTIME DATETIME,
	@IVRNUMBER INT,
	@LASTCHANGEDBY CHAR(36),
	@LASTCHANGEDON DATETIME,
	@ROWVERSION INT
)
AS
DECLARE @OUTPUTTABLE as TABLE([ROWVERSION]  int)
UPDATE [dbo].[IMSCHEDULEDTIMEGROUP] SET
	[NAME] = @NAME,
	[STARTTIME] = @STARTTIME,
	[ENDTIME] = @ENDTIME,
	[IVRNUMBER] = @IVRNUMBER,
	[LASTCHANGEDBY] = @LASTCHANGEDBY,
	[LASTCHANGEDON] = @LASTCHANGEDON,
	[ROWVERSION] = @ROWVERSION + 1
OUTPUT inserted.[ROWVERSION] INTO @OUTPUTTABLE
WHERE
	[IMSCHEDULEDTIMEGROUPID] = @IMSCHEDULEDTIMEGROUPID AND 
	[ROWVERSION]= @ROWVERSION

SELECT * FROM @OUTPUTTABLE