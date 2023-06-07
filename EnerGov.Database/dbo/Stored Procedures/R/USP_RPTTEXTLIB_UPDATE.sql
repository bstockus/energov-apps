﻿CREATE PROCEDURE [dbo].[USP_RPTTEXTLIB_UPDATE]
(
	@RPTTEXTLIBID CHAR(36),
	@TEXTNAME NVARCHAR(50),
	@REPORTTEXT NVARCHAR(4000),
	@ACTIVE BIT,
	@LASTCHANGEDBY CHAR(36),
	@LASTCHANGEDON DATETIME,
	@ROWVERSION INT
)
AS
DECLARE @OUTPUTTABLE as TABLE([ROWVERSION]  int)
UPDATE [dbo].[RPTTEXTLIB] SET
	[TEXTNAME] = @TEXTNAME,
	[REPORTTEXT] = @REPORTTEXT,
	[ACTIVE] = @ACTIVE,
	[LASTCHANGEDBY] = @LASTCHANGEDBY,
	[LASTCHANGEDON] = @LASTCHANGEDON,
	[ROWVERSION] = @ROWVERSION + 1
OUTPUT inserted.[ROWVERSION] INTO @OUTPUTTABLE
WHERE
	[RPTTEXTLIBID] = @RPTTEXTLIBID AND 
	[ROWVERSION]= @ROWVERSION

SELECT * FROM @OUTPUTTABLE