﻿CREATE PROCEDURE [dbo].[USP_SERVICETASK_UPDATE]
(
	@SERVICETASKID INT,
	@NAME NVARCHAR(50),
	@DESCRIPTION NVARCHAR(2000),
	@ISMONITORINGSUPPORTED BIT,
	@ISDETAILEDMONITORINGSUPPORTED BIT,
	@ISQUEUEDISPLAYSUPPORTED BIT,
	@ISMONITORINGENABLED BIT,
	@ISDETAILEDMONITORINGENABLED BIT,
	@LASTCHANGEDBY CHAR(36),
	@LASTCHANGEDON DATETIME,
	@ROWVERSION INT
)
AS
DECLARE @OUTPUTTABLE as TABLE([ROWVERSION]  int)
UPDATE [dbo].[SERVICETASK] SET
	[NAME] = @NAME,
	[DESCRIPTION] = @DESCRIPTION,
	[ISMONITORINGSUPPORTED] = @ISMONITORINGSUPPORTED,
	[ISDETAILEDMONITORINGSUPPORTED] = @ISDETAILEDMONITORINGSUPPORTED,
	[ISQUEUEDISPLAYSUPPORTED] = @ISQUEUEDISPLAYSUPPORTED,
	[ISMONITORINGENABLED] = @ISMONITORINGENABLED,
	[ISDETAILEDMONITORINGENABLED] = @ISDETAILEDMONITORINGENABLED,
	[LASTCHANGEDBY] = @LASTCHANGEDBY,
	[LASTCHANGEDON] = @LASTCHANGEDON,
	[ROWVERSION] = @ROWVERSION + 1
OUTPUT inserted.[ROWVERSION] INTO @OUTPUTTABLE
WHERE
	[SERVICETASKID] = @SERVICETASKID AND 
	[ROWVERSION]= @ROWVERSION

SELECT * FROM @OUTPUTTABLE