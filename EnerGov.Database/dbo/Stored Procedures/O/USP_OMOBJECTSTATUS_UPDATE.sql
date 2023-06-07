﻿CREATE PROCEDURE [dbo].[USP_OMOBJECTSTATUS_UPDATE]
(
	@OMOBJECTSTATUSID CHAR(36),
	@NAME NVARCHAR(50),
	@DESCRIPTION NVARCHAR(MAX),
	@OMOBJECTSTATUSSYSTEMID INT,
	@LASTCHANGEDBY CHAR(36),
	@LASTCHANGEDON DATETIME,
	@ROWVERSION INT
)
AS
DECLARE @OUTPUTTABLE as TABLE([ROWVERSION]  int)
UPDATE [dbo].[OMOBJECTSTATUS] SET
	[NAME] = @NAME,
	[DESCRIPTION] = @DESCRIPTION,
	[OMOBJECTSTATUSSYSTEMID] = @OMOBJECTSTATUSSYSTEMID,
	[LASTCHANGEDBY] = @LASTCHANGEDBY,
	[LASTCHANGEDON] = @LASTCHANGEDON,
	[ROWVERSION] = @ROWVERSION + 1
OUTPUT inserted.[ROWVERSION] INTO @OUTPUTTABLE
WHERE
	[OMOBJECTSTATUSID] = @OMOBJECTSTATUSID AND 
	[ROWVERSION]= @ROWVERSION

SELECT * FROM @OUTPUTTABLE