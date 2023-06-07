﻿CREATE PROCEDURE [dbo].[USP_LICENSECYCLERECURRENCESETUP_UPDATE]
(
	@LICENSECYCLERECURRENCESETUPID CHAR(36),
	@NAME NVARCHAR(50),
	@DESCRIPTION NVARCHAR(MAX),
	@RECURRENCEID CHAR(36),
	@LICENSECYCLETYPEID INT,
	@LASTCHANGEDBY CHAR(36),
	@LASTCHANGEDON DATETIME,
	@ROWVERSION INT
)
AS
DECLARE @OUTPUTTABLE as TABLE([ROWVERSION]  int)
UPDATE [dbo].[LICENSECYCLERECURRENCESETUP] SET
	[NAME] = @NAME,
	[DESCRIPTION] = @DESCRIPTION,
	[RECURRENCEID] = @RECURRENCEID,
	[LICENSECYCLETYPEID] = @LICENSECYCLETYPEID,
	[LASTCHANGEDBY] = @LASTCHANGEDBY,
	[LASTCHANGEDON] = @LASTCHANGEDON,
	[ROWVERSION] = @ROWVERSION + 1
OUTPUT inserted.[ROWVERSION] INTO @OUTPUTTABLE
WHERE
	[LICENSECYCLERECURRENCESETUPID] = @LICENSECYCLERECURRENCESETUPID AND 
	[ROWVERSION]= @ROWVERSION

SELECT * FROM @OUTPUTTABLE