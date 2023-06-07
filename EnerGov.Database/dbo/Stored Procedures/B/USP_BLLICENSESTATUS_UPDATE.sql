﻿CREATE PROCEDURE [dbo].[USP_BLLICENSESTATUS_UPDATE]
(
	@BLLICENSESTATUSID CHAR(36),
	@NAME NVARCHAR(50),
	@DESCRIPTION NVARCHAR(MAX),
	@BLLICENSESTATUSSYSTEMID INT,
	@LASTCHANGEDBY CHAR(36),
	@LASTCHANGEDON DATETIME,
	@ROWVERSION INT
)
AS
DECLARE @OUTPUTTABLE as TABLE([ROWVERSION]  int)
UPDATE [dbo].[BLLICENSESTATUS] SET
	[NAME] = @NAME,
	[DESCRIPTION] = @DESCRIPTION,
	[BLLICENSESTATUSSYSTEMID] = @BLLICENSESTATUSSYSTEMID,
	[LASTCHANGEDBY] = @LASTCHANGEDBY,
	[LASTCHANGEDON] = @LASTCHANGEDON,
	[ROWVERSION] = @ROWVERSION + 1
OUTPUT inserted.[ROWVERSION] INTO @OUTPUTTABLE
WHERE
	[BLLICENSESTATUSID] = @BLLICENSESTATUSID AND 
	[ROWVERSION]= @ROWVERSION

SELECT * FROM @OUTPUTTABLE