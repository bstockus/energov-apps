﻿CREATE PROCEDURE [dbo].[USP_PLPLANTYPEGROUP_UPDATE]
(
	@PLPLANTYPEGROUPID CHAR(36),
	@NAME NVARCHAR(100),
	@DESCRIPTION NVARCHAR(MAX),
	@LASTCHANGEDBY CHAR(36),
	@LASTCHANGEDON DATETIME,
	@ROWVERSION INT
)
AS
DECLARE @OUTPUTTABLE as TABLE([ROWVERSION]  int)
UPDATE [dbo].[PLPLANTYPEGROUP] SET
	[NAME] = @NAME,
	[DESCRIPTION] = @DESCRIPTION,
	[LASTCHANGEDBY] = @LASTCHANGEDBY,
	[LASTCHANGEDON] = @LASTCHANGEDON,
	[ROWVERSION] = @ROWVERSION + 1
OUTPUT inserted.[ROWVERSION] INTO @OUTPUTTABLE
WHERE
	[PLPLANTYPEGROUPID] = @PLPLANTYPEGROUPID AND 
	[ROWVERSION]= @ROWVERSION

SELECT * FROM @OUTPUTTABLE