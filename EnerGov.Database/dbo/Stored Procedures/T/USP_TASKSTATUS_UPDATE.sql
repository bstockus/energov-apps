﻿CREATE PROCEDURE [dbo].[USP_TASKSTATUS_UPDATE]
(
	@TASKSTATUSID INT,
	@TASKSTATUSNAME NVARCHAR(30),
	@ISCOMPLETED BIT,
	@LASTCHANGEDBY CHAR(36),
	@LASTCHANGEDON DATETIME,
	@ROWVERSION INT
)
AS
DECLARE @OUTPUTTABLE as TABLE([ROWVERSION]  int)
UPDATE [dbo].[TASKSTATUS] SET
	[TASKSTATUSNAME] = @TASKSTATUSNAME,
	[ISCOMPLETED] = @ISCOMPLETED,
	[LASTCHANGEDBY] = @LASTCHANGEDBY,
	[LASTCHANGEDON] = @LASTCHANGEDON,
	[ROWVERSION] = @ROWVERSION + 1
OUTPUT inserted.[ROWVERSION] INTO @OUTPUTTABLE
WHERE
	[TASKSTATUSID] = @TASKSTATUSID AND 
	[ROWVERSION]= @ROWVERSION

SELECT * FROM @OUTPUTTABLE