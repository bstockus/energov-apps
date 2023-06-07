﻿CREATE PROCEDURE [dbo].[USP_QUERYBUILDER_UPDATE]
(
	@QUERYBUILDERID CHAR(36),
	@NAME NVARCHAR(100),
	@DESCRIPTION NVARCHAR(MAX),
	@QUERY NVARCHAR(MAX),
	@LASTCHANGEDON DATETIME,
	@LASTCHANGEDBY CHAR(36),
	@ROWVERSION INT
)
AS
DECLARE @OUTPUTTABLE as TABLE([ROWVERSION]  int)
UPDATE [dbo].[QUERYBUILDER] SET
	[NAME] = @NAME,
	[DESCRIPTION] = @DESCRIPTION,
	[QUERY] = @QUERY,
	[LASTCHANGEDON] = @LASTCHANGEDON,
	[LASTCHANGEDBY] = @LASTCHANGEDBY,
	[ROWVERSION] = @ROWVERSION + 1
OUTPUT inserted.[ROWVERSION] INTO @OUTPUTTABLE
WHERE
	[QUERYBUILDERID] = @QUERYBUILDERID AND 
	[ROWVERSION]= @ROWVERSION

SELECT * FROM @OUTPUTTABLE